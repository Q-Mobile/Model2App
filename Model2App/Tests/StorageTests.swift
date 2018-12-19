//
//  StorageTests.swift
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


class StorageTests: XCTestCase {
    
    private var storage: Storage { return Storage.shared }
    
    override func setUp() {
        super.setUp()
        
        storage.inMemoryId = name
        storage.write { storage.deleteAll() }
    }
    
    func testTransactions() {
        XCTAssertFalse(storage.isInWriteTransaction)
        storage.beginWrite()
        XCTAssertTrue(storage.isInWriteTransaction)
        storage.cancelWrite()
        XCTAssertFalse(storage.isInWriteTransaction)
        storage.beginWrite()
        storage.commitWrite()
        XCTAssertFalse(storage.isInWriteTransaction)
    }
    
    func testCreatingObjects() {
        XCTAssertEqual(storage.objects(M2A_TestCompany.self).objectCount, 0)
        storage.write {
            let newCompanyInstance = M2A_TestCompany()
            storage.add(newCompanyInstance)
        }
        XCTAssertEqual(storage.objects(M2A_TestCompany.self).objectCount, 1)
    }
    
    func testRetrievingObjects() {
        let newPersonInstance = M2A_TestPerson()
        newPersonInstance.firstName = "Steve"
        storage.write { storage.add(newPersonInstance) }
        
        guard let firstPerson = storage.firstObject(M2A_TestPerson.self) else {
            return XCTFail("`firstObject` from Storage returned nil for `M2A_TestPerson`")
        }
        
        XCTAssertTrue(firstPerson.isSameObject(as: newPersonInstance))
        storage.write { storage.add(M2A_TestPerson()) }
        XCTAssertEqual(storage.objects(M2A_TestPerson.self).objectCount, 2)
    }
    
    func testUpdatingObjects() {
        let newDealInstance = M2A_TestDeal()
        newDealInstance.name = "Steve's Deal"
        storage.write { storage.add(newDealInstance) }
        
        guard let firstDeal = storage.firstObject(M2A_TestDeal.self) else {
            return XCTFail("`firstObject` from Storage returned nil for `M2A_TestDeal`")
        }
        storage.write { firstDeal.name = "No Jobs" }
        
        XCTAssertEqual(storage.firstObject(M2A_TestDeal.self)?.name, "No Jobs")
    }
    
    func testDeletingObjects() {
        storage.write { storage.add(M2A_TestCompany()) }
        XCTAssertEqual(storage.objects(M2A_TestCompany.self).objectCount, 1)

        guard let firstCompany = storage.firstObject(M2A_TestCompany.self) else {
            return XCTFail("`firstObject` from Storage returned nil for `M2A_TestCompany`")
        }
        storage.write { storage.delete(firstCompany) }
        XCTAssertEqual(storage.objects(M2A_TestCompany.self).objectCount, 0)
    }
    
}
