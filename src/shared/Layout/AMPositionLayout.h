//
//  AMPositionLayout.h
//  AppMap
//
//  Created by Nick Bolton on 12/28/14.
//  Copyright (c) 2014 Pixelbleed LLC. All rights reserved.
//

#import "AMLayout.h"

@interface AMPositionLayout : AMLayout

@property (nonatomic, readonly) NSLayoutConstraint *leftSpace;
@property (nonatomic, readonly) NSLayoutConstraint *topSpace;
@property (nonatomic, readonly) NSLayoutConstraint *width;
@property (nonatomic, readonly) NSLayoutConstraint *height;

@end
