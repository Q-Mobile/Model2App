//
//  Person.swift
//  Model2AppTestApp
//
//  Created by Karol Kulesza on 9/29/18.
//  Copyright © 2018 Q Mobile { http://Q-Mobile.IT } 
//

import Model2App


@objcMembers class Person : ModelClass {
    dynamic var firstName : String?
    dynamic var lastName : String?
    dynamic var salutation : String?
    dynamic var phoneNumber : String?
    dynamic var privateEmail : String?
    dynamic var workEmail : String?
    let isKeyOpinionLeader = OptionalProperty<Bool>()
    dynamic var birthday : Date?
    dynamic var website : String?
    dynamic var note : String?
    dynamic var picture : Data?
    dynamic var company : Company?
    
    override class var pluralName: String { return "People" }
    override class var menuIconFileName: String { return "user-1" }
    override class var menuIconIsFromAppBundle: Bool { return true }
    override class var menuOrder: Int { return 1 }
    
    override class var inverseRelationships: [InverseRelationship] {
        return [
            InverseRelationship("activities", sourceType: Activity.self, sourceProperty: #keyPath(Activity.contact)),
        ]
    }
    
    override class var listViewCellProperties: [String] {
        return [#keyPath(picture), #keyPath(firstName), #keyPath(lastName)]
    }
    
    override class var listViewCellLayoutVisualFormats: [String] {
        return [
            "H:|-10-[picture]-[firstName]-5-[lastName(>=50)]-|" // OR: (with slightly weaker readability but more safe): "H:|-10-[#keyPath(picture)(>=50)]-[#keyPath(firstName)]-5-[#keyPath(lastName)(>=50)]"
        ]
    }
    
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
            #keyPath(company) : PropertyConfiguration(
                validationRules: [.Required]
            ),
            #keyPath(picture) : PropertyConfiguration(
                controlType: .ImagePicker
            )
        ]
    }
}
