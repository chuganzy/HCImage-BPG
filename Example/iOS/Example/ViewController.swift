//
//  ViewController.swift
//  Example
//
//  Created by Takeru Chuganji on 11/11/15.
//  Copyright © 2015 Takeru Chuganji. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView?.image = NSBundle.mainBundle().pathForResource("sample", ofType: "bpg")
            .flatMap { NSData(contentsOfFile: $0) }
            .flatMap { UIImage(BPGData: $0) }
    }
}

