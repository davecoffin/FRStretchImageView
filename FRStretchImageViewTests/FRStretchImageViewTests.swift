//
//  FRStretchImageViewTests.swift
//  FRStretchImageViewTests
//
//  Created by Felipe Ricieri on 11/03/17.
//  Copyright © 2017 Ricieri Labs. All rights reserved.
//

import XCTest
@testable import FRStretchImageView

class FRStretchImageViewTests: XCTestCase {
    
    fileprivate var image : FRStretchImageView!
    fileprivate var scroll : UIScrollView!
    fileprivate var contentView : UIView!
    
    override func setUp() {
        super.setUp()
        
        // Frame
        let frame = CGRect(
            origin: CGPoint(x:0, y:0),
            size: CGSize(width: 375, height: 667)
        )
        let imageHeight : CGFloat = 200
        
        // Set up Scroll
        scroll = UIScrollView(frame: frame)
        
        // Set up Content View
        contentView = UIView(frame: frame)
        
        // Set up Image
        image = FRStretchImageView(frame: frame)
        
        // Prepare Scrollview
        contentView.addSubview(image)
        scroll.addSubview(contentView)
        
        // Assert we do have outlets
        XCTAssert(scroll != nil, "UIScrollView cannot be nil")
        XCTAssert(image != nil, "UIImageView cannot be nil")
        XCTAssert(contentView != nil, "Content View (UIView) cannot be nil")
        
        // Set constraints
        let topConstraint = NSLayoutConstraint(item: image, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: image, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 0.0, constant: imageHeight)
        NSLayoutConstraint.activate([topConstraint, heightConstraint])
    }
    
    override func tearDown() {
        self.image = nil
        self.scroll = nil
        self.contentView = nil
        super.tearDown()
    }
    
    func testStretchHeightWhenPulledByScrollView() {
        
        // Launch method
        image.stretchHeightWhenPulledBy(scrollView: scroll)
        
        // Assert
        XCTAssert(scroll.clipsToBounds == false, "FRStretchImageView didn't set UIScrollView.clipToBounds to FALSE")
        XCTAssert(image.topConstraint != nil, "FRStretchImageView Top Constraint cannot be nil.")
        XCTAssert(image.heightConstraint != nil, "FRStretchImageView Height Constraint cannot be nil")
    }
    
    func testObserveValueForKeyPathContentOffset() {
        
        // Assert outlets have relationship
        XCTAssert(image.superview == contentView, "UIImageView must be child of Content View (UIView)")
        XCTAssert(contentView.superview == scroll, "Content View (UIView) must be child of UIScrollView")
        
        // Launch method
        image.stretchHeightWhenPulledBy(scrollView: scroll)
        
        // Initial state
        let initialPosition = image.topConstraint.constant
        let initialSize = image.heightConstraint.constant
        let change : CGFloat = -300
        
        // Change UIScrollView contentOffset
        scroll.contentOffset = CGPoint(x: 0, y: -300)
        
        // Assert changes
        XCTAssert(image.heightConstraint.constant > initialSize, "UIImageView didn't changed height")
        XCTAssert(image.topConstraint.constant < initialPosition, "UIImageView didn't changed position")
        XCTAssert(image.heightConstraint.constant == initialSize + (-change), "UIImageView height must be equal (-\"change\")")
        XCTAssert(image.topConstraint.constant == change, "UIImageView origin Y must be equal \"change\"")
        
        // Return to 0
        scroll.contentOffset = CGPoint(x: 0, y: 0)
        
        // Assert changes
        XCTAssert(image.heightConstraint.constant == initialSize, "UIImageView height must return to initial size")
        XCTAssert(image.topConstraint.constant == initialPosition, "UIImageView origin Y must return to initial position")
    }
}

