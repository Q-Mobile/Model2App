//
//  ObjectTableDelegate.swift
//  Model2App
//
//  Created by Karol Kulesza on 10/18/18.
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


class ObjectTableDelegate: NSObject, UITableViewDelegate {
    
    // MARK: -
    // MARK: Properties & Constants
    
    var dataSource: ObjectDataSource
    var object: ModelClass { return dataSource.object }
    var objectClass: ModelClass.Type { return dataSource.objectClass }
    var properties: [ObjectProperty] { return dataSource.visibleProperties }
    
    weak var presenter: ModelPresenter?
    
    // MARK: -
    // MARK: Initializers & Deinitializers
    
    public init(dataSource: ObjectDataSource)
    {
        self.dataSource = dataSource
        super.init()
    }
    
    // MARK: -
    // MARK: UITableViewDelegate Methods
    
    open func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 && !tableView.isEditing { return properties[indexPath.row].type == .object }
        return true
    }
    
    open func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 && !tableView.isEditing { return properties[indexPath.row].type == .object ? indexPath : nil }
        return indexPath
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // In case a property is of type `object`, display its details, but only in case it is not an edit mode
            if !tableView.isEditing && properties[indexPath.row].type == .object {
                (object[properties[indexPath.row].name] as? ModelClass).flatMap {
                    presenter?.showVCFor(object: $0, fromFrame: tableView.rectForRow(at: indexPath))
                }
            } else {
                let cell = tableView.cellForRow(at: indexPath) as? BaseCell ?? BaseCell()
                if !cell.becomeFirstResponder() {
                    tableView.endEditing(true)
                }
                cell.didSelect()
            }
        } else {
            let relationship = objectClass.inverseRelationships[indexPath.section - 1]
            let relatedObject = dataSource.relatedObjects[relationship.name].flatMap { $0[indexPath.row] }
            presenter?.showVCFor(object: relatedObject, fromFrame: tableView.rectForRow(at: indexPath))
        }
    }
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 0 }
        let relatedObjectsCount = dataSource.numberOfSections(in: tableView)
        return relatedObjectsCount > 0 ? UITableView.automaticDimension : 0
    }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard objectClass.inverseRelationships.count >= section else { return nil }
        
        let header = ObjectSectionHeader()
        header.titleLabel.text = objectClass.inverseRelationships[section - 1].name.camelCaseToWords().uppercased()
        return header
    }
    
    open func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == 0 { return .none } else { return .delete }
    }
    
    open func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // MARK: -
    // MARK: ObjectTableDelegate Methods

    func nextCell(for cell: BasePropertyCell, _ tableView: UITableView) -> BasePropertyCell? {
        guard let currentIndexPath = tableView.indexPath(for: cell) else { return nil }
        guard dataSource.visibleProperties.count > currentIndexPath.row + 1 else { return nil }
        
        let nextIndexPath = IndexPath(row: currentIndexPath.row + 1, section: currentIndexPath.section)
        let nextCell = tableView.cellForRow(at: nextIndexPath) as! BasePropertyCell
        if nextCell.canBecomeFirstResponder { return nextCell }
        
        return self.nextCell(for: nextCell, tableView)
    }
}
