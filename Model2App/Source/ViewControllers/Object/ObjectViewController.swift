//
//  ObjectViewController.swift
//  Model2App
//
//  Created by Karol Kulesza on 6/19/18.
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
 *  `ObjectViewController` is responsible for presenting a table view with:
 *    - a section of all the object's properties, with appropriate UI controls for displaying/modifying properties' values
 *    - as many related objects' sections as `inverseRelationships` property for a given `ModelClass` defines, listing all related objects for this object
 */
open class ObjectViewController: ObjectBaseViewController, UINavigationControllerDelegate {
    
    // MARK: -
    // MARK: Properties & Constants
    
    internal var accessoryView: UIToolbar?
    private var editButton: UIBarButtonItem?
    
    /// Data source for the presented `object`
    public private(set) var dataSource: ObjectDataSource
    private(set) var tableDelegate: ObjectTableDelegate
    private(set) var imageSelectionInteraction: ImageSelectionInteraction?
    
    // MARK: -
    // MARK: Initializers & Deinitializers
    
    public init(object: ModelClass)
    {
        self.dataSource = ObjectDataSource(object)
        self.tableDelegate = ObjectTableDelegate(dataSource: dataSource)
        super.init(style: .plain)
        
        setupSourceAndDelegate()
        if object.isNew { storage.beginWrite() }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.dataSource = ObjectDataSource(ModelClass())
        self.tableDelegate = ObjectTableDelegate(dataSource: dataSource)
        super.init(coder: aDecoder)
    }
    
    // MARK: -
    // MARK: UIViewController Methods
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView?.indexPathForSelectedRow.flatMap { tableView?.reloadRows(at: [$0], with: .none) }
    }
    
    // MARK: -
    // MARK: BaseTableViewController Methods
    
    override open func setup() {
        super.setup()
        
        setupObjectVC()
        setupTableView()
        setupAccessoryView()
    }
    
    // MARK: -
    // MARK: Action Methods
    
    @objc private func cancelItemTapped(_ sender: UIBarButtonItem!) {
        tableView?.endEditing(true)
        if storage.isInWriteTransaction { storage.cancelWrite() }
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func addButtonTapped(_ sender: UIBarButtonItem!) {
        showNewRelatedObjectVC(sender)
    }
    
    @objc private func editOrSaveItemTapped(_ sender: UIBarButtonItem!) {
        if tableView.isEditing { handleSave() }
        else { enterEditMode() }
    }
    
    @objc private func accessoryDone(_ sender: UIBarButtonItem) {
        tableView?.endEditing(true)
        tableView?.indexPathForSelectedRow.flatMap { tableView?.reloadRows(at: [$0], with: .automatic) }
    }
    
    // MARK: -
    // MARK: ObjectViewController Methods
    
    private func setupSourceAndDelegate() {
        dataSource.relatedObjectsChanged = { [weak self] (objectsChanged, section) in
            self.flatMap { selfie in
                guard !selfie.tableView.isEditing else { return }
                switch objectsChanged {
                case .update(_, let deletions, let insertions, let modifications):
                    selfie.tableView.beginUpdates()
                    selfie.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: section) }), with: .automatic)
                    selfie.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: section)}), with: .automatic)
                    selfie.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: section) }), with: .automatic)
                    selfie.tableView.endUpdates()
                default: return
                }
            }
        }
        tableDelegate.presenter = self
    }
    
    private func setupObjectVC() {
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelItemTapped(_:)));
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped(_:)));
        editButton = UIBarButtonItem(title: dataSource.object.isNew ? "Save" : "Edit", style: .plain, target: self, action: #selector(editOrSaveItemTapped(_:)));
        
        navigationItem.title = (dataSource.object.isNew ? "New " : "") + "\(dataSource.objectClass.name)"
        navigationItem.leftBarButtonItem = cancelItem
        
        guard let editButton = editButton else { return }
        if dataSource.objectClass.inverseRelationships.isEmpty || dataSource.object.isNew {
            navigationItem.rightBarButtonItem = editButton
        } else {
            navigationItem.rightBarButtonItems = [editButton, plusButton]
        }
    }
    
    private func setupTableView() {
        clearsSelectionOnViewWillAppear = false
        tableView?.dataSource = dataSource
        tableView?.delegate = tableDelegate
        tableView?.setEditing(dataSource.object.isNew, animated: false)
        ModelManager.shared.allCellClasses.forEach { cellClass in
            tableView?.register(cellClass, forCellReuseIdentifier: String(describing: cellClass))
        }
    }
    
    private func setupAccessoryView() {
        accessoryView = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44.0))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(accessoryDone(_:)))
        accessoryView?.setItems([doneButton], animated: false)
    }
    
    private func enterEditMode() {
        storage.beginWrite()
        dataSource.isExplicitlyEditing = true
        
        editButton?.title = "Save"
        setNavigationTitleAnimation()
        navigationItem.title = "Edit \(dataSource.objectClass.name)"
        
        tableView?.setEditing(true, animated: true)
        let relatedSectionsCount = dataSource.numberOfSections(in: tableView) - 1
        if relatedSectionsCount > 0 { tableView?.deleteSections(IndexSet(1...relatedSectionsCount), with: UITableView.RowAnimation.middle) }
        tableView?.reloadData()
        
        guard let editButton = editButton else { return }
        navigationItem.setRightBarButtonItems([editButton], animated: true)
    }
    
    private func handleSave() {
        tableView?.endEditing(true)
        dataSource.isExplicitlyEditing = false
        
        if !ModelValidator.shared.validate(object: dataSource.object) { return }
        if dataSource.object.isNew { storage.add(dataSource.object) }
        storage.commitWrite()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: -
    // MARK: Cell Related Methods
    
    func textFieldShouldReturn(for cell: BasePropertyCell) -> Bool {
        if let nextCell = tableDelegate.nextCell(for: cell, tableView) {
            tableView?.indexPath(for: nextCell).flatMap {
                tableView?.selectRow(at: $0, animated: true, scrollPosition: .none)
            }
            nextCell.becomeFirstResponder()
            return true
        }
        tableView?.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(for cell: BasePropertyCell, textField: UITextField) {
        if let _ = tableDelegate.nextCell(for: cell, tableView) { textField.returnKeyType = .next }
        else { textField.returnKeyType = .default }
    }
    
    func deselectRow(for cell: BasePropertyCell) {
        tableView?.indexPath(for: cell).flatMap { tableView?.deselectRow(at: $0, animated: true) }
    }
    
    // MARK: -
    // MARK: VC Presentation Methods
    
    func showObjectSelectionVC() {
        tableView?.indexPathForSelectedRow.flatMap {
            let property = dataSource.visibleProperties[$0.row]
            guard property.type == .object else { // Object selection valid only in case of `object` property type
                log_error("Attempted to show object selection view controller for property of type other than `object`. Discarding ...")
                return
            }
            
            dataSource.objectClass.getClassForName(property.objectClassName ?? "").flatMap { propertyClass in
                let objectSelectionVC = ObjectSelectionListViewController(objectClass: propertyClass)
                objectSelectionVC.objectSelected = { [weak self] object in
                    self.flatMap { selfie in selfie.dataSource.object[property.name] = object }
                }
                presenter?.show(objectSelectionVC, sender: nil)
            }
        }
    }
    
    func showTextPickerVC() {
        tableView?.indexPathForSelectedRow.flatMap {
            let property = dataSource.visibleProperties[$0.row]
            guard property.type == .string else { // Text picker valid only in case of `string` property type
                log_error("Attempted to show text picker view controller for property of type other than `string`. Discarding ...")
                return
            }
            
            dataSource.propertyConfigurations[property.name]?.pickerValues.flatMap { pickerValues in
                let pickerVC = PickerViewController(pickerValues: pickerValues, fieldTitle: property.displayName)
                pickerVC.currentValue = dataSource.object[property.name] as? String ?? ""
                pickerVC.valueSelected = { [weak self] value in
                    self.flatMap { selfie in selfie.dataSource.object[property.name] = value }
                }
                presenter?.show(pickerVC, sender: nil)
            }
        }
    }
    
    func showNewRelatedObjectVC(_ sender: UIBarButtonItem!) {
        let newRelatedObjectsVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        dataSource.objectClass.inverseRelationships.forEach { inverseRelationship in
            let sourceClassName = inverseRelationship.sourceType.name
            let action = UIAlertAction(title: "New \(sourceClassName)", style: .default, handler: { [weak self] _ in
                self.flatMap { selfie in
                    let newRelatedObject = inverseRelationship.sourceType.init()
                    newRelatedObject[inverseRelationship.sourceProperty] = selfie.dataSource.object
                    selfie.showVCFor(object: newRelatedObject)
                }})
            newRelatedObjectsVC.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        newRelatedObjectsVC.addAction(cancelAction)
        newRelatedObjectsVC.popoverPresentationController?.barButtonItem = sender

        presenter?.present(newRelatedObjectsVC, animated: true, completion: nil)
    }
    
    func handleImageSelection() {
        tableView?.indexPathForSelectedRow.flatMap { indexPath in
            let property = dataSource.visibleProperties[indexPath.row]
            guard property.type == .data else { // Image selection valid only in case of `data` property type
                log_error("Attempted to show image source selection action sheet for property of type other than `data`. Discarding ...")
                return
            }
            imageSelectionInteraction = ImageSelectionInteraction(presenter: presenter ?? self,
                                                                  imageNameData: dataSource.object[property.name] as? Data,
                                                                  imageSelected: { [weak self] image in
                self.flatMap { selfie in
                    selfie.dataSource.object.setImage(image, for: property.name)
                    selfie.tableView?.reloadRows(at: [indexPath], with: .automatic)
                }
            }, cancelled: { [weak self] in _ = self.flatMap { selfie in selfie.tableView?.endEditing(true) } })
            
            imageSelectionInteraction?.handle(sourceView: tableView?.cellForRow(at: indexPath) ?? view)
        }
    }
    
}
