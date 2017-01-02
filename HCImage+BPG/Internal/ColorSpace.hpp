//
// Created by Takeru Chuganji on 12/21/14.
// Copyright (c) 2014 Takeru Chuganji. All rights reserved.
//

#ifndef ColorSpace_hpp
#define ColorSpace_hpp

#include <CoreGraphics/CGColorSpace.h>

namespace CG
{
    class ColorSpace
    {
    public:
        static ColorSpace CreateDeviceRGB();
        
        ColorSpace(CGColorSpaceRef);
        ~ColorSpace();
        
        operator CGColorSpaceRef() const;
        
    private:
        CGColorSpaceRef _ref;
    };
}

#endif /* ColorSpace_hpp */
