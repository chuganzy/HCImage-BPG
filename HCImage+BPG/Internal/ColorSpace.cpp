//
// Created by Takeru Chuganji on 12/21/14.
// Copyright (c) 2014 Takeru Chuganji. All rights reserved.
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
