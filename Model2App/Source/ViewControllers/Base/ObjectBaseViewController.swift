//
//  ObjectBaseViewController.swift
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


protocol BasePresenter: class {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Swift.Void)?)
    func show(_ vc: UIViewController, sender: Any?)
}

protocol ModelPresenter: BasePresenter {
    func showVCFor(object: ModelClass?, fromFrame: CGRect?)
}

/**
 *  Base class for object-based VCs
 */
open class ObjectBaseViewController: BaseTableViewController, ModelPresenter {
    
    // MARK: -
    // MARK: Properties & Constants
    
    weak var presenter: BasePresenter?
    private let transitionDelegate = TransitioningDelegate()
    
    // MARK: -
    // MARK: Computed Properties

    /// Storage used by this VC (subject for injection)
    open var storage: StorageProtocol { return Storage.shared }

    // MARK: -
    // MARK: BaseTableViewController Methods
    
    override open func setup() {
        super.setup()
        self.presenter = self
    }
    
    // MARK: -
    // MARK: ObjectBaseViewController Methods
    
    func showVCFor(object: ModelClass?, fromFrame: CGRect? = nil) {
        object.flatMap {
            let objectVC = ObjectViewController(object: $0)
            let navigationVC = UINavigationController(rootViewController: objectVC)
            
            fromFrame.flatMap {
                transitionDelegate.initialFrame = tableView.convert($0, to: tableView.superview)
                
                navigationVC.transitioningDelegate = transitionDelegate
                navigationVC.modalPresentationStyle = .custom
            }
            
            presenter?.present(navigationVC, animated: true, completion: nil)
        }
    }
}
