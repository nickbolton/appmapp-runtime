//
//  AMProportionalVerticalCenterLayout.m
//  AppMap
//
//  Created by Nick Bolton on 5/24/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMProportionalVerticalCenterLayout.h"

@implementation AMProportionalVerticalCenterLayout

- (AMLayoutType)layoutType {
    return AMLayoutTypeProportionalVerticalCenter;
}

- (NSLayoutConstraint *)buildConstraintWithMultiplier:(CGFloat)multiplier {
    
    return
    [NSLayoutConstraint
     constraintWithItem:self.view
     attribute:NSLayoutAttributeCenterY
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
    
    CGFloat topSpace = self.proportionalValue * CGRectGetHeight(parentFrame);
    
    if (animated) {
        self.constraint.animator.constant = topSpace;
    } else {
        self.constraint.constant = topSpace;
    }

    [self applyConstraintIfNecessary];
}

- (void)updateProportionalValueFromFrame:(CGRect)frame parentFrame:(CGRect)parentFrame {
    self.proportionalValue = CGRectGetMidY(frame) / CGRectGetHeight(parentFrame);
}

- (CGRect)adjustedFrame:(CGRect)frame parentFrame:(CGRect)parentFrame {
    
    CGRect result = frame;
    result.origin.y = self.proportionalValue * CGRectGetHeight(parentFrame) - (CGRectGetHeight(frame) / 2.0f);
    [self.view setNeedsUpdateConstraints];

    return result;
}

@end
