//
//  HCImage.h
//  ImageBPG
//
//  Created by Takeru Chuganji on 2/24/16.
//  Copyright © 2016 Takeru Chuganji. All rights reserved.
//

#ifndef HCImage_h
#define HCImage_h

#include <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#include <UIKit/UIKit.h>
#define HCImage UIImage
#else
#include <Cocoa/Cocoa.h>
#define HCImage NSImage
#endif

#endif /* HCImage_h */
