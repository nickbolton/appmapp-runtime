//
//  AMComponent.m
//  AppMapTest
//
//  Created by Nick Bolton on 8/1/14.
//  Copyright (c) 2014 Nick Bolton. All rights reserved.
//

#import "AMComponent.h"
#import "AppMap.h"
#import "AMView+Geometry.h"
#import "AMLayoutPresetHelper.h"
#import "AMColor+AMColor.h"
#import "AMCompositeTextDescriptor.h"
#import "AMComponentBehavior.h"
#import "AMLayout.h"

NSString *const kAMComponentIdentifierKey = @"identifier";
NSString *const kAMComponentAttributesKey = @"attributes";
NSString *const kAMComponentClassNameKey = @"class-name";
NSString *const kAMComponentsKey = @"components";
NSString *const kAMComponentChildComponentsKey = @"childComponents";
NSString *const kAMComponentTopLevelComponentKey = @"tlc";
NSString *const kAMComponentTypeKey = @"type";
NSString *const kAMComponentNameKey = @"name";
NSString *const kAMComponentBehavorKey = @"behavior";
NSString *const kAMComponentClassPrefixKey = @"classPrefix";
NSString *const kAMComponentLinkedComponentKey = @"linkedComponent";
NSString *const kAMComponentUseCustomViewClassKey = @"useCustomViewClass";
NSString *const kAMComponentTextDescriptorKey = @"textDescriptor";
NSString *const kAMComponentDuplicateTypeKey = @"duplicateType";
NSString *const kAMComponentDuplicateSourceKey = @"duplicateSource";

NSString *const kAMComponentFrameKey = @"frame";
NSString *const kAMComponentClippedKey = @"clipped";
NSString *const kAMComponentBackgroundColorKey = @"backgroundColor";
NSString *const kAMComponentBorderWidthKey = @"borderWidth";
NSString *const kAMComponentBorderColorWidthKey = @"borderColor";
NSString *const kAMComponentAlphaKey = @"alpha";
NSString *const kAMComponentCornerRadiusKey = @"cornerRadius";
NSString *const kAMComponentLayoutObjectsKey = @"layoutObjects";
NSString *const kAMComponentLayoutPresetKey = @"layoutPreset";

static NSString *const kAMComponentDefaultNamePrefix = @"Container-";
static NSInteger AMComponentMaxDefaultComponentNumber = 0;

@interface AMComponent()

@property (nonatomic, strong) NSMutableArray *primChildComponents;
@property (nonatomic, readwrite) BOOL hasProportionalLayout;
@property (nonatomic, readwrite) NSString *defaultName;
@property (nonatomic, readwrite) NSString *exportedName;
@property (nonatomic, strong) NSMutableDictionary *behavors;
@property (nonatomic, readwrite) NSString *linkedComponentIdentifier;

@end

@implementation AMComponent

@synthesize name = _name;

- (void)encodeWithCoder:(NSCoder *)coder {    
    [coder encodeObject:self.identifier forKey:kAMComponentIdentifierKey];
    [coder encodeInteger:self.componentType forKey:kAMComponentTypeKey];
    [coder encodeObject:self.name forKey:kAMComponentNameKey];
    [coder encodeObject:self.behavor forKey:kAMComponentBehavorKey];
    [coder encodeObject:self.linkedComponent.identifier forKey:kAMComponentLinkedComponentKey];
    [coder encodeObject:self.classPrefix forKey:kAMComponentClassPrefixKey];
    [coder encodeBool:self.useCustomViewClass forKey:kAMComponentUseCustomViewClassKey];
    [coder encodeObject:self.textDescriptor forKey:kAMComponentTextDescriptorKey];
    [coder encodeInteger:self.duplicateType forKey:kAMComponentDuplicateTypeKey];
    [coder encodeObject:self.childComponents forKey:kAMComponentChildComponentsKey];
    [coder encodeObject:self.duplicateSourceIdentifier forKey:kAMComponentDuplicateSourceKey];
    
    // attributes
    [coder encodeBool:self.isClipped forKey:kAMComponentClippedKey];
    [coder encodeObject:self.backgroundColor forKey:kAMComponentBackgroundColorKey];
    [coder encodeObject:self.borderColor forKey:kAMComponentBorderColorWidthKey];
    [coder encodeFloat:self.alpha forKey:kAMComponentAlphaKey];
    [coder encodeFloat:self.cornerRadius forKey:kAMComponentCornerRadiusKey];
    [coder encodeFloat:self.borderWidth forKey:kAMComponentBorderWidthKey];
    [coder encodeInteger:self.layoutPreset forKey:kAMComponentLayoutPresetKey];
    [coder encodeObject:self.layoutObjects forKey:kAMComponentLayoutObjectsKey];
    [coder encodeObject:NSStringFromCGRect(self.frame) forKey:kAMComponentFrameKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    
    if (self != nil) {
        _identifier = [decoder decodeObjectForKey:kAMComponentIdentifierKey];
        _componentType = [decoder decodeIntegerForKey:kAMComponentTypeKey];
        _name = [decoder decodeObjectForKey:kAMComponentNameKey];
        _classPrefix = [decoder decodeObjectForKey:kAMComponentClassPrefixKey];
        _useCustomViewClass = [decoder decodeBoolForKey:kAMComponentUseCustomViewClassKey];
        _linkedComponentIdentifier = [decoder decodeObjectForKey:kAMComponentLinkedComponentKey];
        _textDescriptor = [decoder decodeObjectForKey:kAMComponentTextDescriptorKey];
        _duplicateType = [decoder decodeIntegerForKey:kAMComponentDuplicateTypeKey];
        _duplicateSourceIdentifier = [decoder decodeObjectForKey:kAMComponentDuplicateSourceKey];
        
        // attributes
        _clipped = [decoder decodeBoolForKey:kAMComponentClippedKey];
        _backgroundColor = [decoder decodeObjectForKey:kAMComponentBackgroundColorKey];
        _alpha = [decoder decodeFloatForKey:kAMComponentAlphaKey];
        _cornerRadius = [decoder decodeFloatForKey:kAMComponentCornerRadiusKey];
        _borderWidth = [decoder decodeFloatForKey:kAMComponentBorderWidthKey];
        _borderColor = [decoder decodeObjectForKey:kAMComponentBorderColorWidthKey];
        _layoutPreset = [decoder decodeIntegerForKey:kAMComponentLayoutPresetKey];
        _layoutObjects = [decoder decodeObjectForKey:kAMComponentLayoutObjectsKey];
        _frame = CGRectFromString([decoder decodeObjectForKey:kAMComponentFrameKey]);
        
        AMComponentBehavior *behavior = [decoder decodeObjectForKey:kAMComponentBehavorKey];
        
        if (behavior != nil) {
            [self addBehavor:behavior];
        }

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
        _identifier = dict[kAMComponentIdentifierKey];
        _componentType = [dict[kAMComponentTypeKey] integerValue];
        _name = dict[kAMComponentNameKey];
        _classPrefix = dict[kAMComponentClassPrefixKey];
        _useCustomViewClass = [dict[kAMComponentUseCustomViewClassKey] boolValue];
        _linkedComponentIdentifier = dict[kAMComponentLinkedComponentKey];
        _duplicateType = [dict[kAMComponentDuplicateTypeKey] integerValue];
        _duplicateSourceIdentifier = dict[kAMComponentDuplicateSourceKey];
        
        NSDictionary *descriptorDict = dict[kAMComponentTextDescriptorKey];
        
        if (descriptorDict != nil) {
            _textDescriptor = [[AMCompositeTextDescriptor alloc] initWithDictionary:descriptorDict];
        }
        
        // attributes
        
        NSString *backgroundColorString = dict[kAMComponentBackgroundColorKey];
        NSString *borderColorString = dict[kAMComponentBorderColorWidthKey];
        
        _layoutPreset = [dict[kAMComponentLayoutPresetKey] integerValue];
        _clipped = [dict[kAMComponentClippedKey] boolValue];
        _alpha = [dict[kAMComponentAlphaKey] floatValue];
        _cornerRadius = [dict[kAMComponentCornerRadiusKey] floatValue];
        _borderWidth = [dict[kAMComponentBorderWidthKey] floatValue];
        _borderColor = [AMColor colorWithHexcodePlusAlpha:borderColorString];
        _backgroundColor = [AMColor colorWithHexcodePlusAlpha:backgroundColorString];
        
        _frame = CGRectFromString(dict[kAMComponentFrameKey]);
        
        // layout objects
        
        NSMutableArray *layoutObjects = [NSMutableArray array];
        NSArray *layoutObjectDicts = dict[kAMComponentLayoutObjectsKey];
        
        for (NSDictionary *dict in layoutObjectDicts) {
            
            AMLayout *layout = [AMLayout layoutWithDictionary:dict];
            [layoutObjects addObject:layout];
        }
        
        _layoutObjects = layoutObjects;
        
        // behaviors
        
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

        // children
        
        NSMutableArray *childComponents = [NSMutableArray array];
        id children = dict[kAMComponentChildComponentsKey];
        NSArray *childrenArray = nil;
        
        if ([children isKindOfClass:[NSArray class]]) {
            childrenArray = children;
        } else if ([children isKindOfClass:[NSDictionary class]]) {
            childrenArray = ((NSDictionary *)children).allValues;
        }
        
        for (NSDictionary *childDict in childrenArray) {
            
            AMComponent *childComponent = [self.class componentWithDictionary:childDict];
            [childComponents addObject:childComponent];
        }
        
        [self addChildComponents:childComponents];
        [self updateComponentMaxDefaultComponentNumber];
    }
    
    return self;
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

+ (instancetype)componentWithDictionary:(NSDictionary *)dict {
    
    NSString *className = dict[kAMComponentClassNameKey];
    AMComponent *component =
    [[NSClassFromString(className) alloc] initWithDictionary:dict];
    
    return component;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return [self copy];
}

- (instancetype)copy {
    
    AMComponent *component = [[self.class alloc] init];
    [self copyToComponent:component deep:YES];
    return component;
}

- (instancetype)shallowCopy {
    
    AMComponent *component = [[self.class alloc] init];
    [self copyToComponent:component deep:NO];
    return component;
}

- (void)copyToComponent:(AMComponent *)component {
    [self copyToComponent:component deep:YES];
}

- (void)copyToComponent:(AMComponent *)component deep:(BOOL)deep {
    component.identifier = self.identifier.copy;
    component.componentType = self.componentType;
    component.name = self.name.copy;
    component.defaultName = self.defaultName.copy;
    component.textDescriptor = self.textDescriptor.copy;
    component.duplicateType = self.duplicateType;
    component.duplicateSourceIdentifier = self.duplicateSourceIdentifier;
    component.behavors = self.behavors.mutableCopy;
    component.classPrefix = self.classPrefix.copy;
    component.useCustomViewClass = self.useCustomViewClass;
    component.linkedComponent = self.linkedComponent;
    
    // attributes
    component.clipped = self.isClipped;
    component.backgroundColor = self.backgroundColor;
    component.alpha = self.alpha;
    component.borderWidth = self.borderWidth;
    component.borderColor = self.borderColor;
    component.layoutPreset = self.layoutPreset;

    component.frame = self.frame;
    NSArray *layoutObjects = [[NSArray alloc] initWithArray:self.layoutObjects copyItems:YES];
    [component setLayoutObjects:layoutObjects clearLayouts:YES customPreset:NO];

    // only used to refer back to original parent
    // children will have this reset with the next loop
    component.parentComponent = self.parentComponent;
    
    if (deep) {
        for (AMComponent *childComponent in component.childComponents) {
            childComponent.parentComponent = component;
        }
        
        NSMutableArray *children = [NSMutableArray array];
        
        for (AMComponent *component in self.childComponents) {
            [children addObject:component.copy];
        }
        component.childComponents = children;
    }
}

- (void)resetIdentifiers:(AMComponent *)component {
    component.identifier = [[NSUUID UUID] UUIDString];
    
    for (AMLayout *layoutObject in component.layoutObjects) {
        layoutObject.componentIdentifier = nil;
        layoutObject.relatedComponentIdentifier = nil;
        layoutObject.commonAncestorComponentIdentifier = nil;
    }
    
    for (AMComponent *childComponent in component.childComponents) {
        [self resetIdentifiers:childComponent];
    }
}

- (instancetype)duplicate {
    AMComponent *result = self.copy;
    [self resetIdentifiers:result];
    
    return result;
}

- (void)augmentComponentForPasting:(AMComponent *)component sourceComponent:(AMComponent *)sourceComponent {
    
    component.duplicateSourceIdentifier = sourceComponent.identifier;
    component.defaultName = nil;
    
    if ([component.name hasPrefix:kAMComponentDefaultNamePrefix]) {
        component.name = nil;
    }
    
    NSMutableArray *children = [NSMutableArray array];
    
    for (AMComponent *childComponent in sourceComponent.childComponents) {
        
        AMComponent *childCopy = [childComponent copyForPasting];
        [children addObject:childCopy];
    }
    
    component.childComponents = children;
}

- (instancetype)copyForPasting {
    
    AMComponent *result = [self shallowCopy];
    [self augmentComponentForPasting:result sourceComponent:self];
    
    return result;
}

+ (NSDictionary *)exportComponents:(NSArray *)components {
    
    NSMutableDictionary *componentDictionaries = [NSMutableDictionary dictionary];
    
    [components enumerateObjectsUsingBlock:^(AMComponent *component, NSUInteger idx, BOOL *stop) {
        
        NSDictionary *componentDict = [component dictionaryRepresentation];
        componentDictionaries[component.identifier] = componentDict;
    }];
    
    NSDictionary *dict =
    @{
      kAMComponentsKey : componentDictionaries,
      };
    
    return dict;
}

- (NSDictionary *)dictionaryRepresentation {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[kAMComponentIdentifierKey] = self.identifier;
    dict[kAMComponentClassNameKey] = NSStringFromClass(self.class);
    dict[kAMComponentTypeKey] = @(self.componentType);
    dict[kAMComponentNameKey] = self.name;
    dict[kAMComponentDuplicateTypeKey] = @(self.duplicateType);
    dict[kAMComponentUseCustomViewClassKey] = @(self.useCustomViewClass);
    dict[kAMComponentTopLevelComponentKey] = @(self.isTopLevelComponent);
    dict[kAMComponentLayoutPresetKey] = @(self.layoutPreset);
    
    if (self.duplicateSourceIdentifier != nil) {
        dict[kAMComponentDuplicateSourceKey] = self.duplicateSourceIdentifier;
    }
 
    if (self.textDescriptor != nil) {
        dict[kAMComponentTextDescriptorKey] = [self.textDescriptor exportTextDescriptor];
    }
    
    if (self.behavor != nil) {
        dict[kAMComponentBehavorKey] = [self.behavor exportBehavior];
    }
    
    if (self.linkedComponent != nil) {
        dict[kAMComponentLinkedComponentKey] = self.linkedComponent.identifier;
    }
    
    if (self.classPrefix != nil) {
        dict[kAMComponentClassPrefixKey] = self.classPrefix;
    }
    
    NSMutableDictionary *children = [NSMutableDictionary dictionary];
    
    for (AMComponent *childComponent in self.childComponents) {
        children[childComponent.identifier] = [childComponent dictionaryRepresentation];
    }
    
    dict[kAMComponentChildComponentsKey] = children;
    
    // attributes
    
    dict[kAMComponentClippedKey] = @(self.isClipped);
    dict[kAMComponentBackgroundColorKey] = [self.backgroundColor hexcodePlusAlpha];
    dict[kAMComponentBorderColorWidthKey] = [self.borderColor hexcodePlusAlpha];
    dict[kAMComponentAlphaKey] = @(self.alpha);
    dict[kAMComponentCornerRadiusKey] = @(self.cornerRadius);
    dict[kAMComponentBorderWidthKey] = @(self.borderWidth);
    dict[kAMComponentLayoutPresetKey] = @(self.layoutPreset);
    dict[kAMComponentFrameKey] = NSStringFromCGRect(self.frame);
    
    NSMutableArray *layoutObjectDicts = [NSMutableArray array];
    
    for (AMLayout *layout in self.layoutObjects) {
        NSDictionary *dict = [layout exportLayout];
        [layoutObjectDicts addObject:dict];
    }
    
    dict[kAMComponentLayoutObjectsKey] = layoutObjectDicts;

    return dict;
}

- (NSString *)description {
    NSString *frameString = NSStringFromCGRect(self.frame);
    
    return [NSString stringWithFormat:@"\
            Instance(%d): %p %@ %@\
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

- (BOOL)isEqualToComponent:(AMComponent *)object {
    return
    [self.identifier isEqualToString:object.identifier];
}

- (BOOL)isContainer {
    return self.componentType == AMComponentContainer;
}

- (void)setFrame:(CGRect)frame {
    [self setFrame:frame inAnimation:NO];
}

- (void)setFrame:(CGRect)frame inAnimation:(BOOL)inAnimation {
    BOOL sizeChanged = (CGSizeEqualToSize(frame.size, self.frame.size) == NO);
    _frame = frame;
    
    for (AMLayout *layoutObject in self.layoutObjects) {
        layoutObject.referenceFrame = frame;
        [layoutObject updateLayoutWithFrame:frame inAnimation:inAnimation];
    }
    
    if (sizeChanged) {
//        [self updateChildFrames];
    }
}

- (void)setScale:(CGFloat)scale {
    _scale = scale;
    
    for (AMComponent *component in self.childComponents) {
        component.scale = scale;
    }
}

- (void)setLayoutPreset:(AMLayoutPreset)layoutPreset {
    _layoutPreset = layoutPreset;
    _layoutPreset = MAX(0, _layoutPreset);
    _layoutPreset = MIN(AMLayoutPresetCustom, _layoutPreset);
    
    AMLayoutPresetHelper *helper = [AMLayoutPresetHelper new];
    NSArray *layoutObjects = [helper layoutObjectsForComponent:self layoutPreset:_layoutPreset];
    [self setLayoutObjects:layoutObjects clearLayouts:YES customPreset:NO];
}

- (void)setLayoutObjects:(NSArray *)layoutObjects {
    [self setLayoutObjects:layoutObjects clearLayouts:YES customPreset:YES];
}

- (void)setLayoutObjects:(NSArray *)layoutObjects
            clearLayouts:(BOOL)clearLayouts
            customPreset:(BOOL)customPreset {
    
    if (clearLayouts) {
        
        for (AMLayout *layoutObject in _layoutObjects) {
            [layoutObject clearLayout];
        }
    }
    
    _layoutObjects = layoutObjects;

    if (customPreset) {
        _layoutPreset = AMLayoutPresetCustom;
    }
}

- (void)restoreLayoutObjects:(NSArray *)layoutObjects {
    _layoutObjects = layoutObjects.copy;
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

- (NSMutableDictionary *)behavors {
    
    if (_behavors == nil) {
        _behavors = [NSMutableDictionary dictionary];
    }
    return _behavors;
}

- (AMComponentBehavior *)behavor {
    
    AMComponentBehavior *result = self.behavors[@(self.componentType)];
    return result;
}

- (void)setLinkedComponent:(AMComponent *)linkedComponent {
    _linkedComponent = linkedComponent;
    self.linkedComponentIdentifier = linkedComponent.identifier;
}

- (BOOL)isMirrored {
    return self.duplicateType == AMDuplicateTypeMirrored;
}

- (BOOL)isCopied {
    return self.duplicateType == AMDuplicateTypeCopied;
}

- (BOOL)isInherited {
    return self.duplicateType == AMDuplicateTypeInherited;
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

#pragma mark - Parent/Child

- (NSArray *)allAncestors {
    NSMutableArray *result = [NSMutableArray new];
    [self appendAncestorOfComponent:self toArray:result];
    
    return result;
}

- (void)appendAncestorOfComponent:(AMComponent *)component toArray:(NSMutableArray *)array {
    AMComponent *parent = component.parentComponent;
    if (parent != nil) {
        [array addObject:parent];
        [self appendAncestorOfComponent:parent toArray:array];
    }
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

#pragma mark - Helpers

//- (void)updateProportionalLayouts {
//    
//    for (AMLayout *layout in self.layoutObjects) {
//        
//        if (self.parentComponent != nil) {
//            [layout
//             updateProportionalValueFromFrame:self.frame
//             parentFrame:self.parentComponent.frame];
//            
//            for (AMComponent *childComponent in self.childComponents) {
//                
//                [childComponent updateProportionalLayouts];
//            }
//        }
//    }
//}
//
//- (void)updateChildFrames {
//    
//    for (AMComponent *childComponent in self.childComponents) {
//        [childComponent updateFrame];
//    }
//}
//
//- (void)updateFrame {
//    
////        NSLog(@"startingFrame: %@", NSStringFromCGRect(self.frame));
////        NSLog(@"parentFrame: %@", NSStringFromCGRect(self.parentComponent.frame));
//    
//    CGRect updatedFrame = self.frame;
//    
//    for (AMLayout *layout in self.layoutObjects) {
//        
//        updatedFrame =
//        [layout
//         adjustedFrame:updatedFrame
//         forComponent:self
//         scale:self.scale];
//        
////                NSLog(@"%@ - %@", NSStringFromClass(layout.class), NSStringFromCGRect(updatedFrame));
//    }
//    
//    updatedFrame = AMPixelAlignedCGRect(updatedFrame);
////        NSLog(@"endingFrame: %@", NSStringFromCGRect(updatedFrame));
//    
//    self.frame = updatedFrame;
//    
//    
//    for (AMComponent *childComponent in self.childComponents) {
//        [childComponent updateFrame];
//    }
//}

@end
