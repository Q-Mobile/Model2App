//
//  ObjectListViewControllerTests.swift
//  Model2AppTests
//
//  Created by Karol Kulesza on 10/22/18.
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

import XCTest
@testable import Model2App


class ObjectListViewControllerTests: ObjectTestCase {
    
    private var objectListVC: ObjectListViewController!
    
    override func setUp() {
        super.setUp()
        
        objectListVC = ObjectListViewController(objectClass: M2A_TestPerson.self)
    }
    
    override func tearDown() {
        objectListVC = nil
        
        super.tearDown()
    }
    
    func testLoadingObjectListVC() {
        XCTAssertNotNil(objectListVC.view)
        XCTAssertNotNil(objectListVC.tableView)
        XCTAssertNotNil(objectListVC.tableView?.backgroundView)
        
        XCTAssertNotNil(objectListVC.navigationItem.leftBarButtonItem)
        XCTAssertNotNil(objectListVC.navigationItem.rightBarButtonItem)
        XCTAssertEqual(objectListVC.navigationItem.title, "People")
        
        XCTAssertTrue(objectListVC.objectClass == M2A_TestPerson.self)
        XCTAssertEqual(objectListVC.objects?.objectCount, storage.objects(M2A_TestPerson.self).objectCount)
    }
    
    func testObjectListVCTableView() {
        let rowsCount = objectListVC.tableView(objectListVC.tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(rowsCount, storage.objects(M2A_TestPerson.self).objectCount)
        
        let objectListCell = objectListVC.tableView(objectListVC.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertTrue(type(of: objectListCell) == type(of: ObjectListViewCell()))
    }
    
    func testObjectListVCTableViewUpdates() {
        let objectCount = storage.objects(M2A_TestPerson.self).objectCount
        var rowsCount = objectListVC.tableView(objectListVC.tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(rowsCount, storage.objects(M2A_TestPerson.self).objectCount)
        
        storage.beginWrite()
        let newContact = addTestContact("John", "Appleseed")
        storage.commitWrite()
        rowsCount = objectListVC.tableView(objectListVC.tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(rowsCount, objectCount + 1)
        
        storage.write { storage.delete(newContact) }
        rowsCount = objectListVC.tableView(objectListVC.tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(rowsCount, objectCount)
    }
    
    func testObjectVCPresentation() {
        guard let firstContact = storage.firstObject(M2A_TestPerson.self) else { return XCTFail() }
        
        let fakePresenter = BasePresenterMock()
        objectListVC.presenter = fakePresenter
        objectListVC.showVCFor(object: firstContact)
        
        XCTAssertTrue(fakePresenter.didPresent)
        XCTAssertNotNil(fakePresenter.presentedVC)
        guard let presentedVC = fakePresenter.presentedVC else { return XCTFail() }
        let isObjectVCPresented = presentedVC.children.contains(where: { type(of: $0) == ObjectViewController.self })
        XCTAssertTrue(isObjectVCPresented)
    }
    
    func testObjectListViewCell() {
        guard let objectListCell = objectListVC.tableView(objectListVC.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? ObjectListViewCell else { return XCTFail() }
        guard let firstContact = storage.firstObject(M2A_TestPerson.self) else { return XCTFail() }
        
        objectListCell.updateForObject(object: firstContact)
        XCTAssertTrue(objectListCell.modelClass == M2A_TestPerson.self)
        XCTAssertFalse(objectListCell.listViewCellProperties.isEmpty)
        
        M2A_TestPerson.listViewCellProperties.forEach { property in
            let view = objectListCell.views[property]
            XCTAssertNotNil(view, "There is no `\(property)` view in `objectListCell` for `M2A_TestPerson`.")
            view.flatMap { propertyView in
                XCTAssertTrue(propertyView.isDescendant(of: objectListCell.contentView))
                if M2A_TestPerson.isProperty(property, ofType: .data) {
                    XCTAssertTrue(type(of: propertyView) == UIImageView.self)
                    XCTAssertNotNil((propertyView as? UIImageView)?.image)
                } else {
                    XCTAssertTrue(type(of: propertyView) == UILabel.self)
                    XCTAssertEqual((propertyView as? UILabel)?.text, firstContact.valueString(forProperty: property))
                }
            }
        }
    }
}
