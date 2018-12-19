//
//  Activity.swift
//  Model2AppTestApp
//
//  Created by Karol Kulesza on 9/29/18.
//  Copyright © 2018 Q Mobile { http://Q-Mobile.IT } 
//

import Model2App


@objcMembers class Activity : ModelClass {
    dynamic var activityType : String?
    dynamic var subject : String?
    dynamic var contact : Person?
    dynamic var company : Company?
    dynamic var startTime : Date?
    dynamic var endTime : Date?
    dynamic var comments : String?
    
    override class var pluralName: String { return "Activities" }
    override class var menuIconFileName: String { return "chat" }
    override class var menuOrder: Int { return 4 }
    override class var inverseRelationships: [InverseRelationship] {
        return [
            InverseRelationship("productsDiscussed", sourceType: ActivityProduct.self, sourceProperty: #keyPath(ActivityProduct.activity))
        ]
    }
    
    override class var listViewCellProperties: [String] {
        return [#keyPath(subject), #keyPath(activityType), #keyPath(startTime)]
    }
    
    override class var listViewCellLayoutVisualFormats: [String] {
        return [
            "H:|-10@750-[subject]-(>=10)-[startTime(>=120)]-|",
            "H:|-10@750-[activityType]-(>=10)-[startTime]",
            "V:|-10@750-[startTime]-10@750-|",
            "V:|-10@750-[subject]-[activityType]-|"
        ]
    }
    
    override class var propertyConfigurations: [String: PropertyConfiguration] {
        return [
            #keyPath(activityType) : PropertyConfiguration(
                controlType: .TextPicker,
                pickerValues: ["Phone Call", "Meeting", "Email", "Task", "Other"],
                validationRules: [.Required]
            ),
            #keyPath(subject) : PropertyConfiguration(
                placeholder: "Enter activity subject",
                validationRules: [.Required]
            ),
            #keyPath(contact) : PropertyConfiguration(
                validationRules: [.Required]
            ),
            #keyPath(startTime) : PropertyConfiguration(
                controlType: .DateTimePicker,
                validationRules: [.Required]
            ),
            #keyPath(endTime) : PropertyConfiguration(
                controlType: .DateTimePicker,
                validationRules: [.Required]
            ),
            #keyPath(comments) : PropertyConfiguration(
                validationRules: [
                    .Custom(isValid: { object in
                        if let activityType = object[#keyPath(activityType)] as? String,
                            let activityComments = object[#keyPath(comments)] as? String,
                            activityType == "Other",
                            activityComments.isEmpty {
                            UIUtilities.showValidationAlert("`Comments` field cannot be empty in case of `Other` activity type.")
                            return false
                        }
                        return true
                    }),
                    .Custom(isValid: { object in
                        if let startTime = object[#keyPath(startTime)] as? Date,
                            let endTime = object[#keyPath(endTime)] as? Date,
                            endTime <= startTime {
                            UIUtilities.showValidationAlert("Activity End Time should be later than Start Time")
                            return false
                        }
                        return true
                    })
                ]
            )
        ]
    }
}

