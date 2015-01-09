//
//  AMPositionLayout.m
//  AppMap
//
//  Created by Nick Bolton on 12/28/14.
//  Copyright (c) 2014 Pixelbleed LLC. All rights reserved.
//

#import "AMPositionLayout.h"

@interface AMPositionLayout()

@property (nonatomic, readwrite) NSLayoutConstraint *leftSpace;
@property (nonatomic, readwrite) NSLayoutConstraint *topSpace;
@property (nonatomic, readwrite) NSLayoutConstraint *width;
@property (nonatomic, readwrite) NSLayoutConstraint *height;

@end

@implementation AMPositionLayout

- (void)clearLayout {
    [super clearLayout];
    
    [self.view.superview removeConstraint:self.leftSpace];
    [self.view.superview removeConstraint:self.topSpace];
    [self.view removeConstraint:self.width];
    [self.view removeConstraint:self.height];
    
    self.leftSpace = nil;
    self.topSpace = nil;
    self.width = nil;
    self.height = nil;
}

- (void)createConstraintsIfNecessary {
    [super createConstraintsIfNecessary];
    
    if (self.leftSpace == nil && self.view.superview != nil) {
        self.leftSpace = [NSLayoutConstraint alignToLeft:self.view withPadding:0.0f];
    }
    
    if (self.topSpace == nil && self.view.superview != nil) {
        self.topSpace = [NSLayoutConstraint alignToTop:self.view withPadding:0.0f];
    }
    
    if (self.width == nil) {
        self.width = [NSLayoutConstraint addWidthConstraint:0.0f toView:self.view];
    }
    
    if (self.height == nil) {
        self.height = [NSLayoutConstraint addHeightConstraint:0.0f toView:self.view];
    }
}

- (void)updateLayoutWithFrame:(CGRect)frame {
    [super updateLayoutWithFrame:frame];
    
    [self createConstraintsIfNecessary];

    self.leftSpace.constant = CGRectGetMinX(frame);
    self.topSpace.constant = CGRectGetMinY(frame);
    self.width.constant = CGRectGetWidth(frame);
    self.height.constant = CGRectGetHeight(frame);
}

@end
