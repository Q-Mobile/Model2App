//
//  PickerCell.swift
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
 *  Label cell for presenting the picker values
 */
open class PickerCell<T> : LabelCell<T> where T: Equatable {

    // MARK: -
    // MARK: BaseCell Methods
    
    override open func setup() {
        super.setup()
        
        selectionStyle = .default
    }
    
    override open func update() {
        // Set accessory types before calling `super`
        accessoryType = isInEditMode ? .disclosureIndicator : .none
        editingAccessoryType = accessoryType
        
        super.update()
    }
}

/**
 *  Label cell for presenting the object picker values
 */
open class ObjectPickerCell: PickerCell<ModelClass> {
    
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
    
    override open func didSelect() {
        super.didSelect()
        objectVC?.showObjectSelectionVC()
    }
    
    // MARK: -
    // MARK: PropertyCell Methods
    
    override open var valueString: String {
        return value.flatMap { $0.objectName } ?? ""
    }
}

/**
 *  Label cell for presenting the text picker values
 */
open class TextPickerCell: PickerCell<String> {
    
    // MARK: -
    // MARK: BaseCell Methods
    
    override open func didSelect() {
        super.didSelect()
        objectVC?.showTextPickerVC()
    }
}
