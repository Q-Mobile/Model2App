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
import RealmSwift


@objcMembers class M2A_TestCompany : ModelClass {
    dynamic var name : String?
    dynamic var phoneNumber : String?
    dynamic var email : String?
    dynamic var website : String?
    let numberOfDepartments = OptionalProperty<Int>()
    
    override class var displayName: String { return "Company" }
    override class var pluralName: String { return "Companies" }
    override class var menuIconFileName: String { return "users" }
    override class var menuOrder: Int { return 2 }
    override class var inverseRelationships: [InverseRelationship] {
        return [
            InverseRelationship("employees", sourceType: M2A_TestPerson.self, sourceProperty: #keyPath(M2A_TestPerson.company)),
            InverseRelationship("deals", sourceType: M2A_TestDeal.self, sourceProperty: #keyPath(M2A_TestDeal.company))
        ]
    }
}

@objcMembers class M2A_TestPerson : ModelClass {
    dynamic var firstName : String?
    dynamic var lastName : String?
    dynamic var salutation : String?
    dynamic var phoneNumber : String?
    dynamic var mobileNumber : String?
    dynamic var privateEmail : String?
    dynamic var workEmail : String?
    let isKeyOpinionLeader = OptionalProperty<Bool>()
    dynamic var birthday : Date?
    dynamic var website : String?
    dynamic var note : String?
    dynamic var preferredLunchTime : Date?
    dynamic var picture : Data?
    dynamic var company : M2A_TestCompany?
    
    override class var pluralName: String { return "People" }
    override class var menuIconFileName: String { return "user-1" }
    override class var menuOrder: Int { return 1 }
    
    override class var propertyConfigurations: [String: PropertyConfiguration] {
        return [
            #keyPath(firstName) : PropertyConfiguration(
                controlType: .TextField,
                placeholder: "Enter first name",
                validationRules: [.Required]
            ),
            #keyPath(lastName) : PropertyConfiguration(
                controlType: .TextField,
                placeholder: "Enter last name",
                validationRules: [.Required]
            ),
            #keyPath(salutation) : PropertyConfiguration(
                controlType: .TextPicker,
                pickerValues: ["Mr.", "Ms.", "Mrs.", "Dr.", "Prof."],
                validationRules: [.Required]
            ),
            #keyPath(phoneNumber) : PropertyConfiguration(
                controlType: .PhoneField,
                placeholder: "Enter phone number",
                validationRules: [.MinLength(length: 9), .MaxLength(length: 12)]
            ),
            #keyPath(mobileNumber) : PropertyConfiguration(
                isHidden: true
            ),
            #keyPath(privateEmail) : PropertyConfiguration(
                controlType: .EmailField,
                placeholder: "Enter email address",
                validationRules: [.Email]
            ),
            #keyPath(workEmail) : PropertyConfiguration(
                controlType: .EmailField,
                placeholder: "Enter email address",
                validationRules: [.Required, .Email, .Custom(isValid: { object in
                    if let workEmail = object[#keyPath(workEmail)] as? String,
                       let privateEmail = object[#keyPath(privateEmail)] as? String,
                       workEmail == privateEmail {
                            UIUtilities.showValidationAlert("Work Email cannot be the same as Private Email.")
                            return false
                    }
                    return true
                })]
            ),
            #keyPath(birthday) : PropertyConfiguration(
                controlType: .DatePicker,
                validationRules: [.Required]
            ),
            #keyPath(website) : PropertyConfiguration(
                controlType: .URLField,
                placeholder: "Enter URL",
                validationRules: [.URL]
            ),
            #keyPath(note) : PropertyConfiguration(
                controlType: .TextField,
                placeholder: "Enter note",
                validationRules: [.MaxLength(length: 1000)]
            ),
            #keyPath(preferredLunchTime) : PropertyConfiguration(
                controlType: .TimePicker
            ),
            #keyPath(company) : PropertyConfiguration(
                validationRules: [.Required]
            ),
            #keyPath(picture) : PropertyConfiguration(
                controlType: .ImagePicker
            )
        ]
    }
    
    override class var listViewCellProperties: [String] {
        return [#keyPath(picture), #keyPath(firstName), #keyPath(lastName)]
    }
    
    override class var listViewCellLayoutVisualFormats: [String] {
        return [
            "H:|-10-[picture]-[firstName]-5-[lastName]", // OR: (with slightly weaker readability but more safe): "H:|-10-[#keyPath(picture)]-[#keyPath(firstName)]-5-[#keyPath(lastName)]", "V:|-[\(#keyPath(lastName))]-|"
        ]
    }
}

@objcMembers class M2A_TestDeal : ModelClass {
    dynamic var name : String?
    let value = OptionalProperty<Float>()
    let prospectValue = OptionalProperty<Double>()
    dynamic var stage : String?
    dynamic var source : String?
    dynamic var closingDate : Date?
    dynamic var company : M2A_TestCompany?
    
    override class var pluralName: String { return "Deals" }
    override class var menuIconFileName: String { return "money" }
    override class var isHiddenInRootView: Bool { return true }
    
    override class var propertyConfigurations: [String: PropertyConfiguration] {
        return [
            #keyPath(name) : PropertyConfiguration(
                controlType: .TextField,
                placeholder: "Enter deal name",
                validationRules: [.Required]
            ),
            "value" : PropertyConfiguration(
                controlType: .FloatDecimalField,
                placeholder: "Enter deal value",
                validationRules: [.Required, .MinValue(value: 100.00), .MaxValue(value: 10000000.00)]
            ),
            #keyPath(stage) : PropertyConfiguration(
                controlType: .TextPicker,
                pickerValues: ["Prospecting", "Qualified", "Reviewed", "Quote", "Won", "Lost"],
                validationRules: [.Required]
            ),
            #keyPath(source) : PropertyConfiguration(
                controlType: .TextPicker,
                pickerValues: ["Advertisement", "Website", "Cold Call", "Referral", "Partner"],
                validationRules: [.Required]
            ),
            #keyPath(closingDate) : PropertyConfiguration(
                controlType: .DateTimePicker
            ),
            #keyPath(company) : PropertyConfiguration(
                validationRules: [.Required]
            )
        ]
    }
    
    override class var listViewCellProperties: [String] {
        return [#keyPath(name), "value", #keyPath(stage)]
    }
    
    override class var listViewCellLayoutVisualFormats: [String] {
        return [
            "H:|-10-[name]-10@250-[value]-|",
            "H:|-10-[stage]",
            "V:|-10-[value]-10-|",
            "V:|-10-[name]-[stage]-|"
        ]
    }
}

