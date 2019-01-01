//
//  Extensions.swift
//  Model2App
//
//  Created by Karol Kulesza on 7/30/18.
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


extension String {

    func camelCaseToWords() -> String {
        let words = unicodeScalars.reduce("") {
            if CharacterSet.uppercaseLetters.contains($1) {
                return $0.count > 0 ? ($0 + " " + String($1)) : String($1)
            } else {
                return $0 + String($1)
            }
        }
        
        return words.prefix(1).uppercased() + words.dropFirst()
    }

    func image(forWidth width: CGFloat, fontSizeToWidthPercentage: CGFloat) -> UIImage? {
        let size = CGSize(width: width, height: width)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(rect)
        
        let font = UIFont.systemFont(ofSize: (width * fontSizeToWidthPercentage).rounded())
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: font
        ]
        
        self.draw(in: rect.insetBy(dx: 0, dy: (rect.height - font.lineHeight)/2), withAttributes: attributes)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}

extension Date {
    
    public init?(dateString: String) {
        self.init(dateString, format: "yyyy-MM-dd")
    }
    
    public init?(timeString: String) {
        self.init(timeString, format: "HH:mm")
    }
    
    public init?(dateTimeString: String) {
        self.init(dateTimeString, format: "yyyy-MM-dd HH:mm")
    }
    
    private init?(_ string: String, format: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = formatter.date(from: string) {
            self.init(timeInterval: 0, since: date)
        } else { return nil }
    }
    
}

extension UIUtilities {
    
    class func isObjectPresentedInVCHierarchy(object: ModelClass, parentVC: UIViewController? = rootViewController()) -> Bool {
        if let objectVC = parentVC as? ObjectViewController {
            if objectVC.dataSource.object.isSameObject(as: object) { return true }
        }
        if let presentedVC = parentVC?.presentedViewController?.children.first { // Assuming that every presented VC will be wrapped in navigation controller
            return UIUtilities.isObjectPresentedInVCHierarchy(object: object, parentVC: presentedVC)
        }
        return false
    }
    
}
