//
//  AnimatedTransitioning.swift
//  Model2App
//
//  Created by Karol Kulesza on 06/09/2018.
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


class AnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    var initialFrame: CGRect = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return M2A.config.defaultPresentationAnimationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // To be overridden
    }
            
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning, isPresenting: Bool) {
        let fromViewController = transitionContext.viewController(forKey: .from)!
        let toViewController = transitionContext.viewController(forKey: .to)!
        let containerView = transitionContext.containerView
        
        let animationDuration = transitionDuration(using: transitionContext)
        let viewController = isPresenting ? toViewController : fromViewController
        
        let snapshotView = viewController.view.resizableSnapshotView(from: viewController.view.frame, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero)!
        containerView.addSubview(snapshotView)
        
        if isPresenting {
            snapshotView.frame = initialFrame
            toViewController.view.alpha = 0.0
            containerView.addSubview(toViewController.view)
            
            UIView.animate(withDuration: animationDuration,
                           delay: 0.0,
                           usingSpringWithDamping: M2A.config.defaultAnimationDampingRatio,
                           initialSpringVelocity: M2A.config.defaultAnimationInitialSpringVelocity,
                           options: [],
                           animations: {
                snapshotView.frame = fromViewController.view.frame
            }) { finished in
                snapshotView.removeFromSuperview()
                toViewController.view.alpha = 1.0
                
                transitionContext.completeTransition(finished)
            }
        } else {
            toViewController.beginAppearanceTransition(true, animated: true)
            fromViewController.view.alpha = 0.0
            
            UIView.animate(withDuration: animationDuration, animations: {
                snapshotView.frame = self.initialFrame
                snapshotView.alpha = 0.0
            }) { finished in
                snapshotView.removeFromSuperview()
                fromViewController.view.removeFromSuperview()
                
                toViewController.endAppearanceTransition()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}

class AnimatedPresentationTransitioning: AnimatedTransitioning {
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        super.animateTransition(using: transitionContext, isPresenting: true)
    }
}

class AnimatedDismissalTransitioning: AnimatedTransitioning {
    
    override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return M2A.config.defaultDismissalAnimationDuration
    }
    
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        super.animateTransition(using: transitionContext, isPresenting: false)
    }
}


