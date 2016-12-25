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

FOUNDATION_EXTERN NSString *const HCImageBPGErrorDomain;

typedef NS_ENUM(NSUInteger, HCImageBPGErrorCode) {
    HCImageBPGErrorCodeInvalidFormat,
    HCImageBPGErrorCodeOutOfMemory,
};

@interface HCImage (BPG)

+ (HCImage * __nullable)imageWithBPGData:(NSData *)data
                                   error:(NSError **)error;

@end

@interface HCImage (Deprecated)

+ (HCImage * __nullable)imageWithBPGData:(NSData *)data DEPRECATED_ATTRIBUTE;

@end

NS_ASSUME_NONNULL_END
