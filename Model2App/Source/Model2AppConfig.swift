//
//  Model2AppConfig.swift
//  Model2App
//
//  Created by Karol Kulesza on 4/30/18.
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

struct M2AConstants {
    static let menuBackgroundImageName = "iOS12Wallpaper"
    static let defaultBoldFont = "AppleSDGothicNeo-Bold"
    static let defaultRegularFont = "AppleSDGothicNeo-Regular"
    static let defaultListViewUpdateDelay = 0.2
}

/**
 *  `Model2App` configuration class (to be potentially subclassed by the app)
 */
open class M2AConfig {

    // MARK: -
    // MARK: Root Menu Config
    
    /// Default number of columns in app's root menu
    open class var menuDefaultNumberOfColumns: Int { return 2 }
    
    /// Default margin to be applied in app's root menu
    open class var menuDefaultInset: CGFloat { return 20 }
    
    /// Default spacing between app's root menu rows
    open class var menuDefaultMinimumLineSpacing: CGFloat { return 20 }
    
    /// Default spacing between app's root menu columns
    open class var menuDefaultMinimumInteritemSpacing: CGFloat { return 20 }
    
    /// Default image name of the app's root menu background
    open class var menuDefaultBackgroundImageName: String { return M2AConstants.menuBackgroundImageName }

    
    // MARK: -
    // MARK: Root Menu Item Config
    
    /// Default font name to be used in app's root menu item
    open class var menuItemDefaultFontName: String { return M2AConstants.defaultBoldFont }
    
    /// Default minimum size of the font in app's root menu item
    open class var menuItemDefaultMinimumFontSize: CGFloat { return 10 }
    
    /// Default ratio of menu item name label height to menu item content height, expressed in %
    open class var menuItemDefaultLabelToContentHeightPercentage: CGFloat { return 20 } // (%)
    
    /// Default corner radius of the app's menu item icon
    open class var menuItemDefaultCornerRadius: CGFloat { return 10 }
    
    /// Default alpha component value for background color of app's menu item
    open class var menuItemDefaultBackgroundAlpha: CGFloat { return 0.3 }
    
    /// Default background color of app's menu item
    open class var menuItemDefaultBackgroundColor: UIColor { return UIColor.white }
    
    /// Default font color to be used in app's root menu item
    open class var menuItemDefaultFontColor: UIColor { return UIColor.black }
    
    /// Default setting for enabling animation for app's root menu item, upon selection
    open class var menuItemDefaultShouldAnimateSelection: Bool { return true }
    
    
    // MARK: -
    // MARK: Object List Config
    
    /// Default font name to be used in object list view cell, for object's property value
    open class var objectListCellPropertyDefaultFontName: String { return M2AConstants.defaultBoldFont }
    
    /// Default font size in object list view cell, for object's property value
    open class var objectListCellPropertyDefaultFontSize: CGFloat { return 18 }
    
    /// Default font color in object list view cell, for object's property value
    open class var objectListCellPropertyDefaultFontColor: UIColor { return UIColor.black }
    
    /// Default alpha component value for background color of object list view cell
    open class var objectListCellDefaultBackgroundAlpha: CGFloat { return 0.4 }
    
    /// Default background color of object list view cell
    open class var objectListCellDefaultBackgroundColor: UIColor { return UIColor.white }
    
    /// Default string to be used for representing no selection, for `Object` type of properties (relationships)
    open class var objectListCellDefaultNoneString: String { return "<- None ->" }
    
    /// Default height of the image view used in object list view cell
    open class var objectListCellDefaultImageHeight: CGFloat { return 50 }
    
    /// Default setting for enabling rounding image view corners in object list view cell
    open class var objectListCellDefaultShouldRoundImages: Bool { return true }
    
    /// Default setting for enabling animation for object list view cell, upon selection
    open class var objectListCellDefaultShouldAnimateSelection: Bool { return true }
    
    
    // MARK: -
    // MARK: Object Property Config
    
    /// Default font name to be used in object detail view property cell, for object's property title
    open class var objectPropertyDefaultTitleFontName: String { return M2AConstants.defaultBoldFont }
    
    /// Default font name to be used in object detail view property cell, for object's property value
    open class var objectPropertyDefaultValueFontName: String { return  M2AConstants.defaultRegularFont }
    
    /// Default font size to be used in object detail view property  cell, for object's property title
    open class var objectPropertyDefaultTitleFontSize: CGFloat { return 18 }
    
    /// Default font size to be used in object detail view property cell, for object's property value
    open class var objectPropertyDefaultValueFontSize: CGFloat { return 18 }
    
    /// Default horizontal inset to be applied in object detail view property cell
    open class var objectPropertyDefaultHorizontalInset: CGFloat { return 20 }
    
    /// Default vertical inset to be applied in object detail view property cell
    open class var objectPropertyDefaultVerticalInset: CGFloat { return 10 }
    
    /// Default ratio of object's property value label width to object's detail view property cell width, expressed in %
    open class var objectPropertyDefeaultValueToContentWidthPercentage: CGFloat { return 50 } // (%)
    
    /// Default alpha component value for background color of object detail view property cell
    open class var objectPropertyDefaultBackgroundAlpha: CGFloat { return 0.4 }
    
    /// Default background color of object detail view property cell
    open class var objectPropertyDefaultBackgroundColor: UIColor { return UIColor.white }
    
    /// Default font color in object's detail view property cell, for object's property title
    open class var objectPropertyDefaultTitleFontColor: UIColor { return UIColor.black }
    
    /// Default font color in object's detail view property cell, for object's property value
    open class var objectPropertyDefaultValueFontColor: UIColor { return UIColor.black }
    
    /// Default placeholder font color in object's detail view property cell, for object's property value
    open class var objectPropertyDefaultValuePlaceholderFontColor: UIColor { return UIColor.darkGray }
    
    /// Default placeholder text in detail view property cell, for object's property value
    open class var objectPropertyDefaultTextValuePlaceholder: String { return "Enter text here" }
    
    /// Default setting for enabling rounding image view corners in object's detail view property cell
    open class var objectPropertyDefaultShouldRoundImages: Bool { return true }
    
    
    // MARK: -
    // MARK: Object's Related Objects Config
    
    /// Default font name to be used in related objects section header, in object detail view
    open class var objectRelatedObjectsDefaultTextFontName: String { return M2AConstants.defaultRegularFont }

    /// Default font size to be used in related objects section header, in object detail view
    open class var objectRelatedObjectsDefaultTextFontSize: CGFloat { return 16 }
    
    /// Default font color to be used in related objects section header, in object detail view
    open class var objectRelatedObjectsDefaultTextFontColor: UIColor { return UIColor.black }
    
    /// Default alpha component value for background color of related objects section header, in object detail view
    open class var objectRelatedObjectsDefaultBackgroundAlpha: CGFloat { return 0.3 }
    
    /// Default background color of related objects section header, in object detail view
    open class var objectRelatedObjectsDefaultBackgroundColor: UIColor { return UIColor.black }
    
    /// Default horizontal inset to be applied in related objects section header, in object detail view
    open class var objectRelatedObjectsDefaultHorizontalInset: CGFloat { return 20 }
    
    /// Default vertical inset to be applied in related objects section header, in object detail view
    open class var objectRelatedObjectsDefaultVerticalInset: CGFloat { return 5 }
    
    
    // MARK: -
    // MARK: Picker List Config
    
    /// Default font name to be used in picker list view cell
    open class var pickerListCellDefaultTextFontName: String { return M2AConstants.defaultBoldFont }
   
    /// Default font size to be used in picker list view cell
    open class var pickerListCellDefaultTextFontSize: CGFloat { return 18 }
    
    /// Default font color to be used in picker list view cell
    open class var pickerListCellDefaultTextFontColor: UIColor { return UIColor.black }
    
    /// Default alpha component value for background color of picker list view cell
    open class var pickerListCellDefaultBackgroundAlpha: CGFloat { return 0.4 }
    
    /// Default background color of picker list view cell
    open class var pickerListCellDefaultBackgroundColor: UIColor { return UIColor.white }
    
    /// Default horizontal inset to be applied in picker list view cell
    open class var pickerListCellDefaultHorizontalInset: CGFloat { return 20 }
    
    /// Default vertical inset to be applied in picker list view cell
    open class var pickerListCellDefaultVerticalInset: CGFloat { return 10 }

    
    // MARK: -
    // MARK: Default Cell Config
    
    /// Default font name to be used in default cell
    open class var cellDefaultTextFontName: String { return M2AConstants.defaultBoldFont }
    
    /// Default font size to be used in default cell
    open class var cellDefaultTextFontSize: CGFloat { return 18 }
    
    /// Default font color to be used in default cell
    open class var cellDefaultTextFontColor: UIColor { return UIColor.black }
    
    /// Default alpha component value for background color of a default cell
    open class var cellDefaultBackgroundAlpha: CGFloat { return 0.4 }
    
    /// Default background color of a default cell
    open class var cellDefaultBackgroundColor: UIColor { return UIColor.white }
    
    /// Default horizontal inset to be applied in a default cell
    open class var cellDefaultHorizontalInset: CGFloat { return 20 }
    
    /// Default vertical inset to be applied in a default cell
    open class var cellDefaultVerticalInset: CGFloat { return 10 }
    
    
    // MARK: -
    // MARK: Animation Config
    
    /// Default duration of the VC presentation animation across the app
    open class var defaultPresentationAnimationDuration: TimeInterval { return 0.5 }
    
    /// Default duration of the VC dismissal animation across the app
    open class var defaultDismissalAnimationDuration: TimeInterval { return 0.3 }
    
    /// Default spring damping ratio to be used in animations across the app
    open class var defaultAnimationDampingRatio: CGFloat { return 0.6 }
    
    /// Default initial spring velocity to be used in animations across the app
    open class var defaultAnimationInitialSpringVelocity: CGFloat { return 20.0 }
    
    
    // MARK: -
    // MARK: Image Config
    
    /// Default max pixel size to be used for image thumbnails
    open class var imageThumbnailDefaultMaxPixelSize: Int { return 300 }
    
    
    // MARK: -
    // MARK: Entry point for VCs customization
    
    /// Default root view controller (subclass of `RootViewController`) to be used as app's window `rootViewController`
    /// (To be used as an entry point for any customizations for any subclassable view controllers introduced in `Model2App`)
    open class var defaultRootVC: RootViewController { return RootViewController(collectionViewLayout: UICollectionViewFlowLayout()) }
}

public class M2A {
    static var config: M2AConfig.Type {
        return ModelManager.shared.configClass
    }
}

