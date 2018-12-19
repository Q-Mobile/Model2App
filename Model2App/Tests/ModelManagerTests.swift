//
//  ModelManagerTests.swift
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


class ModelManagerTests: XCTestCase {
    
    private var modelManager: ModelManager { return ModelManager.shared }
    private var validator: ModelValidator { return ModelValidator.shared }
    private static var fakeApp: ApplicationMock?
    
    override class func setUp() {
        super.setUp()
        
        Storage.shared.inMemoryId = "\(ModelManagerTests.self)"
        fakeApp = ApplicationMock()
        ModelManager.shared.launch(for: fakeApp)
    }
    
    func testLoadingModelClasses() {
        XCTAssertEqual(modelManager.allModelClasses.count, 9) // 3 valid + 6 invalid test model classes
        XCTAssertEqual(modelManager.allRootClasses.count, 8) // 1 test model class is hidden
    }
    
    func testLoadingCellClasses() {
        XCTAssertEqual(modelManager.allCellClasses.count, 22)
    }
    
    func testLoadingConfigClass() {
        XCTAssertTrue(modelManager.configClass is M2A_TestAppConfig.Type)
    }
    
    func testValidatingModelClasses() {
        XCTAssertFalse(validator.validate(objectClass: M2A_InvalidTestPerson.self))
        XCTAssertFalse(validator.validate(objectClass: M2A_InvalidTestCompany.self))
        XCTAssertFalse(validator.validate(objectClass: M2A_InvalidTestPartnerCompany.self))
        XCTAssertFalse(validator.validate(objectClass: M2A_InvalidTestContact.self))
        
        XCTAssertTrue(validator.validate(objectClass: M2A_TestPerson.self))
        XCTAssertTrue(validator.validate(objectClass: M2A_TestCompany.self))
        XCTAssertTrue(validator.validate(objectClass: M2A_TestDeal.self))
    }
    
    func testSettingWindowRootVC() {
        let rootVC = ModelManagerTests.fakeApp?.window?.rootViewController
        XCTAssertNotNil(rootVC)
        guard let vc = rootVC else { return XCTFail() }
        XCTAssertTrue(type(of: vc) == RootViewController.self)
    }
    
    func testValidatingObjects() {
        let person = M2A_TestPerson()
        let deal = M2A_TestDeal()
        
        fillAllFields(for: person)
        XCTAssertTrue(validator.validate(object: person))
        person.firstName = nil
        XCTAssertFalse(validator.validate(object: person))

        fillAllFields(for: person)
        person.salutation = nil
        XCTAssertFalse(validator.validate(object: person))
        
        fillAllFields(for: person)
        person.phoneNumber = nil
        XCTAssertFalse(validator.validate(object: person))
        person.phoneNumber = "12345678"
        XCTAssertFalse(validator.validate(object: person))
        person.phoneNumber = "1234567890123"
        XCTAssertFalse(validator.validate(object: person))
        
        fillAllFields(for: person)
        person.privateEmail = "stevejobs"
        XCTAssertFalse(validator.validate(object: person))
        person.privateEmail = "steve@jobs"
        XCTAssertFalse(validator.validate(object: person))
        person.privateEmail = "steve.jobs"
        XCTAssertFalse(validator.validate(object: person))
        
        fillAllFields(for: person)
        person.workEmail = nil
        XCTAssertFalse(validator.validate(object: person))
        person.privateEmail = "steve@jobs.com"
        person.workEmail = "steve@jobs.com"
        XCTAssertFalse(validator.validate(object: person))
        
        fillAllFields(for: person)
        person.birthday = nil
        XCTAssertFalse(validator.validate(object: person))
        
        fillAllFields(for: person)
        person.website = "apple.com"
        XCTAssertFalse(validator.validate(object: person))
        person.website = "http://apple"
        XCTAssertFalse(validator.validate(object: person))
        person.website = "http://apple.com"
        XCTAssertTrue(validator.validate(object: person))
        
        fillAllFields(for: person)
        person.company = nil
        XCTAssertFalse(validator.validate(object: person))
        
        fillAllFields(for: person)
        person.company = nil
        XCTAssertFalse(validator.validate(object: person))
        
        fillAllFields(for: deal)
        deal["value"] = 99.00
        XCTAssertFalse(validator.validate(object: person))
        deal["value"] = 1000000.01
        XCTAssertFalse(validator.validate(object: person))
    }
    
    // MARK: -
    // MARK: Helper Methods
    
    private func fillAllFields(for testPerson: M2A_TestPerson) {
        testPerson.firstName = "Steve"
        testPerson.lastName = "Jobs"
        testPerson.salutation = "Mr."
        testPerson.phoneNumber = "123456789"
        testPerson.privateEmail = "steve@jobs.com"
        testPerson.workEmail = "steve@apple.com"
        testPerson.birthday = Date(dateString: "1955-02-24")
        testPerson.website = "http://www.apple.com"
        testPerson.note = "I want to put a ding in the universe."
        
        let testCompany = M2A_TestCompany()
        testCompany.name = "Apple"
        testPerson.company = testCompany
    }
    
    private func fillAllFields(for testDeal: M2A_TestDeal) {
        testDeal.name = "Entry deal"
        testDeal["value"] = 10000.00
        testDeal.stage = "Prospecting"
        testDeal.source = "Referral"
        
        let testCompany = M2A_TestCompany()
        testCompany.name = "Some Korean Competition"
        testDeal.company = testCompany
    }
}

class ApplicationMock : Application {
    var window: Window? = WindowMock()
}

class WindowMock : Window {
    var rootViewController: UIViewController?
}
