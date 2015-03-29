//
//  AMFixedWidthLayout.m
//  AppMap
//
//  Created by Nick Bolton on 3/22/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMFixedWidthLayout.h"

@implementation AMFixedWidthLayout

- (AMLayoutType)layoutType {
    return AMLayoutTypeFixedWidth;
}

- (NSLayoutConstraint *)buildConstraintWithMultiplier:(CGFloat)multiplier {
    
    return
    [NSLayoutConstraint
     constraintWithItem:self.view
     attribute:NSLayoutAttributeWidth
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
    self.constraint.constant = CGRectGetWidth(frame);
    [self applyConstraintIfNecessary];
}

@end
