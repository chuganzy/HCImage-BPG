//
//  ViewController.swift
//  Example
//
//  Created by Takeru Chuganji on 11/11/15.
//  Copyright © 2015 Takeru Chuganji. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet private weak var imageView: NSImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("sample", ofType: "bpg")!)!
        self.imageView?.image = NSImage(BPGData: data)
    }
}
