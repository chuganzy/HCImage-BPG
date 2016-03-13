//
// Created by Takeru Chuganji on 12/21/14.
// Copyright (c) 2014 Takeru Chuganji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCImage.h"
#import "HCAttributes.h"

FOUNDATION_EXPORT const double HCImageBPGVersionNumber;
FOUNDATION_EXPORT const unsigned char HCImageBPGVersionString[];

@interface HCImage (BPG)
+ (HCImage * HC_NULLABLE)imageWithBPGData:(NSData * HC_NONNULL)data;
@end
