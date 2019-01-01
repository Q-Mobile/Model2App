//
//  RootViewCell.swift
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
 *  Cell responsible for rendering the root menu item, being an entry point for a list of objects for a given `ModelClass` subclass
 */
open class RootViewCell: UICollectionViewCell {
    
    // MARK: -
    // MARK: Properties & Constants
    
    /// Root menu item icon
    open var imageView: UIImageView!
    
    /// Root menu item title
    open var nameLabel: UILabel!
    
    // MARK: -
    // MARK: Initializers & Deinitializers
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = M2A.config.menuItemDefaultCornerRadius
        backgroundColor = M2A.config.menuItemDefaultBackgroundColor.withAlphaComponent(M2A.config.menuItemDefaultBackgroundAlpha)
        
        addViews()
        addConstraints()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: -
    // MARK: RootViewCell Methods
    
    /**
     *  Method responsible for providing any additional views to cell's content view
     */
    open func addViews() {
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        contentView.addSubview(imageView)
        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = M2A.config.menuItemDefaultFontColor
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        contentView.addSubview(nameLabel)
    }
    
    /**
     *  Method responsible for setting up the layout constraints for cell's subviews
     */
    open func addConstraints() {
        let imageHorizontal = NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let imageVertical = NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: (1 - M2A.config.menuItemDefaultLabelToContentHeightPercentage/100), constant: 0)
        let imageWidth = NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.width, multiplier: (1 - M2A.config.menuItemDefaultLabelToContentHeightPercentage/100 - 0.1), constant: 0)
        let imageHeight = NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.height, multiplier: (1 - M2A.config.menuItemDefaultLabelToContentHeightPercentage/100 - 0.1), constant: 0)
        NSLayoutConstraint.activate([imageHorizontal, imageVertical, imageWidth, imageHeight])
        
        let labelHorizontal = NSLayoutConstraint(item: nameLabel, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let labelVertical = NSLayoutConstraint(item: nameLabel, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: (1 - M2A.config.menuItemDefaultLabelToContentHeightPercentage/100 / 2), constant: 0)
        let labelWidth = NSLayoutConstraint(item: nameLabel, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.width, multiplier: 0.9, constant: 0)
        let labelHeight = NSLayoutConstraint(item: nameLabel, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.height, multiplier: M2A.config.menuItemDefaultLabelToContentHeightPercentage/100, constant: 0)
        NSLayoutConstraint.activate([labelHorizontal, labelVertical, labelWidth, labelHeight])
    }
 
    /**
     *  Method responsible for adjusting any subviews based on provided cell size
     */
    open func updateForCellSize(_ size: CGSize) {
        nameLabel.font = UIFont(name: M2A.config.menuItemDefaultFontName, size: (size.height * M2A.config.menuItemDefaultLabelToContentHeightPercentage/100).rounded(.down))
        nameLabel.minimumScaleFactor = M2A.config.menuItemDefaultMinimumFontSize/nameLabel.font.pointSize
    }
    
    /**
     *  Method responsible for updating the subviews based on provided model class
     */
    open func updateForClass(_ modelClass: ModelClass.Type) {
        imageView.image = modelClass.menuIcon(forWidth: frame.size.width)
        nameLabel.text = modelClass.plural
    }
    
    // MARK: -
    // MARK: Overridden
    
    override open var isSelected: Bool {
        didSet{
            if isSelected && M2A.config.menuItemDefaultShouldAnimateSelection {
                layer.add(AnimationUtilities.createSelectionAnimation(duration: 0.05, scale: 0.9), forKey: nil)
            }
        }
    }
}
