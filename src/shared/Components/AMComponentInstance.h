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
extern NSString * kAMComponentBehavorKey;
extern NSString * kAMComponentClassPrefixKey;
extern NSString * kAMComponentLinkedComponentKey;
extern NSString * kAMComponentTextDescriptorKey;
extern NSString * kAMComponentDuplicateTypeKey;
extern NSString * kAMComponentOriginalIdentifierKey;
extern NSString * kAMComponentSourceDescriptorKey;
extern NSString * kAMComponentOriginalDescriptorKey;

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

@property (nonatomic, strong) AMComponentDescriptor *descriptor;
@property (nonatomic, readonly) NSString *descriptorIdentifier;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, readonly) NSString *exportedName;
@property (nonatomic, readonly) NSString *defaultName;
@property (nonatomic, readonly) AMComponentBehavior *behavor;
@property (nonatomic, strong) AMCompositeTextDescriptor *textDescriptor;
@property (nonatomic, readonly) AMComponentInstance *parentInstance;

@property (nonatomic) AMDuplicateType duplicateType;
@property (nonatomic, readonly) AMDuplicateType effectiveDuplicateType;
@property (nonatomic, readonly) NSString *originalIdentifier;
@property (nonatomic, copy) NSString *originalDescriptorIdentifier;
@property (nonatomic, readonly) NSString *sourceDescriptorIdentifier;
@property (nonatomic, readonly) BOOL isMirrored;
@property (nonatomic, readonly) BOOL isCopied;
@property (nonatomic, readonly) BOOL isInherited;

@property (nonatomic, strong) NSString *classPrefix;
@property (nonatomic) BOOL dropTarget;
@property (nonatomic, weak) AMComponentInstance *linkedComponent;
@property (nonatomic, readonly) NSString *linkedComponentIdentifier;
@property (nonatomic, readonly) BOOL isTopLevelComponent;
@property (nonatomic) BOOL useCustomViewClass;

+ (instancetype)buildComponent;
- (instancetype)copyForPasting;
- (instancetype)duplicate;

- (void)addBehavor:(AMComponentBehavior *)behavior;
- (void)removeBehavior:(AMComponentBehavior *)behavior;


@end
