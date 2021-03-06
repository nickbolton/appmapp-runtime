//
//  AMProportionalBottomLayout.m
//  AppMap
//
//  Created by Nick Bolton on 3/28/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMProportionalBottomLayout.h"

@implementation AMProportionalBottomLayout

- (AMLayoutType)layoutType {
    return AMLayoutTypeProportionalBottom;
}

- (NSLayoutConstraint *)buildConstraintWithMultiplier:(CGFloat)multiplier {
    
    return
    [NSLayoutConstraint
     constraintWithItem:self.view
     attribute:NSLayoutAttributeBottom
     relatedBy:self.layoutRelation
     toItem:self.view.superview
     attribute:NSLayoutAttributeBottom
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
    
    CGFloat bottomSpace = self.proportionalValue * CGRectGetHeight(parentFrame);
    
    if (animated) {
        self.constraint.animator.constant = -bottomSpace;
    } else {
        self.constraint.constant = -bottomSpace;
    }

    [self applyConstraintIfNecessary];
}

- (void)updateProportionalValueFromFrame:(CGRect)frame parentFrame:(CGRect)parentFrame {
    self.proportionalValue = (CGRectGetHeight(parentFrame) - CGRectGetMaxY(frame)) / CGRectGetHeight(parentFrame);
}

- (CGRect)adjustedFrame:(CGRect)frame
           forComponent:(AMComponent *)component
           maintainSize:(BOOL)maintainSize
                  scale:(CGFloat)scale {
    
    if (component.parentComponent != nil) {
        
        CGRect parentFrame = component.parentComponent.frame;
        
        CGRect result = frame;
        result.origin.y = CGRectGetHeight(parentFrame) - CGRectGetHeight(frame) - (self.proportionalValue * CGRectGetHeight(parentFrame));
        
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
