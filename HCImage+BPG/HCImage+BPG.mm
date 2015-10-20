//
// Created by Takeru Chuganji on 12/21/14.
// Copyright (c) 2014 Takeru Chuganji. All rights reserved.
//

#import "HCImage+BPG.h"
extern "C" {
    #import <libbpg/libbpg.h>
}

@implementation HCImage (BPG)

static void release_image_data(void *info, const void *data, size_t size) {
    free((void *) data);
}

+ (HCImage *)imageWithBPGData:(NSData *)data {
    BPGDecoderContext *decoderContext;
    decoderContext = bpg_decoder_open();
    if (bpg_decoder_decode(decoderContext, (uint8_t *) data.bytes, (int) data.length) < 0) {
        bpg_decoder_close(decoderContext);
        return nil;
    }
    BPGImageInfo imageInfo;
    bpg_decoder_get_info(decoderContext, &imageInfo);

    const size_t width = imageInfo.width;
    const size_t height = imageInfo.height;

    const size_t lineSize = 4 * width;
    const size_t size = lineSize * height;

    bpg_decoder_start(decoderContext, BPG_OUTPUT_FORMAT_RGBA32);
    uint8_t *rgbaLine = new uint8_t[lineSize];
    uint8_t *rgbaBuffer = new uint8_t[size];
    for (int y = 0; y < height; y++) {
        bpg_decoder_get_line(decoderContext, rgbaLine);
        memcpy(rgbaBuffer + (y * lineSize), rgbaLine, lineSize);
    }
    delete rgbaLine;
    bpg_decoder_close(decoderContext);
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(
            NULL,
            rgbaBuffer,
            size,
            release_image_data);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef cgImage = CGImageCreate(
            width,
            height,
            8,
            4 * 8,
            lineSize,
            colorSpace,
            (CGBitmapInfo) (kCGImageAlphaLast | kCGBitmapByteOrder32Big),
            dataProvider,
            NULL,
            NO,
            kCGRenderingIntentDefault);
    CGColorSpaceRelease(colorSpace);
    CGDataProviderRelease(dataProvider);
#if TARGET_OS_IPHONE
    UIImage *image = [UIImage imageWithCGImage:cgImage];
#else
    NSImage *image = [[NSImage alloc] initWithCGImage:cgImage size:NSMakeSize(width, height)];
#endif
    CGImageRelease(cgImage);
    return image;
}

@end
