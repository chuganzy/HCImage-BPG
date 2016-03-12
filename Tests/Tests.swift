//
//  Tests.swift
//  HCImage+BPG
//
//  Created by Takeru Chuganji on 3/13/16.
//  Copyright © 2016 Takeru Chuganji. All rights reserved.
//

import XCTest
@testable import HCImageBPG

#if os(iOS)
    typealias ImageType = UIImage
#elseif os(OSX)
    typealias ImageType = NSImage
#endif

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
            XCTAssertNotNil(decodeBPGWithName(name), name)
        }
    }

#if os(iOS)
    func testDecodeAnimationImages() {
        XCTAssertEqual(decodeBPGWithName("animation-00000")?.images?.count, 40)
    }
#endif
    
    private func decodeBPGWithName(name: String) -> ImageType? {
        return NSBundle(forClass: self.dynamicType)
            .pathForResource(name, ofType: "bpg")
            .flatMap { NSData(contentsOfFile: $0) }
            .flatMap { ImageType(BPGData: $0) }
    }
}
