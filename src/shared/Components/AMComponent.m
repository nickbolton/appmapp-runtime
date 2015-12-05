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
#import "AMLayout.h"
#import "AMLayoutPresetHelper.h"
#import "AMLayoutFactory.h"
#import "AMView+Geometry.h"
#import "AMCompositeTextDescriptor.h"
#import "AMComponentBehavior.h"

NSString * const kAMComponentClassNameKey = @"class-name";
NSString * const kAMComponentsKey = @"components";

NSString * kAMComponentNameKey = @"name";
NSString * kAMComponentTypeKey = @"type";
NSString * kAMComponentTopLevelComponentKey = @"tlc";
NSString * kAMComponentClassPrefixKey = @"classPrefix";
NSString * kAMComponentIdentifierKey = @"identifier";
NSString * kAMComponentClippedKey = @"clipped";
NSString * kAMComponentBackgroundColorKey = @"backgroundColor";
NSString * kAMComponentBorderWidthKey = @"borderWidth";
NSString * kAMComponentBorderColorWidthKey = @"borderColor";
NSString * kAMComponentAlphaKey = @"alpha";
NSString * kAMComponentFrameKey = @"frame";
NSString * kAMComponentCornerRadiusKey = @"cornerRadius";
NSString * kAMComponentChildComponentsKey = @"childComponents";
NSString * kAMComponentBehavorKey = @"behavior";
NSString * kAMComponentLayoutObjectsKey = @"layoutObjects";
NSString * kAMComponentLayoutPresetKey = @"layoutPreset";
NSString * kAMComponentTextDescriptorKey = @"textDescriptor";
NSString * kAMComponentLinkedComponentKey = @"linkedComponent";
NSString * kAMComponentDuplicateSourceKey = @"duplicateSource";
NSString * kAMComponentUseCustomViewClassKey = @"useCustomViewClass";

static NSString * kAMComponentDefaultNamePrefix = @"Container-";

static NSInteger AMComponentMaxDefaultComponentNumber = 0;

@interface AMComponent()

@property (nonatomic, strong) NSMutableArray *primChildComponents;
@property (nonatomic, readwrite) NSString *defaultName;
@property (nonatomic, readwrite) NSString *exportedName;
@property (nonatomic, readwrite) BOOL hasProportionalLayout;
@property (nonatomic, readwrite) NSString *duplicateSourceIdentifier;
@property (nonatomic, readwrite) NSString *linkedComponentIdentifier;
@property (nonatomic, strong) NSMutableDictionary *behavors;

@end

@implementation AMComponent

@synthesize name = _name;

- (void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeObject:self.name forKey:kAMComponentNameKey];
    [coder encodeInteger:self.componentType forKey:kAMComponentTypeKey];
    [coder encodeObject:self.classPrefix forKey:kAMComponentClassPrefixKey];
    [coder encodeObject:self.identifier forKey:kAMComponentIdentifierKey];
    [coder encodeBool:self.isClipped forKey:kAMComponentClippedKey];
    [coder encodeBool:self.useCustomViewClass forKey:kAMComponentUseCustomViewClassKey];
    [coder encodeObject:self.backgroundColor forKey:kAMComponentBackgroundColorKey];
    [coder encodeObject:self.borderColor forKey:kAMComponentBorderColorWidthKey];
    [coder encodeFloat:self.alpha forKey:kAMComponentAlphaKey];
    [coder encodeFloat:self.cornerRadius forKey:kAMComponentCornerRadiusKey];
    [coder encodeFloat:self.borderWidth forKey:kAMComponentBorderWidthKey];
    [coder encodeObject:self.childComponents forKey:kAMComponentChildComponentsKey];
    [coder encodeObject:self.behavor forKey:kAMComponentBehavorKey];
    [coder encodeInteger:self.layoutPreset forKey:kAMComponentLayoutPresetKey];
    [coder encodeObject:self.layoutObjects forKey:kAMComponentLayoutObjectsKey];
    [coder encodeObject:self.textDescriptor forKey:kAMComponentTextDescriptorKey];
    [coder encodeObject:self.duplicateSource.identifier forKey:kAMComponentDuplicateSourceKey];
    [coder encodeObject:self.linkedComponent.identifier forKey:kAMComponentLinkedComponentKey];
    
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
        self.componentType = [decoder decodeIntegerForKey:kAMComponentTypeKey];
        self.classPrefix = [decoder decodeObjectForKey:kAMComponentClassPrefixKey];
        self.identifier = [decoder decodeObjectForKey:kAMComponentIdentifierKey];
        self.clipped = [decoder decodeBoolForKey:kAMComponentClippedKey];
        self.useCustomViewClass = [decoder decodeBoolForKey:kAMComponentUseCustomViewClassKey];
        self.backgroundColor = [decoder decodeObjectForKey:kAMComponentBackgroundColorKey];
        self.alpha = [decoder decodeFloatForKey:kAMComponentAlphaKey];
        self.cornerRadius = [decoder decodeFloatForKey:kAMComponentCornerRadiusKey];
        self.borderWidth = [decoder decodeFloatForKey:kAMComponentBorderWidthKey];
        self.borderColor = [decoder decodeObjectForKey:kAMComponentBorderColorWidthKey];
        self.layoutPreset = [decoder decodeIntegerForKey:kAMComponentLayoutPresetKey];
        self.layoutObjects = [decoder decodeObjectForKey:kAMComponentLayoutObjectsKey];
        self.textDescriptor = [decoder decodeObjectForKey:kAMComponentTextDescriptorKey];
        self.duplicateSourceIdentifier = [decoder decodeObjectForKey:kAMComponentDuplicateSourceKey];
        self.linkedComponentIdentifier = [decoder decodeObjectForKey:kAMComponentLinkedComponentKey];
        
#if TARGET_OS_IPHONE
        self.frame = CGRectFromString([decoder decodeObjectForKey:kAMComponentFrameKey]);
#else
        self.frame = NSRectFromString([decoder decodeObjectForKey:kAMComponentFrameKey]);
#endif
        
        NSArray *childComponents =
        [decoder decodeObjectForKey:kAMComponentChildComponentsKey];
        
        [self addChildComponents:childComponents];
        
        [self updateComponentMaxDefaultComponentNumber];
        
        AMComponentBehavior *behavior = [decoder decodeObjectForKey:kAMComponentBehavorKey];
        
        if (behavior != nil) {
            [self addBehavor:behavior];
        }
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    
    self = [super init];
    
    if (self != nil) {
        
        NSString *backgroundColorString = dict[kAMComponentBackgroundColorKey];
        NSString *borderColorString = dict[kAMComponentBorderColorWidthKey];

        self.name = dict[kAMComponentNameKey];
        self.componentType = [dict[kAMComponentTypeKey] integerValue];
        self.classPrefix = dict[kAMComponentClassPrefixKey];
        self.identifier = dict[kAMComponentIdentifierKey];
        self.clipped = [dict[kAMComponentClippedKey] boolValue];
        self.useCustomViewClass = [dict[kAMComponentUseCustomViewClassKey] boolValue];
        self.alpha = [dict[kAMComponentAlphaKey] floatValue];
        self.cornerRadius = [dict[kAMComponentCornerRadiusKey] floatValue];
        self.borderWidth = [dict[kAMComponentBorderWidthKey] floatValue];
        self.borderColor = [AMColor colorWithHexcodePlusAlpha:borderColorString];
        self.backgroundColor = [AMColor colorWithHexcodePlusAlpha:backgroundColorString];
        self.layoutPreset = [dict[kAMComponentLayoutPresetKey] integerValue];
        self.duplicateSourceIdentifier = dict[kAMComponentDuplicateSourceKey];
        self.linkedComponentIdentifier = dict[kAMComponentLinkedComponentKey];
        
        NSDictionary *descriptorDict = dict[kAMComponentTextDescriptorKey];
        
        if (descriptorDict != nil) {
            self.textDescriptor = [[AMCompositeTextDescriptor alloc] initWithDictionary:descriptorDict];
        }

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
        
        for (NSDictionary *childDict in childrenArray) {

            AMComponent *childComponent = [AMComponent componentWithDictionary:childDict];
            [childComponents addObject:childComponent];
        }
        
        NSMutableArray *layoutObjects = [NSMutableArray array];
        NSArray *layoutObjectDicts = dict[kAMComponentLayoutObjectsKey];
        
        for (NSDictionary *dict in layoutObjectDicts) {
            
            AMLayout *layout = [AMLayout layoutWithDictionary:dict];
            [layoutObjects addObject:layout];
        }
        
        self.layoutObjects = layoutObjects;
//        self.layoutPreset = AMLayoutPresetFixedSizeFixedPosition;
        
        [self addChildComponents:childComponents];
        
        [self updateComponentMaxDefaultComponentNumber];
        
        NSDictionary *behaviorDict = dict[kAMComponentBehavorKey];
        
        if (behaviorDict != nil) {
            
            NSString *behaviorClassName = behaviorDict[kAMComponentBehaviorClassKey];
            
            if (behaviorClassName != nil) {
                
                Class behaviorClass = NSClassFromString(behaviorClassName);
            
                if (behaviorClass != Nil) {
                    
                    AMComponentBehavior *behavior =
                    [[behaviorClass alloc] initWithDictionary:behaviorDict];
                    
                    if (behavior != nil) {
                        [self addBehavor:behavior];
                    }
                }
            }
        }
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
    component.componentType = self.componentType;
    component.defaultName = self.defaultName.copy;
    component.classPrefix = self.classPrefix.copy;
    component.identifier = self.identifier.copy;
    component.frame = self.frame;
    component.clipped = self.isClipped;
    component.useCustomViewClass = self.useCustomViewClass;
    component.backgroundColor = self.backgroundColor;
    component.alpha = self.alpha;
    component.borderWidth = self.borderWidth;
    component.borderColor = self.borderColor;
    component.layoutPreset = self.layoutPreset;
    component.layoutObjects = self.layoutObjects.copy;
    component.textDescriptor = self.textDescriptor.copy;
    component.linkedComponent = self.linkedComponent;

    // only used to refer back to original parent
    // children will have this reset with the next loop
    component.parentComponent = self.parentComponent;
    
    for (AMComponent *childComponent in component.childComponents) {
        childComponent.parentComponent = component;
    }
    
    NSMutableArray *children = [NSMutableArray array];

    for (AMComponent *component in self.primChildComponents) {
        [children addObject:component.copy];
    }
    component.childComponents = children;
    
    component.behavors = self.behavors.mutableCopy;

    return component;
}

- (instancetype)copyForPasting {
    
    AMComponent *result = self.copy;
    result.identifier = [[NSUUID new] UUIDString];
    result.defaultName = nil;
    
    if ([result.name hasPrefix:kAMComponentDefaultNamePrefix]) {
        result.name = nil;
    }
    
    NSMutableArray *children = [NSMutableArray array];
    
    for (AMComponent *childComponent in self.childComponents) {
        
        AMComponent *childCopy = [childComponent copyForPasting];
        [children addObject:childCopy];
    }
    
    result.childComponents = children;
    result.layoutObjects = nil;
    result.layoutPreset = result.layoutPreset;
    
    return result;
}

+ (AMComponent *)buildComponent {
    
    AMComponent *component = [[self.class alloc] init];
    component.identifier = [[NSUUID new] UUIDString];
    component.cornerRadius = 2.0f;
    component.borderWidth = 1.0f;
    component.alpha = 1.0f;
    component.layoutPreset = AMLayoutPresetFixedSizeNearestCorner;

    return component;
}

+ (NSDictionary *)exportComponents:(NSArray *)components {
    
    NSMutableDictionary *componentDictionaries = [NSMutableDictionary dictionary];
    
    [components enumerateObjectsUsingBlock:^(AMComponent *component, NSUInteger idx, BOOL *stop) {
        
        NSDictionary *componentDict = [component exportComponent];
        componentDictionaries[component.identifier] = componentDict;
    }];
    
    NSDictionary *dict =
    @{
      kAMComponentsKey : componentDictionaries,
      };
    
    return dict;
}

- (NSDictionary *)exportComponent {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[kAMComponentClassNameKey] = NSStringFromClass(self.class);
    dict[kAMComponentNameKey] = self.name;
    dict[kAMComponentTypeKey] = @(self.componentType);
    dict[kAMComponentTopLevelComponentKey] = @(self.isTopLevelComponent);
    dict[kAMComponentIdentifierKey] = self.identifier;
    dict[kAMComponentClippedKey] = @(self.isClipped);
    dict[kAMComponentUseCustomViewClassKey] = @(self.useCustomViewClass);
    dict[kAMComponentBackgroundColorKey] = [self.backgroundColor hexcodePlusAlpha];
    dict[kAMComponentBorderColorWidthKey] = [self.borderColor hexcodePlusAlpha];
    dict[kAMComponentAlphaKey] = @(self.alpha);
    dict[kAMComponentCornerRadiusKey] = @(self.cornerRadius);
    dict[kAMComponentBorderWidthKey] = @(self.borderWidth);
    dict[kAMComponentLayoutPresetKey] = @(self.layoutPreset);
    
    if (self.duplicateSource != nil) {
        dict[kAMComponentDuplicateSourceKey] = self.duplicateSource.identifier;
    }

    if (self.linkedComponent != nil) {
        dict[kAMComponentLinkedComponentKey] = self.linkedComponent.identifier;
    }
    
    if (self.textDescriptor != nil) {
        dict[kAMComponentTextDescriptorKey] = [self.textDescriptor exportTextDescriptor];
    }

    if (self.classPrefix != nil) {
        dict[kAMComponentClassPrefixKey] = self.classPrefix;
    }
    
#if TARGET_OS_IPHONE
    dict[kAMComponentFrameKey] = NSStringFromCGRect(self.frame);
#else
    dict[kAMComponentFrameKey] = NSStringFromRect(self.frame);
#endif
    
    NSMutableDictionary *children = [NSMutableDictionary dictionary];
    
    for (AMComponent *childComponent in self.childComponents) {
        children[childComponent.identifier] = [childComponent exportComponent];
    }

    dict[kAMComponentChildComponentsKey] = children;
    
    NSMutableArray *layoutObjectDicts = [NSMutableArray array];
    
    for (AMLayout *layout in self.layoutObjects) {
        NSDictionary *dict = [layout exportLayout];
        [layoutObjectDicts addObject:dict];
    }
    
    dict[kAMComponentLayoutObjectsKey] = layoutObjectDicts;
    
    if (self.behavor != nil) {
        dict[kAMComponentBehavorKey] = [self.behavor exportBehavior];
    }
    
    return dict;
}

- (NSString *)description {
#if TARGET_OS_IPHONE
    NSString *frameString = NSStringFromCGRect(self.frame);
#else
    NSString *frameString = NSStringFromRect(self.frame);
#endif
    return [NSString stringWithFormat:@"\
Component(%d): %p %@ %@\
    Parent: %@\
    Link: %@\
    LayoutPreset: %ld\
    frame: %@",
    (int)self.componentType, self, self.name, self.identifier, self.parentComponent.identifier, self.linkedComponent.identifier, self.layoutPreset, frameString];
//    return [NSString stringWithFormat:@"\
//Component(%d): %p %@ %@\
//    Parent: %@\
//    Link: %@\
//    LayoutPreset: %ld\
//    frame: %@\
//    children:\
//%@",
//    (int)self.componentType, self, self.name, self.identifier, self.parentComponent.identifier, self.linkedComponent.identifier, self.layoutPreset, NSStringFromCGRect(self.frame), self.childComponents];
}

#pragma mark - Getters and Setters

- (BOOL)isContainer {
    return self.componentType == AMComponentContainer;
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

- (void)setFrame:(CGRect)frame {
    
    BOOL sizeChanged = (CGSizeEqualToSize(frame.size, self.frame.size) == NO);
    _frame = frame;
    if (sizeChanged) {
        [self updateChildFrames];
    }
}

- (void)setParentComponent:(AMComponent *)parentComponent {
    _parentComponent = parentComponent;
    
    if (parentComponent == nil) {
        self.useCustomViewClass = YES;
    }
}

- (void)setDuplicateSource:(AMComponent *)duplicateSource {
    _duplicateSource = duplicateSource;
    self.duplicateSourceIdentifier = duplicateSource.identifier;
}

- (void)setLinkedComponent:(AMComponent *)linkedComponent {
    _linkedComponent = linkedComponent;
    self.linkedComponentIdentifier = linkedComponent.identifier;
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
                    [exportedName appendString:[[component substringFromIndex:1] lowercaseString]];
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

- (NSMutableDictionary *)behavors {
    
    if (_behavors == nil) {
        _behavors = [NSMutableDictionary dictionary];
    }
    return _behavors;
}

- (NSMutableArray *)primChildComponents {
    
    if (_primChildComponents == nil) {
        _primChildComponents = [NSMutableArray array];
    }
    return _primChildComponents;
}

- (NSInteger)depth {
    
    if (self.parentComponent != nil) {
        return [self.parentComponent depth] + 1;
    }
    
    return 1;
}

- (NSInteger)childIndex {
    
    NSInteger result = NSNotFound;
    
    if (self.parentComponent != nil) {
        result = [self.parentComponent.childComponents indexOfObject:self];
    }
    
    return result;
}

- (BOOL)isTopLevelComponent {
    return self.topLevelComponent == self;
}

- (AMComponent *)topLevelComponent {
    
    if (self.parentComponent != nil) {
        return self.parentComponent.topLevelComponent;
    }
    
    return self;
}

+ (BOOL)doesHaveCommonTopLevelComponent:(NSArray *)components {
 
    NSMutableSet *topLevelComponents = [NSMutableSet set];
    BOOL allAreTopLevelComponents = components.count > 0;
    
    for (AMComponent *component in components) {
        
        [topLevelComponents addObject:component.topLevelComponent];
        if (component.parentComponent != nil) {
            allAreTopLevelComponents = NO;
        }
    }
    
    return allAreTopLevelComponents || topLevelComponents.count == 1;
}

+ (BOOL)doesHaveCommonTopLevelComponent:(NSArray *)components
                          withComponent:(AMComponent *)component {
    
    NSMutableArray *allComponents = [NSMutableArray array];
    [allComponents addObjectsFromArray:components];
    
    if (component != nil) {
        [allComponents addObject:component];
    }
    
    return [self doesHaveCommonTopLevelComponent:allComponents];
}

- (void)setLayoutPreset:(AMLayoutPreset)layoutPreset {
    _layoutPreset = layoutPreset;

    _layoutPreset = MAX(0, _layoutPreset);
    _layoutPreset = MIN(AMLayoutPresetCustom, _layoutPreset);

    if (_layoutPreset < AMLayoutPresetCustom) {
        
        AMLayoutPresetHelper *helper = [AMLayoutPresetHelper new];
        
        NSArray *layoutTypes = [helper layoutTypesForComponent:self layoutPreset:_layoutPreset];
        NSMutableArray *layoutObjects = [NSMutableArray array];
        
        for (NSNumber *layoutType in layoutTypes) {
            
            AMLayout *layoutObject =
            [[AMLayoutFactory sharedInstance]
             buildLayoutOfType:layoutType.integerValue];
            
            [layoutObjects addObject:layoutObject];
        }
        
        self.layoutObjects = layoutObjects;
    }
}

- (void)setLayoutObjects:(NSArray *)layoutObjects {
    
    for (AMLayout *layoutObject in _layoutObjects) {
        [layoutObject clearLayout];
    }
    
    _layoutObjects = layoutObjects;
    
    [self updateProportionalLayouts];
    
    self.hasProportionalLayout = NO;
    
    for (AMLayout *layout in layoutObjects) {
        
        if (layout.isProportional) {
            self.hasProportionalLayout = YES;
            break;
        }
    }
}

- (void)setScale:(CGFloat)scale {
    _scale = scale;
    
    for (AMComponent *component in self.childComponents) {
        component.scale = scale;
    }
}

- (NSArray *)sizePresets {
    
    static NSArray *presets = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        presets =
        @[
#if !TARGET_OS_IPHONE
#define valueWithCGSize valueWithSize
#endif
          [NSValue valueWithCGSize:CGSizeMake(768.0f, 1024.0f)],
          [NSValue valueWithCGSize:CGSizeMake(414.0f, 736.0f)],
          [NSValue valueWithCGSize:CGSizeMake(375.0f, 667.0f)],
          [NSValue valueWithCGSize:CGSizeMake(320.0f, 568.0f)],
          [NSValue valueWithCGSize:CGSizeMake(320.0f, 480.0f)],
          [NSValue valueWithCGSize:CGSizeMake(512.0f, 512.0f)],
          ];
    });
    
    return presets;
}

- (void)updateProportionalLayouts {
    
    for (AMLayout *layout in self.layoutObjects) {
        
        if (self.parentComponent != nil) {
            [layout
             updateProportionalValueFromFrame:self.frame
             parentFrame:self.parentComponent.frame];
            
            for (AMComponent *childComponent in self.childComponents) {
         
                [childComponent updateProportionalLayouts];
            }
        }
    }
}

- (void)updateChildFrames {
    
    for (AMComponent *childComponent in self.childComponents) {
        [childComponent updateFrame];
    }
}

- (void)updateFrame {
    
//    NSLog(@"startingFrame: %@", NSStringFromCGRect(self.frame));
//    NSLog(@"parentFrame: %@", NSStringFromCGRect(self.parentComponent.frame));
    
    CGRect updatedFrame = self.frame;
    
    for (AMLayout *layout in self.layoutObjects) {
        
        updatedFrame =
        [layout
         adjustedFrame:updatedFrame
         forComponent:self
         scale:self.scale];
        
//        NSLog(@"%@ - %@", NSStringFromClass(layout.class), NSStringFromCGRect(updatedFrame));
    }

    updatedFrame = AMPixelAlignedCGRect(updatedFrame);
//    NSLog(@"endingFrame: %@", NSStringFromCGRect(updatedFrame));

    self.frame = updatedFrame;
    
    
    for (AMComponent *childComponent in self.childComponents) {
        [childComponent updateFrame];
    }
}

- (AMComponentBehavior *)behavor {
    
    AMComponentBehavior *result = self.behavors[@(self.componentType)];
    return result;
}

#pragma mark - Public

- (void)addBehavor:(AMComponentBehavior *)behavior {
    
    if (behavior != nil) {
        self.behavors[@(behavior.componentType)] = behavior;
    }
}

- (void)removeBehavior:(AMComponentBehavior *)behavior {
    
    if (behavior != nil) {
        [self.behavors removeObjectForKey:@(behavior.componentType)];
    }
}

- (AMComponent *)ancestorBefore:(AMComponent *)component {
    
    AMComponent *parentComponent = self.parentComponent;
    AMComponent *result = self;
    
    while (parentComponent != nil) {
        
        if ([parentComponent.identifier isEqualToString:component.identifier]) {
            return result;
        }
        
        result = parentComponent;
        parentComponent = parentComponent.parentComponent;
    }
    
    return nil;
}

- (BOOL)isDescendent:(AMComponent *)component {
    
    AMComponent *parentComponent = component.parentComponent;
    
    while (parentComponent != nil) {
        
        if ([parentComponent.identifier isEqualToString:self.identifier]) {
            return YES;
        }
        
        parentComponent = parentComponent.parentComponent;
    }
    
    return NO;
}

- (void)addChildComponent:(AMComponent *)component {
    if (component != nil) {
        [self addChildComponents:@[component]];
    }
}

- (void)addChildComponents:(NSArray *)components {

    NSMutableArray *primComponents = self.primChildComponents;

    for (AMComponent *component in components) {
        
        if ([primComponents containsObject:component] == NO) {
            [primComponents addObject:component];
        }
        
        component.parentComponent = self;
    }
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
    
    insertedComponent.parentComponent = self;
}

- (void)insertChildComponent:(AMComponent *)insertedComponent
              afterComponent:(AMComponent *)siblingComponent {
    
    NSMutableArray *primComponents = self.primChildComponents;
    
    NSUInteger pos = [primComponents indexOfObject:siblingComponent];
    
    if (pos == NSNotFound) {
        pos = primComponents.count-1;
    }
    
    pos++;
    pos = MIN(pos, primComponents.count);
    
    if ([primComponents containsObject:insertedComponent]) {
        [primComponents removeObject:insertedComponent];
    }
    
    if (pos < primComponents.count) {
        [primComponents insertObject:insertedComponent atIndex:pos];
    } else {
        [primComponents addObject:insertedComponent];
    }
    
    insertedComponent.parentComponent = self;
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
