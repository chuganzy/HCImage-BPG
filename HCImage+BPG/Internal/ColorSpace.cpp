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
    if (_ref) {
        CGColorSpaceRelease(_ref);
        _ref = nullptr;
    }
}

ColorSpace::operator CGColorSpaceRef() const
{
    return _ref;
}
