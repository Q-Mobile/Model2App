//
//  LabelCell.swift
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
 *  Property cell with label for presenting property value
 */
open class LabelCell<T> : PropertyCell<T> where T: Equatable {
    
    // MARK: -
    // MARK: Properties & Constants
    
    /// Label for presenting property value
    open var valueLabel: UILabel!
    
    override open var valueView: UIView { return valueLabel }
    
    // MARK: -
    // MARK: BaseCell Methods
    
    override open func addViews() {
        super.addViews()
        
        valueLabel = UILabel()
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.font = UIFont(name: M2A.config.objectPropertyDefaultValueFontName, size: M2A.config.objectPropertyDefaultValueFontSize)
        valueLabel.textColor = M2A.config.objectPropertyDefaultValueFontColor
        valueLabel.textAlignment = .right
        contentView.addSubview(valueLabel)
    }
    
    override open func update() {
        super.update()
        
        valueLabel.text = valueString
    }
    
    // MARK: -
    // MARK: LabelCell Overridden Methods
    
    override open var inputAccessoryView: UIView? {
        return objectVC?.accessoryView ?? {
            return super.inputAccessoryView
        }()
    }
    
}
