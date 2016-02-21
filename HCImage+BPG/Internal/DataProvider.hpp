//
//  DataProvider.hpp
//  Pods
//
//  Created by Takeru Chuganji on 2/21/16.
//
//

#ifndef DataProvider_hpp
#define DataProvider_hpp

#include <CoreGraphics/CGDataProvider.h>

namespace CG
{
    class DataProvider
    {
    public:
        DataProvider(void *, const void *, size_t,
                     CGDataProviderReleaseDataCallback);
        ~DataProvider();
        
        operator CGDataProviderRef() const;
        
    private:
        CGDataProviderRef _ref;
    };
}

#endif /* DataProvider_hpp */
