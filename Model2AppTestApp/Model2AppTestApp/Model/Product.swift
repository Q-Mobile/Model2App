//
//  Product.swift
//  Model2AppTestApp
//
//  Created by Karol Kulesza on 9/29/18.
//  Copyright © 2018 Q Mobile { http://Q-Mobile.IT } 
//

import Model2App


@objcMembers class Product : ModelClass {
    dynamic var name : String?
    dynamic var productCode : String?
    dynamic var category : String?
    let unitPrice = OptionalProperty<Int>()
    let isActive = OptionalProperty<Bool>()
    dynamic var salesStartDate : Date?
    dynamic var salesEndDate : Date?
    dynamic var productImage : Data?
    dynamic var notes : String?
    
    override class var pluralName: String { return "Products" }
    override class var menuIconFileName: String { return "price-tag" }
    override class var menuOrder: Int { return 3 }
    
    override class var listViewCellProperties: [String] {
        return [#keyPath(productImage), #keyPath(name), #keyPath(productCode)]
    }
    
    override class var listViewCellLayoutVisualFormats: [String] {
        return [
            "H:|-10-[productImage(60)]-[name]-5-[productCode(>=50)]-|",
            "V:|-10@750-[productImage(60)]-10@750-|",
            "V:|-10@750-[name]-10@750-|",
            "V:|-10@750-[productCode]-10@750-|"
        ]
    }
    
    override class var propertyConfigurations: [String: PropertyConfiguration] {
        return [
            #keyPath(name) : PropertyConfiguration(
                placeholder: "Enter product name",
                validationRules: [.Required]
            ),
            #keyPath(productCode) : PropertyConfiguration(
                placeholder: "Enter product code",
                validationRules: [.Required]
            ),
            #keyPath(category) : PropertyConfiguration(
                controlType: .TextPicker,
                pickerValues: ["Hardware", "Software", "Subscription"]
            ),
            "unitPrice" : PropertyConfiguration(
                controlType: .CurrencyField
            ),
            #keyPath(salesEndDate) : PropertyConfiguration(
                validationRules: [.Custom(isValid: { object in
                    if let salesStartDate = object[#keyPath(salesStartDate)] as? Date,
                        let salesEndDate = object[#keyPath(salesEndDate)] as? Date,
                        salesEndDate <= salesStartDate {
                        UIUtilities.showValidationAlert("Sales End Date should be later than Sales Start Date")
                        return false
                    }
                    return true
                })]
            )
        ]
    }
}
