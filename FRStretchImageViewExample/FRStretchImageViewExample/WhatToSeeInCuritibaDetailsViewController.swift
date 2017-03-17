//
//  WhatToSeeInCuritibaDetailsViewController.swift
//  FRStretchImageViewExample
//
//  Created by Felipe Ricieri on 17/03/17.
//  Copyright © 2017 Ricieri Labs. All rights reserved.
//

import UIKit
import Foundation
import FRStretchImageView

class WhatToSeeInCuritibaDetailsViewController : UIViewController {
    
    var touristicPointName: String = "" {
        didSet {
            touristicPointTitle = "\(touristicPointName), 🇧🇷"
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stretchableImageView: FRStretchImageView!
    
    fileprivate var touristicPointTitle : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Other outlets
        titleLabel.text = touristicPointTitle
        
        // Setting FRStretchImageView
        stretchableImageView.stretchHeightWhenPulledBy(scrollView: scrollView)
    }
}

