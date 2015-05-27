//
//  AMAnchoredLeftLayout.m
//  AppMap
//
//  Created by Nick Bolton on 12/28/14.
//  Copyright (c) 2014 Pixelbleed LLC. All rights reserved.
//

#import "AMAnchoredLeftLayout.h"

@interface AMAnchoredLeftLayout()

@end

@implementation AMAnchoredLeftLayout

- (AMLayoutType)layoutType {
    return AMLayoutTypeAnchoredLeft;
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
        self.constraint.animator.constant = CGRectGetMinX(frame);
    } else {
        self.constraint.constant = CGRectGetMinX(frame);
    }

    [self applyConstraintIfNecessary];
}

- (CGRect)adjustedComponentFrame:(CGRect)frame
            parentComponentFrame:(CGRect)parentFrame
                           scale:(CGFloat)scale {

    scale = MAX(scale, 1.0f);

    CGRect result = frame;
    result.origin.x = self.constraint.constant/scale;
    return result;
}

@end
