//
//  ColorSpace.cpp
//  Pods
//
//  Created by Takeru Chuganji on 2/21/16.
//
//

#include "ColorSpace.hpp"

using namespace CG;

ColorSpace ColorSpace::CreateDeviceRGB()
{
    CGColorSpaceRef ref = CGColorSpaceCreateDeviceRGB();
    ColorSpace space = ColorSpace(ref);
    CGColorSpaceRelease(ref);
    return space;
}

ColorSpace::ColorSpace(CGColorSpaceRef ref)
: _ref(ref)
{
    CGColorSpaceRetain(ref);
}

ColorSpace::~ColorSpace()
{
    if (this->_ref) {
        CGColorSpaceRelease(this->_ref);
        this->_ref = nullptr;
    }
}

ColorSpace::operator CGColorSpaceRef() const
{
    return this->_ref;
}
