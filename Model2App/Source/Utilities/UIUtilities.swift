//
//  UIUtilities.swift
//  Model2App
//
//  Created by Karol Kulesza on 4/25/18.
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
import UIKit


public class UIUtilities {
    public class func showAlert(title: String?,
                         message: String?,
                         actions: [UIAlertAction]? = nil,
                         okHandler: (() -> Swift.Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: title ?? "",
                message: message ?? "",
                preferredStyle: .alert
            )
            
            _ = actions.flatMap{ $0.map { alert.addAction($0) } }
            if actions == nil {
                let dismiss = UIAlertAction(title: "OK", style: .default, handler: { _ in okHandler?() })
                alert.addAction(dismiss)
            }
            presentedViewController()?.present(alert, animated: true, completion: nil)
        }
    }
    
    public class func showValidationAlert(_ alert: String) {
        UIUtilities.showAlert(title: "Info", message: alert)
    }
    
    class func presentedViewController(parentVC: UIViewController? = nil) -> UIViewController? {
        var parentViewController = rootViewController()
        if parentVC != nil {
            parentViewController = parentVC!
        }
 
        if let presentedVC = parentViewController?.presentedViewController {
            return presentedViewController(parentVC: presentedVC)
        } else {
            return parentViewController
        }
    }
    
    class func dismissAllModals(completion: (() -> Swift.Void)? = nil) {
        rootViewController()?.dismiss(animated: true, completion: completion)
    }
    
    class func rootViewController() -> UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }
    
}
