//
//  ColorSpace.hpp
//  Pods
//
//  Created by Takeru Chuganji on 2/21/16.
//
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
