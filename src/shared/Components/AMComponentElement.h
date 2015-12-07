//
//  AMComponentElement.h
//  AppMapTest
//
//  Created by Nick Bolton on 8/1/14.
//  Copyright (c) 2014 Nick Bolton. All rights reserved.
//

extern NSString * const kAMComponentClassNameKey;
extern NSString * const kAMComponentsKey;
extern NSString * kAMComponentChildComponentsKey;
extern NSString * kAMComponentFrameKey;
extern NSString * kAMComponentLayoutObjectsKey;
extern NSString * kAMComponentLayoutPresetKey;
extern NSString * kAMComponentTopLevelComponentKey;

extern NSString * kAMComponentIdentifierKey;

@interface AMComponentElement : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic) AMComponentType componentType;

@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic) CGFloat borderWidth;

@property (nonatomic, getter=isClipped) BOOL clipped;
@property (nonatomic) CGFloat alpha;

@property (nonatomic, strong) AMColor *borderColor;
@property (nonatomic, strong) AMColor *backgroundColor;

@property (nonatomic, readonly) NSInteger depth;
@property (nonatomic, readonly) NSInteger childIndex;
@property (nonatomic, strong) NSArray *childComponents;
@property (nonatomic, weak) AMComponentElement *parentComponent;
@property (nonatomic, readonly) AMComponentElement *topLevelComponent;
@property (nonatomic, readonly) NSArray *sizePresets;
@property (nonatomic) CGRect frame;
@property (nonatomic, strong) NSArray *layoutObjects;
@property (nonatomic, readonly) BOOL hasProportionalLayout;
@property (nonatomic) AMLayoutPreset layoutPreset;
@property (nonatomic) CGFloat scale; // canvas scale

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)componentWithDictionary:(NSDictionary *)dict;
+ (NSDictionary *)exportComponents:(NSArray *)components;
- (void)copyToComponent:(AMComponentElement *)component;
- (instancetype)shallowCopy;

- (BOOL)isEqualToComponent:(AMComponentElement *)object;

- (NSDictionary *)exportComponent;

- (void)updateProportionalLayouts;
- (void)resetLayout;

- (void)updateChildFrames;
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
