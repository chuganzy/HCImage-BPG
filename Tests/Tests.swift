//
//  Tests.swift
//  HCImage+BPG
//
//  Created by Takeru Chuganji on 3/13/16.
//  Copyright © 2016 Takeru Chuganji. All rights reserved.
//

import XCTest
@testable import HCImageBPG

typealias ImageType = NSImage

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        let _ = NSBundle.mainBundle()
            .pathForResource("image-001", ofType: "bpg")
            .flatMap { NSData(contentsOfFile: $0) }
            .flatMap { ImageType(BPGData: $0) }
    }
}
