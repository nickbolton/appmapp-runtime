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

- (void)applyConstraint {
    [self.view.superview addConstraint:self.constraint];
}

@end
