//
//  PropertyCell.swift
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
 *  Base class for all property cell classes
 */
open class BasePropertyCell: BaseCell {
    /// Title of the presented property
    open var title: String?
    
    /// Specifies the placeholder value used when no value is provided for this property
    open var placeholder: String?
    
    /// Non typed value for the presented property
    open var nonTypedValue: Any?
    
    /// Indicates whether a given cell is in edit mode
    open var isInEditMode: Bool = false
    
    /// Handler for `valueChanged` event, for this property
    open var valueChanged: ((Any?) -> Void)?
}

/**
 *  Generic property cell class
 */
open class PropertyCell<T>: BasePropertyCell where T: Equatable {

    // MARK: -
    // MARK: Properties & Constants
    
    /// Label for property title
    open var titleLabel: UILabel!
    
    /// View for presenting property value
    open var valueView: UIView? { return nil } // To be overridden
    
    /// Layout constraing for accessory view
    open var accessoryViewConstraint: NSLayoutConstraint?
    
    /// Typed value for presented property
    open var value: T? {
        set { nonTypedValue = newValue }
        get { return nonTypedValue as? T }
    }
    
    /// String representation of property value
    open var valueString: String {
        return value.flatMap { String(describing: $0) } ?? ""
    }
    
    var objectVC: ObjectViewController? {
        var responder: AnyObject? = self
        while responder != nil {
            if let objectVC = responder as? ObjectViewController { return objectVC }
            responder = responder?.next
        }
        return nil
    }
    
    // MARK: -
    // MARK: BaseCell Methods
    
    override open func addViews() {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: M2A.config.objectPropertyDefaultTitleFontName, size: M2A.config.objectPropertyDefaultTitleFontSize)
        titleLabel.textColor = M2A.config.objectPropertyDefaultTitleFontColor
        contentView.addSubview(titleLabel)
    }
    
    override open func setup() {
        super.setup()
        
        backgroundColor = M2A.config.objectPropertyDefaultBackgroundColor.withAlphaComponent(M2A.config.objectPropertyDefaultBackgroundAlpha)
        selectionStyle = .none
    }
    
    override open func addConstraints() {
        let metrics = [
            "verticalInset" : M2A.config.objectPropertyDefaultVerticalInset,
            "horizontalInset" : M2A.config.objectPropertyDefaultHorizontalInset
        ]

        var views: [String: AnyObject] = [ "titleLabel": titleLabel ]
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-verticalInset-[titleLabel]-verticalInset-|", metrics: metrics, views: views)
        var horizontalVisualFormat = "H:|-horizontalInset-[titleLabel(>=80)]"
        
        if let valueView = valueView {
            views["valueView"] = valueView
            constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-verticalInset-[valueView]-verticalInset-|", metrics: metrics, views: views)
            horizontalVisualFormat += "-[valueView]"

            let valueToContentWidthPercentageConstraint = NSLayoutConstraint(item: valueView,
                                                                             attribute: NSLayoutConstraint.Attribute.width,
                                                                             relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual,
                                                                             toItem: contentView, attribute: NSLayoutConstraint.Attribute.width,
                                                                             multiplier: M2A.config.objectPropertyDefeaultValueToContentWidthPercentage/100,
                                                                             constant: -M2A.config.objectPropertyDefaultHorizontalInset)
            valueToContentWidthPercentageConstraint.priority = .defaultLow
            constraints += [valueToContentWidthPercentageConstraint]
            
            accessoryViewConstraint = NSLayoutConstraint(item: valueView,
                                                         attribute: NSLayoutConstraint.Attribute.right,
                                                         relatedBy: NSLayoutConstraint.Relation.equal,
                                                         toItem: contentView, attribute: NSLayoutConstraint.Attribute.right,
                                                         multiplier: 1,
                                                         constant: -M2A.config.objectPropertyDefaultHorizontalInset)
        }
        
        if let accessoryViewConstraint = accessoryViewConstraint {
            constraints += [accessoryViewConstraint]
        }
        constraints += NSLayoutConstraint.constraints(withVisualFormat: horizontalVisualFormat, metrics: metrics, views: views)
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override open func update() {
        super.update()
        
        titleLabel.text = title
        accessoryViewConstraint?.constant = accessoryType == .none ? -M2A.config.objectPropertyDefaultHorizontalInset : 0
    }
}



