//
// Created by Takeru Chuganji on 12/21/14.
// Copyright (c) 2014 Takeru Chuganji. All rights reserved.
//

#ifndef CG_ColorSpace_hpp
#define CG_ColorSpace_hpp

#include <CoreGraphics/CGColorSpace.h>

namespace CG
{
    class ColorSpace
    {
    public:
        static ColorSpace CreateDeviceRGB();
        
        ColorSpace(CGColorSpaceRef ref);
        ~ColorSpace();
        
        operator CGColorSpaceRef() const;
        
    private:
        CGColorSpaceRef _ref;
    };
}

#endif /* CG_ColorSpace_hpp */
