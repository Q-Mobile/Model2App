//
//  PickerListViewCell.swift
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
 *  Cell responsible for rendering a cell in a picker list view
 */
open class PickerListViewCell: BaseListViewCell {
    
    // MARK: -
    // MARK: Properties & Constants
    
    override open var textFontName: String { return M2A.config.pickerListCellDefaultTextFontName }
    override open var textFontSize: CGFloat { return M2A.config.pickerListCellDefaultTextFontSize }
    override open var textFontColor: UIColor { return M2A.config.pickerListCellDefaultTextFontColor }
    
    override open var cellBackgroundColor: UIColor { return M2A.config.pickerListCellDefaultBackgroundColor }
    override open var cellBackgroundAlpha: CGFloat { return M2A.config.pickerListCellDefaultBackgroundAlpha }
    
    override open var verticalInset: CGFloat { return M2A.config.pickerListCellDefaultVerticalInset }
    override open var horizontalInset: CGFloat { return M2A.config.pickerListCellDefaultHorizontalInset }

    // MARK: -
    // MARK: BaseCell Methods
    
    override open func setup() {
        super.setup()
        accessoryType = .checkmark
        editingAccessoryType = .checkmark
    }
    
    // MARK: -
    // MARK: PickerListViewCell Methods
    
    open func updateForValue(value: String?, selectedValue: String?) {
        valueLabel?.text = value ?? ""
        accessoryType = value == selectedValue ? .checkmark : .none
        editingAccessoryType = accessoryType
    }
    
}
