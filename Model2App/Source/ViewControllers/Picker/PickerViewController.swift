//
//  PickerViewController.swift
//  Model2App
//
//  Created by Karol Kulesza on 6/19/18.
//  Copyright © 2018 Q Mobile ( http://Q-Mobile.IT ) All rights reserved.
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
 *  View controller responsible for presenting a list of possible values to pick from
 */
open class PickerViewController: BaseTableViewController {
    
    // MARK: -
    // MARK: Properties & Constants
    
    private let cellReuseIdentifier = "PickerViewControllerCell"
    
    /// List of possible values to pick from
    public private(set) var pickerValues: [String]?
    
    /// Title of property for this picklist
    public private(set) var fieldTitle: String?
    
    /// Currently selected value
    public internal(set) var currentValue: String?
    
    var valueSelected: ((String) -> Void)?
    
    // MARK: -
    // MARK: Initializers
    
    public init(pickerValues: [String], fieldTitle: String)
    {
        self.pickerValues = pickerValues
        self.fieldTitle = fieldTitle
        super.init(style: .plain)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: -
    // MARK: BaseTableViewController Methods
    
    override open func setup() {
        super.setup()
        
        tableView.register(PickerListViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        navigationItem.title = "Choose \(fieldTitle ?? "value")"
    }
    
    // MARK: -
    // MARK: UITableViewDataSource Methods
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pickerValues?.count ?? 0
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! PickerListViewCell
        cell.updateForValue(value: pickerValues?[indexPath.row], selectedValue: currentValue)

        return cell
    }
    
    // MARK: -
    // MARK: UITableViewDelegate Methods
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = pickerValues?[indexPath.row]
        value.flatMap { valueSelected?($0) }
        navigationController?.popViewController(animated: true)
    }
    
}
