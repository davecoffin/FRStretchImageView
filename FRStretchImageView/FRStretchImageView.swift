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
    
    fileprivate var scrollView : UIScrollView!
    fileprivate var imageViewTopConstraint: NSLayoutConstraint!
    fileprivate var imageViewHeightConstraint: NSLayoutConstraint!
    
    fileprivate var imageViewTopInitialValue : CGFloat!
    fileprivate var imageViewHeightInitialValue : CGFloat!
    
    fileprivate var context = 20_06_87
    fileprivate let keyPathObserved = "contentOffset"
    
    // MARK: - Initialization
    public func stretchHeightWhenPulledBy(scrollView: UIScrollView) {
        
        print("FRStretchImageView: was allocated")
        
        self.scrollView = scrollView
        
        // ScrollView
        assert(self.scrollView != nil, "FRStretchImageView: scrollView cannot be nil")
        self.scrollView.clipsToBounds = false
        self.scrollView.addObserver(self, forKeyPath: self.keyPathObserved, options: [.new], context: &self.context)
        
        // Image
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
        print("FRStretchImageView: was deallocated")
        // Remove observer
        self.scrollView.removeObserver(self, forKeyPath: self.keyPathObserved, context: &self.context)
        // Releasing
        self.scrollView = nil
        self.imageViewTopConstraint = nil
        self.imageViewHeightConstraint = nil
    }
}

// MARK: - KVO
extension FRStretchImageView {
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if  let changeDict = change {
            if  object as? NSObject == self.scrollView && keyPath == self.keyPathObserved && context == &self.context {
                
                if  let new = changeDict[NSKeyValueChangeKey.newKey],
                    let newContentOffset = (new as AnyObject).cgPointValue {
                    
                    if  self.debug {
                        print("FRStretchImageView: New Content Offset --> \(newContentOffset)")
                    }
                    
                    if  newContentOffset.y > 0 {
                        self.imageViewTopConstraint.constant = self.imageViewTopInitialValue
                        self.imageViewHeightConstraint.constant = self.imageViewHeightInitialValue
                    }
                    else {
                        let difference = CGFloat(abs(Int32(newContentOffset.y)))
                        self.imageViewHeightConstraint.constant = self.imageViewHeightInitialValue + difference
                        self.imageViewTopConstraint.constant = newContentOffset.y
                    }
                }
            }
        }
    }
}

