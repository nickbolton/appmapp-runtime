//
//  AMExpandingLayout.m
//  AppMap
//
//  Created by Nick Bolton on 1/1/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMExpandingLayout.h"

@interface AMExpandingLayout()

@property (nonatomic, strong) NSArray *constraints;

@end

@implementation AMExpandingLayout

- (void)clearLayout {
    [super clearLayout];
    
    [self.view.superview removeConstraints:self.constraints];
    self.constraints = nil;
}

- (void)createConstraintsIfNecessary {
    [super createConstraintsIfNecessary];
    
    if (self.constraints == nil && self.view.superview != nil) {
        
        self.constraints =
        [NSLayoutConstraint expandToSuperview:self.view];
    }
}

- (void)updateLayoutWithFrame:(CGRect)frame {
    [super updateLayoutWithFrame:frame];    
    [self createConstraintsIfNecessary];
}

@end
