//
//  AMAnchoredTopLayout.m
//  AppMap
//
//  Created by Nick Bolton on 12/28/14.
//  Copyright (c) 2014 Pixelbleed LLC. All rights reserved.
//

#import "AMAnchoredTopLayout.h"

@interface AMAnchoredTopLayout()

@end

@implementation AMAnchoredTopLayout

- (AMLayoutType)layoutType {
    return AMLayoutTypeAnchoredTop;
}

- (NSLayoutConstraint *)buildConstraintWithMultiplier:(CGFloat)multiplier {

    return
    [NSLayoutConstraint
     constraintWithItem:self.view
     attribute:NSLayoutAttributeTop
     relatedBy:NSLayoutRelationEqual
     toItem:self.view.superview
     attribute:NSLayoutAttributeTop
     multiplier:1.0f
     constant:0.0f];
}

- (void)updateLayoutWithFrame:(CGRect)frame
                   multiplier:(CGFloat)multiplier
                     priority:(AMLayoutPriority)priority
                  parentFrame:(CGRect)parentFrame
                       inView:(AMView *)view {
    
    [super updateLayoutWithFrame:frame multiplier:multiplier priority:priority parentFrame:parentFrame inView:view];
    self.constraint.constant = CGRectGetMinY(frame);
    [self applyConstraintIfNecessary];
}

@end
