//
//  AMAnchoredBottomLayout.m
//  AppMap
//
//  Created by Nick Bolton on 12/28/14.
//  Copyright (c) 2014 Pixelbleed LLC. All rights reserved.
//

#import "AMAnchoredBottomLayout.h"

@interface AMAnchoredBottomLayout()

@end

@implementation AMAnchoredBottomLayout

- (AMLayoutType)layoutType {
    return AMLayoutTypeAnchoredBottom;
}

- (NSLayoutConstraint *)buildConstraintWithMultiplier:(CGFloat)multiplier {

    return
    [NSLayoutConstraint
     constraintWithItem:self.view
     attribute:NSLayoutAttributeBottom
     relatedBy:NSLayoutRelationEqual
     toItem:self.view.superview
     attribute:NSLayoutAttributeBottom
     multiplier:multiplier
     constant:0.0f];
}

- (void)updateLayoutWithFrame:(CGRect)frame
                   multiplier:(CGFloat)multiplier
                     priority:(AMLayoutPriority)priority
                  parentFrame:(CGRect)parentFrame
                       inView:(AMView *)view {
    [super updateLayoutWithFrame:frame multiplier:multiplier priority:priority parentFrame:parentFrame inView:view];
    CGFloat bottomDistance = CGRectGetHeight(parentFrame) - CGRectGetMaxY(frame);
    self.constraint.constant = -bottomDistance;
    [self applyConstraintIfNecessary];
}

@end
