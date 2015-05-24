//
//  AMProportionalHorizontalCenterLayout.m
//  AppMap
//
//  Created by Nick Bolton on 5/24/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMProportionalHorizontalCenterLayout.h"

@implementation AMProportionalHorizontalCenterLayout

- (AMLayoutType)layoutType {
    return AMLayoutTypeProportionalHorizontalCenter;
}

- (NSLayoutConstraint *)buildConstraintWithMultiplier:(CGFloat)multiplier {
    
    return
    [NSLayoutConstraint
     constraintWithItem:self.view
     attribute:NSLayoutAttributeCenterX
     relatedBy:NSLayoutRelationEqual
     toItem:self.view.superview
     attribute:NSLayoutAttributeLeft
     multiplier:multiplier
     constant:0.0f];
}

- (void)updateLayoutWithFrame:(CGRect)frame
                   multiplier:(CGFloat)multiplier
                     priority:(AMLayoutPriority)priority
                  parentFrame:(CGRect)parentFrame
             allLayoutObjects:(NSArray *)allLayoutObjects
                       inView:(AMView *)view {
    [super
     updateLayoutWithFrame:frame
     multiplier:multiplier
     priority:priority
     parentFrame:parentFrame
     allLayoutObjects:allLayoutObjects
     inView:view];
    
    CGFloat leftSpace = self.proportionalValue * CGRectGetWidth(parentFrame);
    self.constraint.constant = leftSpace;
    [self applyConstraintIfNecessary];
}

- (void)updateProportionalValueFromFrame:(CGRect)frame parentFrame:(CGRect)parentFrame {
    self.proportionalValue = CGRectGetMidX(frame) / CGRectGetWidth(parentFrame);
}

@end