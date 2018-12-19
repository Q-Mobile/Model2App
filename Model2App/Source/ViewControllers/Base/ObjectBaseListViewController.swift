//
//  ObjectBaseListViewController.swift
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
 *  Base class for object list VCs
 */
open class ObjectBaseListViewController: ObjectBaseViewController {
    
    // MARK: -
    // MARK: Properties & Constants
    
    /// List of objects presented by this VC
    public private(set) var objects: Objects?
    
    /// Model class of the presented objects
    public private(set) var objectClass: ModelClass.Type
    
    private let cellReuseIdentifier = "ObjectBaseListViewControllerCell"
    private var objectsNotification: ObjectNotification?
    
    // MARK: -
    // MARK: Initializers
    
    public init(objectClass: ModelClass.Type)
    {
        self.objectClass = objectClass
        super.init(style: .plain)

        loadObjects()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.objectClass = ModelClass.self
        super.init(coder: aDecoder)
    }
    
    deinit {
        objectsNotification?.invalidate()
    }
    
    // MARK: -
    // MARK: UITableViewDataSource Methods
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects?.count ?? 0
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var reusableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? ObjectListViewCell
        if reusableCell == nil { // NOTE: Manually creating reusable cell, in order to utilise custom initializer
            reusableCell = ObjectListViewCell(withModelClass: objectClass, reuseIdentifier: cellReuseIdentifier)
        }
        guard let cell = reusableCell else { return UITableViewCell(style: .default, reuseIdentifier: cellReuseIdentifier) }
        if let objects = objects, !objects.isEmpty { cell.updateForObject(object: objects[indexPath.row]) }

        return cell
    }
    
    // MARK: -
    // MARK: ObjectBaseListViewController Methods
    
    /**
     *  Responsible for loading objects and setting up notification handlers
     */
    open func loadObjects() {
        objects = storage.objects(objectClass)
        guard !storage.isInWriteTransaction else { return } // Do not observe changes if in edit mode
        
        objectsNotification = objects?.observe { [weak self] (changes: CollectionChange) in
            let updateTableView = {
                self.flatMap { selfie in
                    guard !selfie.tableView.isEditing else { return }
                    
                    switch changes {
                    case .update(_, let deletions, let insertions, let modifications):
                        selfie.tableView.beginUpdates()
                        selfie.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                        selfie.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                        selfie.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                        selfie.tableView.endUpdates()
                        if insertions.count > 0 { selfie.tableView.scrollToRow(at: IndexPath(row: insertions[0], section: 0), at: .middle, animated: true) }
                    default: return
                    }
                }
            }
            if !ModelManager.shared.isUnderTests { // Do not add delay
                DispatchQueue.main.asyncAfter(deadline: .now() + M2AConstants.defaultListViewUpdateDelay) {
                    updateTableView()
                }
            } else { updateTableView() }
        }
    }
    
}
