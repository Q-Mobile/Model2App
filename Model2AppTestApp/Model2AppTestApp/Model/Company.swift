//
//  Company.swift
//  Model2AppTestApp
//
//  Created by Karol Kulesza on 9/29/18.
//  Copyright © 2018 Q Mobile { http://Q-Mobile.IT } 
//

import Model2App


@objcMembers class Company : ModelClass {
    dynamic var name : String?
    dynamic var phoneNumber : String?
    dynamic var email : String?
    dynamic var website : String?
    dynamic var industry : String?
    
    override class var pluralName: String { return "Companies" }
    override class var menuIconFileName: String { return "users" }
    override class var menuOrder: Int { return 2 }
    override class var inverseRelationships: [InverseRelationship] {
        return [
            InverseRelationship("employees", sourceType: Person.self, sourceProperty: #keyPath(Person.company)),
            InverseRelationship("deals", sourceType: Deal.self, sourceProperty: #keyPath(Deal.company)),
            InverseRelationship("activities", sourceType: Activity.self, sourceProperty: #keyPath(Activity.company)),
        ]
    }
    
    override class var propertyConfigurations: [String: PropertyConfiguration] {
        return [
            #keyPath(name) : PropertyConfiguration(
                placeholder: "Enter company name",
                validationRules: [.Required]
            ),
            #keyPath(phoneNumber) : PropertyConfiguration(
                placeholder: "Enter phone number"
            ),
            #keyPath(email) : PropertyConfiguration(
                placeholder: "Enter email address"
            ),
            #keyPath(website) : PropertyConfiguration(
                placeholder: "Enter website URL"
            ),
            #keyPath(industry) : PropertyConfiguration(
                controlType: .TextPicker,
                pickerValues: ["Consulting", "Education", "Financial Services", "Government", "Manufacturing", "Real Estate", "Technology", "Other"]
            )
        ]
    }
}
