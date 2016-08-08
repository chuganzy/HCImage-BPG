//
// Created by Takeru Chuganji on 12/21/14.
// Copyright (c) 2014 Takeru Chuganji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCImage.h"
#import "HCAttributes.h"

FOUNDATION_EXPORT const double HCImageBPGVersionNumber;
FOUNDATION_EXPORT const unsigned char HCImageBPGVersionString[];

NS_ASSUME_NONNULL_BEGIN
@interface HCImage (BPG)
+ (HCImage * __nullable)imageWithBPGData:(NSData *)data;
@end
NS_ASSUME_NONNULL_END
