//
//  ActivityProduct.swift
//  Model2AppTestApp
//
//  Created by Karol Kulesza on 9/29/18.
//  Copyright © 2018 Q Mobile { http://Q-Mobile.IT } 
//

import Model2App


@objcMembers class ActivityProduct : ModelClass {
    dynamic var activity : Activity?
    dynamic var product : Product?
    let quantityOrdered = OptionalProperty<Int>()
    let samplesGiven = OptionalProperty<Bool>()
    dynamic var feedback : String?
    
    override class var displayName: String { return "Discussed Product" }
    override class var isHiddenInRootView: Bool { return true }
    
    override class var listViewCellProperties: [String] {
        return [#keyPath(product), #keyPath(feedback)]
    }
    
    override class var listViewCellLayoutVisualFormats: [String] {
        return [
            "H:|-10-[product(>=50)]-(>=10)-[feedback(>=50)]-|"
        ]
    }
    override class var propertyConfigurations: [String: PropertyConfiguration] {
        return [
            #keyPath(activity) : PropertyConfiguration(
                isHidden: true
            ),
            #keyPath(product) : PropertyConfiguration(
                validationRules: [.Required]
            ),
            #keyPath(feedback) : PropertyConfiguration(
                controlType: .TextPicker,
                pickerValues: ["Enthusiastic", "Interested", "Neutral", "Not Interested", "Disgusted"]
            ),
        ]
    }
}
