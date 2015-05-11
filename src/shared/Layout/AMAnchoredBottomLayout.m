//
//  AMAnchoredBottomLayout.m
//  AppMap
//
//  Created by Nick Bolton on 12/28/14.
//  Copyright (c) 2014 Pixelbleed LLC. All rights reserved.
//

#import "AMAnchoredBottomLayout.h"
#import "AMAnchoredTopLayout.h"

@interface AMAnchoredBottomLayout()

@property (nonatomic) CGFloat originalConstant;
@property (nonatomic) CGFloat reduceThresholdHeight;

@end

@implementation AMAnchoredBottomLayout

- (AMLayoutType)layoutType {
    return AMLayoutTypeAnchoredBottom;
}

- (NSLayoutConstraint *)buildConstraintWithMultiplier:(CGFloat)multiplier {

    return
    [NSLayoutConstraint
     constraintWithItem:self.view
     attribute:NSLayoutAttributeBottom
     relatedBy:NSLayoutRelationEqual
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
                       inView:(AMView *)view {
    [super
     updateLayoutWithFrame:frame
     multiplier:multiplier
     priority:priority
     parentFrame:parentFrame
     allLayoutObjects:allLayoutObjects
     inView:view];
    
    CGFloat bottomDistance = CGRectGetHeight(parentFrame) - CGRectGetMaxY(frame);
    
    self.originalConstant = -bottomDistance;
    self.constraint.constant = self.originalConstant;
    [self applyConstraintIfNecessary];
    
    CGFloat topSpace = [self topConstraintConstant:allLayoutObjects];
    self.reduceThresholdHeight = topSpace + bottomDistance;
}

- (CGFloat)topConstraintConstant:(NSArray *)allLayoutObjects {
    
    CGFloat topSpace = -MAXFLOAT;
    
    for (AMLayout *layout in allLayoutObjects) {
        if ([layout isKindOfClass:[AMAnchoredTopLayout class]]) {
            if (layout.constraint.isActive) {
                topSpace = layout.constraint.constant;
            }
        }
    }
    
    return topSpace;
}

- (void)adjustLayoutFromParentFrameChange:(CGRect)frame
                               multiplier:(CGFloat)multiplier
                                 priority:(AMLayoutPriority)priority
                              parentFrame:(CGRect)parentFrame
                         allLayoutObjects:(NSArray *)allLayoutObjects
                                   inView:(AMView *)view {
    
    CGFloat topSpace = [self topConstraintConstant:allLayoutObjects];
    
    if (topSpace > -MAXFLOAT) {
        
        CGFloat bottomDistance = -self.constraint.constant;
        
        CGFloat minHeight = topSpace + bottomDistance;
        minHeight = MAX(minHeight, self.reduceThresholdHeight);
        
        if (CGRectGetHeight(parentFrame) < minHeight) {
            bottomDistance = CGRectGetHeight(parentFrame) - topSpace;
            
            self.constraint.constant = -bottomDistance;
            [self applyConstraintIfNecessary];
        }
    }
}

- (CGRect)applyConstraintToFrame:(CGRect)sourceFrame withComponent:(AMComponent *)component {

    CGRect parentFrame = component.parentComponent.frame;

    CGFloat bottomDistance = CGRectGetHeight(parentFrame) - CGRectGetMaxY(component.frame);
    
    CGRect frame = sourceFrame;
    frame.size.height = CGRectGet - bottomDistance;
    return frame;
}

@end
