//
//  BaseTableViewController.swift
//  Model2App
//
//  Created by Karol Kulesza on 6/19/18.
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

import UIKit


/**
 *  Base class for table-based VCs
 */
open class BaseTableViewController: UITableViewController {
    
    // MARK: -
    // MARK: UIViewController Methods
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: -
    // MARK: BaseTableViewController Methods
    
    /**
     *  Method invoked after `viewDidLoad`, setting up this VC
     */
    open func setup() {
        let bundle = M2A.config.menuDefaultBackgroundImageName == M2AConstants.menuBackgroundImageName ? ModelManager.shared.bundle : Bundle.main
        let backgroundImage = UIImage.init(named: M2A.config.menuDefaultBackgroundImageName, in: bundle, compatibleWith: nil)
        tableView?.backgroundView = UIImageView(image: backgroundImage)
        tableView?.tableFooterView = UIView()
        tableView?.cellLayoutMarginsFollowReadableWidth = false
        tableView?.allowsSelectionDuringEditing = true
    }
 
    func setNavigationTitleAnimation() {
        let fadeTitleAnimation = CATransition()
        fadeTitleAnimation.duration = 0.3
        fadeTitleAnimation.type = CATransitionType.fade
        navigationController?.navigationBar.layer.add(fadeTitleAnimation, forKey: "fadeTitle")
    }
}
