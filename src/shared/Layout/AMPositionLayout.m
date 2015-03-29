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

#pragma mark - Getters and Setters

- (AMAnchoredTopLayout *)topLayout {
    if (_topLayout == nil) {
        _topLayout = [AMAnchoredTopLayout new];
    }
    return _topLayout;
}

- (AMAnchoredLeftLayout *)leftLayout {
    if (_leftLayout == nil) {
        _leftLayout = [AMAnchoredLeftLayout new];
    }
    return _leftLayout;
}

- (AMFixedWidthLayout *)widthLayout {
    if (_widthLayout == nil) {
        _widthLayout = [AMFixedWidthLayout new];
    }
    return _widthLayout;
}

- (AMFixedHeightLayout *)heightLayout {
    if (_heightLayout == nil) {
        _heightLayout = [AMFixedHeightLayout new];
    }
    return _heightLayout;
}

- (AMLayoutType)layoutType {
    return AMLayoutTypePosition;
}

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
                  parentFrame:(CGRect)parentFrame
             allLayoutObjects:(NSArray *)allLayoutObjects
                       inView:(AMView *)view {
    [super
     updateLayoutWithFrame:frame
     multiplier:multiplier
     priority:priority
     parentFrame:parentFrame
     allLayoutObjects:allLayoutObjects
     inView:view];

    NSArray *allLayouts =
    @[self.topLayout, self.leftLayout, self.widthLayout, self.heightLayout];
    
    [self.topLayout
     updateLayoutWithFrame:frame
     multiplier:multiplier
     priority:priority
     parentFrame:parentFrame
     allLayoutObjects:allLayouts
     inView:view];

    [self.leftLayout
     updateLayoutWithFrame:frame
     multiplier:multiplier
     priority:priority
     parentFrame:parentFrame
     allLayoutObjects:allLayouts
     inView:view];

    [self.widthLayout
     updateLayoutWithFrame:frame
     multiplier:multiplier
     priority:priority
     parentFrame:parentFrame
     allLayoutObjects:allLayouts
     inView:view];

    [self.heightLayout
     updateLayoutWithFrame:frame
     multiplier:multiplier
     priority:priority
     parentFrame:parentFrame
     allLayoutObjects:allLayouts
     inView:view];
}

@end
