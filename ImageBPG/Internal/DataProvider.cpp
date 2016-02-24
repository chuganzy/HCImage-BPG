//
//  DataProvider.cpp
//  Pods
//
//  Created by Takeru Chuganji on 2/21/16.
//
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
    if (this->_ref != nullptr) {
        CGDataProviderRelease(this->_ref);
        this->_ref = nullptr;
    }
}

DataProvider::operator CGDataProviderRef() const
{
    return this->_ref;
}
