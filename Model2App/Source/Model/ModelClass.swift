//
//  ModelClass.swift
//  Model2App
//
//  Created by Karol Kulesza on 6/28/18.
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

import Foundation
import RealmSwift


/**
 *  Base model class defining the model configuration properties to be overridden by subclasses.
 *
 *  `ModelClass` should be used as a parent class by all classes that should be presented in root menu of the app (if not explicitly hidden)
 */
open class ModelClass : Object {
    
    // MARK: -
    // MARK: Computed Type Properties (To Be Overridden)
    
    /// Display name of this class. If not provided, inferred from the class name
    open class var displayName: String { return "" }
    
    /// Plural name of this class. Used to name list of objects or menu items. If not provided, "`ClassName - List`" is used
    open class var pluralName: String { return "" }

    /// Name of the image file used for menu icon in root menu of the app
    open class var menuIconFileName: String { return "" }
    
    /// Specifies whether `Model2App` should look for menu icon file in main app bundle. If `false`, `Model2App`'s bundle will be used
    open class var menuIconIsFromAppBundle: Bool { return false }
    
    /// Order of menu item for this class in root menu of the app
    open class var menuOrder: Int { return Int.max }
    
    /// Dictionary of property configurations for this class
    open class var propertyConfigurations: [String: PropertyConfiguration] { return [String: PropertyConfiguration]() }
    
    /// List of inverse relationships for this class.
    /// Should be defined if there are any `to-one` relationships from other classes and if one would like to present a section of related objects
    open class var inverseRelationships: [InverseRelationship] { return [InverseRelationship]() }
    
    /// List of properties used in list view cell's for this class. Should contain all properties specified in `listViewCellLayoutVisualFormats`
    open class var listViewCellProperties: [String] { return [String]() }
    
    /// List of visual formats for list view cell layout, using Apple's Auto Layout Visual Format Language
    open class var listViewCellLayoutVisualFormats: [String] { return [String]() }
   
    /// Specifies whether a given model class should be hidden in root menu of the app.
    /// Useful in case of child entities that should only be displayed in related objects section, for a given object
    open class var isHiddenInRootView: Bool { return false }
    
    // MARK: -
    // MARK: Stored Type Properties
    
    private static var referenceObjects = [String: ModelClass]()
    private static var defaultListViewCellPropertyCache = [String: String]()

    // MARK: -
    // MARK: Computed Type Internal Properties
    
    static var name: String {
        return displayName.isEmpty ? String(describing: self) : displayName
    }
    
    static var plural: String {
        return pluralName.isEmpty ? "\(name) - List" : pluralName
    }
    
    static var menuIcon: UIImage? {
        var fileName = menuIconFileName.isEmpty ? FileUtilities.getRandomMenuIcon() : menuIconFileName
        var bundle = ModelManager.shared.bundle
        if !menuIconFileName.isEmpty && menuIconIsFromAppBundle {
            bundle = Bundle.main
        } else {
            fileName = "MenuIcons.bundle/\(fileName).png"
        }
        
        return UIImage.init(named: fileName, in: bundle, compatibleWith: nil)
    }
    
    static var defaultListViewCellProperty: String? {
        return defaultListViewCellPropertyCache[name] ?? {
            // By default, if no `listViewCellProperties` are defined, look for any property containing `name` in its name
            var property: String?
            schema.properties.first(where: { $0.name.lowercased().contains("name") }).flatMap { property = $0.name }
            
            // Otherwise, just use the first property from schema
            if property == nil && schema.properties.count > 0 { property = schema.properties[0].name }
            defaultListViewCellPropertyCache[name] = property
            
            return property
        }()
    }

    static var referenceObject: ModelClass {
        return referenceObjects[name] ?? {
            let referenceObject = self.init()
            referenceObjects[name] = referenceObject
            return referenceObject
        }()
    }
    
    static var schema: ObjectSchema {
        return referenceObject.objectSchema
    }
    

    
    // MARK: -
    // MARK: Computed Instance Properties
    
    var objectName: String {
        let modelClass = type(of: self)
        if modelClass.listViewCellProperties.count > 0 {
            var name = ""
            modelClass.listViewCellProperties.forEach { property in
                guard !modelClass.isProperty(property, ofType: .data) else { return }
                name += "\(self[property] ?? "") "
            }
            return String(name.dropLast())
        }
        return (self[modelClass.defaultListViewCellProperty ?? ""] as? String) ?? "{Reference}"
    }
    
    var isNew: Bool {
        return realm == nil
    }
    
    // MARK: -
    // MARK: Type Methods
    
    static func isProperty(_ propertyName: String, ofType: PropertyType) -> Bool {
        return schema[propertyName].flatMap { $0.type == ofType } ?? false
    }
    
    static func getClassNameForProperty(_ propertyName: String) -> String? {
        return schema[propertyName]?.objectClassName
    }
    
    static func getClassForName(_ className: String) -> ModelClass.Type? {
        let referenceClassName = String(reflecting: self)
        let moduleName = referenceClassName.components(separatedBy: ".").first ?? ""
        
        return NSClassFromString("\(moduleName).\(className)") as? ModelClass.Type
    }
    
    // MARK: -
    // MARK: Instance Methods
    
    func valueString(forProperty propertyName: String) -> String? {
        guard let property = self.objectSchema[propertyName] else { return nil }
        
        switch property.type {
        case .date:
            guard let value = self[propertyName] as? Date else { return nil }
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .none
            dateFormatter.dateStyle = .medium
            if let config = type(of: self).propertyConfigurations[property.name], let type = config.controlType {
                switch type {
                case .TimePicker:
                    dateFormatter.timeStyle = .short
                    dateFormatter.dateStyle = .none
                case .DateTimePicker:
                    dateFormatter.timeStyle = .short
                    dateFormatter.dateStyle = .short
                default:
                    dateFormatter.timeStyle = .none
                    dateFormatter.dateStyle = .medium
                }
            }
            return dateFormatter.string(from: value)
        case .object:
            return (self[propertyName] as? ModelClass).flatMap { $0.objectName }
        case .float:
            return (self[propertyName] as? Float).flatMap { String(describing: $0) }
        case .double:
            return (self[propertyName] as? Double).flatMap { String(describing: $0) }
        case .int:
            if let config = type(of: self).propertyConfigurations[property.name], let type = config.controlType, type == .CurrencyField {
                let formatter = NumberFormatter()
                formatter.locale = .current
                formatter.numberStyle = .currency
                return (self[propertyName] as? Double).flatMap { formatter.string(for: $0/100) }
            } else { fallthrough }
        default:
            return self[propertyName].flatMap { String(describing: $0) }
        }
    }

    public func setImage(_ image: UIImage?, for propertyName: String) {
        guard let image = image else {
            self[propertyName] = nil
            return
        }
        let imageName = UUID().uuidString
        let imagePath = FileUtilities.getImageDirectory().appendingPathComponent(imageName)
        let thumbnailPath = FileUtilities.getImageDirectory().appendingPathComponent("\(imageName)_thumb")
        
        if let imageData = image.pngData(),
            let thumbnailData = ImageUtilities.createThumbnailDataForImageData(imageData) {
            try? imageData.write(to: imagePath)
            try? thumbnailData.write(to: thumbnailPath)
        }
        
        self[propertyName] = imageName.data(using: .utf8)
    }
}

