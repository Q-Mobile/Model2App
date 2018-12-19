//
//  BaseListViewCell.swift
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
 *  Base list view cell with a simple value label
 */
open class BaseListViewCell: BaseCell {
    
    // MARK: -
    // MARK: Properties & Constants
    
    open var valueLabel: UILabel!
    
    open var textFontName: String { return M2A.config.cellDefaultTextFontName }
    open var textFontSize: CGFloat { return M2A.config.cellDefaultTextFontSize }
    open var textFontColor: UIColor { return M2A.config.cellDefaultTextFontColor }
    
    open var cellBackgroundColor: UIColor { return M2A.config.cellDefaultBackgroundColor }
    open var cellBackgroundAlpha: CGFloat { return M2A.config.cellDefaultBackgroundAlpha }
    
    open var verticalInset: CGFloat { return M2A.config.cellDefaultVerticalInset }
    open var horizontalInset: CGFloat { return M2A.config.cellDefaultHorizontalInset }
    
    // MARK: -
    // MARK: BaseCell Methods
    
    override open func addViews() {
        valueLabel = UILabel()
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.font = UIFont(name: textFontName, size: textFontSize)
        valueLabel.textColor = textFontColor
        contentView.addSubview(valueLabel)
    }
    
    override open func setup() {
        super.setup()
        
        backgroundColor = cellBackgroundColor.withAlphaComponent(cellBackgroundAlpha)
    }
    
    override open func addConstraints() {
        let metrics = [
            "verticalInset" : verticalInset,
            "horizontalInset" : horizontalInset
        ]
        
        let views: [String: AnyObject] = [ "valueLabel": valueLabel ]
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-verticalInset-[valueLabel]-verticalInset-|", metrics: metrics, views: views)
        var horizontalVisualFormat = "H:|-horizontalInset-[valueLabel]"
        horizontalVisualFormat += accessoryType == .checkmark ? "|" : "-horizontalInset-|"
        constraints += NSLayoutConstraint.constraints(withVisualFormat: horizontalVisualFormat, metrics: metrics, views: views)
        
        NSLayoutConstraint.activate(constraints)
    }
    
}
