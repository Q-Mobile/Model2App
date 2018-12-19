//
//  ObjectTestCase.swift
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


class ObjectTestCase: XCTestCase {
    
    var storage: Storage { return Storage.shared }
    
    override func setUp() {
        super.setUp()
        
        storage.inMemoryId = name // Separate in-memory storage for each test
        addTestContactsToStorage()
    }
    
    override func tearDown() {
        storage.write { storage.deleteAll() }
        
        super.tearDown()
    }
    
    // MARK: -
    // MARK: Helper Methods
    
    private func addTestContactsToStorage() {
        storage.write {
            addTestContact("Steve", "Jobs", imageFileName: "Steve")
            addTestContact("Nikola", "Tesla")
            addTestContact("Benjamin", "Franklin")
            addTestContact("Henry", "Ford")
            addTestContact("Charles", "Babbage")
            addTestContact("Alexander", "Bell")
            addTestContact("Thomas", "Edison")
            addTestContact("Albert", "Einstein")
            addTestContact("Marie", "Curie")
            addTestContact("Leonardo", "Da Vinci")
        }
    }
    
    @discardableResult
    func addTestContact(_ firstName: String, _ lastName: String, imageFileName: String? = nil) -> M2A_TestPerson {
        let contact = M2A_TestPerson()
        contact.firstName = firstName
        contact.lastName = lastName
        if let imageName = imageFileName {
            let image = UIImage(named: imageName, in: Bundle(for: type(of: self)), compatibleWith: nil)
            contact.setImage(image, for: #keyPath(M2A_TestPerson.picture))
        }
        storage.add(contact)
        
        return contact
    }
}
