//
//  AMPositionLayout.h
//  AppMap
//
//  Created by Nick Bolton on 12/28/14.
//  Copyright (c) 2014 Pixelbleed LLC. All rights reserved.
//

#import "AMLayout.h"

@class AMAnchoredTopLayout;
@class AMAnchoredLeftLayout;
@class AMFixedWidthLayout;
@class AMFixedHeightLayout;

@interface AMPositionLayout : AMLayout

@property (nonatomic, readonly) AMAnchoredTopLayout *topLayout;
@property (nonatomic, readonly) AMAnchoredLeftLayout *leftLayout;
@property (nonatomic, readonly) AMFixedWidthLayout *widthLayout;
@property (nonatomic, readonly) AMFixedHeightLayout *heightLayout;

@end
