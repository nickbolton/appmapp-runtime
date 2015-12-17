//
//  AMComponent.h
//  AppMapTest
//
//  Created by Nick Bolton on 8/1/14.
//  Copyright (c) 2014 Nick Bolton. All rights reserved.
//

extern NSString *const kAMComponentIdentifierKey;
extern NSString *const kAMComponentAttributesKey;
extern NSString *const kAMComponentClassNameKey;
extern NSString *const kAMComponentsKey;
extern NSString *const kAMComponentChildComponentsKey;
extern NSString *const kAMComponentTopLevelComponentKey;
extern NSString *const kAMComponentTypeKey;

extern NSString *const kAMComponentNameKey;
extern NSString *const kAMComponentBehavorKey;
extern NSString *const kAMComponentClassPrefixKey;
extern NSString *const kAMComponentLinkedComponentKey;
extern NSString *const kAMComponentTextDescriptorKey;
extern NSString *const kAMComponentDuplicateTypeKey;
extern NSString *const kAMComponentDuplicateSourceKey;

extern NSString *const kAMComponentFrameKey;
extern NSString *const kAMComponentLayoutObjectsKey;
extern NSString *const kAMComponentLayoutPresetKey;
extern NSString *const kAMComponentClippedKey;
extern NSString *const kAMComponentBackgroundColorKey;
extern NSString *const kAMComponentBorderWidthKey;
extern NSString *const kAMComponentBorderColorWidthKey;
extern NSString *const kAMComponentAlphaKey;
extern NSString *const kAMComponentCornerRadiusKey;

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
@property (nonatomic, readonly) AMComponent *parentInstance;

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
@property (nonatomic, strong) NSArray *layoutObjects;
@property (nonatomic) AMLayoutPreset layoutPreset;
@property (nonatomic) CGRect frame;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)componentWithDictionary:(NSDictionary *)dict;
+ (NSDictionary *)exportComponents:(NSArray *)components;
- (void)copyToComponent:(AMComponent *)component;
- (instancetype)shallowCopy;
- (instancetype)copyForPasting;
- (instancetype)duplicate;

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

+ (BOOL)doesHaveCommonTopLevelComponent:(NSArray *)components;
+ (BOOL)doesHaveCommonTopLevelComponent:(NSArray *)components
                          withComponent:(AMComponent *)component;

@end
