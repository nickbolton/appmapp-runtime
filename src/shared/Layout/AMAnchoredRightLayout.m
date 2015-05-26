//
//  AMAnchoredRightLayout.m
//  AppMap
//
//  Created by Nick Bolton on 12/28/14.
//  Copyright (c) 2014 Pixelbleed LLC. All rights reserved.
//

#import "AMAnchoredRightLayout.h"
#import "AMAnchoredLeftLayout.h"

@interface AMAnchoredRightLayout()

@property (nonatomic) CGFloat originalConstant;
@property (nonatomic) CGFloat reduceThresholdWidth;

@end

@implementation AMAnchoredRightLayout

- (AMLayoutType)layoutType {
    return AMLayoutTypeAnchoredRight;
}

- (NSLayoutConstraint *)buildConstraintWithMultiplier:(CGFloat)multiplier {
    
    return
    [NSLayoutConstraint
     constraintWithItem:self.view
     attribute:NSLayoutAttributeRight
     relatedBy:NSLayoutRelationEqual
     toItem:self.view.superview
     attribute:NSLayoutAttributeRight
     multiplier:1.0f
     constant:0.0f];
}

- (void)updateLayoutWithFrame:(CGRect)frame
                   multiplier:(CGFloat)multiplier
                     priority:(AMLayoutPriority)priority
                  parentFrame:(CGRect)parentFrame
             allLayoutObjects:(NSArray *)allLayoutObjects
                       inView:(AMView *)view {
    [super
     updateLayoutWithFrame:frame
     multiplier:multiplier
     priority:priority
     parentFrame:parentFrame
     allLayoutObjects:allLayoutObjects
     inView:view];
    
    CGFloat rightDistance = CGRectGetWidth(parentFrame) - CGRectGetMaxX(frame);

    self.originalConstant = -rightDistance;
    self.constraint.constant = self.originalConstant;
    [self applyConstraintIfNecessary];
    
    CGFloat leftSpace = [self leftConstraintConstant:allLayoutObjects];
    self.reduceThresholdWidth = leftSpace + rightDistance;
}

- (CGFloat)leftConstraintConstant:(NSArray *)allLayoutObjects {
    
    CGFloat leftSpace = -MAXFLOAT;
    
    for (AMLayout *layout in allLayoutObjects) {
        if ([layout isKindOfClass:[AMAnchoredLeftLayout class]]) {
            if (layout.constraint.isActive) {
                leftSpace = layout.constraint.constant;
            }
        }
    }

    return leftSpace;
}

- (void)adjustLayoutFromParentFrameChange:(CGRect)frame
                               multiplier:(CGFloat)multiplier
                                 priority:(AMLayoutPriority)priority
                              parentFrame:(CGRect)parentFrame
                         allLayoutObjects:(NSArray *)allLayoutObjects
                                   inView:(AMView *)view {
    
    CGFloat leftSpace = [self leftConstraintConstant:allLayoutObjects];
    
    if (leftSpace > -MAXFLOAT) {
        
        CGFloat rightDistance = -self.constraint.constant;
        
        CGFloat minWidth = leftSpace + rightDistance;
        minWidth = MAX(minWidth, self.reduceThresholdWidth);
        
        if (CGRectGetWidth(parentFrame) < minWidth) {
            rightDistance = CGRectGetWidth(parentFrame) - leftSpace;
            
            self.constraint.constant = -rightDistance;
            [self applyConstraintIfNecessary];
        }
    }
}

@end
