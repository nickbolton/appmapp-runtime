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
#import "AMComponentAware.h"

@class AMComponent;

@protocol AMLayoutProvider <NSObject>

- (AMView<AMComponentAware> *)viewWithComponentIdentifier:(NSString *)componentIdentifier;
- (AMComponent *)componentWithComponentIdentifier:(NSString *)componentIdentifier;

@end

@interface AMLayout : NSObject<NSCoding>

@property (nonatomic) NSLayoutAttribute attribute;
@property (nonatomic) NSLayoutRelation relation;
@property (nonatomic) CGFloat multiplier;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *componentIdentifier;
@property (nonatomic, copy) NSString *relatedComponentIdentifier;
@property (nonatomic, copy) NSString *commonAncestorComponentIdentifier;
@property (nonatomic, copy) NSString *proportionalComponentIdentifier;
@property (nonatomic) NSLayoutAttribute relatedAttribute;
@property (nonatomic) CGFloat constant;
@property (nonatomic) AMLayoutPriority priority;
@property (nonatomic) CGRect referenceFrame;
@property (nonatomic, getter=isProportional) BOOL proportional;
@property (nonatomic) CGFloat proportionalValue;
@property (nonatomic, getter=isEnabled) BOOL enabled;
@property (nonatomic, getter=isDefaultLayout) BOOL defaultLayout;
@property (nonatomic) CGFloat scale;

@property (nonatomic, strong) NSLayoutConstraint *constraint;
@property (nonatomic, readonly) BOOL isHorizontal;
@property (nonatomic, readonly) BOOL isVertical;
@property (nonatomic, readonly) BOOL isSizing;
@property (nonatomic, copy) NSString *viewIdentifier;
@property (nonatomic, readonly) CGFloat resolvedConstant;

@property (nonatomic, weak) id <AMLayoutProvider> layoutProvider;

@property (nonatomic, weak, readonly) AMView<AMComponentAware> *view;
@property (nonatomic, weak, readonly) AMView<AMComponentAware> *relatedView;
@property (nonatomic, weak, readonly) AMView<AMComponentAware> *commonAncestorView;
@property (nonatomic, weak, readonly) AMView<AMComponentAware> *proportionalView;

@property (nonatomic, weak, readonly) AMComponent *component;
@property (nonatomic, weak, readonly) AMComponent *relatedComponent;
@property (nonatomic, weak, readonly) AMComponent *commonAncestorComponent;
@property (nonatomic, weak, readonly) AMComponent *proportionalComponent;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)layoutWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)exportLayout;
- (NSDictionary *)debuggingDictionary;

- (BOOL)isEqualToLayout:(AMLayout *)object;

+ (BOOL)isHorizontalLayoutType:(NSLayoutAttribute)layoutType;
+ (BOOL)isVerticalLayoutType:(NSLayoutAttribute)layoutType;

- (void)updateLayoutInAnimation:(BOOL)inAnimation;
- (void)addLayout;
- (void)clearLayout;
- (void)layoutViewIfNeeded;
- (void)setScale:(CGFloat)scale inAnimation:(BOOL)inAnimation;
- (void)changeProportional:(BOOL)proportional;

- (CGRect)updateFrame:(CGRect)frame
basedOnRelatedAttributeWithRelatedSize:(CGSize)relatedSize
        originalFrame:(CGRect)originalFrame
     allLayoutObjects:(NSArray *)allLayoutObjects;

@end
