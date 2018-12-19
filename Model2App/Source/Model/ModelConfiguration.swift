//
//  ModelConfiguration.swift
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


/**
 * Enumeration that defines the possible UI control types used for each property of the class
 */
public enum ControlType: String {
    case TextField
    case NumberField
    case FloatDecimalField
    case DoubleDecimalField
    case CurrencyField
    case PhoneField
    case EmailField
    case PasswordField
    case URLField
    case ZIPField
    case Switch
    case DatePicker
    case TimePicker
    case DateTimePicker
    case TextPicker
    case ObjectPicker
    case ImagePicker
}

/**
 * Enumeration that defines the validation rule to be applied for a given property of the class.
 * Validation rule will be evaluated when the user tries to save a new object of this class.
 */
public enum ValidationRule {
    /// Whether value should specified for a given property
    case Required
    /// Whether value for a given property should have a minimum length
    case MinLength(length: Int)
    /// Whether value for a given property should have a maximum length
    case MaxLength(length: Int)
    /// Whether value for a given property should have a minimum value
    case MinValue(value: Double)
    /// Whether value for a given property should have a maximum value
    case MaxValue(value: Double)
    /// Whether value for a given property should be a valid e-mail address
    case Email
    /// Whether value for a given property should be a valid URL
    case URL
    /// Custom validation rule, defined by specifying a closure with a validated object as input parameter
    case Custom(isValid: (ModelClass) -> Bool)
}

/**
 * Defines the configuration of each property of a given class
 */
public struct PropertyConfiguration {
    /// Specifies the type of UI control used for this property
    var controlType: ControlType?
    
    /// Specifies the placeholder value used when no value is provided for this property
    var placeholder: String?
    
    /// Specifies the list of potential picker values for this property. Valid only for `TextPicker` ControlType
    var pickerValues: [String]?
    
    /// Specifies the list of validation rules for this property (evaluated when creating a new object of this class)
    var validationRules: [ValidationRule]?
    
    /// Specifies whether this property should be hidden on UI
    var isHidden: Bool?
    
    public init(controlType: ControlType? = nil,
                placeholder: String? = nil,
                pickerValues: [String]? = nil,
                validationRules: [ValidationRule]? = nil,
                isHidden: Bool? = false)
    {
        self.controlType = controlType
        self.placeholder = placeholder
        self.pickerValues = pickerValues
        self.validationRules = validationRules
        self.isHidden = isHidden
    }
}

/**
 * Defines inverse relationship for a given class, by specifying it's name, source type and source property
 */
public struct InverseRelationship {
    /// Name that should be displayed in a section's header of related objects, for a given object
    var name: String
    
    /// Source class that has a `to-one` relationship defined as one of it's properties, referencing this class
    var sourceType: ModelClass.Type
    
    /// Name of the property in related class, which references this class
    var sourceProperty: String
    
    public init(_ name: String,
                sourceType: ModelClass.Type,
                sourceProperty: String)
    {
        self.name = name
        self.sourceType = sourceType
        self.sourceProperty = sourceProperty
    }
}

extension ObjectProperty {
    var displayName: String { return name.camelCaseToWords() }
    
    func getControlType(propertyConfig: PropertyConfiguration?) -> ControlType {
        return propertyConfig?.controlType ?? {
            switch type {
            case .string:
                let name = self.name.lowercased()
                if name.contains("phone") { return .PhoneField }
                if name.contains("number") { return .NumberField }
                if name.contains("email") { return .EmailField }
                if name.contains("password") { return .PasswordField }
                if name.contains("url") { return .URLField }
                if name.contains("zip") { return .ZIPField }
                return .TextField
            case .bool:
                return .Switch
            case .int:
                return .NumberField
            case .float:
                return .FloatDecimalField
            case .double:
                return .DoubleDecimalField
            case .date:
                return .DatePicker
            case .object:
                return .ObjectPicker
            case .data:
                return .ImagePicker // Assuming data will mean image, as for now
            default:
                return .TextField
            }
        }()
    }
}

extension ObjectPropertyType : CustomStringConvertible {
    public var description : String {
        switch self {
        case .int: return "Int"
        case .bool: return "Bool"
        case .string: return "String"
        case .data: return "Data"
        case .date: return "Date"
        case .float: return "Float"
        case .double: return "Double"
        case .object: return "Object"
        default: return "Not supported"
        }
    }
}
