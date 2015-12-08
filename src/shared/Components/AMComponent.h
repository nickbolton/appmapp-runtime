//
//  AMComponent.h
//  AppMapTest
//
//  Created by Nick Bolton on 8/1/14.
//  Copyright (c) 2014 Nick Bolton. All rights reserved.
//
#import "AMComponentAttributes.h"

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

@class AMComponentBehavior;
@class AMCompositeTextDescriptor;

@interface AMComponent : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic) AMComponentType componentType;
@property (nonatomic, readonly) BOOL isContainer;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, readonly) NSString *exportedName;
@property (nonatomic, readonly) NSString *defaultName;
@property (nonatomic, readonly) AMComponentBehavior *behavor;
@property (nonatomic, strong) AMCompositeTextDescriptor *textDescriptor;
@property (nonatomic, readonly) AMComponent *parentInstance;
@property (nonatomic, strong) AMComponentAttributes *attributes;
@property (nonatomic) AMLayoutPreset layoutPreset;
@property (nonatomic, strong) NSArray *layoutObjects;
@property (nonatomic) CGRect frame;

@property (nonatomic) AMDuplicateType duplicateType;
@property (nonatomic, readonly) BOOL isMirrored;
@property (nonatomic, readonly) BOOL isCopied;
@property (nonatomic, readonly) BOOL isInherited;
@property (nonatomic) BOOL duplicating;

@property (nonatomic, strong) NSString *classPrefix;
@property (nonatomic) BOOL dropTarget;
@property (nonatomic, weak) AMComponent *linkedComponent;
@property (nonatomic, readonly) NSString *linkedComponentIdentifier;
@property (nonatomic, readonly) BOOL isTopLevelComponent;
@property (nonatomic) BOOL useCustomViewClass;

@property (nonatomic, readonly) NSInteger depth;
@property (nonatomic, readonly) NSInteger childIndex;
@property (nonatomic, strong) NSArray *childComponents;
@property (nonatomic, weak) AMComponent *parentComponent;
@property (nonatomic, readonly) AMComponent *topLevelComponent;
@property (nonatomic, readonly) NSArray *sizePresets;
@property (nonatomic) CGFloat scale; // canvas scale
@property (nonatomic, readonly) NSArray *allAncestors;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)componentWithDictionary:(NSDictionary *)dict;
+ (NSDictionary *)exportComponents:(NSArray *)components;
- (void)copyToComponent:(AMComponent *)component;
- (instancetype)shallowCopy;
+ (instancetype)buildComponent;
- (instancetype)copyForPasting;
- (instancetype)duplicate;

- (void)addBehavor:(AMComponentBehavior *)behavior;
- (void)removeBehavior:(AMComponentBehavior *)behavior;

- (BOOL)isEqualToComponent:(AMComponent *)object;

- (NSDictionary *)dictionaryRepresentation;

- (void)updateProportionalLayouts;
- (void)resetLayout;

- (void)updateChildFrames;
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
