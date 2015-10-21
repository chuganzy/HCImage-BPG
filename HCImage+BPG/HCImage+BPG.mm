//
// Created by Takeru Chuganji on 12/21/14.
// Copyright (c) 2014 Takeru Chuganji. All rights reserved.
//

#import "HCImage+BPG.h"
#import <vector>

extern "C" {
    #import <libbpg/libbpg.h>
}

#if !TARGET_OS_IPHONE
#import <ImageIO/ImageIO.h>
#endif

class Decoder {
public:
    Decoder(const uint8_t *, int);
    HCImage *decode();
    ~Decoder();
    
private:
    HCImage *get_current_frame_image();
    CGImageRef get_current_frame_cg_image();
    CGImageRef create_cg_image_with_buffer(const uint8_t *const);
    uint8_t *get_current_frame_buffer();
    static void release_image_data(void *, const void *, size_t);

    BPGDecoderContext *m_context;
    BPGImageInfo m_image_info;
    CGColorSpaceRef m_color_space;
    size_t m_frame_line_size;
    size_t m_frame_total_size;
    
    struct CGImageFrameInfo {
        CGImageRef image;
        NSTimeInterval frame_duration;
    };
};

void Decoder::release_image_data(void *info, const void *data, size_t size) {
    delete (uint8_t *)data;
}

Decoder::Decoder(const uint8_t *buffer, int buffer_length): m_context(bpg_decoder_open()), m_color_space(CGColorSpaceCreateDeviceRGB()) {
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

Decoder::~Decoder() {
    if (m_context != NULL) {
        bpg_decoder_close(m_context);
    }
    if (m_color_space != NULL) {
        CGColorSpaceRelease(m_color_space);
    }
}

HCImage *Decoder::decode() {
    if (bpg_decoder_start(m_context, BPG_OUTPUT_FORMAT_RGBA32) < 0) {
        throw "could not start decode";
    }
    if (!m_image_info.has_animation) {
        return this->get_current_frame_image();
    }
    std::vector<CGImageFrameInfo> data_array;
    do {
        int num, den;
        bpg_decoder_get_frame_duration(m_context, &num, &den);
        struct CGImageFrameInfo data;
        data.image = this->get_current_frame_cg_image();
        data.frame_duration = (NSTimeInterval)num / den;
        data_array.push_back(data);
    } while (bpg_decoder_start(m_context, BPG_OUTPUT_FORMAT_RGBA32) == 0);
    
#if TARGET_OS_IPHONE
    NSMutableArray *images = [NSMutableArray array];
    NSTimeInterval total_duration = 0;
    for (CGImageFrameInfo data : data_array) {
        [images addObject:[UIImage imageWithCGImage:data.image]];
        total_duration += data.frame_duration;
    }
    return [UIImage animatedImageWithImages:images duration:total_duration];
#else
    size_t number_of_frames = data_array.size();
    NSMutableData *data = [NSMutableData data];
    CGImageDestinationRef destination = CGImageDestinationCreateWithData((CFMutableDataRef) data, kUTTypeGIF, number_of_frames, NULL);
    for (CGImageFrameInfo data : data_array) {
        NSDictionary *properties = @{
                                     (__bridge NSString *)kCGImagePropertyGIFDelayTime: @(data.frame_duration),
                                };
        CGImageDestinationAddImage(destination, data.image, (CFDictionaryRef) properties);
    }
    NSDictionary *properties = @{
                                 (__bridge NSString *)kCGImagePropertyGIFLoopCount: @(m_image_info.loop_count),
                                 };
    CGImageDestinationSetProperties(destination, (CFDictionaryRef) properties);
    CGImageDestinationFinalize(destination);
    return [[NSImage alloc] initWithData:data];
#endif
}

HCImage *Decoder::get_current_frame_image() {
    CGImageRef cg_image = this->get_current_frame_cg_image();
#if TARGET_OS_IPHONE
    return [UIImage imageWithCGImage:cg_image];
#else
    return [[NSImage alloc] initWithCGImage:cg_image size:NSMakeSize(m_image_info.width, m_image_info.height)];
#endif
}

CGImageRef Decoder::get_current_frame_cg_image() {
    return this->create_cg_image_with_buffer(this->get_current_frame_buffer());
}

CGImageRef Decoder::create_cg_image_with_buffer(const uint8_t *const buffer) {
    CGDataProviderRef data_provider = CGDataProviderCreateWithData(
                                 NULL,
                                 buffer,
                                 m_frame_total_size,
                                 release_image_data);
    return CGImageCreate(
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
}

uint8_t *Decoder::get_current_frame_buffer() {
    uint8_t *frame_line_buffer = new uint8_t[m_frame_line_size];
    if (frame_line_buffer == NULL) {
        throw "could not create frame line buffer";
    }
    uint8_t *frame_total_buffer = new uint8_t[m_frame_total_size];
    if (frame_total_buffer == NULL) {
        delete frame_line_buffer;
        throw "could not create frame total buffer";
    }
    for (int y = 0; y < m_image_info.height; ++y) {
        if (bpg_decoder_get_line(m_context, frame_line_buffer) < 0) {
            delete frame_line_buffer;
            delete frame_total_buffer;
            throw "could not get frame line";
        }
        memcpy(frame_total_buffer + (y * m_frame_line_size), frame_line_buffer, m_frame_line_size);
    }
    delete frame_line_buffer;
    return frame_total_buffer;
}

@implementation HCImage (BPG)

+ (HCImage *)imageWithBPGData:(NSData *)data {
    Decoder *decoder;
    try {
        decoder = new Decoder((uint8_t *) data.bytes, (int) data.length);
        HCImage *image = decoder->decode();
        delete decoder;
        return image;
    } catch (...) {
        delete decoder;
        return nil;
    }
}

@end
