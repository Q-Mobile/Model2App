//
//  ObjectDataSource.swift
//  Model2App
//
//  Created by Karol Kulesza on 10/17/18.
//  Copyright © 2018 Q Mobile { http://Q-Mobile.IT } 
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit


/**
 *  `ObjectDataSource` describes the data source for any instance of `ModelClass` subclass
 */
open class ObjectDataSource: NSObject, UITableViewDataSource {

    // MARK: -
    // MARK: Properties & Constants
    
    /// `object` - instance of `ModelClass` subclass
    public private(set) var object: ModelClass
    
    /// `objectClass` - subclass of `ModelClass`
    public private(set) var objectClass = ModelClass.self
    
    /// List of all properties defined by `ModelClass` subclass
    public private(set) var properties = [ObjectProperty]()
    
    /// Dictionary of property configurations for `ModelClass` subclass
    public private(set) var propertyConfigurations = [String: PropertyConfiguration]()
    
    /// Dictionary of related objects for this object (inferred from `inverseRelationships` property)
    public private(set) var relatedObjects = [String: Objects]()
    
    var relatedObjectsChanged: ((CollectionChange<Objects>, Int) -> Void)?
    private var relatedObjectsNotifications: [ObjectNotification] = [ObjectNotification]()
    var isExplicitlyEditing = false
    
    // MARK: -
    // MARK: Computed Properties
    
    public var visibleProperties: [ObjectProperty] {
        return properties.filter { !(propertyConfigurations[$0.name]?.isHidden ?? false) }
    }
    
    // MARK: -
    // MARK: Initializers & Deinitializers
    
    public init(_ object: ModelClass)
    {
        self.object = object
        super.init()
        
        setMetadata()
        setRelatedObjects()
    }
    
    deinit {
        relatedObjectsNotifications.forEach { $0.invalidate() }
    }
    
    // MARK: -
    // MARK: ObjectDataSource Methods
    
    private func setMetadata() {
        objectClass = type(of: object)
        properties = object.objectSchema.properties
        propertyConfigurations = objectClass.propertyConfigurations
    }
    
    private func setRelatedObjects() {
        for (index, inverseRelationship) in objectClass.inverseRelationships.enumerated() {
            let inverseObjects = Storage.shared.objects(inverseRelationship.sourceType).filter("\(inverseRelationship.sourceProperty) == %@", object)
            
            let notificationToken = inverseObjects.observe { [weak self] (changes: CollectionChange) in
                self.flatMap { selfie in selfie.relatedObjectsChanged?(changes, index + 1) }
            }
            relatedObjects[inverseRelationship.name] = inverseObjects
            relatedObjectsNotifications.append(notificationToken)
        }
    }
    
    // MARK: -
    // MARK: UITableViewDataSource Methods
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return (object.isNew || isExplicitlyEditing) ? 1 : 1 + objectClass.inverseRelationships.count
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return visibleProperties.count }
        guard objectClass.inverseRelationships.count >= section else { return 0 }
        
        let relationship = objectClass.inverseRelationships[section - 1]
        return relatedObjects[relationship.name].flatMap { $0.count } ?? 0
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 { return getPropertyCell(for: indexPath, tableView) }
        return getRelatedObjectCell(for: indexPath, tableView)
    }
    
    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 { return false } else { return true }
    }
    
    open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            guard let relatedObject = getRelatedObject(for: indexPath) else { return }
            guard !UIUtilities.isObjectPresentedInVCHierarchy(object: relatedObject) else {
                UIUtilities.showAlert(title: "Info", message: "This object is currently presented in one of the previous views in your work stack. Please go to root menu, in order to delete it.")
                return
            }
            tableView.beginUpdates()
            Storage.shared.write { Storage.shared.delete(relatedObject) }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    // MARK: -
    // MARK: Helper Methods
    
    private func getPropertyCell(for indexPath: IndexPath, _ tableView: UITableView) -> BasePropertyCell {
        let property = visibleProperties[indexPath.row]
        let propertyValue = object[property.name]
        let placeholder = propertyConfigurations[property.name]?.placeholder ?? M2A.config.objectPropertyDefaultTextValuePlaceholder
        
        let controlType = property.getControlType(propertyConfig: propertyConfigurations[property.name])
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(controlType.rawValue)Cell", for: indexPath) as! BasePropertyCell
        
        cell.title = property.name.camelCaseToWords()
        cell.nonTypedValue = propertyValue
        cell.placeholder = placeholder
        cell.isInEditMode = tableView.isEditing
        cell.valueChanged = { [weak self] value in
            self.flatMap { selfie in selfie.object[property.name] = value }
        }
        cell.update()
        
        return cell
    }
    
    private func getRelatedObjectCell(for indexPath: IndexPath, _ tableView: UITableView) -> ObjectListViewCell {
        let defaultCell = ObjectListViewCell(style: .default, reuseIdentifier: "defaultCell")
        guard objectClass.inverseRelationships.count >= indexPath.section else { return defaultCell }
        guard let relatedObject = getRelatedObject(for: indexPath) else { return defaultCell }
        
        let relationship = getRelationship(for: indexPath)
        var reusableCell = tableView.dequeueReusableCell(withIdentifier: relationship.name) as? ObjectListViewCell
        if reusableCell == nil {
            reusableCell = ObjectListViewCell(withModelClass: relationship.sourceType, reuseIdentifier: relationship.name)
        }
        guard let cell = reusableCell else { return defaultCell }
        
        cell.updateForObject(object: relatedObject)
        return cell
    }
    
    private func getRelatedObject(for indexPath: IndexPath) -> ModelClass? {
        let relationship = getRelationship(for: indexPath)
        return relatedObjects[relationship.name]?[indexPath.row]
    }
    
    private func getRelationship(for indexPath: IndexPath) -> InverseRelationship {
        return objectClass.inverseRelationships[indexPath.section - 1]
    }
}
