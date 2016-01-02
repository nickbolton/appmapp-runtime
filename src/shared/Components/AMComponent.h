//
//  AMComponent.h
//  AppMapTest
//
//  Created by Nick Bolton on 8/1/14.
//  Copyright (c) 2014 Nick Bolton. All rights reserved.
//
#import "AppMap.h"
#import "AppMapTypes.h"
#import "AMLayout.h"

extern NSString *const kAMComponentsKey;
extern NSString *const kAMComponentChildComponentsKey;
extern NSString *const kAMComponentTopLevelComponentKey;
extern NSString *const kAMComponentClassPrefixKey;

@class AMComponentBehavior;
@class AMCompositeTextDescriptor;

@interface AMComponent : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic) AMComponentType componentType;
@property (nonatomic, readonly) BOOL isContainer;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, readonly) NSString *exportedName;
@property (nonatomic, readonly) NSString *defaultName;
@property (nonatomic, readonly) AMComponentBehavior *behavor;
@property (nonatomic, strong) AMCompositeTextDescriptor *textDescriptor;

@property (nonatomic) AMDuplicateType duplicateType;
@property (nonatomic, readonly) BOOL isMirrored;
@property (nonatomic, readonly) BOOL isCopied;
@property (nonatomic, readonly) BOOL isInherited;
@property (nonatomic, copy) NSString *duplicateSourceIdentifier;

@property (nonatomic, copy) NSString *classPrefix;
@property (nonatomic) BOOL dropTarget;
@property (nonatomic, weak) AMComponent *linkedComponent;
@property (nonatomic, readonly) NSString *linkedComponentIdentifier;
@property (nonatomic, readonly) BOOL isTopLevelComponent;
@property (nonatomic) BOOL useCustomViewClass;

@property (nonatomic, readonly) NSInteger depth;
@property (nonatomic, readonly) NSInteger childIndex;
@property (nonatomic, copy) NSArray *childComponents;
@property (nonatomic, weak) AMComponent *parentComponent;
@property (nonatomic, readonly) AMComponent *topLevelComponent;
@property (nonatomic, readonly) NSArray *sizePresets;
@property (nonatomic) CGFloat scale; // canvas scale
@property (nonatomic, readonly) NSArray *allAncestors;

// attributes
@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic, getter=isClipped) BOOL clipped;
@property (nonatomic) CGFloat alpha;
@property (nonatomic, strong) AMColor *borderColor;
@property (nonatomic, strong) AMColor *backgroundColor;
@property (nonatomic) CGRect frame;
@property (nonatomic, readonly) BOOL hasProportionalLayout;
@property (nonatomic, readonly) NSArray *allLayoutObjects;
@property (nonatomic, strong) NSArray *layoutObjects;
@property (nonatomic, strong) NSArray *defaultLayoutObjects;
@property (nonatomic) AMLayoutPreset layoutPreset;
@property (nonatomic, readonly) NSArray *dependentRelatedComponents;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)componentWithDictionary:(NSDictionary *)dict;

- (void)clearLayoutComponentWiring;
- (void)setLayoutObjectsEnabled:(BOOL)enabled;
- (void)addLayoutObject:(AMLayout *)layoutObject layoutProvider:(id<AMLayoutProvider>)layoutProvider;
- (void)removeLayoutObject:(AMLayout *)layoutObject;

- (void)applyLayoutInAnimation:(BOOL)inAnimation;
- (void)setFrame:(CGRect)frame inAnimation:(BOOL)inAnimation;
- (void)updateFrame:(CGRect)frame;

- (void)setLayoutObjects:(NSArray *)layoutObjects
            clearLayouts:(BOOL)clearLayouts
            customPreset:(BOOL)customPreset;
- (void)restoreLayoutObjects:(NSArray *)layoutObjects;

- (void)addBehavor:(AMComponentBehavior *)behavior;
- (void)removeBehavior:(AMComponentBehavior *)behavior;

- (BOOL)isEqualToComponent:(AMComponent *)object;

- (NSDictionary *)dictionaryRepresentation;

- (void)addChildComponent:(AMComponent *)component;
- (void)addChildComponents:(NSArray *)components;
- (void)removeChildComponent:(AMComponent *)component;
- (void)removeChildComponents:(NSArray *)components;
- (void)insertChildComponent:(AMComponent *)insertedComponent
             beforeComponent:(AMComponent *)siblingComponent;
- (void)insertChildComponent:(AMComponent *)insertedComponent
              afterComponent:(AMComponent *)siblingComponent;

- (BOOL)isDescendent:(AMComponent *)component;
- (AMComponent *)ancestorBefore:(AMComponent *)component;
- (BOOL)isAncestorOfComponent:(AMComponent *)component;
- (AMComponent *)commonAncestorWithComponent:(AMComponent *)otherComponent;

+ (BOOL)doesHaveCommonTopLevelComponent:(NSArray *)components;
+ (BOOL)doesHaveCommonTopLevelComponent:(NSArray *)components
                          withComponent:(AMComponent *)component;

- (CGFloat)distanceFromAttribute:(NSLayoutAttribute)attribute
                     toComponent:(AMComponent *)relatedComponent
                relatedAttribute:(NSLayoutAttribute)relatedAttribute;

- (CGRect)convertComponentFrameToAncestorComponent:(AMComponent *)targetComponent;
- (CGRect)convertAncestorFrame:(CGRect)frame toComponent:(AMComponent *)targetComponent;

- (AMLayout *)layoutObjectWithIdentifier:(NSString *)identifier;

@end
