//
//  Context.hpp
//  HCImage+BPG
//
//  Created by Takeru Chuganji on 2017/10/22.
//  Copyright © 2017 Takeru Chuganji. All rights reserved.
//

#ifndef BPG_Context_hpp
#define BPG_Context_hpp

#include <CoreFoundation/CoreFoundation.h>

CF_EXTERN_C_BEGIN
#include "libbpg.h"
CF_EXTERN_C_END

namespace BPG {
    class Context
    {
    public:
        Context();
        ~Context();

        bool decode(const uint8_t *buffer, int length) const;
        bool start(BPGDecoderOutputFormat format) const;
        bool getInfo(BPGImageInfo *info) const;
        void getFrameDuration(int *pnum, int *pden) const;
        bool getLine(void *buffer) const;

    private:
        BPGDecoderContext *_ref;
    };
    
}

#endif /* BPG_Context_hpp */
