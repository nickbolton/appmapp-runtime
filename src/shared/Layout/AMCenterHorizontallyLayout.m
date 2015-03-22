//
//  AMCenterHorizontallyLayout.m
//  AppMap
//
//  Created by Nick Bolton on 3/21/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMCenterHorizontallyLayout.h"

@implementation AMCenterHorizontallyLayout

- (NSLayoutConstraint *)buildConstraintWithMultiplier:(CGFloat)multiplier {

    return
    [NSLayoutConstraint
     constraintWithItem:self.view
     attribute:NSLayoutAttributeCenterX
     relatedBy:NSLayoutRelationEqual
     toItem:self.view.superview
     attribute:NSLayoutAttributeCenterX
     multiplier:1.0f
     constant:0.0f];
}

@end
