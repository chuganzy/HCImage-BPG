//
// Created by Takeru Chuganji on 12/21/14.
// Copyright (c) 2014 Takeru Chuganji. All rights reserved.
//

#include "DataProvider.hpp"

using namespace CG;

DataProvider::DataProvider(void *info, const void *data, size_t size,
                           CGDataProviderReleaseDataCallback releaseData)
: _ref(CGDataProviderCreateWithData(info, data, size, releaseData))
{
}

DataProvider::~DataProvider()
{
    if (this->_ref) {
        CGDataProviderRelease(this->_ref);
        this->_ref = nullptr;
    }
}

DataProvider::operator CGDataProviderRef() const
{
    return this->_ref;
}
