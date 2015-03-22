//
//  AMAnchoredRightLayout.m
//  AppMap
//
//  Created by Nick Bolton on 12/28/14.
//  Copyright (c) 2014 Pixelbleed LLC. All rights reserved.
//

#import "AMAnchoredRightLayout.h"

@interface AMAnchoredRightLayout()

@end

@implementation AMAnchoredRightLayout

- (NSLayoutConstraint *)buildConstraintWithMultiplier:(CGFloat)multiplier {
    
    return
    [NSLayoutConstraint
     constraintWithItem:self.view
     attribute:NSLayoutAttributeRight
     relatedBy:NSLayoutRelationEqual
     toItem:self.view.superview
     attribute:NSLayoutAttributeRight
     multiplier:1.0f
     constant:0.0f];
}

- (void)updateLayoutWithFrame:(CGRect)frame
                   multiplier:(CGFloat)multiplier
                     priority:(AMLayoutPriority)priority
                  parentFrame:(CGRect)parentFrame {
    [super updateLayoutWithFrame:frame multiplier:multiplier priority:priority parentFrame:parentFrame];
    CGFloat rightDistance = CGRectGetWidth(parentFrame) - CGRectGetMaxX(frame);
    self.constraint.constant = -rightDistance;
}

@end
