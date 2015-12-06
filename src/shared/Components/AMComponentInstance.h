//
//  AMComponentInstance.h
//  AppMap
//
//  Created by Nick Bolton on 12/5/15.
//  Copyright © 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMComponentElement.h"
#import "AppMap.h"
#import "AppMapTypes.h"

extern NSString * kAMComponentNameKey;
extern NSString * kAMComponentDescriptorKey;
extern NSString * kAMComponentFrameKey;
extern NSString * kAMComponentBehavorKey;
extern NSString * kAMComponentLayoutObjectsKey;
extern NSString * kAMComponentLayoutPresetKey;
extern NSString * kAMComponentTopLevelComponentKey;
extern NSString * kAMComponentClassPrefixKey;
extern NSString * kAMComponentChildComponentsKey;
extern NSString * kAMComponentLinkedComponentKey;
extern NSString * kAMComponentTextDescriptorKey;
extern NSString * kAMComponentDuplicateTypeKey;

extern NSString * kAMComponentOverridingClippedKey;
extern NSString * kAMComponentOverridingBackgroundColorKey;
extern NSString * kAMComponentOverridingBorderWidthKey;
extern NSString * kAMComponentOverridingBorderColorKey;
extern NSString * kAMComponentOverridingAlphaKey;
extern NSString * kAMComponentOverridingCornerRadiusKey;

@class AMComponentDescriptor;
@class AMComponentBehavior;
@class AMCompositeTextDescriptor;

@interface AMComponentInstance : AMComponentElement

@property (nonatomic, weak) AMComponentDescriptor *descriptor;
@property (nonatomic) BOOL holdDescriptor;

@property (nonatomic, readonly) NSString *descriptorIdentifier;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, readonly) NSString *exportedName;
@property (nonatomic, readonly) NSString *defaultName;
@property (nonatomic) CGFloat scale; // canvas scale
@property (nonatomic, readonly) NSArray *sizePresets;
@property (nonatomic) CGRect frame;
@property (nonatomic, readonly) AMComponentBehavior *behavor;
@property (nonatomic, strong) AMCompositeTextDescriptor *textDescriptor;

@property (nonatomic, strong) NSArray *layoutObjects;
@property (nonatomic, readonly) BOOL hasProportionalLayout;
@property (nonatomic) AMLayoutPreset layoutPreset;
@property (nonatomic) AMDuplicateType duplicateType;
@property (nonatomic, readonly) BOOL isMirrored;
@property (nonatomic, readonly) BOOL isCopied;
@property (nonatomic, readonly) BOOL isInherited;

@property (nonatomic, strong) NSString *classPrefix;
@property (nonatomic, readonly) NSInteger depth;
@property (nonatomic, readonly) NSInteger childIndex;
@property (nonatomic) BOOL dropTarget;
@property (nonatomic, strong) NSArray *childComponents;
@property (nonatomic, weak) AMComponentInstance *parentComponent;
@property (nonatomic, readonly) AMComponentInstance *topLevelComponent;
@property (nonatomic, weak) AMComponentInstance *linkedComponent;
@property (nonatomic, readonly) NSString *linkedComponentIdentifier;
@property (nonatomic, readonly) BOOL isTopLevelComponent;
@property (nonatomic) BOOL useCustomViewClass;

+ (instancetype)buildComponent;
- (instancetype)copyForPasting;

- (void)addBehavor:(AMComponentBehavior *)behavior;
- (void)removeBehavior:(AMComponentBehavior *)behavior;

- (void)updateProportionalLayouts;

- (void)addChildComponent:(AMComponentElement *)component;
- (void)addChildComponents:(NSArray *)components;
- (void)removeChildComponent:(AMComponentElement *)component;
- (void)removeChildComponents:(NSArray *)components;
- (void)insertChildComponent:(AMComponentElement *)insertedComponent
             beforeComponent:(AMComponentElement *)siblingComponent;
- (void)insertChildComponent:(AMComponentElement *)insertedComponent
              afterComponent:(AMComponentElement *)siblingComponent;

- (BOOL)isDescendent:(AMComponentElement *)component;
- (AMComponentElement *)ancestorBefore:(AMComponentElement *)component;

+ (BOOL)doesHaveCommonTopLevelComponent:(NSArray *)components;
+ (BOOL)doesHaveCommonTopLevelComponent:(NSArray *)components
                          withComponent:(AMComponentElement *)component;


@end
