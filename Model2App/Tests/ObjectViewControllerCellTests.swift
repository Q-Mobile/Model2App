//
//  ObjectViewControllerCellTests.swift
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


class ObjectViewControllerCellTests: ObjectTestCase {
    
    private var objectVC: ObjectViewController!
    private var testPerson: M2A_TestPerson!
    
    override func setUp() {
        super.setUp()
        
        testPerson = storage.firstObject(M2A_TestPerson.self)
        objectVC = ObjectViewController(object: testPerson)
        storage.beginWrite()
        XCTAssertNotNil(testPerson)
    }
    
    override func tearDown() {
        storage.cancelWrite()
        testPerson = nil
        objectVC = nil
        
        super.tearDown()
    }
    
    func testObjectViewTextFieldCell() {
        guard let textFieldCell = getCellForPropertyName(#keyPath(M2A_TestPerson.firstName)) else { return XCTFail() }
        textFieldCell.valueChanged?("John")
        XCTAssertEqual(testPerson.firstName, "John")
        XCTAssertTrue(type(of: textFieldCell) == TextFieldCell.self)
        
        guard let cell = textFieldCell as? TextFieldCell else { return XCTFail() }
        XCTAssertNotNil(cell.titleLabel)
        XCTAssertNotNil(cell.valueView)
        XCTAssertTrue(cell.titleLabel.isDescendant(of: cell.contentView))
        XCTAssertTrue(cell.textField.isDescendant(of: cell.contentView))
    }
    
    func testObjectViewTextPickerCell() {
        guard let textPickerCell = getCellForPropertyName(#keyPath(M2A_TestPerson.salutation)) else { return XCTFail() }
        textPickerCell.valueChanged?("Dr.")
        XCTAssertEqual(testPerson.salutation, "Dr.")
        XCTAssertTrue(type(of: textPickerCell) == TextPickerCell.self)
        
        guard let cell = textPickerCell as? TextPickerCell else { return XCTFail() }
        XCTAssertNotNil(cell.titleLabel)
        XCTAssertNotNil(cell.valueView)
        XCTAssertTrue(cell.titleLabel.isDescendant(of: cell.contentView))
        XCTAssertTrue(cell.valueLabel.isDescendant(of: cell.contentView))
    }
    
    func testObjectViewPhoneFieldCell() {
        guard let phoneFieldCell = getCellForPropertyName(#keyPath(M2A_TestPerson.phoneNumber)) else { return XCTFail() }
        phoneFieldCell.valueChanged?("123123123")
        XCTAssertEqual(testPerson.phoneNumber, "123123123")
        XCTAssertTrue(type(of: phoneFieldCell) == PhoneFieldCell.self)

        guard let cell = phoneFieldCell as? PhoneFieldCell else { return XCTFail() }
        XCTAssertNotNil(cell.titleLabel)
        XCTAssertNotNil(cell.valueView)
        XCTAssertTrue(cell.titleLabel.isDescendant(of: cell.contentView))
        XCTAssertTrue(cell.textField.isDescendant(of: cell.contentView))
    }

    func testObjectViewEmailFieldCell() {
        guard let emailFieldCell = getCellForPropertyName(#keyPath(M2A_TestPerson.privateEmail)) else { return XCTFail() }
        emailFieldCell.valueChanged?("john@jobs.com")
        XCTAssertEqual(testPerson.privateEmail, "john@jobs.com")
        XCTAssertTrue(type(of: emailFieldCell) == EmailFieldCell.self)
        
        guard let cell = emailFieldCell as? EmailFieldCell else { return XCTFail() }
        XCTAssertNotNil(cell.titleLabel)
        XCTAssertNotNil(cell.valueView)
        XCTAssertTrue(cell.titleLabel.isDescendant(of: cell.contentView))
        XCTAssertTrue(cell.textField.isDescendant(of: cell.contentView))
    }
    
    func testObjectViewSwitchCell() {
        guard let switchCell = getCellForPropertyName("isKeyOpinionLeader") else { return XCTFail() }
        switchCell.valueChanged?(true)
        XCTAssertEqual(testPerson.isKeyOpinionLeader.value, true)
        XCTAssertTrue(type(of: switchCell) == SwitchCell.self)

        guard let cell = switchCell as? SwitchCell else { return XCTFail() }
        XCTAssertNotNil(cell.titleLabel)
        XCTAssertNotNil(cell.switchControl)
        XCTAssertTrue(cell.titleLabel.isDescendant(of: cell.contentView))
        XCTAssertTrue(cell.switchControl.isDescendant(of: cell.accessoryView ?? UIView()))
    }
    
    func testObjectViewDatePickerCell() {
        guard let datePickerCell = getCellForPropertyName(#keyPath(M2A_TestPerson.birthday)) else { return XCTFail() }
        datePickerCell.valueChanged?(Date(dateString: "1909-03-14"))
        XCTAssertEqual(testPerson.birthday, Date(dateString: "1909-03-14"))
        XCTAssertTrue(type(of: datePickerCell) == DatePickerCell.self)
        
        guard let cell = datePickerCell as? DatePickerCell else { return XCTFail() }
        XCTAssertNotNil(cell.titleLabel)
        XCTAssertNotNil(cell.valueView)
        XCTAssertNotNil(cell.datePicker)
        XCTAssertNotNil(cell.dateFormatter)
        XCTAssertTrue(cell.titleLabel.isDescendant(of: cell.contentView))
        XCTAssertTrue(cell.valueLabel.isDescendant(of: cell.contentView))
    }
    
    func testObjectViewUrlFieldCell() {
        guard let urlFieldCell = getCellForPropertyName(#keyPath(M2A_TestPerson.website)) else { return XCTFail() }
        urlFieldCell.valueChanged?("http://www.q-mobile.it")
        XCTAssertEqual(testPerson.website, "http://www.q-mobile.it")
        XCTAssertTrue(type(of: urlFieldCell) == URLFieldCell.self)
        
        guard let cell = urlFieldCell as? URLFieldCell else { return XCTFail() }
        XCTAssertNotNil(cell.titleLabel)
        XCTAssertNotNil(cell.valueView)
        XCTAssertTrue(cell.titleLabel.isDescendant(of: cell.contentView))
        XCTAssertTrue(cell.textField.isDescendant(of: cell.contentView))
    }
    
    func testObjectViewTimePickerCell() {
        guard let timePickerCell = getCellForPropertyName(#keyPath(M2A_TestPerson.preferredLunchTime)) else { return XCTFail() }
        timePickerCell.valueChanged?(Date(timeString: "11:30"))
        XCTAssertEqual(testPerson.preferredLunchTime, Date(timeString: "11:30"))
        XCTAssertTrue(type(of: timePickerCell) == TimePickerCell.self)

        guard let cell = timePickerCell as? TimePickerCell else { return XCTFail() }
        XCTAssertNotNil(cell.titleLabel)
        XCTAssertNotNil(cell.valueView)
        XCTAssertNotNil(cell.datePicker)
        XCTAssertNotNil(cell.dateFormatter)
        XCTAssertTrue(cell.titleLabel.isDescendant(of: cell.contentView))
        XCTAssertTrue(cell.valueLabel.isDescendant(of: cell.contentView))
    }
    
    func testObjectViewObjectPickerCell() {
        addTestCompany("Ford")
        guard let testCompany = storage.objects(M2A_TestCompany.self).filter("name == 'Ford'").first else { return XCTFail() }
        
        guard let objectPickerCell = getCellForPropertyName(#keyPath(M2A_TestPerson.company)) else { return XCTFail() }
        objectPickerCell.valueChanged?(testCompany)
        XCTAssertTrue(testCompany.isSameObject(as: testPerson.company))
        XCTAssertTrue(type(of: objectPickerCell) == ObjectPickerCell.self)
        
        guard let cell = objectPickerCell as? ObjectPickerCell else { return XCTFail() }
        XCTAssertNotNil(cell.titleLabel)
        XCTAssertNotNil(cell.valueView)
        XCTAssertTrue(cell.titleLabel.isDescendant(of: cell.contentView))
        XCTAssertTrue(cell.valueLabel.isDescendant(of: cell.contentView))
    }
    
    func testObjectViewImagePickerCell() {
        guard let imagePickerCell = getCellForPropertyName(#keyPath(M2A_TestPerson.picture)) else { return XCTFail() }
        imagePickerCell.nonTypedValue = testPerson.picture
        imagePickerCell.update()
        XCTAssertTrue(type(of: imagePickerCell) == ImagePickerCell.self)
        
        guard let cell = imagePickerCell as? ImagePickerCell else { return XCTFail() }
        XCTAssertNotNil(cell.titleLabel)
        XCTAssertNotNil(cell.accessoryView)
        XCTAssertTrue(cell.titleLabel.isDescendant(of: cell.contentView))
        cell.accessoryView.flatMap { XCTAssertTrue(type(of: $0) == UIImageView.self) }
    }
    
    func testObjectViewFloatDecimalFieldCell() {
        addTestDeal("Test Deal")
        guard let deal = storage.objects(M2A_TestDeal.self).first else { return XCTFail() }
        objectVC = ObjectViewController(object: deal)
        
        guard let floatDecimalFieldCell = getCellForPropertyName("value") else { return XCTFail() }
        floatDecimalFieldCell.valueChanged?(Float(6.66))
        XCTAssertEqual(deal.value.value, Float(6.66))
        XCTAssertTrue(type(of: floatDecimalFieldCell) == FloatDecimalFieldCell.self)
        
        guard let cell = floatDecimalFieldCell as? FloatDecimalFieldCell else { return XCTFail() }
        XCTAssertNotNil(cell.titleLabel)
        XCTAssertNotNil(cell.valueView)
        XCTAssertTrue(cell.titleLabel.isDescendant(of: cell.contentView))
        XCTAssertTrue(cell.textField.isDescendant(of: cell.contentView))
    }
    
    func testObjectViewDoubleDecimalFieldCell() {
        addTestDeal("Test Deal")
        guard let deal = storage.objects(M2A_TestDeal.self).first else { return XCTFail() }
        objectVC = ObjectViewController(object: deal)
        
        guard let doubleDecimalFieldCell = getCellForPropertyName("prospectValue") else { return XCTFail() }
        doubleDecimalFieldCell.valueChanged?(Double(66666666.66))
        XCTAssertEqual(deal.prospectValue.value, Double(66666666.66))
        XCTAssertTrue(type(of: doubleDecimalFieldCell) == DoubleDecimalFieldCell.self)
        
        guard let cell = doubleDecimalFieldCell as? DoubleDecimalFieldCell else { return XCTFail() }
        XCTAssertNotNil(cell.titleLabel)
        XCTAssertNotNil(cell.valueView)
        XCTAssertTrue(cell.titleLabel.isDescendant(of: cell.contentView))
        XCTAssertTrue(cell.textField.isDescendant(of: cell.contentView))
    }
    
    // MARK: -
    // MARK: Helper Methods
    
    @discardableResult
    func addTestCompany(_ name: String) -> M2A_TestCompany {
        let company = M2A_TestCompany()
        company.name = name
        storage.add(company)
        
        return company
    }

    @discardableResult
    func addTestDeal(_ name: String) -> M2A_TestDeal {
        let deal = M2A_TestDeal()
        deal.name = name
        storage.add(deal)
        
        return deal
    }
    
    private func getCellForPropertyName(_ propertyName: String) -> BasePropertyCell? {
        guard let tableView = objectVC.tableView else {
            XCTFail("Could not retrieve cell for property: \(propertyName)")
            return nil
        }
        guard let index = objectVC.dataSource.visibleProperties.index(where: { $0.name == propertyName }) else {
            XCTFail("Could not retrieve cell for property: \(propertyName)")
            return nil
        }
        
        return objectVC.dataSource.tableView(tableView, cellForRowAt: IndexPath(row: index, section: 0)) as? BasePropertyCell
    }
}
