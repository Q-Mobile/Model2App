//
//  ModelValidator.swift
//  Model2App
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

import Foundation


struct ValidationConfig {
    static let allowedTypesForControls: [ControlType : [ObjectPropertyType]] = [
        .TextField: [.string], // ROADMAP: Add support for: `[.int, .float, .double, .string]`
        .NumberField: [.int],
        .FloatDecimalField: [.float],
        .DoubleDecimalField: [.double],
        .CurrencyField: [.int],
        .PhoneField: [.string],
        .EmailField: [.string],
        .PasswordField: [.string],
        .URLField: [.string],
        .ZIPField: [.string],
        .Switch: [.bool],
        .DatePicker: [.date],
        .TimePicker: [.date],
        .DateTimePicker: [.date],
        .TextPicker: [.string],
        .ObjectPicker : [.object],
        .ImagePicker: [.data],
    ]
}

class ModelValidator {
    static let shared = ModelValidator() ; private init() {} // SINGLETON
    
    func validate(object: ModelClass) -> Bool {
        let objectClass: ModelClass.Type = type(of: object)
        let properties = object.objectSchema.properties
        let propertyConfigurations = objectClass.propertyConfigurations
        
        for property in properties {
            guard let validationRules = propertyConfigurations[property.name]?.validationRules else { continue }
            
            let propertyName = property.name.camelCaseToWords()
            let propertyValue = String(describing: object[property.name] ?? "")
            let invalid: (String)->Bool = { alert in
                UIUtilities.showValidationAlert(alert)
                return false
            }
            
            for rule in validationRules {
                switch rule {
                case .Required:
                    if propertyValue.isEmpty {
                        return invalid("\(propertyName) cannot be empty.")
                    }
                case let .MinLength(length):
                    if propertyValue.count < length {
                        return invalid("Minimum length for \(propertyName) is: \(length)")
                    }
                case let .MaxLength(length):
                    if propertyValue.count > length {
                        return invalid("Maximum length for \(propertyName) is: \(length)")
                    }
                case let .MinValue(value): // ROADMAP: Add suppport for `Date` types
                    let alert = "Minimum value for \(propertyName) is: \(value)"
                    guard let number = Double(propertyValue), !propertyValue.isEmpty else { return invalid(alert) }
                    if number < value { return invalid(alert) }
                case let .MaxValue(value): // ROADMAP: Add suppport for `Date` types
                    if let number = Double(propertyValue), number > value {
                        return invalid("Maximum value for \(propertyName) is: \(value)")
                    }
                case .Email:
                    let predicate = NSPredicate(format: "SELF MATCHES %@", "^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z‌​]{2,})$")
                    if !propertyValue.isEmpty && !predicate.evaluate(with: propertyValue) {
                        return invalid("Invalid email address for \(propertyName)")
                    }
                case .URL:
                    let predicate = NSPredicate(format: "SELF MATCHES %@", "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+([/?#]\\S*)?")
                    if !propertyValue.isEmpty && !predicate.evaluate(with: propertyValue) {
                        return invalid("Invalid URL address for \(propertyName)")
                    }
                case let .Custom(isValid):
                    if !isValid(object) { return false }
                }
            }
        }
        return true
    }
    
    func validate(objectClass: ModelClass.Type) -> Bool {
        var classValid = true
        
        // Validate control types for all properties
        objectClass.schema.properties.forEach { property in
            if let config = objectClass.propertyConfigurations[property.name], let controlType = config.controlType {
                let allowedTypes = ValidationConfig.allowedTypesForControls[controlType] ?? [ObjectPropertyType]()
                if !allowedTypes.isEmpty && !allowedTypes.contains(property.type) {
                    logValidationError("""
                        \n\nPROPERTY VALIDATION ERROR:
                        Property `\(property.name)` on class `\(String(describing: objectClass))` defines control type: `\(String(describing: controlType))`,
                        while data type of `\(property.name)` is: `\(property.type)`.
                        Allowed property data types for control type `\(String(describing: controlType))` are: \n\(allowedTypes)
                        """)
                    classValid = false
                }
            }
        }
        
        // Validate inverse relationships
        objectClass.inverseRelationships.forEach { inverseRelationship in
            if !inverseRelationship.sourceType.isProperty(inverseRelationship.sourceProperty, ofType: .object) {
                logValidationError("""
                    \n\nINVERSE RELATIONSHIP VALIDATION ERROR:
                    Property `\(inverseRelationship.name)` on class `\(String(describing: objectClass))`
                    refers to source property `\(inverseRelationship.sourceProperty)` on class `\(inverseRelationship.sourceType)`
                    which is not of type `Object`.
                    """)
                classValid = false
            }
            if let destinationClassName = inverseRelationship.sourceType.getClassNameForProperty(inverseRelationship.sourceProperty) {
                if destinationClassName != String(describing: objectClass) {
                    logValidationError("""
                        \n\nINVERSE RELATIONSHIP VALIDATION ERROR:
                        Property `\(inverseRelationship.name)` on class `\(String(describing: objectClass))`
                        refers to source property `\(inverseRelationship.sourceProperty)` on class `\(inverseRelationship.sourceType)`
                        which is not of type `\(String(describing: objectClass))`.
                        """)
                    classValid = false
                }
            } else {
                logValidationError("""
                    \n\nINVERSE RELATIONSHIP VALIDATION ERROR:
                    Property `\(inverseRelationship.name)` on class `\(String(describing: objectClass))`
                    refers to source property `\(inverseRelationship.sourceProperty)` which does not have any class name.
                    """)
                classValid = false
            }
        }
        return classValid
    }
    
    private func logValidationError(_ errorMessage: String) {
        guard !ModelManager.shared.isUnderTests else { return }
        log_error(errorMessage, log: Log.validation)
    }

 }
