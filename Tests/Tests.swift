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

final class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDecodeImages() {
        (0...19).forEach { index in
            let name = String(format: "image-%05d", index)
            XCTAssertNotNil(decodeBPG(forResource: name), name)
        }
    }
    
    func testDecodeInvalidImages() {
        XCTAssertNil(decodeBPG(forResource: "broken-00000"))
        XCTAssertNil(decodeBPG(forResource: "jpeg-00000", withExtension: "jpg"))
        XCTAssertNil(ImageType(bpgData: Data(bytes: [])))
    }
    
    func testDecodeAnimatedImages() {
        let image = decodeBPG(forResource: "animation-00000")
        let expectedCount = 40
        #if os(iOS)
            XCTAssertEqual(image?.images?.count, expectedCount)
        #elseif os(OSX)
            let count = (image?.representations.first as? NSBitmapImageRep)?
                .value(forProperty: NSImageFrameCount) as? Int
            XCTAssertEqual(count, expectedCount)
        #endif
    }
    
    
    private func decodeBPG(forResource res: String, withExtension ext: String = "bpg") -> ImageType? {
        return Bundle(for: type(of: self))
            .url(forResource: res, withExtension: ext)
            .flatMap { try? Data(contentsOf: $0) }
            .flatMap(ImageType.init(bpgData:))
    }
}
