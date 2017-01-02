//
// Created by Takeru Chuganji on 12/21/14.
// Copyright (c) 2014 Takeru Chuganji. All rights reserved.
//

#ifndef Image_hpp
#define Image_hpp

#include <CoreGraphics/CGImage.h>

namespace CG
{
    
    class ColorSpace;
    class DataProvider;
    
    class Image
    {
    public:
        Image(size_t, size_t,
              size_t, size_t, size_t,
              const ColorSpace &, CGBitmapInfo,
              const DataProvider &,
              const CGFloat *, bool,
              CGColorRenderingIntent);
        ~Image();
        
        operator CGImageRef() const;
        
    private:
        CGImageRef _ref;
    };
}

#endif /* Image_hpp */
