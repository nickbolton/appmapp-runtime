//
//  AMLayout.h
//  AppMap
//
//  Created by Nick Bolton on 12/28/14.
//  Copyright (c) 2014 Pixelbleed LLC. All rights reserved.
//
#import "AppMap.h"

@interface AMLayout : NSObject

@property (nonatomic, strong) NSLayoutConstraint *constraint;

@property (nonatomic, weak) AMView *view;

- (void)clearLayout;
- (void)updateLayoutWithFrame:(CGRect)frame
                   multiplier:(CGFloat)multiplier
                     priority:(NSLayoutPriority)priority
                  parentFrame:(CGRect)parentFrame;

- (void)applyConstraint;
- (void)createConstraintsIfNecessaryWithMultiplier:(CGFloat)multiplier
                                          priority:(NSLayoutPriority)priority;
- (NSLayoutConstraint *)buildConstraintWithMultiplier:(CGFloat)multiplier;
@end
