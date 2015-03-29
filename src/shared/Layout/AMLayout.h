//
//  AMLayout.h
//  AppMap
//
//  Created by Nick Bolton on 12/28/14.
//  Copyright (c) 2014 Pixelbleed LLC. All rights reserved.
//
#import "AppMap.h"

@interface AMLayout : NSObject

@property (nonatomic) CGFloat proportionalValue;
@property (nonatomic, strong) NSLayoutConstraint *constraint;
@property (nonatomic, readonly) AMLayoutType layoutType;
@property (nonatomic) BOOL layoutApplied;

@property (nonatomic, weak) AMView *view;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)layoutWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)exportComponent;

- (void)clearLayout;
- (void)updateLayoutWithFrame:(CGRect)frame
                   multiplier:(CGFloat)multiplier
                     priority:(AMLayoutPriority)priority
                  parentFrame:(CGRect)parentFrame
             allLayoutObjects:(NSArray *)allLayoutObjects
                       inView:(AMView *)view;

- (void)adjustLayoutFromParentFrameChange:(CGRect)frame
                               multiplier:(CGFloat)multiplier
                                 priority:(AMLayoutPriority)priority
                              parentFrame:(CGRect)parentFrame
                         allLayoutObjects:(NSArray *)allLayoutObjects
                                   inView:(AMView *)view;

- (void)applyConstraintIfNecessary;
- (void)updateProportionalValueFromFrame:(CGRect)frame parentFrame:(CGRect)parentFrame;
- (void)createConstraintsIfNecessaryWithMultiplier:(CGFloat)multiplier
                                          priority:(AMLayoutPriority)priority;
- (NSLayoutConstraint *)buildConstraintWithMultiplier:(CGFloat)multiplier;
@end
