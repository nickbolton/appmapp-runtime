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

    if (animated) {
        self.constraint.animator.constant = CGRectGetWidth(frame);
    } else {
        self.constraint.constant = CGRectGetWidth(frame);
    }

    [self applyConstraintIfNecessary];
}

- (CGRect)adjustedFrame:(CGRect)frame
           forComponent:(AMComponentElement *)component
           maintainSize:(BOOL)maintainSize
                  scale:(CGFloat)scale {
    
    if (maintainSize == NO && component.parentComponent != nil && scale > 0.0f) {
        CGRect result = frame;
        result.size.width = self.constraint.constant/scale;
        return result;
    }
    
    return frame;
}

@end
