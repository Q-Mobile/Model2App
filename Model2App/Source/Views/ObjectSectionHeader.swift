//
//  ObjectSectionHeader.swift
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
 *  View for section header, for object's related objects' list
 */
open class ObjectSectionHeader: UIView {
    
    // MARK: -
    // MARK: Properties & Constants
    
    open var titleLabel: UILabel!
    
    open var textFontName: String { return M2A.config.objectRelatedObjectsDefaultTextFontName }
    open var textFontSize: CGFloat { return M2A.config.objectRelatedObjectsDefaultTextFontSize }
    open var textFontColor: UIColor { return M2A.config.objectRelatedObjectsDefaultTextFontColor }
    
    open var headerBackgroundColor: UIColor { return M2A.config.objectRelatedObjectsDefaultBackgroundColor }
    open var headerBackgroundAlpha: CGFloat { return M2A.config.objectRelatedObjectsDefaultBackgroundAlpha }
    
    open var verticalInset: CGFloat { return M2A.config.objectRelatedObjectsDefaultVerticalInset }
    open var horizontalInset: CGFloat { return M2A.config.objectRelatedObjectsDefaultHorizontalInset }
    
    // MARK: -
    // MARK: Initializers & Deinitializers
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = headerBackgroundColor.withAlphaComponent(headerBackgroundAlpha)
        
        addViews()
        addConstraints()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: -
    // MARK: ObjectSectionHeader Methods
    
    /**
     *  Method responsible for providing any additional views to section header view
     */
    open func addViews() {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: textFontName, size: textFontSize)
        titleLabel.textColor = textFontColor
        titleLabel.adjustsFontSizeToFitWidth = true
         
        addSubview(titleLabel)
    }
    
    /**
     *  Method responsible for setting up the layout constraints for section header view
     */
    open func addConstraints() {
        let metrics = [
            "verticalInset" : verticalInset,
            "horizontalInset" : horizontalInset
        ]
        let views: [String: AnyObject] = [ "titleLabel": titleLabel ]
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-verticalInset-[titleLabel]-verticalInset-|", metrics: metrics, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-horizontalInset-[titleLabel]-horizontalInset-|", metrics: metrics, views: views)
        
        NSLayoutConstraint.activate(constraints)
    }
}
