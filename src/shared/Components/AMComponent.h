//
//  AMComponent.h
//  AppMapTest
//
//  Created by Nick Bolton on 8/1/14.
//  Copyright (c) 2014 Nick Bolton. All rights reserved.
//

#import "AppMap.h"
#import "AppMapTypes.h"

extern NSString * const kAMComponentClassNameKey;
extern NSString * kAMComponentNameKey;
extern NSString * kAMComponentClassPrefixKey;
extern NSString * kAMComponentIdentifierKey;
extern NSString * kAMComponentClippedKey;
extern NSString * kAMComponentBackgroundColorKey;
extern NSString * kAMComponentBorderWidthKey;
extern NSString * kAMComponentBorderColorWidthKey;
extern NSString * kAMComponentAlphaKey;
extern NSString * kAMComponentFrameKey;
extern NSString * kAMComponentCornerRadiusKey;
extern NSString * kAMComponentChildComponentsKey;
extern NSString * kAMComponentLayoutObjectsKey;
extern NSString * kAMComponentLayoutPresetKey;

@interface AMComponent : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *classPrefix;
@property (nonatomic, readonly) NSString *exportedName;
@property (nonatomic, readonly) NSString *defaultName;
@property (nonatomic, readonly) NSInteger depth;
@property (nonatomic, readonly) NSInteger childIndex;
@property (nonatomic, readonly) AMComponentType componentType;
@property (nonatomic, strong) NSArray *layoutObjects;
@property (nonatomic, strong) NSArray *childComponents;
@property (nonatomic, weak) AMComponent *parentComponent;
@property (nonatomic, strong) NSString *lastParentComponentIdentifier;
@property (nonatomic, readonly) AMComponent *topLevelComponent;
@property (nonatomic, readonly) BOOL isTopLevelComponent;
@property (nonatomic, readonly) NSArray *sizePresets;

@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic) CGFloat borderWidth;

@property (nonatomic, getter=isClipped) BOOL clipped;
@property (nonatomic, readonly) BOOL hasProportionalLayout;
@property (nonatomic) CGFloat alpha;
@property (nonatomic) CGRect frame;
@property (nonatomic, readonly) BOOL isContainer;

@property (nonatomic, strong) AMColor *borderColor;
@property (nonatomic, strong) AMColor *backgroundColor;

@property (nonatomic) AMLayoutPreset layoutPreset;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)componentWithDictionary:(NSDictionary *)dict;

- (BOOL)isEqualToComponent:(AMComponent *)object;

- (void)addChildComponent:(AMComponent *)component;
- (void)addChildComponents:(NSArray *)components;
- (void)removeChildComponent:(AMComponent *)component;
- (void)removeChildComponents:(NSArray *)components;
- (void)insertChildComponent:(AMComponent *)insertedComponent
             beforeComponent:(AMComponent *)siblingComponent;
- (void)insertChildComponent:(AMComponent *)insertedComponent
              afterComponent:(AMComponent *)siblingComponent;

- (void)updateProportionalLayouts;

- (NSDictionary *)exportComponent;

+ (instancetype)buildComponent;

- (instancetype)copyForPasting;
- (BOOL)isDescendent:(AMComponent *)component;
- (AMComponent *)ancestorBefore:(AMComponent *)component;

+ (BOOL)doesHaveCommonTopLevelComponent:(NSArray *)components;
+ (BOOL)doesHaveCommonTopLevelComponent:(NSArray *)components
                          withComponent:(AMComponent *)component;

@end
