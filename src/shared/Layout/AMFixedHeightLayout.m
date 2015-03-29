//
//  AMFixedHeightLayout.m
//  AppMap
//
//  Created by Nick Bolton on 3/22/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMFixedHeightLayout.h"

@implementation AMFixedHeightLayout

- (AMLayoutType)layoutType {
    return AMLayoutTypeFixedHeight;
}

- (NSLayoutConstraint *)buildConstraintWithMultiplier:(CGFloat)multiplier {

    return
    [NSLayoutConstraint
     constraintWithItem:self.view
     attribute:NSLayoutAttributeHeight
     relatedBy:NSLayoutRelationEqual
     toItem:nil
     attribute:NSLayoutAttributeNotAnAttribute
     multiplier:1.0f
     constant:0.0f];
}

- (void)updateLayoutWithFrame:(CGRect)frame
                   multiplier:(CGFloat)multiplier
                     priority:(AMLayoutPriority)priority
                  parentFrame:(CGRect)parentFrame
                       inView:(AMView *)view {
    [super updateLayoutWithFrame:frame multiplier:multiplier priority:priority parentFrame:parentFrame inView:view];
    self.constraint.constant = CGRectGetHeight(frame);
    [self applyConstraintIfNecessary];
}

@end
