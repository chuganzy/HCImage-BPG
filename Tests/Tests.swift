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
    
    func testDecodeInvalidImages() {
        XCTAssertNil(decodeBPGWithName("broken-00000"))
        XCTAssertNil(decodeBPGWithName("jpeg-00000", type: "jpg"))
        XCTAssertNil(ImageType(BPGData: NSData(bytes: nil, length: 0)))
    }
    
    func testDecodeAnimationImages() {
        let image = decodeBPGWithName("animation-00000")
        let expectedCount = 40
        #if os(iOS)
            XCTAssertEqual(image?.images?.count, expectedCount)
        #elseif os(OSX)
            let count = (image?.representations.first as? NSBitmapImageRep)?
                .valueForProperty(NSImageFrameCount) as? Int
            XCTAssertEqual(count, expectedCount)
        #endif
    }
    
    
    private func decodeBPGWithName(name: String, type: String = "bpg") -> ImageType? {
        return NSBundle(forClass: self.dynamicType)
            .pathForResource(name, ofType: type)
            .flatMap { NSData(contentsOfFile: $0) }
            .flatMap { ImageType(BPGData: $0) }
    }
}
