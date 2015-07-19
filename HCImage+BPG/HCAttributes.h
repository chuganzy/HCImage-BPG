//
// Created by Takeru Chuganji on 7/19/15.
// Copyright (c) 2014 Takeru Chuganji. All rights reserved.
//

#ifndef _HCAttributes_h
#define _HCAttributes_h

#if __has_feature(nullability)
    #define HC_NULLABLE __nullable
    #define HC_NONNULL __nonnull
#else
    #define HC_NULLABLE
    #define HC_NONNULL
#endif

#endif /* _HCAttributes_h */
