//
//  ObjectListViewCell.swift
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
 *  Cell responsible for rendering a cell for a given object on the list of objects
 */
open class ObjectListViewCell: BaseCell {
    
    // MARK: -
    // MARK: Properties & Constants
    
    /// `ModelClass` subclass being a source for the list of objects
    open var modelClass: ModelClass.Type = ModelClass.self
    
    /// Dictionary of subViews presented for a given object, where object's property name is the key in the dictionary
    open var views = [String: AnyObject]()
    
    /// List of object's properties to be presented on UI
    open var listViewCellProperties: [String] {
        if modelClass.listViewCellProperties.count == 0 {
            return modelClass.defaultListViewCellProperty != nil ? [modelClass.defaultListViewCellProperty!] : []
        }
        return modelClass.listViewCellProperties
    }
    
    // MARK: -
    // MARK: Initializers & Deinitializers
    
    public init(withModelClass modelClass: ModelClass.Type, reuseIdentifier: String?) {
        self.modelClass = modelClass
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }
    
    public required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: -
    // MARK: UITableViewCell Methods
    
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if isSelected && M2A.config.objectListCellDefaultShouldAnimateSelection {
            contentView.layer.add(AnimationUtilities.createSelectionAnimation(duration: 0.05, scale: 0.95), forKey: nil)
        }
    }
    
    // MARK: -
    // MARK: BaseCell Methods
    
    override open func addViews() {
        listViewCellProperties.reversed().forEach { property in            
            // Assuming as for now, that `Data` property type always map to UIImage on UI
            if modelClass.isProperty(property, ofType: .data) {
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFill
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.clipsToBounds = true
                
                contentView.addSubview(imageView)
                views[property] = imageView;
            } else {
                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.font = UIFont(name: M2A.config.objectListCellPropertyDefaultFontName, size: M2A.config.objectListCellPropertyDefaultFontSize)
                label.textColor = M2A.config.objectListCellPropertyDefaultFontColor
                label.textAlignment = .left
                contentView.addSubview(label)
                
                views[property] = label;
            }
        }
    }
    
    override open func setup() {
        super.setup()
        
        backgroundColor = M2A.config.objectListCellDefaultBackgroundColor.withAlphaComponent(M2A.config.objectListCellDefaultBackgroundAlpha)
    }
    
    override open func addConstraints() {
        var constraints = [NSLayoutConstraint]()
        var containsVerticalConstraint = false
        modelClass.listViewCellLayoutVisualFormats.forEach { visualFormat in
            constraints += NSLayoutConstraint.constraints(withVisualFormat: visualFormat, metrics: nil, views: views)
            if !containsVerticalConstraint && visualFormat.hasPrefix("V:") {
                containsVerticalConstraint = true
            }
        }
        // If there are no constraints defined by `listViewCellLayoutVisualFormats`, use `listViewCellProperties` to define default horizontal constraints
        if constraints.count == 0 && listViewCellProperties.count > 0 {
            var visualFormat = "H:|"
            listViewCellProperties.forEach { property in visualFormat += "-[\(property)]" }
            constraints += NSLayoutConstraint.constraints(withVisualFormat: visualFormat, metrics: nil, views: views)
            
            listViewCellProperties.forEach { property in
                constraints += NSLayoutConstraint.constraints(withVisualFormat: "[\(property)]->=8-|", metrics: nil, views: views)
            }
        }
        
        if !containsVerticalConstraint {
            listViewCellProperties.forEach { property in
                if modelClass.isProperty(property, ofType: .data)  {
                    let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=\(M2A.config.cellDefaultVerticalInset))-[\(property)]-(>=\(M2A.config.cellDefaultVerticalInset))-|", metrics: nil, views: views)
                    verticalConstraints.forEach { $0.priority = UILayoutPriority.defaultHigh }
                    constraints += verticalConstraints
                } else {
                    let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(M2A.config.cellDefaultVerticalInset)-[\(property)]-\(M2A.config.cellDefaultVerticalInset)-|", metrics: nil, views: views)
                    verticalConstraints.forEach { $0.priority = UILayoutPriority.defaultHigh }
                    constraints += verticalConstraints
                }
            }
        }
        
        listViewCellProperties.forEach { property in
            let containsImageWidthConstraint = containsImageSizeConstraintForOrientationPrefix("H:", property: property)
            let containsImageHeightConstraint = containsImageSizeConstraintForOrientationPrefix("V:", property: property)
            
            // Assuming as for now, that `Data` property type always map to UIImage on UI
            if modelClass.isProperty(property, ofType: .data), let imageView = views[property] {
                let imageWidthConstraint = NSLayoutConstraint(item: imageView,
                                           attribute: NSLayoutConstraint.Attribute.width,
                                           relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual,
                                           toItem: nil,
                                           attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                           multiplier: 0,
                                           constant: M2A.config.objectListCellDefaultImageHeight)
                imageWidthConstraint.priority = containsImageWidthConstraint ? UILayoutPriority.defaultHigh : UILayoutPriority.required
                constraints += [imageWidthConstraint]
                
                let imageHeightConstraint = NSLayoutConstraint(item: imageView,
                                           attribute: NSLayoutConstraint.Attribute.height,
                                           relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual,
                                           toItem: nil,
                                           attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                           multiplier: 0,
                                           constant: M2A.config.objectListCellDefaultImageHeight)
                imageHeightConstraint.priority = containsImageHeightConstraint ? UILayoutPriority.defaultHigh : UILayoutPriority.required
                constraints += [imageHeightConstraint]
            }
        }
        NSLayoutConstraint.activate(constraints)
    }
  
    // MARK: -
    // MARK: UIView Methods
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if !M2A.config.objectListCellDefaultShouldRoundImages { return }
        for property in listViewCellProperties {
            if modelClass.isProperty(property, ofType: .data),
                let imageView = views[property] as? UIImageView, imageView.layer.cornerRadius == 0 {
                imageView.layer.cornerRadius = imageView.frame.size.height / 2
            }
        }
    }
    
    // MARK: -
    // MARK: ObjectListViewCell Methods
    
    /**
     *  Method responsible for updating the subviews based on provided object
     */
    open func updateForObject(object: ModelClass) {
        listViewCellProperties.forEach { property in
            // Assuming as for now, that `Data` property type always map to UIImage on UI
            if modelClass.isProperty(property, ofType: .data) {
                (views[property] as? UIImageView)?.image = ImageUtilities.getThumbnailForNameData(nameData: object[property] as? Data);
            } else {
                (views[property] as? UILabel)?.text = object.valueString(forProperty: property);
            }
        }
    }
    
    // MARK: -
    // MARK: Helper Methods
    
    private func containsImageSizeConstraintForOrientationPrefix(_ orientationPrefix: String, property: String) -> Bool {
        return modelClass.listViewCellLayoutVisualFormats.contains { format in
            let specifiesSize = (format.range(of: property)?.upperBound).flatMap { format[$0] == "(" } ?? false
            return format.hasPrefix(orientationPrefix) && specifiesSize
        }
    }
}

open class NoneObjectListViewCell: BaseListViewCell {
    
    // MARK: -
    // MARK: Properties & Constants
    
    override open var textFontName: String { return M2A.config.objectListCellPropertyDefaultFontName }
    override open var textFontSize: CGFloat { return M2A.config.objectListCellPropertyDefaultFontSize }
    override open var textFontColor: UIColor { return M2A.config.objectListCellPropertyDefaultFontColor }
    
    override open var cellBackgroundColor: UIColor { return M2A.config.objectListCellDefaultBackgroundColor }
    override open var cellBackgroundAlpha: CGFloat { return M2A.config.objectListCellDefaultBackgroundAlpha }
    
    // MARK: -
    // MARK: BaseCell Methods
    
    override open func setup() {
        super.setup()
        
        valueLabel?.text = M2A.config.objectListCellDefaultNoneString
    }
    
}
