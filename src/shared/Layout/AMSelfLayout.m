//
//  AMSelfLayout.m
//  AppMap
//
//  Created by Nick Bolton on 3/22/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMSelfLayout.h"

@implementation AMSelfLayout

- (void)clearLayout {
    [self.view removeConstraint:self.constraint];
    [super clearLayout];
}

- (void)applyConstraintIfNecessary {
    
    if (self.layoutApplied == NO && self.constraint != nil) {
        [self clearPreviousConstraint];
        [self.view addConstraint:self.constraint];
        self.layoutApplied = YES;
    }
}

- (void)clearPreviousConstraint {
    for (NSLayoutConstraint *constraint in self.view.constraints.copy) {
        if (constraint.firstItem == self.constraint.firstItem &&
            constraint.firstAttribute == self.constraint.firstAttribute) {
            [self.view removeConstraint:constraint];
        }
    }
}

@end
