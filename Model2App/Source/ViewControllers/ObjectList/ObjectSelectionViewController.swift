//
//  ObjectSelectionListViewController.swift
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
 *  View controller responsible for presenting a list of objects to be selected for a given property of type `object`
 */
open class ObjectSelectionListViewController: ObjectBaseListViewController {
    
    private let noneCellReuseIdentifier = "NoneObjectListViewCell"
    var objectSelected: ((ModelClass?) -> Void)?
    
    // MARK: -
    // MARK: BaseTableViewController Methods
    
    override open func setup() {
        super.setup()
        
        navigationItem.title = "Choose \(objectClass.name)"
        tableView.register(NoneObjectListViewCell.self, forCellReuseIdentifier: noneCellReuseIdentifier)
    }
    
    // MARK: -
    // MARK: UITableViewDataSource Methods
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return super.tableView(tableView, numberOfRowsInSection: section) + 1
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return  tableView.dequeueReusableCell(withIdentifier: noneCellReuseIdentifier) as! NoneObjectListViewCell
        }
        return super.tableView(tableView, cellForRowAt: IndexPath(row: indexPath.row - 1, section: indexPath.section))
    }
    
    // MARK: -
    // MARK: UITableViewDelegate Methods
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object: ModelClass? = indexPath.row == 0 ? nil : objects?[indexPath.row - 1]
        objectSelected?(object)
        
        navigationController?.popViewController(animated: true)
    }
    
}
