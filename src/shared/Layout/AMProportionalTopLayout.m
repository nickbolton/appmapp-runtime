//
//  AMProportionalTopLayout.m
//  AppMap
//
//  Created by Nick Bolton on 3/28/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMProportionalTopLayout.h"

@implementation AMProportionalTopLayout

- (AMLayoutType)layoutType {
    return AMLayoutTypeProportionalTop;
}

- (NSLayoutConstraint *)buildConstraintWithMultiplier:(CGFloat)multiplier {
    
    return
    [NSLayoutConstraint
     constraintWithItem:self.view
     attribute:NSLayoutAttributeTop
     relatedBy:NSLayoutRelationEqual
     toItem:self.view.superview
     attribute:NSLayoutAttributeTop
     multiplier:multiplier
     constant:0.0f];
}

- (void)updateLayoutWithFrame:(CGRect)frame
                   multiplier:(CGFloat)multiplier
                     priority:(AMLayoutPriority)priority
                  parentFrame:(CGRect)parentFrame
                       inView:(AMView *)view {
    
    [super updateLayoutWithFrame:frame multiplier:multiplier priority:priority parentFrame:parentFrame inView:view];
    
    CGFloat topSpace = self.proportionalValue * CGRectGetHeight(parentFrame);
    self.constraint.constant = topSpace;
    [self applyConstraintIfNecessary];
}

- (void)updateProportionalValueFromFrame:(CGRect)frame parentFrame:(CGRect)parentFrame {
    self.proportionalValue = CGRectGetMinY(frame) / CGRectGetHeight(parentFrame);
}

@end
