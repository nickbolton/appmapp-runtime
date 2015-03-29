//
//  AMProportionalLeftLayout.m
//  AppMap
//
//  Created by Nick Bolton on 3/28/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMProportionalLeftLayout.h"

@implementation AMProportionalLeftLayout

- (AMLayoutType)layoutType {
    return AMLayoutTypeProportionalLeft;
}

- (NSLayoutConstraint *)buildConstraintWithMultiplier:(CGFloat)multiplier {
    
    return
    [NSLayoutConstraint
     constraintWithItem:self.view
     attribute:NSLayoutAttributeLeft
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
                       inView:(AMView *)view {
    
    [super updateLayoutWithFrame:frame multiplier:multiplier priority:priority parentFrame:parentFrame inView:view];
    
    CGFloat leftSpace = self.proportionalValue * CGRectGetWidth(parentFrame);
    self.constraint.constant = leftSpace;
    [self applyConstraintIfNecessary];
}

- (void)updateProportionalValueFromFrame:(CGRect)frame parentFrame:(CGRect)parentFrame {
    self.proportionalValue = CGRectGetMinX(frame) / CGRectGetWidth(parentFrame);
}

@end
