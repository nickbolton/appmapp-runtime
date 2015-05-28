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
    
    CGFloat leftSpace = self.proportionalValue * CGRectGetWidth(parentFrame);
    
    if (animated) {
        self.constraint.animator.constant = leftSpace;
    } else {
        self.constraint.constant = leftSpace;
    }

    [self applyConstraintIfNecessary];
}

- (void)updateProportionalValueFromFrame:(CGRect)frame parentFrame:(CGRect)parentFrame {
    self.proportionalValue = CGRectGetMinX(frame) / CGRectGetWidth(parentFrame);
}

- (CGRect)adjustedFrame:(CGRect)frame
           forComponent:(AMComponent *)component
                  scale:(CGFloat)scale {
    
    if (component.parentComponent != nil) {
    
        CGRect result = frame;
        result.origin.x = self.proportionalValue * CGRectGetWidth(component.parentComponent.frame);
        
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
