//
// Created by Takeru Chuganji on 7/19/15.
// Copyright (c) 2014 Takeru Chuganji. All rights reserved.
//

#ifndef HCAttributes_h
#define HCAttributes_h

#if !__has_feature(nullability)
    #define __nullable
    #define __nonnull
    #define NS_ASSUME_NONNULL_BEGIN
    #define NS_ASSUME_NONNULL_END
#endif

#endif /* HCAttributes_h */
