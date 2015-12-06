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
    self.proportionalValue = CGRectGetMinY(frame) / CGRectGetHeight(parentFrame);
}

- (CGRect)adjustedFrame:(CGRect)frame
           forComponent:(AMComponentInstance *)component
           maintainSize:(BOOL)maintainSize
                  scale:(CGFloat)scale {
    
    if (component.parentComponent != nil) {
        
        CGRect parentFrame = component.parentComponent.frame;
    
        CGRect result = frame;
        result.origin.y = self.proportionalValue * CGRectGetHeight(parentFrame);
        
#if TARGET_OS_IPHONE
        [self.view setNeedsUpdateConstraints];
#else
        [self.view setNeedsUpdateConstraints:YES];
#endif
        
        return result;
    }
    
    return frame;
}

@end
