//
//  FRViewController.swift
//  FRStretchImageViewExample
//
//  Created by Felipe Ricieri on 16/03/17.
//  Copyright © 2017 Ricieri Labs. All rights reserved.
//

import UIKit
import FRStretchImageView

class FRViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageHeader: FRStretchImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting FRStretchImageView
        imageHeader.stretchHeightWhenPulledBy(scrollView: scrollView)
    }
}

