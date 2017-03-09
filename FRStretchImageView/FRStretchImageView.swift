//
//  FRStretchImageView.swift
//  FRStretchImageView
//
//  Created by Felipe Ricieri on 08/03/17.
//  Copyright © 2017 Ricieri Labs. All rights reserved.
//

import Foundation
import UIKit

public class FRStretchImageView : UIImageView {
    
    var debug = false
    
    /* ScrollView observed by the ImageView */
    fileprivate var scrollView : UIScrollView!
    /* Constraints we need to change in order to get the "stretch" behavior */
    fileprivate var imageViewTopConstraint: NSLayoutConstraint!
    fileprivate var imageViewHeightConstraint: NSLayoutConstraint!
    /* We also need to keep the constraint's initial value */
    fileprivate var imageViewTopInitialValue : CGFloat!
    fileprivate var imageViewHeightInitialValue : CGFloat!
    /* KVO tools */
    fileprivate var context = 20_06_87
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
        
        // ImageView
        assert(self.superview != nil, "FRStretchImageView: imageView has no superview")
        // 1) Find top constraint
        let constraints = self.superview!.constraints
        for constraint in constraints {
            if  constraint.firstAttribute == .top
                && (constraint.firstItem as! NSObject) == self
                && (constraint.secondItem as! NSObject) == self.superview  {
                self.imageViewTopConstraint = constraint
            }
        }
        // 2) Find height constraint
        let selfConstraints = self.constraints
        for constraint in selfConstraints {
            if  constraint.firstAttribute == .height {
                self.imageViewHeightConstraint = constraint
            }
        }
        
        // Assert
        assert(self.imageViewTopConstraint != nil, "FRStretchImageView: imageView must have a top constraint pinned to top of superview. Use Interface Builder to pin it.")
        assert(self.imageViewHeightConstraint != nil, "FRStretchImageView: imageView must have a height constraint pinned on it. Use Interface Builder to pin it.")
        
        // Set initial values
        self.imageViewTopInitialValue = self.imageViewTopConstraint.constant
        self.imageViewHeightInitialValue = self.imageViewHeightConstraint.constant
    }
    
    deinit {
        if  debug {
            print("FRStretchImageView: was deallocated")
        }
        // Remove observer
        self.scrollView.removeObserver(self, forKeyPath: self.keyPathObserved, context: &self.context)
        // Releasing the references we made
        self.scrollView = nil
        self.imageViewTopConstraint = nil
        self.imageViewHeightConstraint = nil
    }
}

// MARK: - KVO
extension FRStretchImageView {
    
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
                        self.imageViewTopConstraint.constant = self.imageViewTopInitialValue
                        self.imageViewHeightConstraint.constant = self.imageViewHeightInitialValue
                    }
                    /* if it isn't, we do our math */
                    else {
                        let dif = CGFloat(abs(Int32(newContentOffset.y)))
                        self.imageViewHeightConstraint.constant = self.imageViewHeightInitialValue + dif
                        self.imageViewTopConstraint.constant = newContentOffset.y
                    }
                }
            }
        }
    }
}

