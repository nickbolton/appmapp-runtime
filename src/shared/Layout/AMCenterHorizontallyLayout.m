//
//  AMCenterHorizontallyLayout.m
//  AppMap
//
//  Created by Nick Bolton on 3/21/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMCenterHorizontallyLayout.h"

@implementation AMCenterHorizontallyLayout

- (AMLayoutType)layoutType {
    return AMLayoutTypeCenterHorizontally;
}

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

- (void)updateLayoutWithFrame:(CGRect)frame
                   multiplier:(CGFloat)multiplier
                     priority:(AMLayoutPriority)priority
                  parentFrame:(CGRect)parentFrame
             allLayoutObjects:(NSArray *)allLayoutObjects
                       inView:(AMView *)view
                     animated:(BOOL)animated {

    [super
     updateLayoutWithFrame:frame
     multiplier:multiplier
     priority:priority
     parentFrame:parentFrame
     allLayoutObjects:allLayoutObjects
     inView:view
     animated:animated];
    
    CGFloat constant = CGRectGetMidX(frame) - (CGRectGetWidth(parentFrame) / 2.0f);
    
    if (animated) {
        self.constraint.animator.constant = constant;
    } else {
        self.constraint.constant = constant;
    }

    [self applyConstraintIfNecessary];
}

- (CGRect)adjustedFrame:(CGRect)frame parentFrame:(CGRect)parentFrame {
    
    CGRect result = frame;
    result.origin.x = (CGRectGetWidth(parentFrame)/2.0f) - (CGRectGetWidth(frame)/2.0f) + self.constraint.constant;
    return result;
}

@end
