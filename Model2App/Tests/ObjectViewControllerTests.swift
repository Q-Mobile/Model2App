//
//  ObjectViewControllerTests.swift
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


class ObjectViewControllerTests: ObjectTestCase {
    
    private var objectVC: ObjectViewController!
    
    override func setUp() {
        super.setUp()
        guard let firstContact = storage.firstObject(M2A_TestPerson.self) else { return XCTFail() }
        objectVC = ObjectViewController(object: firstContact)
        addTestCompaniesToStorage()
    }
    
    override func tearDown() {
        objectVC = nil
        
        super.tearDown()
    }
    
    func testLoadingObjectVC() {
        XCTAssertNotNil(objectVC.view)
        XCTAssertNotNil(objectVC.tableView)
        XCTAssertNotNil(objectVC.tableView?.backgroundView)
        XCTAssertNotNil(objectVC.tableView.dataSource)
        XCTAssertNotNil(objectVC.tableView.delegate)
        XCTAssertNotNil(objectVC.accessoryView)
        XCTAssertNotNil(objectVC.dataSource)
        XCTAssertNotNil(objectVC.tableDelegate)
        
        XCTAssertTrue(type(of: objectVC.dataSource) == ObjectDataSource.self)
        XCTAssertTrue(type(of: objectVC.tableDelegate) == ObjectTableDelegate.self)
        
        XCTAssertNotNil(objectVC.navigationItem.leftBarButtonItem)
        XCTAssertNotNil(objectVC.navigationItem.rightBarButtonItem)
        XCTAssertTrue(objectVC.navigationItem.rightBarButtonItems?.count == 1)
        XCTAssertEqual(objectVC.navigationItem.title, "M2A_TestPerson")
        
        guard let company = storage.objects(M2A_TestCompany.self).filter("name == 'Ford'").first else { return XCTFail() }
        objectVC = ObjectViewController(object: company)
        XCTAssertNotNil(objectVC.view)
        XCTAssertTrue(objectVC.navigationItem.rightBarButtonItems?.count == 2)
    }
    
    func testLoadingObjectDataSource() {
        var dataSource = objectVC.dataSource
        XCTAssertNotNil(dataSource.object)
        XCTAssertNotNil(dataSource.objectClass)
        XCTAssertEqual(dataSource.properties.count, 14)
        XCTAssertEqual(dataSource.visibleProperties.count, 13)
        XCTAssertFalse(dataSource.propertyConfigurations.isEmpty)
        
        guard let company = storage.objects(M2A_TestCompany.self).filter("name == 'Ford'").first else { return XCTFail() }
        objectVC = ObjectViewController(object: company)
        dataSource = objectVC.dataSource
        
        XCTAssertFalse(dataSource.relatedObjects.isEmpty)
        XCTAssertEqual(dataSource.relatedObjects["employees"]?.objectCount, 2)
        XCTAssertEqual(dataSource.relatedObjects["deals"]?.objectCount, 0)
        
        guard let tableView = objectVC.tableView else { return XCTFail() }
        
        let sectionsCount = dataSource.numberOfSections(in: tableView)
        XCTAssertEqual(sectionsCount, 3)
        
        var rowsCount = dataSource.tableView(tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(rowsCount, 5)
        rowsCount = dataSource.tableView(tableView, numberOfRowsInSection: 1)
        XCTAssertEqual(rowsCount, 2)
        
        var sectionCell = dataSource.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertTrue(sectionCell.isKind(of: BasePropertyCell.self))
        sectionCell = dataSource.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 1))
        XCTAssertTrue(type(of: sectionCell) == ObjectListViewCell.self)
    }
 
    func testObjectVCTableViewUpdates() {
        guard let company = storage.objects(M2A_TestCompany.self).filter("name == 'Ford'").first else { return XCTFail() }
        objectVC = ObjectViewController(object: company)
        guard let tableView = objectVC.tableView else { return XCTFail() }
        let dataSource = objectVC.dataSource
        
        var relatedObjectsCount = dataSource.tableView(tableView, numberOfRowsInSection: 1)
        XCTAssertEqual(relatedObjectsCount, 2)
        
        storage.beginWrite()
        guard let contact = storage.objects(M2A_TestPerson.self).filter("lastName == 'Da Vinci'").first else { return XCTFail() }
        contact.company = company
        storage.commitWrite()
        
        relatedObjectsCount = dataSource.tableView(tableView, numberOfRowsInSection: 1)
        XCTAssertEqual(relatedObjectsCount, 3)
    }
    
    func testObjectTableDelegate() {
        guard let company = storage.objects(M2A_TestCompany.self).filter("name == 'Ford'").first else { return XCTFail() }
        objectVC = ObjectViewController(object: company)
        
        let tableDelegate = objectVC.tableDelegate
        XCTAssertNotNil(tableDelegate.object)
        XCTAssertNotNil(tableDelegate.objectClass)
        XCTAssertNotNil(tableDelegate.dataSource)
        XCTAssertFalse(tableDelegate.properties.isEmpty)
        
        let relatedObjectsHeader = tableDelegate.tableView(objectVC.tableView, viewForHeaderInSection: 1)
        XCTAssertNotNil(relatedObjectsHeader)
        relatedObjectsHeader.flatMap { XCTAssertTrue(type(of: $0) == ObjectSectionHeader.self) }
        (relatedObjectsHeader as? ObjectSectionHeader).flatMap { header in
            XCTAssertEqual(header.titleLabel.text, "EMPLOYEES")
            XCTAssertTrue(header.titleLabel.isDescendant(of: header))
        }
    }
     
    func testObjectVCPresentationFromProperty() {
        guard let contact = storage.objects(M2A_TestPerson.self).filter("lastName == 'Ford'").first else { return XCTFail() }
        objectVC = ObjectViewController(object: contact)
        
        guard let tableView = objectVC.tableView else { return XCTFail() }
        let tableDelegate = objectVC.tableDelegate
        
        let fakePresenter = BasePresenterMock()
        objectVC.presenter = fakePresenter
        
        guard let companyIndex = objectVC.dataSource.visibleProperties.index(where: { $0.name == "company" }) else { return XCTFail() }
        tableDelegate.tableView(tableView, didSelectRowAt: IndexPath(row: companyIndex, section: 0))
        
        XCTAssertTrue(fakePresenter.didPresent)
        XCTAssertNotNil(fakePresenter.presentedVC)
        guard let presentedVC = fakePresenter.presentedVC else { return XCTFail() }
        let isObjectVCPresented = presentedVC.children.contains(where: { type(of: $0) == ObjectViewController.self })
        XCTAssertTrue(isObjectVCPresented)
    }
    
    func testObjectVCPresentationFromRelatedObject() {
        guard let company = storage.objects(M2A_TestCompany.self).filter("name == 'Ford'").first else { return XCTFail() }
        objectVC = ObjectViewController(object: company)
        
        guard let tableView = objectVC.tableView else { return XCTFail() }
        let tableDelegate = objectVC.tableDelegate
        
        let fakePresenter = BasePresenterMock()
        objectVC.presenter = fakePresenter
        tableDelegate.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 1))
        
        XCTAssertTrue(fakePresenter.didPresent)
        XCTAssertNotNil(fakePresenter.presentedVC)
        guard let presentedVC = fakePresenter.presentedVC else { return XCTFail() }
        let isObjectVCPresented = presentedVC.children.contains(where: { type(of: $0) == ObjectViewController.self })
        XCTAssertTrue(isObjectVCPresented)
    }

    func testObjectSelectionVCPresentation() {
        guard let tableView = objectVC.tableView else { return XCTFail() }
        guard let companyIndex = objectVC.dataSource.visibleProperties.index(where: { $0.name == "company" }) else { return XCTFail() }
        tableView.selectRow(at: IndexPath(row: companyIndex, section: 0), animated: false, scrollPosition: .none)
        
        let fakePresenter = BasePresenterMock()
        objectVC.presenter = fakePresenter
        
        objectVC.showObjectSelectionVC()
        
        XCTAssertTrue(fakePresenter.didPresent)
        XCTAssertNotNil(fakePresenter.presentedVC)
        guard let presentedVC = fakePresenter.presentedVC else { return XCTFail() }
        XCTAssertTrue(type(of: presentedVC) == ObjectSelectionListViewController.self)
    }
    
    func testTextPickerVCPresentation() {
        guard let tableView = objectVC.tableView else { return XCTFail() }
        guard let salutationIndex = objectVC.dataSource.visibleProperties.index(where: { $0.name == "salutation" }) else { return XCTFail() }
        tableView.selectRow(at: IndexPath(row: salutationIndex, section: 0), animated: false, scrollPosition: .none)
        
        let fakePresenter = BasePresenterMock()
        objectVC.presenter = fakePresenter
        
        objectVC.showTextPickerVC()
        
        XCTAssertTrue(fakePresenter.didPresent)
        XCTAssertNotNil(fakePresenter.presentedVC)
        guard let presentedVC = fakePresenter.presentedVC else { return XCTFail() }
        XCTAssertTrue(type(of: presentedVC) == PickerViewController.self)
    }
    
    func testNewRelatedObjectVCPresentation() {
        let fakePresenter = BasePresenterMock()
        objectVC.presenter = fakePresenter
        
        objectVC.showNewRelatedObjectVC(UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil))
        
        XCTAssertTrue(fakePresenter.didPresent)
        XCTAssertNotNil(fakePresenter.presentedVC)
        guard let presentedVC = fakePresenter.presentedVC else { return XCTFail() }
        XCTAssertTrue(type(of: presentedVC) == UIAlertController.self)
    }
    
    func testImageSelectionInteraction() {
        guard let tableView = objectVC.tableView else { return XCTFail() }
        guard let pictureIndex = objectVC.dataSource.visibleProperties.index(where: { $0.name == "picture" }) else { return XCTFail() }
        tableView.selectRow(at: IndexPath(row: pictureIndex, section: 0), animated: false, scrollPosition: .none)
        
        let fakePresenter = BasePresenterMock()
        objectVC.presenter = fakePresenter
        
        objectVC.handleImageSelection()
        
        XCTAssertNotNil(objectVC.imageSelectionInteraction)
        XCTAssertTrue(fakePresenter.didPresent)
        XCTAssertNotNil(fakePresenter.presentedVC)
        guard let presentedVC = fakePresenter.presentedVC else { return XCTFail() }
        XCTAssertTrue(type(of: presentedVC) == UIAlertController.self)
    }
    
    // MARK: -
    // MARK: Helper Methods
    
    private func addTestCompaniesToStorage() {
        storage.write {
            addTestCompany("Apple")
            let company = addTestCompany("Ford")

            if let contact = storage.objects(M2A_TestPerson.self).filter("lastName == 'Ford'").first {
                contact.company = company
            }
            if let contact = storage.objects(M2A_TestPerson.self).filter("lastName == 'Einstein'").first {
                contact.company = company
            }
        }
    }
    
    @discardableResult
    func addTestCompany(_ name: String) -> M2A_TestCompany {
        let company = M2A_TestCompany()
        company.name = name
        storage.add(company)
        
        return company
    }
}
