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
        let data = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("sample", ofType: "bpg")!)!
        self.imageView?.image = UIImage(BPGData: data)
    }
}

