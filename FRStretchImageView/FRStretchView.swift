//
//  FRStretchView.swift
//  FRStretchImageView
//
//  Created by Felipe Ricieri on 09/03/17.
//  Copyright © 2017 Ricieri Labs. All rights reserved.
//

import Foundation
import UIKit

public class FRStretchView : UIView {
    
    var debug = false
    
    /* ScrollView observed by the View */
    fileprivate var scrollView : UIScrollView!
    /* Constraints we need to change in order to get the "stretch" behavior */
    fileprivate var topConstraint: NSLayoutConstraint!
    fileprivate var heightConstraint: NSLayoutConstraint!
    /* We also need to keep the constraint's initial value */
    fileprivate var topInitialValue : CGFloat!
    fileprivate var heightInitialValue : CGFloat!
    /* KVO tools */
    fileprivate var context = 01_11_89
    fileprivate let keyPathObserved = "contentOffset"
    
    // MARK: - Initialization
    public func stretchHeightWhenPulledBy(scrollView: UIScrollView) {
        
        if  debug {
            print("FRStretchImageView: was allocated")
        }
        
        self.scrollView = scrollView
        
        // ScrollView
        assert(self.scrollView != nil, "FRStretchImageView: scrollView cannot be nil")
        self.scrollView.clipsToBounds = false
        self.scrollView.addObserver(self, forKeyPath: self.keyPathObserved, options: [.new], context: &self.context)
        
        // View
        assert(self.superview != nil, "FRStretchImageView: view has no superview")
        // 1) Find top constraint
        let constraints = self.superview!.constraints
        for constraint in constraints {
            if  constraint.firstAttribute == .top
                && (constraint.firstItem as! NSObject) == self
                && (constraint.secondItem as! NSObject) == self.superview  {
                self.topConstraint = constraint
            }
        }
        // 2) Find height constraint
        let selfConstraints = self.constraints
        for constraint in selfConstraints {
            if  constraint.firstAttribute == .height {
                self.heightConstraint = constraint
            }
        }
        
        // Assert
        assert(self.topConstraint != nil, "FRStretchImageView: view must have a top constraint pinned to top of superview. Use Interface Builder to pin it.")
        assert(self.heightConstraint != nil, "FRStretchImageView: view must have a height constraint pinned on it. Use Interface Builder to pin it.")
        
        // Set initial values
        self.topInitialValue = self.topConstraint.constant
        self.heightInitialValue = self.heightConstraint.constant
    }
    
    deinit {
        if  debug {
            print("FRStretchImageView: was deallocated")
        }
        // Remove observer
        self.scrollView.removeObserver(self, forKeyPath: self.keyPathObserved, context: &self.context)
        // Releasing the references we made
        self.scrollView = nil
        self.topConstraint = nil
        self.heightConstraint = nil
    }
}

// MARK: - KVO
extension FRStretchView {
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if  let changeDict = change {
            /* This is our scope */
            if  object as? NSObject == self.scrollView
                &&  keyPath == self.keyPathObserved
                &&  context == &self.context {
                /* We will only proceed in case we have the correct new value as CGPoint */
                if  let new = changeDict[.newKey],
                    let newContentOffset = (new as AnyObject).cgPointValue {
                    
                    if  debug {
                        print("FRStretchImageView: New Content Offset --> \(newContentOffset)")
                    }
                    
                    /* if offset y is higher than 0, we keep the initial values */
                    if  newContentOffset.y > 0 {
                        self.topConstraint.constant = self.topInitialValue
                        self.heightConstraint.constant = self.heightInitialValue
                        self.superview?.layoutSubviews()
                    }
                        /* if it isn't, we do our math */
                    else {
                        let dif = CGFloat(abs(Int32(newContentOffset.y)))
                        self.heightConstraint.constant = self.heightInitialValue + dif
                        self.topConstraint.constant = newContentOffset.y
                        self.superview?.layoutSubviews()
                    }
                }
            }
        }
    }
}

