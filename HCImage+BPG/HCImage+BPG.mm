//
// Created by Takeru Chuganji on 12/21/14.
// Copyright (c) 2014 Takeru Chuganji. All rights reserved.
//

#import "HCImage+BPG.h"
#import <vector>
#import <memory>

extern "C" {
    #import <libbpg/libbpg.h>
}

using namespace std;

class Decoder {
public:
    static shared_ptr<Decoder> decoder(const uint8_t *buffer, int buffer_length) {
        shared_ptr<Decoder> decoder = make_shared<Decoder>();
        decoder->initialize(buffer, buffer_length);
        return decoder;
    }
    
    Decoder() : m_context(bpg_decoder_open()), m_color_space(CGColorSpaceCreateDeviceRGB()) {
    }
    
    ~Decoder() {
        if (m_context != NULL) {
            bpg_decoder_close(m_context);
            m_context = NULL;
        }
        if (m_color_space != NULL) {
            CGColorSpaceRelease(m_color_space);
            m_color_space = NULL;
        }
    }
    
    HCImage *decode() {
        if (bpg_decoder_start(m_context, BPG_OUTPUT_FORMAT_RGBA32) < 0) {
            throw "could not start decode";
        }
        
        class FrameInfo {
        public:
            static shared_ptr<FrameInfo> info(CGImageRef image, NSTimeInterval frame_duration) {
                return make_shared<FrameInfo>(image, frame_duration);
            }
            
            FrameInfo(CGImageRef image, NSTimeInterval frame_duration)
            : m_image(image), m_frame_duration(frame_duration) {
                
            }
            
            ~FrameInfo() {
                if (m_image != NULL) {
                    CGImageRelease(m_image);
                    m_image = NULL;
                }
            }
            
            CGImageRef get_image() {
                return m_image;
            }
            
            NSTimeInterval get_frame_duration() {
                return m_frame_duration;
            }
        private:
            CGImageRef m_image;
            NSTimeInterval m_frame_duration;
        };
        
        if (!m_image_info.has_animation) {
            return get_image_with_cg_image(FrameInfo::info(get_current_frame_cg_image(), 0)->get_image());
        }
        
        vector<shared_ptr<FrameInfo>> infos;
        do {
            int num, den;
            bpg_decoder_get_frame_duration(m_context, &num, &den);
            infos.push_back(FrameInfo::info(get_current_frame_cg_image(), (NSTimeInterval) num / den));
        } while (bpg_decoder_start(m_context, BPG_OUTPUT_FORMAT_RGBA32) == 0);
        
#if TARGET_OS_IPHONE
        NSMutableArray *images = [NSMutableArray array];
        NSTimeInterval total_duration = 0;
        for (shared_ptr<FrameInfo> info : infos) {
            UIImage *image = get_image_with_cg_image(info->get_image());
            [images addObject:image];
            total_duration += info->get_frame_duration();
        }
        return [UIImage animatedImageWithImages:images duration:total_duration];
#else
        size_t number_of_frames = infos.size();
        NSMutableData *data = [NSMutableData data];
        CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef) data, kUTTypeGIF, number_of_frames, NULL);
        for (shared_ptr<FrameInfo> info : infos) {
            NSDictionary *properties = @{
                                         (__bridge NSString *) kCGImagePropertyGIFDelayTime : @(info->get_frame_duration()),
                                         };
            CGImageDestinationAddImage(destination, info->get_image(), (__bridge CFDictionaryRef) properties);
        }
        NSDictionary *properties = @{
                                     (__bridge NSString *) kCGImagePropertyGIFLoopCount : @(m_image_info.loop_count),
                                     };
        CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef) properties);
        CGImageDestinationFinalize(destination);
        CFRelease(destination);
        return [[NSImage alloc] initWithData:data];
#endif
    }
    
private:
    BPGDecoderContext *m_context;
    BPGImageInfo m_image_info;
    CGColorSpaceRef m_color_space;
    size_t m_frame_line_size;
    size_t m_frame_total_size;
    
    static void release_image_data(void *info, const void *data, size_t size) {
        delete (uint8_t *) data;
    }
    
    void initialize(const uint8_t *buffer, int buffer_length) {
        if (m_context == NULL) {
            throw "could not open decoder";
        }
        if (bpg_decoder_decode(m_context, buffer, buffer_length) < 0) {
            throw "could not decode buffer";
        }
        if (bpg_decoder_get_info(m_context, &m_image_info) < 0) {
            throw "could not get image info";
        }
        m_frame_line_size = 4 * m_image_info.width;
        m_frame_total_size = m_frame_line_size * m_image_info.height;
    }
    
    HCImage *get_image_with_cg_image(CGImage *const cg_image) {
#if TARGET_OS_IPHONE
        return [UIImage imageWithCGImage:cg_image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
#else
        return [[NSImage alloc] initWithCGImage:cg_image size:NSMakeSize(m_image_info.width, m_image_info.height)];
#endif
    }
    
    CGImageRef get_current_frame_cg_image() {
        return create_cg_image_with_buffer(get_current_frame_buffer());
    }
    
    CGImageRef create_cg_image_with_buffer(const uint8_t *const buffer) {
        CGDataProviderRef data_provider = CGDataProviderCreateWithData(
                                                                       NULL,
                                                                       buffer,
                                                                       m_frame_total_size,
                                                                       release_image_data);
        CGImageRef image = CGImageCreate(
                                         m_image_info.width,
                                         m_image_info.height,
                                         8,
                                         4 * 8,
                                         m_frame_line_size,
                                         m_color_space,
                                         (CGBitmapInfo) (kCGImageAlphaLast | kCGBitmapByteOrder32Big),
                                         data_provider,
                                         NULL,
                                         NO,
                                         kCGRenderingIntentDefault);
        CGDataProviderRelease(data_provider);
        return image;
    }
    
    uint8_t *get_current_frame_buffer() {
        uint8_t *frame_total_buffer;
        try {
            frame_total_buffer = new uint8_t[m_frame_total_size];
        } catch (...) {
            throw "could not create buffer";
        }
        for (int y = 0; y < m_image_info.height; ++y) {
            if (bpg_decoder_get_line(m_context, frame_total_buffer + (y * m_frame_line_size)) < 0) {
                delete frame_total_buffer;
                throw "could not get frame line";
            }
        }
        return frame_total_buffer;
    }
};

@implementation HCImage (BPG)

+ (HCImage *)imageWithBPGData:(NSData *)data {
    NSParameterAssert(data);
    try {
        return Decoder::decoder((uint8_t *) data.bytes, (int) data.length)->decode();
    } catch (...) {
        return nil;
    }
}

@end
