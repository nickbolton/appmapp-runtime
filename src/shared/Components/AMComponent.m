//
//  AMComponent.m
//  AppMapTest
//
//  Created by Nick Bolton on 8/1/14.
//  Copyright (c) 2014 Nick Bolton. All rights reserved.
//

#import "AMComponent.h"
#import "AppMap.h"
#import "AMColor+AMColor.h"

NSString * const kAMComponentClassNameKey = @"class-name";

NSString * kAMComponentNameKey = @"name";
NSString * kAMComponentClassPrefixKey = @"classPrefix";
NSString * kAMComponentLayoutTypeKey = @"layoutType";
NSString * kAMComponentIdentifierKey = @"identifier";
NSString * kAMComponentClippedKey = @"clipped";
NSString * kAMComponentBackgroundColorKey = @"backgroundColor";
NSString * kAMComponentBorderWidthKey = @"borderWidth";
NSString * kAMComponentBorderColorWidthKey = @"borderColor";
NSString * kAMComponentAlphaKey = @"alpha";
NSString * kAMComponentFrameKey = @"frame";
NSString * kAMComponentCornerRadiusKey = @"cornerRadius";
NSString * kAMComponentChildComponentsKey = @"childComponents";

static NSString * kAMComponentDefaultNamePrefix = @"Container-";

static NSInteger AMComponentMaxDefaultComponentNumber = 0;

@interface AMComponent()

@property (nonatomic, strong) NSMutableArray *primChildComponents;
@property (nonatomic, readwrite) NSString *defaultName;
@property (nonatomic, readwrite) NSString *exportedName;

@end

@implementation AMComponent

@synthesize name = _name;

- (void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeObject:self.name forKey:kAMComponentNameKey];
    [coder encodeObject:self.classPrefix forKey:kAMComponentClassPrefixKey];
    [coder encodeInt32:self.layoutType forKey:kAMComponentLayoutTypeKey];
    [coder encodeObject:self.identifier forKey:kAMComponentIdentifierKey];
    [coder encodeBool:self.isClipped forKey:kAMComponentClippedKey];
    [coder encodeObject:self.backgroundColor forKey:kAMComponentBackgroundColorKey];
    [coder encodeObject:self.borderColor forKey:kAMComponentBorderColorWidthKey];
    [coder encodeFloat:self.alpha forKey:kAMComponentAlphaKey];
    [coder encodeFloat:self.cornerRadius forKey:kAMComponentCornerRadiusKey];
    [coder encodeFloat:self.borderWidth forKey:kAMComponentBorderWidthKey];
    [coder encodeObject:self.childComponents forKey:kAMComponentChildComponentsKey];
    
#if TARGET_OS_IPHONE
    [coder encodeObject:NSStringFromCGRect(self.frame) forKey:kAMComponentFrameKey];
#else
    [coder encodeObject:NSStringFromRect(self.frame) forKey:kAMComponentFrameKey];
#endif
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    
    if (self != nil) {

        self.name = [decoder decodeObjectForKey:kAMComponentNameKey];
        self.classPrefix = [decoder decodeObjectForKey:kAMComponentClassPrefixKey];
        self.layoutType = [decoder decodeInt32ForKey:kAMComponentLayoutTypeKey];
        self.identifier = [decoder decodeObjectForKey:kAMComponentIdentifierKey];
        self.clipped = [decoder decodeBoolForKey:kAMComponentClippedKey];
        self.backgroundColor = [decoder decodeObjectForKey:kAMComponentBackgroundColorKey];
        self.alpha = [decoder decodeFloatForKey:kAMComponentAlphaKey];
        self.cornerRadius = [decoder decodeFloatForKey:kAMComponentCornerRadiusKey];
        self.borderWidth = [decoder decodeFloatForKey:kAMComponentBorderWidthKey];
        self.borderColor = [decoder decodeObjectForKey:kAMComponentBorderColorWidthKey];
        
#if TARGET_OS_IPHONE
        self.frame = CGRectFromString([decoder decodeObjectForKey:kAMComponentFrameKey]);
#else
        self.frame = NSRectFromString([decoder decodeObjectForKey:kAMComponentFrameKey]);
#endif
        
        NSArray *childComponents =
        [decoder decodeObjectForKey:kAMComponentChildComponentsKey];
        
        [self addChildComponents:childComponents];
        
        [self updateComponentMaxDefaultComponentNumber];
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    
    self = [super init];
    
    if (self != nil) {
        
        NSString *backgroundColorString = dict[kAMComponentBackgroundColorKey];
        NSString *borderColorString = dict[kAMComponentBorderColorWidthKey];

        self.name = dict[kAMComponentNameKey];
        self.classPrefix = dict[kAMComponentClassPrefixKey];
        self.layoutType = [dict[kAMComponentLayoutTypeKey] integerValue];
        self.identifier = dict[kAMComponentIdentifierKey];
        self.clipped = [dict[kAMComponentClippedKey] boolValue];
        self.alpha = [dict[kAMComponentAlphaKey] floatValue];
        self.cornerRadius = [dict[kAMComponentCornerRadiusKey] floatValue];
        self.borderWidth = [dict[kAMComponentBorderWidthKey] floatValue];
        self.borderColor = [AMColor colorWithHexcodePlusAlpha:borderColorString];
        self.backgroundColor = [AMColor colorWithHexcodePlusAlpha:backgroundColorString];

#if TARGET_OS_IPHONE
        self.frame = CGRectFromString(dict[kAMComponentFrameKey]);
#else
        self.frame = NSRectFromString(dict[kAMComponentFrameKey]);
#endif
        
        NSMutableArray *childComponents = [NSMutableArray array];
        id children = dict[kAMComponentChildComponentsKey];
        NSArray *childrenArray = nil;
        
        if ([children isKindOfClass:[NSArray class]]) {
            childrenArray = children;
        } else if ([children isKindOfClass:[NSDictionary class]]) {
            childrenArray = ((NSDictionary *)children).allValues;
        }
        
        [childrenArray enumerateObjectsUsingBlock:^(NSDictionary *childDict, NSUInteger idx, BOOL *stop) {
            
            NSString *className = childDict[kAMComponentClassNameKey];
            AMComponent *childComponent =
            [[NSClassFromString(className) alloc] initWithDictionary:childDict];
            
            [childComponents addObject:childComponent];
        }];
        
        [self addChildComponents:childComponents];
        
        [self updateComponentMaxDefaultComponentNumber];
    }
    
    return self;
}

+ (instancetype)componentWithDictionary:(NSDictionary *)dict {
    
    NSString *className = dict[kAMComponentClassNameKey];
    AMComponent *component =
    [[NSClassFromString(className) alloc] initWithDictionary:dict];
    
    return component;
}

- (void)updateComponentMaxDefaultComponentNumber {
    
    if ([self.name hasPrefix:kAMComponentDefaultNamePrefix] &&
        self.name.length > kAMComponentDefaultNamePrefix.length) {
        
        NSString *numberString =
        [self.name substringFromIndex:kAMComponentDefaultNamePrefix.length];
        NSInteger componentNumber = [numberString integerValue];
        
        AMComponentMaxDefaultComponentNumber =
        MAX(AMComponentMaxDefaultComponentNumber, componentNumber+1);
    }
}

- (id)copyWithZone:(NSZone *)zone {
    return [self copy];
}

- (id)copy {
    
    AMComponent *component = [[self.class alloc] init];
    component.name = self.name.copy;
    component.classPrefix = self.classPrefix.copy;
    component.identifier = self.identifier.copy;
    component.frame = self.frame;
    component.layoutType = self.layoutType;
    component.childComponents = self.primChildComponents.mutableCopy;
    component.clipped = self.isClipped;
    component.backgroundColor = self.backgroundColor;
    component.alpha = self.alpha;
    component.borderWidth = self.borderWidth;
    component.borderColor = self.borderColor;
    
    return component;
}

- (instancetype)copyForPasting {
    
    AMComponent *result = self.copy;
    result.identifier = [[NSUUID new] UUIDString];
    
    NSMutableArray *children = [NSMutableArray array];
    
    for (AMComponent *childComponent in self.childComponents) {
        
        AMComponent *childCopy = [childComponent copyForPasting];
        [children addObject:childCopy];
    }
    
    result.childComponents = children;
    
    return result;
}

+ (AMComponent *)buildComponent {
    
    AMComponent *component = [[self.class alloc] init];
    component.identifier = [[NSUUID new] UUIDString];
    component.cornerRadius = 2.0f;
    component.borderWidth = 1.0f;
    component.alpha = 1.0f;

    return component;
}

- (NSDictionary *)exportComponent {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[kAMComponentClassNameKey] = NSStringFromClass(self.class);
    dict[kAMComponentNameKey] = self.name;
    dict[kAMComponentLayoutTypeKey] = @(self.layoutType);
    dict[kAMComponentIdentifierKey] = self.identifier;
    dict[kAMComponentClippedKey] = @(self.isClipped);
    dict[kAMComponentBackgroundColorKey] = [self.backgroundColor hexcodePlusAlpha];
    dict[kAMComponentBorderColorWidthKey] = [self.borderColor hexcodePlusAlpha];
    dict[kAMComponentAlphaKey] = @(self.alpha);
    dict[kAMComponentCornerRadiusKey] = @(self.cornerRadius);
    dict[kAMComponentBorderWidthKey] = @(self.borderWidth);
    
    if (self.classPrefix != nil) {
        dict[kAMComponentClassPrefixKey] = self.classPrefix;
    }
    
#if TARGET_OS_IPHONE
    dict[kAMComponentFrameKey] = NSStringFromCGRect(self.frame);
#else
    dict[kAMComponentFrameKey] = NSStringFromRect(self.frame);
#endif
    
    NSMutableDictionary *children = [NSMutableDictionary dictionary];
    
    [self.childComponents enumerateObjectsUsingBlock:^(AMComponent *childComponent, NSUInteger idx, BOOL *stop) {
    
        children[childComponent.exportedName] = [childComponent exportComponent];
    }];

    dict[kAMComponentChildComponentsKey] = children;
    
    return dict;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Component: %@, %@, %d", self.name, self.identifier, (int)self.componentType];
}

#pragma mark - Getters and Setters

- (BOOL)isContainer {
    return self.componentType == AMComponentContainer;
}

- (AMComponentType)componentType {
    return AMComponentContainer;
}

- (NSString *)name {
    if (_name != nil) {
        return _name;
    }
    return self.defaultName;
}

- (void)setName:(NSString *)name {
    _name = name;
    _exportedName = nil;
}

- (NSString *)exportedName {
    
    if (_exportedName == nil) {
        
        NSMutableString *exportedName = [NSMutableString string];
        
        NSString *name = [self.name stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        
        // string components
        NSArray *components = [name componentsSeparatedByString:@" "];
        [components enumerateObjectsUsingBlock:^(NSString *component, NSUInteger idx, BOOL *stop) {
            
            if (component.length > 0) {
            
                NSString *firstCharacter;
                
                if (exportedName.length == 0) {

                    firstCharacter = [[component substringToIndex:1] lowercaseString];
                } else {
                    firstCharacter = [[component substringToIndex:1] uppercaseString];
                }
                
                [exportedName appendString:firstCharacter];

                if (component.length > 1) {
                    [exportedName appendString:[component substringFromIndex:1]];
                }
            }
        }];
        
        NSCharacterSet *charactersToRemove = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
        _exportedName = [[exportedName componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@""];
    }
    
    return _exportedName;
}

- (NSString *)defaultName {
    
    if (_defaultName == nil) {
        
        _defaultName =
        [NSString stringWithFormat:@"%@%d",
         kAMComponentDefaultNamePrefix,
         (int)AMComponentMaxDefaultComponentNumber++];
    }
    
    return _defaultName;
}

- (NSArray *)childComponents {
    return
    [NSArray arrayWithArray:self.primChildComponents];
}

- (void)setChildComponents:(NSArray *)childComponents {
 
    NSMutableArray *primComponents = self.primChildComponents;
    [primComponents removeAllObjects];
    [primComponents addObjectsFromArray:childComponents];
}

- (NSMutableArray *)primChildComponents {
    
    if (_primChildComponents == nil) {
        _primChildComponents = [NSMutableArray array];
    }
    return _primChildComponents;
}

#pragma mark - Public

- (void)addChildComponent:(AMComponent *)component {
    if (component != nil) {
        [self addChildComponents:@[component]];
    }
}

- (void)addChildComponents:(NSArray *)components {

    NSMutableArray *primComponents = self.primChildComponents;

    [components enumerateObjectsUsingBlock:^(AMComponent *component, NSUInteger idx, BOOL *stop) {
        
        if ([primComponents containsObject:component] == NO) {
            [primComponents addObject:component];
        }
        
        component.parentComponent = self;
    }];
}

- (void)insertChildComponent:(AMComponent *)insertedComponent
             beforeComponent:(AMComponent *)siblingComponent {
    
    NSMutableArray *primComponents = self.primChildComponents;

    NSUInteger pos = [primComponents indexOfObject:siblingComponent];
    
    if (pos == NSNotFound) {
        pos = 0;
    }
    
    if ([primComponents containsObject:insertedComponent]) {
        [primComponents removeObject:insertedComponent];
    }
    
    [primComponents insertObject:insertedComponent atIndex:pos];
}

- (void)removeChildComponent:(AMComponent *)component {
    if (component != nil) {
        [self removeChildComponents:@[component]];
    }
}

- (void)removeChildComponents:(NSArray *)components {
    [self.primChildComponents removeObjectsInArray:components];
    
    [components enumerateObjectsUsingBlock:^(AMComponent *component, NSUInteger idx, BOOL *stop) {
        component.parentComponent = nil;
    }];
}

- (BOOL)isEqualToComponent:(AMComponent *)object {
    return
    [self.identifier isEqualToString:object.identifier];
}

@end
