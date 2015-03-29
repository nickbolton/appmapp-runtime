//
//  AMProportionalRightLayout.m
//  AppMap
//
//  Created by Nick Bolton on 3/28/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMProportionalRightLayout.h"

@implementation AMProportionalRightLayout

- (AMLayoutType)layoutType {
    return AMLayoutTypeProportionalRight;
}

- (NSLayoutConstraint *)buildConstraintWithMultiplier:(CGFloat)multiplier {
    
    return
    [NSLayoutConstraint
     constraintWithItem:self.view
     attribute:NSLayoutAttributeRight
     relatedBy:NSLayoutRelationEqual
     toItem:self.view.superview
     attribute:NSLayoutAttributeRight
     multiplier:multiplier
     constant:0.0f];
}

- (void)updateLayoutWithFrame:(CGRect)frame
                   multiplier:(CGFloat)multiplier
                     priority:(AMLayoutPriority)priority
                  parentFrame:(CGRect)parentFrame
                       inView:(NSView *)view {

    [super updateLayoutWithFrame:frame multiplier:multiplier priority:priority parentFrame:parentFrame inView:view];
    
    CGFloat rightSpace = self.proportionalValue * CGRectGetWidth(parentFrame);
    self.constraint.constant = -rightSpace;
}

- (void)updateProportionalValueFromFrame:(CGRect)frame parentFrame:(CGRect)parentFrame {
    self.proportionalValue = (CGRectGetWidth(parentFrame) - CGRectGetMaxX(frame)) / CGRectGetWidth(parentFrame);
}

@end
