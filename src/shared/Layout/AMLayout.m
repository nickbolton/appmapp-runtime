//
//  AMLayout.m
//  AppMap
//
//  Created by Nick Bolton on 12/28/14.
//  Copyright (c) 2014 Pixelbleed LLC. All rights reserved.
//

#import "AMLayout.h"

@implementation AMLayout

- (void)clearLayout {
    self.constraint = nil;
}

- (void)updateLayoutWithFrame:(CGRect)frame
                   multiplier:(CGFloat)multiplier
                     priority:(NSLayoutPriority)priority
                  parentFrame:(CGRect)parentFrame {
    [self createConstraintsIfNecessaryWithMultiplier:multiplier priority:priority];
}

- (void)createConstraintsIfNecessaryWithMultiplier:(CGFloat)multiplier
                                          priority:(NSLayoutPriority)priority {

    if (self.view != nil &&
        (self.constraint == nil ||
         self.constraint.multiplier != multiplier ||
         self.constraint.priority != priority)) {
        
        [self clearLayout];
        self.constraint = [self buildConstraintWithMultiplier:multiplier];
        self.constraint.priority = priority;
        [self applyConstraint];
    }
}

- (void)applyConstraint {
    [self doesNotRecognizeSelector:_cmd];
}

- (NSLayoutConstraint *)buildConstraintWithMultiplier:(CGFloat)multiplier {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
