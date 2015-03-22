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
                     priority:(NSLayoutPriority)priority
                  parentFrame:(CGRect)parentFrame {
    [super updateLayoutWithFrame:frame multiplier:multiplier priority:priority parentFrame:parentFrame];
    self.constraint.constant = CGRectGetMinY(frame);
}

@end
