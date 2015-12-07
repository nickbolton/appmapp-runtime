//
//  AMParentLayout.m
//  AppMap
//
//  Created by Nick Bolton on 3/22/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMParentLayout.h"

@implementation AMParentLayout

- (void)clearLayout {
    [self.view.superview removeConstraint:self.constraint];
    [super clearLayout];
}

- (void)applyConstraintIfNecessary {
    
    if (self.layoutApplied == NO && self.constraint != nil) {
        [self clearPreviousConstraint];
        [self.view.superview addConstraint:self.constraint];
        self.layoutApplied = YES;
    }
}

- (void)clearPreviousConstraint {
    for (NSLayoutConstraint *constraint in self.view.superview.constraints.copy) {
        if (constraint.firstItem == self.constraint.firstItem &&
            constraint.firstAttribute == self.constraint.firstAttribute &&
            constraint.secondItem == self.constraint.secondItem &&
            constraint.secondAttribute == self.constraint.secondAttribute) {
            [self.view.superview removeConstraint:constraint];
        }
    }
}

//- (void)applyConstraint {
//    [self.view.superview addConstraint:self.constraint];
//}

@end
