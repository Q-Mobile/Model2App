//
//  TestModel.swift
//  Model2AppTests
//
//  Created by Karol Kulesza on 6/28/18.
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

import Model2App


@objcMembers class M2A_InvalidTestCompany : ModelClass {
    dynamic var name : String?
    
    override class var inverseRelationships: [InverseRelationship] {
        return [
            InverseRelationship("employees", sourceType: M2A_InvalidTestPerson.self, sourceProperty: #keyPath(M2A_InvalidTestPerson.picture)), // Test invalid inverse relationship configuration
        ]
    }
}

@objcMembers class M2A_InvalidTestPartnerCompany : ModelClass {
    dynamic var name : String?
    
    override class var inverseRelationships: [InverseRelationship] {
        return [
            InverseRelationship("partnerDeals", sourceType: M2A_InvalidTestPartnerDeal.self, sourceProperty: #keyPath(M2A_InvalidTestPartnerDeal.contact)) // Test invalid inverse relationship configuration
        ]
    }
}

@objcMembers class M2A_InvalidTestPerson : ModelClass {
    dynamic var firstName : String?
    dynamic var lastName : String?
    dynamic var picture : Data?
    dynamic var company : M2A_InvalidTestCompany?
    
    override class var propertyConfigurations: [String: PropertyConfiguration] {
        return [
            #keyPath(firstName) : PropertyConfiguration(
                controlType: .DatePicker, // Test invalid property control configuration
                placeholder: "Enter first name",
                validationRules: [.Required]
            )
        ]
    }
}

@objcMembers class M2A_InvalidTestContact : ModelClass {
    dynamic var firstName : String?
    dynamic var lastName : String?
    
    override class var inverseRelationships: [InverseRelationship] {
        return [
            InverseRelationship("deals", sourceType: M2A_InvalidTestDeal.self, sourceProperty: #keyPath(M2A_InvalidTestDeal.name)) // Test invalid inverse relationship configuration
        ]
    }
}

@objcMembers class M2A_InvalidTestDeal : ModelClass {
    dynamic var name : String?
    dynamic var company : M2A_InvalidTestCompany?
    dynamic var contact : M2A_InvalidTestContact?
}

@objcMembers class M2A_InvalidTestPartnerDeal : ModelClass {
    dynamic var title : String?
    dynamic var company : M2A_InvalidTestPartnerCompany?
    dynamic var contact : M2A_InvalidTestPerson?
}
