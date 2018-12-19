//
//  ModelClassTests.swift
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


class ModelClassTests: XCTestCase {
    
    func testComputedTypeProperties() {
        let companyClass = M2A_TestCompany.self
        let personClass = M2A_InvalidTestPerson.self
        let dealClass = M2A_InvalidTestPartnerDeal.self
        
        XCTAssertEqual(companyClass.displayName, "Company")
        XCTAssertEqual(companyClass.plural, "Companies")
        XCTAssertEqual(personClass.plural, "M2A_InvalidTestPerson - List")
        
        XCTAssertNotNil(companyClass.menuIcon)
        XCTAssertNotNil(personClass.menuIcon)
        
        XCTAssertEqual(companyClass.defaultListViewCellProperty, "name")
        XCTAssertEqual(dealClass.defaultListViewCellProperty, "title")
        
        XCTAssertTrue(type(of: companyClass.referenceObject) == type(of: M2A_TestCompany()))
    }
    
    func testComputedInstanceProperties() {
        let personInstance = M2A_TestPerson()
        let companyInstance = M2A_TestCompany()
        
        personInstance.firstName = "Steve"
        personInstance.lastName = "Jobs"
        companyInstance.name = "Apple"
        
        XCTAssertEqual(personInstance.objectName, "Steve Jobs")
        XCTAssertEqual(companyInstance.objectName, "Apple")
        XCTAssertTrue(personInstance.isNew)
    }
    
    func testTypeMethods() {
        let personClass = M2A_TestPerson.self
        
        XCTAssertTrue(personClass.isProperty("picture", ofType: .data))
        XCTAssertTrue(personClass.isProperty("birthday", ofType: .date))
        XCTAssertTrue(personClass.isProperty("workEmail", ofType: .string))
        
        XCTAssertEqual(personClass.getClassNameForProperty("company"), "M2A_TestCompany")
        XCTAssertNil(personClass.getClassNameForProperty("note"))
        
        XCTAssertTrue(personClass.getClassForName("M2A_TestCompany") == M2A_TestCompany.self)
    }
    
    func testInstanceMethods() {
        let personInstance = M2A_TestPerson()
        let companyInstance = M2A_TestCompany()
        let dealInstance = M2A_TestDeal()
        
        personInstance.company = companyInstance
        personInstance.salutation = "Mr."
        personInstance.birthday = Date(dateString: "1900-03-14")
        personInstance.preferredLunchTime = Date(timeString: "11:30")
        companyInstance.name = "Apple"
        companyInstance["numberOfDepartments"] = 6
        dealInstance["value"] = Float(9.99)
        dealInstance["prospectValue"] = Double(99999999.99)
        dealInstance.closingDate = Date(dateTimeString: "2018-10-31 10:30")
        
        XCTAssertEqual(personInstance.valueString(forProperty: "company"), "Apple")
        XCTAssertEqual(personInstance.valueString(forProperty: "salutation"), "Mr.")
        XCTAssertEqual(personInstance.valueString(forProperty: "birthday"), "Mar 14, 1900")
        XCTAssertEqual(personInstance.valueString(forProperty: "preferredLunchTime"), "11:30 AM")
        XCTAssertEqual(companyInstance.valueString(forProperty: "numberOfDepartments"), "6")
        XCTAssertEqual(dealInstance.valueString(forProperty: "value"), "9.99")
        XCTAssertEqual(dealInstance.valueString(forProperty: "prospectValue"), "99999999.99")
        XCTAssertEqual(dealInstance.valueString(forProperty: "closingDate"), "10/31/18, 10:30 AM")
    }
}
