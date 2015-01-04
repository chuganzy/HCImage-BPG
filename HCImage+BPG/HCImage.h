//
// Created by Takeru Chuganji on 1/4/15.
// Copyright (c) 2014 Takeru Chuganji. All rights reserved.
//

#ifndef _HCImage_h
#define _HCImage_h

#if TARGET_OS_IPHONE
    #import <UIKit/UIKit.h>
    #define HCImage UIImage
#else
    #import <Cocoa/Cocoa.h>
    #define HCImage NSImage
#endif

#endif
