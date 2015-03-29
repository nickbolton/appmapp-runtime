//
//  AMCenterVerticallyLayout.m
//  AppMap
//
//  Created by Nick Bolton on 3/21/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMCenterVerticallyLayout.h"

@implementation AMCenterVerticallyLayout

- (AMLayoutType)layoutType {
    return AMLayoutTypeCenterVertically;
}

- (NSLayoutConstraint *)buildConstraintWithMultiplier:(CGFloat)multiplier {

    return
    [NSLayoutConstraint
     constraintWithItem:self.view
     attribute:NSLayoutAttributeCenterY
     relatedBy:NSLayoutRelationEqual
     toItem:self.view.superview
     attribute:NSLayoutAttributeCenterY
     multiplier:1.0f
     constant:0.0f];
}

- (void)updateLayoutWithFrame:(CGRect)frame
                   multiplier:(CGFloat)multiplier
                     priority:(AMLayoutPriority)priority
                  parentFrame:(CGRect)parentFrame
                       inView:(AMView *)view {
    
    [super updateLayoutWithFrame:frame multiplier:multiplier priority:priority parentFrame:parentFrame inView:view];
    [self applyConstraintIfNecessary];
}

@end
