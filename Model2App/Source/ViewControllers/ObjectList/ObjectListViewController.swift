//
//  ObjectListViewController.swift
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
 *  View controller responsible for presenting a list of objects of a given model class,
 *  with the option to create a new object of a given class by tapping on a `+` button in the navigation bar
 */
open class ObjectListViewController: ObjectBaseListViewController {
    
    // MARK: -
    // MARK: BaseTableViewController Methods
    
    override open func setup() {
        super.setup()
        
        let menuItem = UIBarButtonItem(title: "Menu", style: .done, target: self, action: #selector(doneItemTapped(_:)));
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewObjectItemTapped(_:)));
        
        navigationItem.leftBarButtonItem = menuItem
        navigationItem.rightBarButtonItem = addItem
        navigationItem.title = objectClass.plural
    }
  
    // MARK: -
    // MARK: UIViewController Methods
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !M2A.config.objectListCellDefaultShouldRoundImages { return }
        
        guard let objectListCell = tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? ObjectListViewCell else { return }
        (objectListCell.views.values.first(where: { ($0 as? UIImageView) != nil }) as? UIView).flatMap {
            if $0.frame.isEmpty { tableView.layoutIfNeeded() } // NOTE: To dynamically set images` corner radiuses, based on image view size defined in `listViewCellLayoutVisualFormats` of a given class
        }
    }
    
    // MARK: -
    // MARK: Action Methods
    
    @objc private func addNewObjectItemTapped(_ sender: UIBarButtonItem!) {
        showVCFor(object: objectClass.init())
    }
    
    @objc private func doneItemTapped(_ sender: UIBarButtonItem!) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: -
    // MARK: UITableViewDataSource Methods
    
    override open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            tableView.beginUpdates()
            if let object = objects?[indexPath.row] {
                storage.write { storage.delete(object) }
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    // MARK: -
    // MARK: UITableViewDelegate Methods
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let object = objects?[indexPath.row] {
            let objectFrame = tableView.rectForRow(at: indexPath)
            showVCFor(object: object, fromFrame: objectFrame)
        }
    }
    
}
