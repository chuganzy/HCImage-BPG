//
// Created by Takeru Chuganji on 12/21/14.
// Copyright (c) 2014 Takeru Chuganji. All rights reserved.
//

#import "HCImage.h"
#import "HCAttributes.h"

@interface HCImage (BPG)
+ (HCImage * HC_NULLABLE)imageWithBPGData:(NSData * HC_NONNULL)data;
@end
