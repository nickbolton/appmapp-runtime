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

- (void)applyConstraint {
    [self.view addConstraint:self.constraint];
}

@end
