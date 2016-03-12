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
    
    func testDecodeImages() {
        (0...19).forEach { index in
            let name = String(format: "image-%05d", index)
            let image = NSBundle(forClass: self.dynamicType)
                .pathForResource(name, ofType: "bpg")
                .flatMap { NSData(contentsOfFile: $0) }
                .flatMap { ImageType(BPGData: $0) }
            XCTAssertNotNil(image, name)
        }
    }
}
