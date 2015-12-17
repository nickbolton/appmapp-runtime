//
//  AMTopLayout.m
//  AppMap
//
//  Created by Nick Bolton on 12/28/14.
//  Copyright (c) 2014 Pixelbleed LLC. All rights reserved.
//

#import "AMTopLayout.h"

@interface AMTopLayout()

@end

@implementation AMTopLayout

- (AMLayoutType)layoutType {
    return AMLayoutTypeTop;
}

- (NSLayoutConstraint *)buildConstraintWithMultiplier:(CGFloat)multiplier {

    return
    [NSLayoutConstraint
     constraintWithItem:self.view
     attribute:NSLayoutAttributeTop
     relatedBy:self.layoutRelation
     toItem:self.view.superview
     attribute:NSLayoutAttributeTop
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
        self.constraint.animator.constant = CGRectGetMinY(frame);
    } else {
        self.constraint.constant = CGRectGetMinY(frame);
    }

    [self applyConstraintIfNecessary];
}

- (CGRect)adjustedFrame:(CGRect)frame
           forComponent:(AMComponent *)component
           maintainSize:(BOOL)maintainSize
                  scale:(CGFloat)scale {
    
    if (component.parentComponent != nil && scale > 0.0f) {
        
        CGRect result = frame;
        result.origin.y = self.constraint.constant/scale;
        return result;
    }
    
    return frame;
}

@end
