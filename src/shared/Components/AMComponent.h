//
//  AMComponent.h
//  AppMapTest
//
//  Created by Nick Bolton on 8/1/14.
//  Copyright (c) 2014 Nick Bolton. All rights reserved.
//

#import "AMComponentFactory.h"
#import "AMLayout.h"

@class AMComponent;

extern NSString * const kAMComponentClassNameKey;

@interface AMComponent : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, readonly) NSString *exportedName;
@property (nonatomic, readonly) NSString *defaultName;
@property (nonatomic, readonly) AMComponentType componentType;
@property (nonatomic) AMLayoutType layoutType;
@property (nonatomic, strong) NSArray *childComponents;
@property (nonatomic, weak) AMComponent *parentComponent;
@property (nonatomic, weak) AMComponent *lastParentComponent;
@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic) CGFloat borderWidth;

@property (nonatomic, getter=isClipped) BOOL clipped;
@property (nonatomic) CGFloat alpha;
@property (nonatomic) CGRect frame;
@property (nonatomic, readonly) BOOL isContainer;

#if TARGET_OS_IPHONE
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIColor *backgroundColor;
#else
@property (nonatomic, strong) NSColor *borderColor;
@property (nonatomic, strong) NSColor *backgroundColor;
#endif

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)componentWithDictionary:(NSDictionary *)dict;

- (BOOL)isEqualToComponent:(AMComponent *)object;

- (void)addChildComponent:(AMComponent *)component;
- (void)addChildComponents:(NSArray *)components;
- (void)removeChildComponent:(AMComponent *)component;
- (void)removeChildComponents:(NSArray *)components;
- (void)insertChildComponent:(AMComponent *)insertedComponent
             beforeComponent:(AMComponent *)siblingComponent;

- (NSDictionary *)exportComponent;

+ (instancetype)buildComponent;

@end
