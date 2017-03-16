//
//  FRStretchViewTests.swift
//  FRStretchtestViewView
//
//  Created by Felipe Ricieri on 11/03/17.
//  Copyright © 2017 Ricieri Labs. All rights reserved.
//

import XCTest
@testable import FRStretchImageView

class FRStretchViewTests: XCTestCase {
    
    fileprivate var testView : FRStretchView!
    fileprivate var scroll : UIScrollView!
    fileprivate var contentView : UIView!
    
    override func setUp() {
        super.setUp()
        
        // Frame
        let frame = CGRect(
            origin: CGPoint(x:0, y:0),
            size: CGSize(width: 375, height: 667)
        )
        let testViewHeight : CGFloat = 200
        
        // Set up Scroll
        scroll = UIScrollView(frame: frame)
        
        // Set up Content View
        contentView = UIView(frame: frame)
        
        // Set up testView
        testView = FRStretchView(frame: frame)
        
        // Prepare Scrollview
        contentView.addSubview(testView)
        scroll.addSubview(contentView)
        
        // Assert we do have outlets
        XCTAssert(scroll != nil, "UIScrollView cannot be nil")
        XCTAssert(testView != nil, "UItestViewView cannot be nil")
        XCTAssert(contentView != nil, "Content View (UIView) cannot be nil")
        
        // Set constraints
        let topConstraint = NSLayoutConstraint(item: testView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: testView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 0.0, constant: testViewHeight)
        NSLayoutConstraint.activate([topConstraint, heightConstraint])
    }
    
    override func tearDown() {
        self.testView = nil
        self.scroll = nil
        self.contentView = nil
        super.tearDown()
    }
    
    func testStretchHeightWhenPulledByScrollView() {
        
        // Launch method
        testView.stretchHeightWhenPulledBy(scrollView: scroll)
        
        // Assert
        XCTAssert(scroll.clipsToBounds == false, "FRStretchtestViewView didn't set UIScrollView.clipToBounds to FALSE")
        XCTAssert(testView.topConstraint != nil, "FRStretchtestViewView Top Constraint cannot be nil.")
        XCTAssert(testView.heightConstraint != nil, "FRStretchtestViewView Height Constraint cannot be nil")
    }
    
    func testObserveValueForKeyPathContentOffset() {
        
        // Assert outlets have relationship
        XCTAssert(testView.superview == contentView, "UItestViewView must be child of Content View (UIView)")
        XCTAssert(contentView.superview == scroll, "Content View (UIView) must be child of UIScrollView")
        
        // Launch method
        testView.stretchHeightWhenPulledBy(scrollView: scroll)
        
        // Initial state
        let initialPosition = testView.topConstraint.constant
        let initialSize = testView.heightConstraint.constant
        let change : CGFloat = -300
        
        // Change UIScrollView contentOffset
        scroll.contentOffset = CGPoint(x: 0, y: change)
        
        // Assert changes
        XCTAssert(testView.heightConstraint.constant > initialSize, "UItestViewView didn't changed height")
        XCTAssert(testView.topConstraint.constant < initialPosition, "UItestViewView didn't changed position")
        XCTAssert(testView.heightConstraint.constant == initialSize + (-change), "UItestViewView height must be equal (-\"change\")")
        XCTAssert(testView.topConstraint.constant == change, "UItestViewView origin Y must be equal \"change\"")
        
        // Return to 0
        scroll.contentOffset = CGPoint(x: 0, y: 0)
        
        // Assert changes
        XCTAssert(testView.heightConstraint.constant == initialSize, "UItestViewView height must return to initial size")
        XCTAssert(testView.topConstraint.constant == initialPosition, "UItestViewView origin Y must return to initial position")
    }
}
