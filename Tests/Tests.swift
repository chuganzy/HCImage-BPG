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
            XCTAssertNotNil(try! decodeBPG(forResource: name), name)
        }
    }
    
    func testDecodeInvalidImages() {
        func performCheck(_ block: () throws -> Void , throwsErrorWith code: HCImageBPGErrorCode) {
            do {
                try block()
            } catch let error as NSError where error.domain == HCImageBPGErrorDomain {
                XCTAssertEqual(error.code, code.rawValue)
                
            } catch {
                XCTFail()
            }
        }
        performCheck(
            { _ = try decodeBPG(forResource: "broken-00000") },
            throwsErrorWith: .invalidFormat
        )
        performCheck(
            { _ = try decodeBPG(forResource: "jpeg-00000", withExtension: "jpg") },
            throwsErrorWith: .invalidFormat
        )
        performCheck(
            { _ = try ImageType(bpgData: Data(bytes: [])) },
            throwsErrorWith: .invalidFormat
        )
    }
    
    func testDecodeAnimatedImages() {
        let image = try! decodeBPG(forResource: "animation-00000")
        let expectedCount = 40
        #if os(iOS)
            XCTAssertEqual(image?.images?.count, expectedCount)
        #elseif os(OSX)
            let count = (image?.representations.first as? NSBitmapImageRep)?
                .value(forProperty: NSImageFrameCount) as? Int
            XCTAssertEqual(count, expectedCount)
        #endif
    }
    
    
    private func decodeBPG(forResource res: String, withExtension ext: String = "bpg") throws -> ImageType? {
        return try Bundle(for: type(of: self))
            .url(forResource: res, withExtension: ext)
            .flatMap { try Data(contentsOf: $0) }
            .flatMap { try ImageType(bpgData: $0) }
    }
}
