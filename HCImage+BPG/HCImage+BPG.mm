//
// Created by Takeru Chuganji on 12/21/14.
// Copyright (c) 2014 Takeru Chuganji. All rights reserved.
//

#import "HCImage+BPG.h"
#import <vector>

extern "C" {
    #import <libbpg/libbpg.h>
}

class Decoder {
public:
    Decoder(const uint8_t *, int);
    ~Decoder();
    HCImage *decode();

private:
    static void release_image_data(void *, const void *, size_t);
    HCImage *get_image_with_cg_image(CGImage *const);
    CGImageRef get_current_frame_cg_image();
    CGImageRef create_cg_image_with_buffer(const uint8_t *const);
    uint8_t *get_current_frame_buffer();

    BPGDecoderContext *m_context;
    BPGImageInfo m_image_info;
    CGColorSpaceRef m_color_space;
    size_t m_frame_line_size;
    size_t m_frame_total_size;
};

void Decoder::release_image_data(void *info, const void *data, size_t size) {
    delete (uint8_t *) data;
}

Decoder::Decoder(const uint8_t *buffer, int buffer_length)
        : m_context(bpg_decoder_open()), m_color_space(CGColorSpaceCreateDeviceRGB()) {
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
        return this->get_image_with_cg_image(this->get_current_frame_cg_image());
    }
    
    struct FrameInfo {
        CGImageRef image;
        NSTimeInterval frame_duration;
    };
    
    std::vector<FrameInfo> infos;
    do {
        int num, den;
        bpg_decoder_get_frame_duration(m_context, &num, &den);
        FrameInfo data;
        data.image = this->get_current_frame_cg_image();
        data.frame_duration = (NSTimeInterval) num / den;
        infos.push_back(data);
    } while (bpg_decoder_start(m_context, BPG_OUTPUT_FORMAT_RGBA32) == 0);

#if TARGET_OS_IPHONE
    NSMutableArray *images = [NSMutableArray array];
    NSTimeInterval total_duration = 0;
    for (FrameInfo info : infos) {
        [images addObject:this->get_image_with_cg_image(info.image)];
        total_duration += info.frame_duration;
    }
    return [UIImage animatedImageWithImages:images duration:total_duration];
#else
    size_t number_of_frames = infos.size();
    NSMutableData *data = [NSMutableData data];
    CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef) data, kUTTypeGIF, number_of_frames, NULL);
    for (FrameInfo info : infos) {
        NSDictionary *properties = @{
                (__bridge NSString *) kCGImagePropertyGIFDelayTime : @(info.frame_duration),
        };
        CGImageDestinationAddImage(destination, info.image, (__bridge CFDictionaryRef) properties);
    }
    NSDictionary *properties = @{
            (__bridge NSString *) kCGImagePropertyGIFLoopCount : @(m_image_info.loop_count),
    };
    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef) properties);
    CGImageDestinationFinalize(destination);
    return [[NSImage alloc] initWithData:data];
#endif
}

HCImage *Decoder::get_image_with_cg_image(CGImage *const image) {
#if TARGET_OS_IPHONE
    return [UIImage imageWithCGImage:image];
#else
    return [[NSImage alloc] initWithCGImage:image size:NSMakeSize(m_image_info.width, m_image_info.height)];
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
    uint8_t *frame_total_buffer;
    try {
        frame_total_buffer = new uint8_t[m_frame_total_size];
    } catch (...) {
        delete frame_total_buffer;
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
