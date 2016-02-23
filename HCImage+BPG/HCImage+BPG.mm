//
// Created by Takeru Chuganji on 12/21/14.
// Copyright (c) 2014 Takeru Chuganji. All rights reserved.
//

#import "HCImage+BPG.h"
#import <vector>
#import <memory>
#import "Internal/CG.hpp"

extern "C" {
#import <libbpg/libbpg.h>
}

class Decoder
{
public:
    Decoder(const uint8_t *buffer, int length) :
    _colorSpace(CG::ColorSpace::CreateDeviceRGB())
    ,_context(bpg_decoder_open())
#if TARGET_OS_IPHONE
    ,_imageScale([UIScreen mainScreen].scale)
#endif
    {
        if (!this->_context) {
            throw "bpg_decoder_open";
        }
        if (bpg_decoder_decode(this->_context, buffer, length) != 0) {
            throw "bpg_decoder_decode";
        }
        if (bpg_decoder_get_info(this->_context, &this->_imageInfo) != 0) {
            throw "bpg_decoder_get_info";
        }
        this->_imageLineSize = (this->_imageInfo.has_alpha ? 4 : 3) * this->_imageInfo.width;
        this->_imageTotalSize = this->_imageLineSize * this->_imageInfo.height;
    }
    
    HCImage *decode() const
    {
        if (bpg_decoder_start(this->_context, BPG_OUTPUT_FORMAT_RGBA32) != 0) {
            throw "bpg_decoder_start";
        }
        if (!this->_imageInfo.has_animation) {
            return this->cgImageToHCImage(*this->getCurrentFrameCGImage());
        }
        
        struct FrameInfo {
            std::shared_ptr<CG::Image> image;
            NSTimeInterval duration;
        };
        
        std::vector<FrameInfo> infos;
        do {
            int num, den;
            bpg_decoder_get_frame_duration(this->_context, &num, &den);
            infos.push_back({
                this->getCurrentFrameCGImage(),
                (NSTimeInterval)num / den
            });
        } while (bpg_decoder_start(this->_context, BPG_OUTPUT_FORMAT_RGBA32) == 0);
        
#if TARGET_OS_IPHONE
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:infos.size()];
        NSTimeInterval totalDuration = 0;
        for (auto info : infos) {
            totalDuration += info.duration;
            [images addObject:this->cgImageToHCImage(*info.image)];
        }
        return [UIImage animatedImageWithImages:images duration:totalDuration];
        
#else
        NSMutableData *data = [NSMutableData data];
        CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)data,
                                                                             kUTTypeGIF,
                                                                             infos.size(),
                                                                             nullptr);
        NSDictionary *destProperties = @{
                                         (__bridge NSString *)kCGImagePropertyGIFDictionary : @{
                                                 (__bridge NSString *)kCGImagePropertyGIFLoopCount : @(this->_imageInfo.loop_count),
                                                 }
                                         };
        CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)destProperties);
        for (auto info : infos) {
            NSDictionary *properties = @{
                                         (__bridge NSString *)kCGImagePropertyGIFDictionary : @{
                                                 (__bridge NSString *)kCGImagePropertyGIFDelayTime : @(info.duration),
                                                 }
                                         };
            CGImageDestinationAddImage(destination, *info.image, (__bridge CFDictionaryRef)properties);
        }
        CGImageDestinationFinalize(destination);
        CFRelease(destination);
        return [[NSImage alloc] initWithData:data];
#endif
    }
    
    ~Decoder()
    {
        if (this->_context) {
            bpg_decoder_close(this->_context);
            this->_context = nullptr;
        }
    }
    
private:
    CG::ColorSpace _colorSpace;
    BPGDecoderContext *_context;
    BPGImageInfo _imageInfo;
    size_t _imageLineSize;
    size_t _imageTotalSize;
#if TARGET_OS_IPHONE
    CGFloat _imageScale;
#endif
    
    static void releaseImageData(void *info, const void *data, size_t size)
    {
        delete (uint8_t *)data;
    }
    
    uint8_t *getCurrentFrameBuffer() const
    {
        uint8_t *buffer = new uint8_t[this->_imageTotalSize];
        for (int y = 0; y < this->_imageInfo.height; ++y) {
            if (bpg_decoder_get_line(this->_context, buffer + (y * this->_imageLineSize)) == 0) {
                continue;
            }
            delete buffer;
            throw "bpg_decoder_get_line";
        }
        return buffer;
    }
    
    std::shared_ptr<CG::Image> getCurrentFrameCGImage() const
    {
        CG::DataProvider provider = CG::DataProvider(nullptr,
                                                     this->getCurrentFrameBuffer(),
                                                     this->_imageTotalSize,
                                                     this->releaseImageData
                                                     );
        return std::make_shared<CG::Image>(this->_imageInfo.width,
                                           this->_imageInfo.height,
                                           8,
                                           (this->_imageInfo.has_alpha ? 4 : 3) * 8,
                                           this->_imageLineSize,
                                           this->_colorSpace,
                                           (CGBitmapInfo)((this->_imageInfo.has_alpha ? kCGImageAlphaLast : kCGImageAlphaNone) | kCGBitmapByteOrder32Big),
                                           provider,
                                           nullptr,
                                           false,
                                           kCGRenderingIntentDefault);
    }
    
    HCImage *cgImageToHCImage(const CG::Image &image) const
    {
#if TARGET_OS_IPHONE
        return [UIImage imageWithCGImage:image scale:this->_imageScale orientation:UIImageOrientationUp];
#else
        return [[NSImage alloc] initWithCGImage:image size:NSMakeSize(this->_imageInfo.width, this->_imageInfo.height)];
#endif
    }
};

@implementation HCImage (BPG)

+ (HCImage *)imageWithBPGData:(NSData *)data {
    NSParameterAssert(data);
    try {
        Decoder decoder((uint8_t *)data.bytes, (int)data.length);
        return decoder.decode();
    } catch (...) {
        return nil;
    }
}

@end
