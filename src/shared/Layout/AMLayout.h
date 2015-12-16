//
//  AMLayout.h
//  AppMap
//
//  Created by Nick Bolton on 12/28/14.
//  Copyright (c) 2014 Pixelbleed LLC. All rights reserved.
//
#import "AppMap.h"
#import "NSLayoutConstraint+Utilities.h"
#import "AppMapTypes.h"

@class AMComponent;

@interface AMLayout : NSObject

@property (nonatomic) CGFloat proportionalValue;
@property (nonatomic, strong) NSLayoutConstraint *constraint;
@property (nonatomic, readonly) AMLayoutType layoutType;
@property (nonatomic) NSLayoutRelation layoutRelation;
@property (nonatomic) BOOL layoutApplied;
@property (nonatomic, readonly) BOOL isHorizontal;
@property (nonatomic, readonly) BOOL isVertical;
@property (nonatomic, readonly) BOOL isProportional;
@property (nonatomic, copy) NSString *viewIdentifier;

@property (nonatomic, weak) AMView *view;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)layoutWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)exportLayout;

+ (BOOL)isProportionalLayoutType:(AMLayoutType)layoutType;
+ (BOOL)isHorizontalLayoutType:(AMLayoutType)layoutType;
+ (BOOL)isVerticalLayoutType:(AMLayoutType)layoutType;

- (void)clearLayout;
- (void)updateLayoutWithFrame:(CGRect)frame
                   multiplier:(CGFloat)multiplier
                     priority:(AMLayoutPriority)priority
                  parentFrame:(CGRect)parentFrame
             allLayoutObjects:(NSArray *)allLayoutObjects
                       inView:(AMView *)view
                     animated:(BOOL)animated;

- (CGRect)adjustedFrame:(CGRect)frame
           forComponent:(AMComponent *)component
           maintainSize:(BOOL)maintainSize
                  scale:(CGFloat)scale;

- (CGRect)adjustedFrame:(CGRect)frame
           forComponent:(AMComponent *)component
                  scale:(CGFloat)scale;

- (void)applyConstraintIfNecessary;
- (void)updateProportionalValueFromFrame:(CGRect)frame parentFrame:(CGRect)parentFrame;
- (void)createConstraintsIfNecessaryWithMultiplier:(CGFloat)multiplier
                                          priority:(AMLayoutPriority)priority;
- (NSLayoutConstraint *)buildConstraintWithMultiplier:(CGFloat)multiplier;
@end
