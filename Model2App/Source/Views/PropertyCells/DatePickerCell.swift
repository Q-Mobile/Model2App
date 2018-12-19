//
//  DatePickerCell.swift
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


/**
 *  Property cell date picker for modifying property value
 */
open class DatePickerCell : LabelCell<Date> {

    // MARK: -
    // MARK: Properties & Constants
    
    /// Date picker for modifying property value
    open var datePicker: UIDatePicker!
    
    /// Date formatter used for presenting the value
    open var dateFormatter: DateFormatter?
    
    // MARK: -
    // MARK: Initializers & Deinitializers
    
    deinit {
        datePicker.removeTarget(self, action: nil, for: .valueChanged)
    }
    
    // MARK: -
    // MARK: BaseCell Methods
    
    override open func addViews() {
        super.addViews()
        
        datePicker = UIDatePicker()
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        dateFormatter = DateFormatter()
        dateFormatter?.locale = Locale.current
    }
    
    override open func setup() {
        super.setup()
        
        selectionStyle = .default
        datePicker.datePickerMode = .date
        dateFormatter?.timeStyle = .none
        dateFormatter?.dateStyle = .medium
    }
    
    override open func update() {
        super.update()
        
        datePicker.setDate(value ?? Date(), animated: true)
    }
    
    // MARK: -
    // MARK: Action Methods
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        value = sender.date
        update()
        
        valueChanged?(sender.date)
    }
    
    // MARK: -
    // MARK: DatePickerCell Overridden Methods
    
    override open var valueString: String {
        guard let value = value, let formatter = self.dateFormatter else { return "" }
        return formatter.string(from: value)
    }
    
    override open var inputView: UIView? {
        value.flatMap { datePicker.setDate($0, animated: true) }
        return datePicker
    }
    
    override open var canBecomeFirstResponder: Bool {
        return true
    }
    
    open override func resignFirstResponder() -> Bool {
        let resign = super.resignFirstResponder()
        if resign { objectVC?.deselectRow(for: self) }
        return resign
    }
}

open class TimePickerCell : DatePickerCell {
    
    override open func setup() {
        super.setup()
        
        datePicker.datePickerMode = .time
        dateFormatter?.timeStyle = .short
        dateFormatter?.dateStyle = .none
    }
    
}

open class DateTimePickerCell : DatePickerCell {
    
    override open func setup() {
        super.setup()
        
        datePicker.datePickerMode = .dateAndTime
        dateFormatter?.timeStyle = .short
        dateFormatter?.dateStyle = .short
    }
    
}
