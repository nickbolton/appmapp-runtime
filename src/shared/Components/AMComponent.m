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
#import "AMBuilderView.h"

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
NSString * kAMComponentDuplicateTypeKey = @"duplicateType";

static NSString * kAMComponentDefaultNamePrefix = @"Container-";

static NSInteger AMComponentMaxDefaultComponentNumber = 0;

@interface AMComponent()

@property (nonatomic, strong) NSMutableArray *localChildComponents;
@property (nonatomic, strong) NSArray *fullChildComponents;
@property (nonatomic, readwrite) NSString *defaultName;
@property (nonatomic, readwrite) NSString *exportedName;
@property (nonatomic, readwrite) BOOL hasProportionalLayout;
@property (nonatomic, readwrite) NSString *linkedComponentIdentifier;
@property (nonatomic, readwrite) NSString *duplicateSourceIdentifier;
@property (nonatomic, strong) NSMutableDictionary *behavors;
@property (nonatomic, strong) NSNumber *rawComponentType;
@property (nonatomic, strong) NSNumber *rawClipped;
@property (nonatomic, strong) NSNumber *rawUseCustomClass;
@property (nonatomic, strong) NSNumber *rawAlpha;
@property (nonatomic, strong) NSNumber *rawCornerRadius;
@property (nonatomic, strong) NSNumber *rawBorderWidth;
@property (nonatomic) BOOL useLocalGetters;

@end

@implementation AMComponent

@synthesize parentComponent = _parentComponent;
@synthesize name = _name;
@synthesize classPrefix = _classPrefix;
@synthesize borderColor = _borderColor;
@synthesize backgroundColor = _backgroundColor;
@synthesize textDescriptor = _textDescriptor;

- (void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeObject:self.identifier forKey:kAMComponentIdentifierKey];
    [coder encodeObject:_name forKey:kAMComponentNameKey];
    [coder encodeObject:self.rawComponentType forKey:kAMComponentTypeKey];
    [coder encodeObject:_classPrefix forKey:kAMComponentClassPrefixKey];
    [coder encodeObject:self.rawClipped forKey:kAMComponentClippedKey];
    [coder encodeObject:self.rawUseCustomClass forKey:kAMComponentUseCustomViewClassKey];
    [coder encodeObject:_backgroundColor forKey:kAMComponentBackgroundColorKey];
    [coder encodeObject:_borderColor forKey:kAMComponentBorderColorWidthKey];
    [coder encodeObject:self.rawAlpha forKey:kAMComponentAlphaKey];
    [coder encodeObject:self.rawCornerRadius forKey:kAMComponentCornerRadiusKey];
    [coder encodeObject:self.rawBorderWidth forKey:kAMComponentBorderWidthKey];
    [coder encodeObject:_textDescriptor forKey:kAMComponentTextDescriptorKey];
    [coder encodeObject:self.linkedComponent.identifier forKey:kAMComponentLinkedComponentKey];
    [coder encodeObject:self.duplicateSource.identifier forKey:kAMComponentDuplicateSourceKey];
    [coder encodeInteger:self.duplicateType forKey:kAMComponentDuplicateTypeKey];
    
    if (self.behavors.count > 0) {
        [coder encodeObject:self.behavor forKey:kAMComponentBehavorKey];
    }
    
    [coder encodeInteger:self.layoutPreset forKey:kAMComponentLayoutPresetKey];
    [coder encodeObject:self.layoutObjects forKey:kAMComponentLayoutObjectsKey];
    [coder encodeObject:self.localChildComponents forKey:kAMComponentChildComponentsKey];

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
        self.rawComponentType = [decoder decodeObjectForKey:kAMComponentTypeKey];
        self.classPrefix = [decoder decodeObjectForKey:kAMComponentClassPrefixKey];
        self.identifier = [decoder decodeObjectForKey:kAMComponentIdentifierKey];
        self.rawClipped = [decoder decodeObjectForKey:kAMComponentClippedKey];
        self.rawUseCustomClass = [decoder decodeObjectForKey:kAMComponentUseCustomViewClassKey];
        self.backgroundColor = [decoder decodeObjectForKey:kAMComponentBackgroundColorKey];
        self.rawAlpha = [decoder decodeObjectForKey:kAMComponentAlphaKey];
        self.rawCornerRadius = [decoder decodeObjectForKey:kAMComponentCornerRadiusKey];
        self.rawBorderWidth = [decoder decodeObjectForKey:kAMComponentBorderWidthKey];
        self.borderColor = [decoder decodeObjectForKey:kAMComponentBorderColorWidthKey];
        self.layoutPreset = [decoder decodeIntegerForKey:kAMComponentLayoutPresetKey];
        self.layoutObjects = [decoder decodeObjectForKey:kAMComponentLayoutObjectsKey];
        self.textDescriptor = [decoder decodeObjectForKey:kAMComponentTextDescriptorKey];
        self.linkedComponentIdentifier = [decoder decodeObjectForKey:kAMComponentLinkedComponentKey];
        self.duplicateSourceIdentifier = [decoder decodeObjectForKey:kAMComponentDuplicateSourceKey];
        self.duplicateType = [decoder decodeIntegerForKey:kAMComponentDuplicateTypeKey];
        
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
        self.rawComponentType = dict[kAMComponentTypeKey];
        self.classPrefix = dict[kAMComponentClassPrefixKey];
        self.identifier = dict[kAMComponentIdentifierKey];
        self.rawClipped = dict[kAMComponentClippedKey];
        self.rawUseCustomClass = dict[kAMComponentUseCustomViewClassKey];
        self.rawAlpha = dict[kAMComponentAlphaKey];
        self.rawCornerRadius = dict[kAMComponentCornerRadiusKey];
        self.rawBorderWidth = dict[kAMComponentBorderWidthKey];
        self.borderColor = [AMColor colorWithHexcodePlusAlpha:borderColorString];
        self.backgroundColor = [AMColor colorWithHexcodePlusAlpha:backgroundColorString];
        self.layoutPreset = [dict[kAMComponentLayoutPresetKey] integerValue];
        self.linkedComponentIdentifier = dict[kAMComponentLinkedComponentKey];
        self.duplicateSourceIdentifier = dict[kAMComponentDuplicateSourceKey];
        self.duplicateType = [dict[kAMComponentDuplicateTypeKey] integerValue];
        
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
    component.rawComponentType = self.rawComponentType;
    component.defaultName = self.defaultName.copy;
    component.classPrefix = self.classPrefix.copy;
    component.identifier = self.identifier.copy;
    component.frame = self.frame;
    component.rawClipped = self.rawClipped;
    component.rawUseCustomClass = self.rawUseCustomClass;
    component.backgroundColor = self.backgroundColor;
    component.rawAlpha = self.rawAlpha;
    component.rawBorderWidth = self.rawBorderWidth;
    component.borderColor = self.borderColor;
    component.layoutPreset = self.layoutPreset;
    component.layoutObjects = self.layoutObjects.copy;
    component.textDescriptor = self.textDescriptor.copy;
    component.linkedComponent = self.linkedComponent;
    component.duplicateSource = self.duplicateSource;
    component.duplicateType = self.duplicateType;
    
    // only used to refer back to original parent
    // children will have this reset with the next loop
    component.parentComponent = self.parentComponent;
    
    for (AMComponent *childComponent in component.childComponents) {
        childComponent.parentComponent = component;
    }
    
    NSMutableArray *children = [NSMutableArray array];

    for (AMComponent *component in self.localChildComponents) {
        [children addObject:component.copy];
    }
    component.localChildComponents = children;
    
    component.behavors = self.behavors.mutableCopy;

    return component;
}

- (instancetype)duplicateComponent:(AMComponent *)component {
    
    AMComponent *result = component.copyForPasting;
    result.parentComponent = self;
    result.duplicateType = self.duplicateType;
    
    result.identifier =
    [NSString stringWithFormat:@"%@-%@",
     self.identifier, component.identifier];

    return result;
}

- (instancetype)copyForPasting {
    
    AMComponent *result = self.copy;
    result.identifier = [[NSUUID new] UUIDString];
    result.defaultName = nil;
    
    if ([result.name hasPrefix:kAMComponentDefaultNamePrefix]) {
        result.name = nil;
    }
    
    NSMutableArray *children = [NSMutableArray array];
    
    for (AMComponent *childComponent in self.localChildComponents) {
        
        AMComponent *childCopy = [childComponent copyForPasting];
        [children addObject:childCopy];
    }
    
    [result.localChildComponents removeAllObjects];
    [result addChildComponents:children];
    
    NSMutableArray *layoutObjects = [NSMutableArray array];
    
    for (AMLayout *layoutObject in result.layoutObjects) {
        
        AMLayout *copiedObject =
        [[AMLayoutFactory sharedInstance]
         buildLayoutOfType:layoutObject.layoutType];
        
        [layoutObjects addObject:copiedObject];
    }
    
    [result setLayoutObjects:layoutObjects clearLayouts:NO];
    result.layoutObjects = layoutObjects;
    
    result.duplicateSource = self;
    
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
    dict[kAMComponentTopLevelComponentKey] = @(self.isTopLevelComponent);
    dict[kAMComponentIdentifierKey] = self.identifier;
    dict[kAMComponentLayoutPresetKey] = @(self.layoutPreset);
    dict[kAMComponentDuplicateTypeKey] = @(self.duplicateType);
    
    if (self.rawComponentType != nil) {
        dict[kAMComponentTypeKey] = self.rawComponentType;
    }

    if (self.rawClipped != nil) {
        dict[kAMComponentClippedKey] = self.rawClipped;
    }
    
    if (self.rawUseCustomClass != nil) {
        dict[kAMComponentUseCustomViewClassKey] = self.rawUseCustomClass;
    }
    
    if (self.backgroundColor != nil) {
        dict[kAMComponentBackgroundColorKey] = [self.backgroundColor hexcodePlusAlpha];
    }
    
    if (self.borderColor != nil) {
        dict[kAMComponentBorderColorWidthKey] = [self.borderColor hexcodePlusAlpha];
    }
    
    if (self.rawAlpha != nil) {
        dict[kAMComponentAlphaKey] = self.rawAlpha;
    }
    
    if (self.rawCornerRadius != nil) {
        dict[kAMComponentCornerRadiusKey] = self.rawCornerRadius;
    }
    
    if (self.rawBorderWidth != nil) {
        dict[kAMComponentBorderWidthKey] = self.rawBorderWidth;
    }
    
    if (self.linkedComponent != nil) {
        dict[kAMComponentLinkedComponentKey] = self.linkedComponent.identifier;
    }
    
    if (self.duplicateSource != nil) {
        dict[kAMComponentDuplicateSourceKey] = self.duplicateSource.identifier;
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
    
    for (AMComponent *childComponent in self.localChildComponents) {
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
    Duplicate Source: %@\
    Duplicate Type: %ld\
    LayoutPreset: %ld\
    frame: %@",
    (int)self.componentType, self, self.name, self.identifier, self.parentComponent.identifier, self.linkedComponent.identifier, self.duplicateSource.identifier, (long)self.duplicateType, (long)self.layoutPreset, frameString];
//    return [NSString stringWithFormat:@"\
//Component(%d): %p %@ %@\
//    Parent: %@\
//    Link: %@\
//    Duplicate Source: %@\
//    Duplicate Type: %ld\
//    LayoutPreset: %ld\
//    frame: %@\
//    children:\
//%@",
//    (int)self.componentType, self, self.name, self.identifier, self.parentComponent.identifier, self.linkedComponent.identifier, self.duplicateSource.identifier, self.duplicateType, self.layoutPreset, NSStringFromCGRect(self.frame), self.childComponents];
}

#pragma mark - Getters and Setters

- (BOOL)useLocalGetters {
    return (self.duplicateSource == nil || self.duplicateType != AMDuplicateTypeMirrored);
}

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

- (NSString *)classPrefix {
    
    if (self.useLocalGetters && _classPrefix != nil) {
        return _classPrefix;
    }
    
    return self.duplicateSource.classPrefix;
}

- (void)setClassPrefix:(NSString *)classPrefix {
    
    if (self.duplicateSource != nil) {
        if (self.duplicateType == AMDuplicateTypeMirrored) {
            self.duplicateSource.classPrefix = classPrefix;
            return;
        }
    }
    
    _classPrefix = classPrefix;
}

- (AMComponentType)componentType {
    
    if (self.useLocalGetters && _rawComponentType != nil) {
        return _rawComponentType.integerValue;
    }
    return self.duplicateSource.componentType;
}

- (void)setComponentType:(AMComponentType)componentType {
    
    if (self.duplicateSource != nil) {
        if (self.duplicateType == AMDuplicateTypeMirrored) {
            self.duplicateSource.componentType = componentType;
            return;
        }
    }
    
    _rawComponentType = @(componentType);
}

- (BOOL)useCustomViewClass {

    if (self.useLocalGetters && _rawUseCustomClass != nil) {
        return _rawUseCustomClass.boolValue;
    }
    return self.duplicateSource.useCustomViewClass;
}

- (void)setUseCustomViewClass:(BOOL)useCustomViewClass {
    
    if (self.duplicateSource != nil) {
        if (self.duplicateType == AMDuplicateTypeMirrored) {
            self.duplicateSource.useCustomViewClass = useCustomViewClass;
            return;
        }
    }
    
    _rawUseCustomClass = @(useCustomViewClass);
}

- (CGFloat)cornerRadius {
    
    if (self.useLocalGetters && _rawCornerRadius != nil) {
        return _rawCornerRadius.floatValue;
    }
    return self.duplicateSource.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    
    if (self.duplicateSource != nil) {
        if (self.duplicateType == AMDuplicateTypeMirrored) {
            self.duplicateSource.cornerRadius = cornerRadius;
            return;
        }
    }
    
    _rawCornerRadius = @(cornerRadius);
}

- (CGFloat)borderWidth {
    
    if (self.useLocalGetters && _rawBorderWidth != nil) {
        return _rawBorderWidth.floatValue;
    }
    return self.duplicateSource.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    
    if (self.duplicateSource != nil) {
        if (self.duplicateType == AMDuplicateTypeMirrored) {
            self.duplicateSource.borderWidth = borderWidth;
            return;
        }
    }
    
    _rawBorderWidth = @(borderWidth);
}

- (BOOL)isClipped {
    
    if (self.useLocalGetters && _rawClipped != nil) {
        return _rawClipped.boolValue;
    }
    return self.duplicateSource.isClipped;
}

- (void)setClipped:(BOOL)clipped {
    
    if (self.duplicateSource != nil) {
        if (self.duplicateType == AMDuplicateTypeMirrored) {
            self.duplicateSource.clipped = clipped;
            return;
        }
    }
    
    _rawClipped = @(clipped);
}

- (CGFloat)alpha {
    
    if (self.useLocalGetters && _rawAlpha != nil) {
        return _rawAlpha.floatValue;
    }
    return self.duplicateSource.alpha;
}

- (void)setAlpha:(CGFloat)alpha {
    
    if (self.duplicateSource != nil) {
        if (self.duplicateType == AMDuplicateTypeMirrored) {
            self.duplicateSource.alpha = alpha;
            return;
        }
    }
    
    _rawAlpha = @(alpha);
}

- (AMColor *)borderColor {
    
    if (self.useLocalGetters && _borderColor != nil) {
        return _borderColor;
    }
    return self.duplicateSource.borderColor;
}

- (void)setBorderColor:(AMColor *)borderColor {
    
    if (self.duplicateSource != nil) {
        if (self.duplicateType == AMDuplicateTypeMirrored) {
            self.duplicateSource.borderColor = borderColor;
            return;
        }
    }
    
    _borderColor = borderColor;
}

- (AMColor *)backgroundColor {
    
    if (self.useLocalGetters && _backgroundColor != nil) {
        return _backgroundColor;
    }
    return self.duplicateSource.backgroundColor;
}

- (void)setBackgroundColor:(AMColor *)backgroundColor {
    
    if (self.duplicateSource != nil) {
        if (self.duplicateType == AMDuplicateTypeMirrored) {
            self.duplicateSource.backgroundColor = backgroundColor;
            return;
        }
    }
    
    _backgroundColor = backgroundColor;
}

- (AMCompositeTextDescriptor *)textDescriptor {
    
    if (self.useLocalGetters && _textDescriptor != nil) {
        return _textDescriptor;
    }
    return self.duplicateSource.textDescriptor;
}

- (void)setTextDescriptor:(AMCompositeTextDescriptor *)textDescriptor {
 
    if (self.duplicateSource != nil) {
        if (self.duplicateType == AMDuplicateTypeMirrored) {
            self.duplicateSource.textDescriptor = textDescriptor;
            return;
        }
    }
    
    _textDescriptor = textDescriptor;
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

- (void)setLinkedComponent:(AMComponent *)linkedComponent {
    _linkedComponent = linkedComponent;
    self.linkedComponentIdentifier = linkedComponent.identifier;
}

- (void)setDuplicateSource:(AMComponent *)duplicateSource {
    _duplicateSource = duplicateSource;
    self.duplicateSourceIdentifier = duplicateSource.identifier;
}

- (AMComponent *)mirrorSource {
    
    if (self.duplicateSource != nil && self.duplicateType == AMDuplicateTypeMirrored) {
        return self.duplicateSource.mirrorSource;
    }
    
    return self;
}

- (void)setDuplicateType:(AMDuplicateType)duplicateType {
    _duplicateType = duplicateType;
    NSArray *childComponents = self.localChildComponents.copy;
    [self.localChildComponents removeAllObjects];
    
    if (duplicateType != AMDuplicateTypeMirrored) {
        [self addChildComponents:childComponents];
    }
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

- (NSArray *)ownedChildComponents {
    return self.localChildComponents.copy;
}

- (NSArray *)childComponents {

    NSMutableArray *result = [NSMutableArray array];
    
    if (self.duplicateSource != nil) {
        
        if (self.fullChildComponents != nil) {
            return self.fullChildComponents;
        }
        
        if (self.duplicateType == AMDuplicateTypeMirrored) {
            NSArray *components = [self duplicateComponents:self.duplicateSource.childComponents];
            self.fullChildComponents = components;
            return components;
        }
    }
    
    [result addObjectsFromArray:self.localChildComponents];
    
    return result;
}

- (NSArray *)duplicateComponents:(NSArray *)components {
    
    NSMutableArray *result = [NSMutableArray array];
    
    for (AMComponent *component in components) {
        
        AMComponent *duplicate = [self duplicateComponent:component];
        [result addObject:duplicate];
    }
    
    return result;
}

- (void)promoteToDuplicateSource:(AMComponent *)sourceComponent {
    
    self.duplicateSource = nil;
    self.duplicateSourceIdentifier = nil;
    
    if (self.duplicateType == AMDuplicateTypeMirrored ||
        _name == nil) {
        
        self.name = sourceComponent.name;
    }

    if (self.duplicateType == AMDuplicateTypeMirrored ||
        _classPrefix == nil) {
        
        self.classPrefix = sourceComponent.classPrefix;
    }

    if (self.duplicateType == AMDuplicateTypeMirrored ||
        _borderColor == nil) {
        
        self.borderColor = sourceComponent.borderColor;
    }

    if (self.duplicateType == AMDuplicateTypeMirrored ||
        _backgroundColor == nil) {
        
        self.backgroundColor = sourceComponent.backgroundColor;
    }

    if (self.duplicateType == AMDuplicateTypeMirrored ||
        _textDescriptor == nil) {
        
        self.textDescriptor = sourceComponent.textDescriptor;
    }

    if (self.duplicateType == AMDuplicateTypeMirrored ||
        _rawComponentType == nil) {
        
        self.rawComponentType = @(sourceComponent.componentType);
    }

    if (self.duplicateType == AMDuplicateTypeMirrored ||
        _rawClipped == nil) {
        
        self.rawClipped = @(sourceComponent.isClipped);
    }
    
    if (self.duplicateType == AMDuplicateTypeMirrored ||
        _rawUseCustomClass == nil) {
        
        self.rawUseCustomClass = @(sourceComponent.useCustomViewClass);
    }

    if (self.duplicateType == AMDuplicateTypeMirrored ||
        _rawAlpha == nil) {
        
        self.rawAlpha = @(sourceComponent.alpha);
    }

    if (self.duplicateType == AMDuplicateTypeMirrored ||
        _rawCornerRadius == nil) {
        
        self.rawCornerRadius = @(sourceComponent.cornerRadius);
    }

    if (self.duplicateType == AMDuplicateTypeMirrored ||
        _rawBorderWidth == nil) {
        
        self.rawBorderWidth = @(sourceComponent.borderWidth);
    }
    
    for (AMComponent *childComponent in sourceComponent.ownedChildComponents) {
        [self addChildComponent:childComponent];
    }
}

- (void)setChildComponents:(NSArray *)childComponents {
    
    NSMutableArray *localComponents = childComponents.mutableCopy;
    
    if (self.duplicateSource != nil) {
        if (self.duplicateType == AMDuplicateTypeMirrored) {
            self.duplicateSource.childComponents = childComponents;
            return;
        }
    }
 
    self.localChildComponents = localComponents;
}

- (NSMutableDictionary *)behavors {
    
    if (_behavors == nil) {
        _behavors = [NSMutableDictionary dictionary];
    }
    return _behavors;
}

- (NSMutableArray *)localChildComponents {
    
    if (_localChildComponents == nil) {
        _localChildComponents = [NSMutableArray array];
    }
    return _localChildComponents;
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
    [self setLayoutObjects:layoutObjects clearLayouts:YES];
}

- (void)setLayoutObjects:(NSArray *)layoutObjects clearLayouts:(BOOL)clearLayouts {

    if (clearLayouts) {
        
        for (AMLayout *layoutObject in _layoutObjects) {
            [layoutObject clearLayout];
        }
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
    
    for (AMComponent *component in self.ownedChildComponents) {
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
            
            for (AMComponent *childComponent in self.localChildComponents) {
         
                [childComponent updateProportionalLayouts];
            }
        }
    }
}

- (void)updateChildFrames {
    
    for (AMComponent *childComponent in self.localChildComponents) {
        [childComponent updateFrame];
    }
}

- (void)updateFrame {
    
    CGRect updatedFrame = self.frame;
    
    for (AMLayout *layout in self.layoutObjects) {
        
        updatedFrame =
        [layout
         adjustedFrame:updatedFrame
         forComponent:self
         scale:self.scale];
    }

    updatedFrame = AMPixelAlignedCGRect(updatedFrame);

    self.frame = updatedFrame;
    
    for (AMComponent *childComponent in self.localChildComponents) {
        [childComponent updateFrame];
    }
}

- (AMComponentBehavior *)behavor {
    
    if (self.behavors.count > 0) {
        AMComponentBehavior *result = self.behavors[@(self.componentType)];
        return result;
    }
    
    return self.duplicateSource.behavor;
}

- (NSArray *)allAncestors {
    
    NSMutableArray *result = [NSMutableArray array];
    
    AMComponent *parentComponent = self.parentComponent;
    
    while (parentComponent != nil) {
        [result addObject:parentComponent];
        parentComponent = parentComponent.parentComponent;
    }
    
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
    
    if (self.duplicateSource != nil) {
        
        if (self.duplicateType == AMDuplicateTypeMirrored) {
            [self.duplicateSource addChildComponents:components];
            return;
        }
    }

    NSMutableArray *localComponents = self.localChildComponents;

    for (AMComponent *component in components) {
        
        if ([localComponents containsObject:component] == NO) {
            [localComponents addObject:component];
        }
        
        component.parentComponent = self;
    }
}

- (void)insertChildComponent:(AMComponent *)insertedComponent
             beforeComponent:(AMComponent *)siblingComponent {
    
    if (self.duplicateSource != nil) {
        
        if (self.duplicateType == AMDuplicateTypeMirrored) {
            [self.duplicateSource insertChildComponent:insertedComponent beforeComponent:siblingComponent];
            return;
        }
    }
    
    NSMutableArray *localComponents = self.localChildComponents;

    NSUInteger pos = [localComponents indexOfObject:siblingComponent];
    
    if (pos == NSNotFound) {
        pos = 0;
    }
    
    if ([localComponents containsObject:insertedComponent]) {
        [localComponents removeObject:insertedComponent];
    }
    
    [localComponents insertObject:insertedComponent atIndex:pos];
    
    insertedComponent.parentComponent = self;
}

- (void)insertChildComponent:(AMComponent *)insertedComponent
              afterComponent:(AMComponent *)siblingComponent {
    
    if (self.duplicateSource != nil) {
        
        if (self.duplicateType == AMDuplicateTypeMirrored) {
            [self.duplicateSource insertChildComponent:insertedComponent afterComponent:siblingComponent];
            return;
        }
    }

    NSMutableArray *localComponents = self.localChildComponents;
    
    NSUInteger pos = [localComponents indexOfObject:siblingComponent];
    
    if (pos == NSNotFound) {
        pos = localComponents.count-1;
    }
    
    pos++;
    pos = MIN(pos, localComponents.count);
    
    if ([localComponents containsObject:insertedComponent]) {
        [localComponents removeObject:insertedComponent];
    }
    
    if (pos < localComponents.count) {
        [localComponents insertObject:insertedComponent atIndex:pos];
    } else {
        [localComponents addObject:insertedComponent];
    }
    
    insertedComponent.parentComponent = self;
}

- (void)removeChildComponent:(AMComponent *)component {
    if (component != nil) {
        [self removeChildComponents:@[component]];
    }
}

- (void)removeChildComponents:(NSArray *)components {
    [self.localChildComponents removeObjectsInArray:components];
    [self.duplicateSource removeChildComponents:components];
    
    [components enumerateObjectsUsingBlock:^(AMComponent *component, NSUInteger idx, BOOL *stop) {
        component.parentComponent = nil;
    }];
}

- (void)clearDuplicateCaches {
    
    self.fullChildComponents = nil;
    for (AMComponent *childComponent in self.localChildComponents) {
        [childComponent clearDuplicateCaches];
    }
}

- (BOOL)isEqualToComponent:(AMComponent *)object {
    return
    [self.identifier isEqualToString:object.identifier];
}

@end
