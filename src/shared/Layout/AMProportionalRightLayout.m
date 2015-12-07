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
    
    CGFloat rightSpace = self.proportionalValue * CGRectGetWidth(parentFrame);
    
    if (animated) {
        self.constraint.animator.constant = -rightSpace;
    } else {
        self.constraint.constant = -rightSpace;
    }

    [self applyConstraintIfNecessary];
}

- (void)updateProportionalValueFromFrame:(CGRect)frame parentFrame:(CGRect)parentFrame {
    self.proportionalValue = (CGRectGetWidth(parentFrame) - CGRectGetMaxX(frame)) / CGRectGetWidth(parentFrame);
}

- (CGRect)adjustedFrame:(CGRect)frame
           forComponent:(AMComponentElement *)component
           maintainSize:(BOOL)maintainSize
                  scale:(CGFloat)scale {

    if (component.parentComponent != nil) {
        
        CGRect parentFrame = component.parentComponent.frame;
        
        CGRect result = frame;
        result.origin.x =
        CGRectGetWidth(parentFrame) -
        CGRectGetWidth(frame) -
        (self.proportionalValue * CGRectGetWidth(parentFrame));
        
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
