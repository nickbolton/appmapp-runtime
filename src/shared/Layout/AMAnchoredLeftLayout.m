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
                     priority:(NSLayoutPriority)priority
                  parentFrame:(CGRect)parentFrame {
    [super updateLayoutWithFrame:frame multiplier:multiplier priority:priority parentFrame:parentFrame];
    self.constraint.constant = CGRectGetMinX(frame);
}

@end
