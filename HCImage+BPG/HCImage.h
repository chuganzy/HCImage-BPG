//
// Created by Takeru Chuganji on 1/4/15.
// Copyright (c) 2014 Takeru Chuganji. All rights reserved.
//

#ifndef HCImage_h
#define HCImage_h

#if TARGET_OS_IOS

#import <UIKit/UIImage.h>
@compatibility_alias HCImage UIImage;

#else

#import <AppKit/NSImage.h>
@compatibility_alias HCImage NSImage;

#endif

#endif /* HCImage_h */
