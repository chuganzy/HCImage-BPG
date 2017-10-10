//
// Created by Takeru Chuganji on 12/21/14.
// Copyright (c) 2014 Takeru Chuganji. All rights reserved.
//

#import "HCImage+BPG.h"
#import <vector>
#import <memory>
#import "CG.hpp"
#if TARGET_OS_IOS
#import <UIKit/UIScreen.h>
#endif

extern "C" {
#import "libbpg.h"
}

// MARK:- BPG
namespace BPG
{
    // MARK: Context
    class Context
    {
    public:
        Context(): _context(bpg_decoder_open())
        {
        }

        ~Context()
        {
            if (_context) {
                bpg_decoder_close(_context);
            }
        }

        bool decode(const uint8_t *buffer, int length) const
        {
            return bpg_decoder_decode(_context, buffer, length) == 0;
        }

        bool start(BPGDecoderOutputFormat format) const
        {
            return bpg_decoder_start(_context, format) == 0;
        }

        bool getInfo(BPGImageInfo *info) const
        {
            return bpg_decoder_get_info(_context, info) == 0;
        }

        void getFrameDuration(int *pnum, int *pden) const
        {
            bpg_decoder_get_frame_duration(_context, pnum, pden);
        }

        bool getLine(void *buffer) const
        {
            return bpg_decoder_get_line(_context, buffer) == 0;
        }

    private:
        BPGDecoderContext *_context;
    };
}

// MARK:- ImageProcessor
class ImageProcessor
{
public:
    ImageProcessor(): _colorSpace(CG::ColorSpace::CreateDeviceRGB())
    {
    }

    HCImage *process(NSData *data) const
    {
        if (!_context.decode((uint8_t *)data.bytes, (int)data.length)) {
            return nil;
        }

        BPGImageInfo info;
        if (!_context.getInfo(&info)) {
            return nil;
        }

        auto format = info.has_alpha ? BPG_OUTPUT_FORMAT_RGBA32 : BPG_OUTPUT_FORMAT_RGB24;
        auto scale = getScale();

        if (info.has_animation) {
            return processAnimated(info, format, scale);
        }

        if (!_context.start(format)) {
            return nil;
        }

        return convertCGImage(*createCurrentFrameImage(info), info, scale);
    }

private:
    BPG::Context _context;
    CG::ColorSpace _colorSpace;

    static void releaseImageData(void *info, const void *data, size_t size)
    {
        delete[] (uint8_t *)data;
    }

    static CGFloat getScale()
    {
#if TARGET_OS_IOS
        return UIScreen.mainScreen.scale;
#else
        return 1;
#endif
    }

    static HCImage *convertCGImage(const CG::Image& image, BPGImageInfo info, CGFloat scale)
    {
#if TARGET_OS_IOS
        return [UIImage imageWithCGImage:image
                                   scale:scale
                             orientation:UIImageOrientationUp];
#else
        return [[NSImage alloc] initWithCGImage:image
                                           size:NSMakeSize(info.width, info.height)];
#endif
    }

    HCImage *processAnimated(BPGImageInfo info, BPGDecoderOutputFormat format, CGFloat scale) const
    {
#if TARGET_OS_IOS
        auto images = [NSMutableArray array];
        NSTimeInterval totalDuration = 0;
        while (_context.start(format)) {
            int num, den;
            _context.getFrameDuration(&num, &den);
            totalDuration += (NSTimeInterval)num / den;
            [images addObject:convertCGImage(*createCurrentFrameImage(info), info, scale)];
        }
        return [UIImage animatedImageWithImages:images duration:totalDuration];
#else
        struct Frame {
            std::shared_ptr<CG::Image> image;
            NSTimeInterval duration;
        };

        std::vector<Frame> frames;
        while (_context.start(format)) {
            int num, den;
            _context.getFrameDuration(&num, &den);
            frames.push_back({
                createCurrentFrameImage(info),
                (NSTimeInterval)num / den
            });
        }

        auto data = [NSMutableData data];
        auto dest = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)data,
                                                     kUTTypeGIF,
                                                     frames.size(),
                                                     nullptr);
        auto destProperties = @{
                                (__bridge NSString *)kCGImagePropertyGIFDictionary : @{
                                        (__bridge NSString *)kCGImagePropertyGIFLoopCount : @(info.loop_count),
                                        }
                                };
        CGImageDestinationSetProperties(dest, (__bridge CFDictionaryRef)destProperties);
        for (auto frame : frames) {
            auto properties = @{
                                (__bridge NSString *)kCGImagePropertyGIFDictionary : @{
                                        (__bridge NSString *)kCGImagePropertyGIFDelayTime : @(frame.duration),
                                        }
                                };

            CGImageDestinationAddImage(dest, *frame.image, (__bridge CFDictionaryRef)properties);
        }
        CGImageDestinationFinalize(dest);
        CFRelease(dest);
        return [[NSImage alloc] initWithData:data];
#endif
    }

    std::shared_ptr<CG::Image> createCurrentFrameImage(BPGImageInfo info) const
    {
        auto bytesPerPixel = info.has_alpha ? 4 : 3;
        auto lineLength = info.width * bytesPerPixel;
        auto buffer = new uint8_t[lineLength * info.height];
        for (auto y = 0; y < info.height; y++) {
            if (!_context.getLine(buffer + lineLength * y)) {
                break;
            }
        }

        CG::DataProvider provider(nullptr,
                                  buffer,
                                  lineLength * info.height,
                                  releaseImageData);

        return std::make_shared<CG::Image>(info.width,
                                           info.height,
                                           8,
                                           8 * bytesPerPixel,
                                           lineLength,
                                           _colorSpace,
                                           (CGBitmapInfo)((info.has_alpha ? kCGImageAlphaLast : kCGImageAlphaNone) | kCGBitmapByteOrder32Big),
                                           provider,
                                           nullptr,
                                           false,
                                           kCGRenderingIntentDefault);
    }
};

// MARK:- HCImage+BPG
@implementation HCImage (BPG)

+ (HCImage *)imageWithBPGData:(NSData *)data
{
    NSParameterAssert(data);
    ImageProcessor processor;
    return processor.process(data);
}

@end
