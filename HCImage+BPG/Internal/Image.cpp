//
//  Image.cpp
//  Pods
//
//  Created by Takeru Chuganji on 2/21/16.
//
//

#include "Image.hpp"
#include "ColorSpace.hpp"
#include "DataProvider.hpp"

using namespace CG;

Image::Image(size_t width, size_t height,
             size_t bitsPerComponent, size_t bitsPerPixel, size_t bytesPerRow,
             const ColorSpace &space, CGBitmapInfo bitmapInfo,
             const DataProvider &provider,
             const CGFloat *decode, bool shouldInterpolate,
             CGColorRenderingIntent intent)
: _ref(CGImageCreate(width, height,
                     bitsPerComponent, bitsPerPixel, bytesPerRow,
                     space, bitmapInfo,
                     provider,
                     decode, shouldInterpolate,
                     intent)) {
}

Image::~Image()
{
    if (this->_ref) {
        CGImageRelease(this->_ref);
        this->_ref = nullptr;
    }
}

Image::operator CGImageRef() const
{
    return this->_ref;
}
