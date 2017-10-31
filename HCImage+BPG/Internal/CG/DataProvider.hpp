//
// Created by Takeru Chuganji on 12/21/14.
// Copyright (c) 2014 Takeru Chuganji. All rights reserved.
//

#ifndef CG_DataProvider_hpp
#define CG_DataProvider_hpp

#include <CoreGraphics/CGDataProvider.h>

namespace CG
{
    class DataProvider
    {
    public:
        DataProvider(void *info, const void *data, size_t size,
                     CGDataProviderReleaseDataCallback releaseData);
        ~DataProvider();
        
        operator CGDataProviderRef() const;
        
    private:
        CGDataProviderRef _ref;
    };
}

#endif /* CG_DataProvider_hpp */
