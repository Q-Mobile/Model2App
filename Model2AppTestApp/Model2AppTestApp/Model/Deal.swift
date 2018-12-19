//
//  Deal.swift
//  Model2AppTestApp
//
//  Created by Karol Kulesza on 9/29/18.
//  Copyright © 2018 Q Mobile { http://Q-Mobile.IT } 
//

import Model2App


@objcMembers class Deal : ModelClass {
    dynamic var name : String?
    let value = OptionalProperty<Int>()
    dynamic var stage : String?
    dynamic var source : String?
    dynamic var closingDate : Date?
    dynamic var company : Company?
    
    override class var pluralName: String { return "Deals" }
    override class var menuIconFileName: String { return "money" }
    
    override class var listViewCellProperties: [String] {
        return [#keyPath(name), "value", #keyPath(stage)]
    }
    
    override class var listViewCellLayoutVisualFormats: [String] {
        return [
            "H:|-10@750-[name(>=50)]-(>=10)-[value(>=50)]-|",
            "H:|-10@750-[stage]-(>=10)-[value]",
            "V:|-10@750-[value]-10@750-|",
            "V:|-10@750-[name]-[stage]-|"
        ]
    }
    
    override class var propertyConfigurations: [String: PropertyConfiguration] {
        return [
            #keyPath(name) : PropertyConfiguration(
                controlType: .TextField,
                placeholder: "Enter deal name",
                validationRules: [.Required]
            ),
            "value" : PropertyConfiguration(
                controlType: .CurrencyField,
                placeholder: "Enter deal value",
                validationRules: [.Required]
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
            #keyPath(company) : PropertyConfiguration(
                validationRules: [.Required]
            )
        ]
    }
}
