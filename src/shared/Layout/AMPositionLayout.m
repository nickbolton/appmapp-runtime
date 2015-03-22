//
//  AMPositionLayout.m
//  AppMap
//
//  Created by Nick Bolton on 12/28/14.
//  Copyright (c) 2014 Pixelbleed LLC. All rights reserved.
//

#import "AMPositionLayout.h"
#import "AMAnchoredLeftLayout.h"
#import "AMAnchoredTopLayout.h"
#import "AMFixedWidthLayout.h"
#import "AMFixedHeightLayout.h"

@interface AMPositionLayout()

@property (nonatomic, strong) AMAnchoredTopLayout *topLayout;
@property (nonatomic, strong) AMAnchoredLeftLayout *leftLayout;
@property (nonatomic, strong) AMFixedWidthLayout *widthLayout;
@property (nonatomic, strong) AMFixedHeightLayout *heightLayout;

@end

@implementation AMPositionLayout

- (id)init {
    self = [super init];
    
    if (self != nil) {
        self.topLayout = [AMAnchoredTopLayout new];
        self.leftLayout = [AMAnchoredLeftLayout new];
        self.widthLayout = [AMFixedWidthLayout new];
        self.heightLayout = [AMFixedHeightLayout new];
    }
    
    return self;
}

#pragma mark - Getters and Setters

- (void)setView:(UIView *)view {
    self.topLayout.view = view;
    self.leftLayout.view = view;
    self.widthLayout.view = view;
    self.heightLayout.view = view;
}

#pragma mark - Public

- (void)clearLayout {
    [super clearLayout];
    [self.topLayout clearLayout];
    [self.leftLayout clearLayout];
    [self.widthLayout clearLayout];
    [self.heightLayout clearLayout];
}

- (void)createConstraintsIfNecessaryWithMultiplier:(CGFloat)multiplier
                                          priority:(AMLayoutPriority)priority {
    
    [self.topLayout createConstraintsIfNecessaryWithMultiplier:multiplier priority:priority];
    [self.leftLayout createConstraintsIfNecessaryWithMultiplier:multiplier priority:priority];
    [self.widthLayout createConstraintsIfNecessaryWithMultiplier:multiplier priority:priority];
    [self.heightLayout createConstraintsIfNecessaryWithMultiplier:multiplier priority:priority];
}

- (void)updateLayoutWithFrame:(CGRect)frame
                   multiplier:(CGFloat)multiplier
                     priority:(AMLayoutPriority)priority
                  parentFrame:(CGRect)parentFrame {
    [super updateLayoutWithFrame:frame multiplier:multiplier priority:priority parentFrame:parentFrame];
    [self.topLayout updateLayoutWithFrame:frame multiplier:multiplier priority:priority parentFrame:parentFrame];
    [self.leftLayout updateLayoutWithFrame:frame multiplier:multiplier priority:priority parentFrame:parentFrame];
    [self.widthLayout updateLayoutWithFrame:frame multiplier:multiplier priority:priority parentFrame:parentFrame];
    [self.heightLayout updateLayoutWithFrame:frame multiplier:multiplier priority:priority parentFrame:parentFrame];
}

@end
