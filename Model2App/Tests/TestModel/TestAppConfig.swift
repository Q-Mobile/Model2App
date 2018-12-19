//
//  TestModel.swift
//  Model2AppTests
//
//  Created by Karol Kulesza on 6/28/18.
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

import Model2App


class M2A_TestAppConfig : M2AConfig {
    
    override static var menuDefaultNumberOfColumns: Int { return 3 }
    override static var menuItemDefaultFontName: String { return "Arial" }
    override static var menuItemDefaultLabelToContentHeightPercentage: CGFloat { return 15 }  //(%)
    override static var menuItemDefaultCornerRadius: CGFloat { return 15 }
    
    override static var objectPropertyDefaultTitleFontSize: CGFloat { return 20 }
    override static var objectPropertyDefaultShouldRoundImages: Bool { return false }
    
    override static var objectListCellPropertyDefaultFontColor: UIColor { return UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0) }
    override static var objectListCellDefaultNoneString: String { return "<- NONE ->" }
    override static var objectListCellDefaultImageHeight: CGFloat { return 70 }
    override static var objectListCellDefaultShouldRoundImages: Bool { return false }
    
}

