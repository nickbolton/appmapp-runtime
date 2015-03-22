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
                  parentFrame:(CGRect)parentFrame {
    [super updateLayoutWithFrame:frame multiplier:multiplier priority:priority parentFrame:parentFrame];
    CGFloat bottomDistance = CGRectGetHeight(parentFrame) - CGRectGetMaxY(frame);
    self.constraint.constant = -bottomDistance;
}

@end
