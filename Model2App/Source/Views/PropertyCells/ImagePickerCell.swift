//
//  ImagePickerCell.swift
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


struct ImagePickerConstants {
    static let accessoryViewVerticalInset: CGFloat = 5.0
}

/**
 *  Property cell for displaying and picking the image value for a property
 */
open class ImagePickerCell : PropertyCell<Data> {
    
    // MARK: -
    // MARK: BaseCell Methods
    
    override open func didSelect() {
        super.didSelect()
        
        objectVC?.handleImageSelection()
    }
    
    override open func setup() {
        super.setup()
        
        selectionStyle = .default
    }
    
    override open func update() {
        super.update()

        if let image = ImageUtilities.getThumbnailForNameData(nameData: value) {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.height - 2 * ImagePickerConstants.accessoryViewVerticalInset, height: frame.height - 2 * ImagePickerConstants.accessoryViewVerticalInset))
            imageView.contentMode = .scaleAspectFill
            imageView.image = image
            imageView.clipsToBounds = true
            
            accessoryView = imageView
            editingAccessoryView = accessoryView
            if M2A.config.objectPropertyDefaultShouldRoundImages {
                accessoryView?.layer.cornerRadius = (frame.height - 2 * ImagePickerConstants.accessoryViewVerticalInset) / 2
            }
        } else {
            accessoryView = nil
            editingAccessoryView = nil
        }
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
