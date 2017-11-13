//
// Created by Takeru Chuganji on 12/21/14.
// Copyright (c) 2014 Takeru Chuganji. All rights reserved.
//

#ifndef CG_Image_hpp
#define CG_Image_hpp

#include <CoreGraphics/CGImage.h>

namespace CG
{
    
    class ColorSpace;
    class DataProvider;
    
    class Image
    {
    public:
        Image(size_t width, size_t height,
              size_t bitsPerComponent, size_t bitsPerPixel, size_t bytesPerRow,
              const ColorSpace &space, CGBitmapInfo bitmapInfo,
              const DataProvider &provider,
              const CGFloat *decode, bool shouldInterpolate,
              CGColorRenderingIntent intent);
        ~Image();
        
        operator CGImageRef() const;
        
    private:
        CGImageRef _ref;
    };
}

#endif /* CG_Image_hpp */
