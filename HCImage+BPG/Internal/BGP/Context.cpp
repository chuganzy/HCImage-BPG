//
//  Context.cpp
//  HCImage+BPG
//
//  Created by Takeru Chuganji on 2017/10/22.
//  Copyright © 2017 Takeru Chuganji. All rights reserved.
//

#include "Context.hpp"

using namespace BPG;

Context::Context()
: _ref(bpg_decoder_open())
{
}

Context::~Context()
{
    if (_ref) {
        bpg_decoder_close(_ref);
    }
}

bool Context::decode(const uint8_t *buffer, int length) const
{
    return bpg_decoder_decode(_ref, buffer, length) == 0;
}

bool Context::start(BPGDecoderOutputFormat format) const
{
    return bpg_decoder_start(_ref, format) == 0;
}

bool Context::getInfo(BPGImageInfo *info) const
{
    return bpg_decoder_get_info(_ref, info) == 0;
}

void Context::getFrameDuration(int *pnum, int *pden) const
{
    bpg_decoder_get_frame_duration(_ref, pnum, pden);
}

bool Context::getLine(void *buffer) const
{
    return bpg_decoder_get_line(_ref, buffer) == 0;
}
