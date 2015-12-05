//
//  AMFixedHeightLayout.m
//  AppMap
//
//  Created by Nick Bolton on 3/22/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMFixedHeightLayout.h"

@implementation AMFixedHeightLayout

- (AMLayoutType)layoutType {
    return AMLayoutTypeFixedHeight;
}

- (NSLayoutConstraint *)buildConstraintWithMultiplier:(CGFloat)multiplier {

    return
    [NSLayoutConstraint
     constraintWithItem:self.view
     attribute:NSLayoutAttributeHeight
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
        self.constraint.animator.constant = CGRectGetHeight(frame);
    } else {
        self.constraint.constant = CGRectGetHeight(frame);
    }

    [self applyConstraintIfNecessary];
}

- (CGRect)adjustedFrame:(CGRect)frame
           forComponent:(AMComponent *)component
           maintainSize:(BOOL)maintainSize
                  scale:(CGFloat)scale {

    if (maintainSize == NO && component.parentComponent != nil && scale > 0.0f) {
        CGRect result = frame;
        result.size.height = self.constraint.constant/scale;
        return result;
    }
    
    return frame;
}

@end
