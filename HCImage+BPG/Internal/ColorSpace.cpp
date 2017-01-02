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
    return CGColorSpaceCreateDeviceRGB();
}

ColorSpace::ColorSpace(CGColorSpaceRef ref)
: _ref(ref)
{
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
