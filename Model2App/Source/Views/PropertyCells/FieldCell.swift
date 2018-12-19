//
//  FieldCell.swift
//  Model2App
//
//  Created by Karol Kulesza on 7/12/18.
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


public protocol StringInitiable {
    init?(fromString string: String)
}

extension Int: StringInitiable {
    public init?(fromString string: String) {
        self.init(string)
    }
}

extension Float: StringInitiable {
    public init?(fromString string: String) {
        self.init(string)
    }
}

extension Double: StringInitiable {
    public init?(fromString string: String) {
        self.init(string)
    }
}

extension String: StringInitiable {
    public init?(fromString string: String) {
        self.init(string)
    }
}


/**
 *  Property cell with text field for presenting & modifying property value
 */
open class FieldCell<T> : PropertyCell<T>, UITextFieldDelegate where T: Equatable, T: StringInitiable {
    
    // MARK: -
    // MARK: Properties & Constants
    
    /// Text field for presenting & modifying property value
    open var textField: UITextField!
    
    override open var valueView: UIView? { return textField }
    
    // MARK: -
    // MARK: Initializers & Deinitializers
    
    deinit {
        textField?.delegate = nil
    }
    
    // MARK: -
    // MARK: BaseCell Methods
    
    override open func addViews() {
        textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: M2A.config.objectPropertyDefaultValueFontName, size: M2A.config.objectPropertyDefaultValueFontSize)
        textField.textColor = M2A.config.objectPropertyDefaultValueFontColor
        textField.textAlignment = .right
        textField.returnKeyType = .next
        textField.delegate = self
        contentView.addSubview(textField)

        // Call on `super` deferred on purpose
        super.addViews()
    }
    
    override open func setup() {
        super.setup()
        
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .default
    }
    
    override open func update() {
        super.update()
        
        textField.text = valueString
        let placeholderText = isInEditMode ? (placeholder ?? "") : ""
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: M2A.config.objectPropertyDefaultValuePlaceholderFontColor])
    }
    
    // MARK: -
    // MARK: UITextFieldDelegate Methods
    
    open func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return isInEditMode
    }
    
    open func textFieldDidBeginEditing(_ textField: UITextField) {
        objectVC?.textFieldDidBeginEditing(for: self, textField: textField)
    }
    
    open func textFieldDidEndEditing(_ textField: UITextField) {
        let value = T.init(fromString: textField.text ?? "")
        valueChanged?(value)
    }
    
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return objectVC?.textFieldShouldReturn(for: self) ?? true
    }
    
    // MARK: -
    // MARK: FieldCell Overridden Methods
    
    override open var canBecomeFirstResponder: Bool {
        return true
    }
    
    override open func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
}

open class TextFieldCell: FieldCell<String> {
    
    override open func setup() {
        super.setup()
        textField.autocorrectionType = .default
        textField.autocapitalizationType = .sentences
    }
}

open class NumberFieldCell: FieldCell<Int> {
    
    override open func setup() {
        super.setup()
        textField.keyboardType = .numberPad
    }
}

open class FloatDecimalFieldCell: FieldCell<Float> {
    
    override open func setup() {
        super.setup()
        textField.keyboardType = .decimalPad
    }
}

open class DoubleDecimalFieldCell: FieldCell<Double> {
    
    override open func setup() {
        super.setup()
        textField.keyboardType = .decimalPad
    }
}

open class PhoneFieldCell: FieldCell<String> {
    
    override open func setup() {
        super.setup()
        textField.keyboardType = .phonePad
    }
}

open class EmailFieldCell: FieldCell<String> {
    
    override open func setup() {
        super.setup()
        textField.keyboardType = .emailAddress
    }
}

open class PasswordFieldCell: FieldCell<String> {
    
    override open func setup() {
        super.setup()
        textField.keyboardType = .asciiCapable
        textField.isSecureTextEntry = true
    }
}

open class URLFieldCell: FieldCell<String> {
    
    override open func setup() {
        super.setup()
        textField.keyboardType = .URL
    }
}

open class ZIPFieldCell: FieldCell<String> {
    
    override open func setup() {
        super.setup()
        textField.autocapitalizationType = .allCharacters
        textField.keyboardType = .numbersAndPunctuation
    }
}

open class CurrencyFieldCell: FieldCell<Int> {
    open var formatter: NumberFormatter?
    
    override open func setup() {
        super.setup()
        
        textField.keyboardType = .decimalPad
        textField.addTarget(self, action: #selector(CurrencyFieldCell.textFieldDidChange(_:)), for: .editingChanged)
        formatter = NumberFormatter()
        formatter?.locale = .current
        formatter?.numberStyle = .currency
    }
    
    override open var valueString: String {
        return formatter?.string(for: (Double(value ?? 0))/100) ?? ""
    }
    
    @objc open func textFieldDidChange(_ textField: UITextField) {
        guard let formatter = formatter, let rangeStart = textField.selectedTextRange?.start else { return }
        
        let numbersText = textField.text.flatMap{ $0.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "") } ?? ""
        let value = (Double(numbersText) ?? 0.0) / Double(pow(10.0, Double(formatter.minimumFractionDigits)))
        
        let previousText = textField.text
        textField.text = formatter.string(for: value)
        let newRangeStart = textField.position(from: rangeStart, offset:((textField.text?.count ?? 0) - (previousText?.count ?? 0))) ?? rangeStart
        textField.selectedTextRange = textField.textRange(from: newRangeStart, to: newRangeStart)
    }
    
    override open func textFieldDidEndEditing(_ textField: UITextField) {
        let value = formatter?.number(from: textField.text ?? "") as? Double
        valueChanged?(value.flatMap{ Int($0 * 100) })
    }
    
    deinit {
        textField?.removeTarget(self, action: nil, for: .allEvents)
    }
}

