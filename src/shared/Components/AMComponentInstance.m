//
//  AMComponentInstance.m
//  AppMap
//
//  Created by Nick Bolton on 12/5/15.
//  Copyright © 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMComponentInstance.h"
#import "AMComponentDescriptor.h"
#import "AMComponentBehavior.h"
#import "AMLayout.h"
#import "AMLayoutPresetHelper.h"
#import "AMLayoutFactory.h"
#import "AMCompositeTextDescriptor.h"
#import "AMColor+AMColor.h"

NSString * kAMComponentDescriptorKey = @"descriptor";
NSString * kAMComponentNameKey = @"name";
NSString * kAMComponentFrameKey = @"frame";
NSString * kAMComponentBehavorKey = @"behavior";
NSString * kAMComponentLayoutObjectsKey = @"layoutObjects";
NSString * kAMComponentLayoutPresetKey = @"layoutPreset";
NSString * kAMComponentTopLevelComponentKey = @"tlc";
NSString * kAMComponentClassPrefixKey = @"classPrefix";
NSString * kAMComponentChildComponentsKey = @"childComponents";
NSString * kAMComponentLinkedComponentKey = @"linkedComponent";
NSString * kAMComponentUseCustomViewClassKey = @"useCustomViewClass";
NSString * kAMComponentTextDescriptorKey = @"textDescriptor";
NSString * kAMComponentDuplicateTypeKey = @"duplicateType";
NSString * kAMComponentOriginalDescriptorKey = @"originalDescriptor";

NSString * kAMComponentOverridingCornerRadiusKey = @"overridingCornerRadius";
NSString * kAMComponentOverridingBorderWidthKey = @"overridingBorderWidth";
NSString * kAMComponentOverridingClippedKey = @"overridingClipped";
NSString * kAMComponentOverridingAlphaKey = @"overridingAlpha";
NSString * kAMComponentOverridingBorderColorKey = @"overridingBorderColor";
NSString * kAMComponentOverridingBackgroundColorKey = @"overridingBackgroundColor";

static NSString * kAMComponentDefaultNamePrefix = @"Container-";
static NSInteger AMComponentMaxDefaultComponentNumber = 0;

@interface AMComponentInstance()

@property (nonatomic, strong) AMComponentDescriptor *strongDescriptor;
@property (nonatomic, readwrite) NSString *descriptorIdentifier;
@property (nonatomic, readwrite) NSString *defaultName;
@property (nonatomic, readwrite) NSString *exportedName;
@property (nonatomic, strong) NSMutableDictionary *behavors;
@property (nonatomic, readwrite) BOOL hasProportionalLayout;
@property (nonatomic, strong) NSMutableArray *primChildComponents;
@property (nonatomic, readwrite) NSString *linkedComponentIdentifier;

@property (nonatomic, strong) NSNumber *overridingCornerRadius;
@property (nonatomic, strong) NSNumber *overridingBorderWidth;
@property (nonatomic, strong) NSNumber *overridingClipped;
@property (nonatomic, strong) NSNumber *overridingAlpha;
@property (nonatomic, strong) AMColor *overridingBorderColor;
@property (nonatomic, strong) AMColor *overridingBackgroundColor;

@end

@implementation AMComponentInstance

@synthesize name = _name;

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    [coder encodeObject:self.descriptor.identifier forKey:kAMComponentDescriptorKey];
    [coder encodeObject:self.name forKey:kAMComponentNameKey];
    [coder encodeObject:self.behavor forKey:kAMComponentBehavorKey];
    [coder encodeInteger:self.layoutPreset forKey:kAMComponentLayoutPresetKey];
    [coder encodeObject:self.layoutObjects forKey:kAMComponentLayoutObjectsKey];
    [coder encodeObject:self.childComponents forKey:kAMComponentChildComponentsKey];
    [coder encodeObject:self.linkedComponent.identifier forKey:kAMComponentLinkedComponentKey];
    [coder encodeObject:self.classPrefix forKey:kAMComponentClassPrefixKey];
    [coder encodeBool:self.useCustomViewClass forKey:kAMComponentUseCustomViewClassKey];
    [coder encodeObject:self.textDescriptor forKey:kAMComponentTextDescriptorKey];
    [coder encodeInteger:self.duplicateType forKey:kAMComponentDuplicateTypeKey];
    [coder encodeObject:self.originalDescriptorIdentifier forKey:kAMComponentOriginalDescriptorKey];

    [coder encodeObject:self.overridingCornerRadius forKey:kAMComponentOverridingCornerRadiusKey];
    [coder encodeObject:self.overridingBorderWidth forKey:kAMComponentOverridingBorderWidthKey];
    [coder encodeObject:self.overridingClipped forKey:kAMComponentOverridingClippedKey];
    [coder encodeObject:self.overridingAlpha forKey:kAMComponentOverridingAlphaKey];
    [coder encodeObject:self.overridingBorderColor forKey:kAMComponentOverridingBorderColorKey];
    [coder encodeObject:self.overridingBackgroundColor forKey:kAMComponentOverridingBackgroundColorKey];

#if TARGET_OS_IPHONE
    [coder encodeObject:NSStringFromCGRect(self.frame) forKey:kAMComponentFrameKey];
#else
    [coder encodeObject:NSStringFromRect(self.frame) forKey:kAMComponentFrameKey];
#endif
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super initWithCoder:decoder];
    
    if (self != nil) {
        self.descriptorIdentifier = [decoder decodeObjectForKey:kAMComponentDescriptorKey];
        self.name = [decoder decodeObjectForKey:kAMComponentNameKey];
        self.layoutPreset = [decoder decodeIntegerForKey:kAMComponentLayoutPresetKey];
        self.layoutObjects = [decoder decodeObjectForKey:kAMComponentLayoutObjectsKey];
        self.classPrefix = [decoder decodeObjectForKey:kAMComponentClassPrefixKey];
        self.useCustomViewClass = [decoder decodeBoolForKey:kAMComponentUseCustomViewClassKey];
        self.linkedComponentIdentifier = [decoder decodeObjectForKey:kAMComponentLinkedComponentKey];
        self.textDescriptor = [decoder decodeObjectForKey:kAMComponentTextDescriptorKey];
        self.duplicateType = [decoder decodeIntegerForKey:kAMComponentDuplicateTypeKey];
        self.originalDescriptorIdentifier = [decoder decodeObjectForKey:kAMComponentOriginalDescriptorKey];
        
        self.overridingCornerRadius = [decoder decodeObjectForKey:kAMComponentOverridingCornerRadiusKey];
        self.overridingBorderWidth = [decoder decodeObjectForKey:kAMComponentOverridingBorderWidthKey];
        self.overridingClipped = [decoder decodeObjectForKey:kAMComponentOverridingClippedKey];
        self.overridingAlpha = [decoder decodeObjectForKey:kAMComponentOverridingAlphaKey];
        self.overridingBorderColor = [decoder decodeObjectForKey:kAMComponentOverridingBorderColorKey];
        self.overridingBackgroundColor = [decoder decodeObjectForKey:kAMComponentOverridingBackgroundColorKey];

#if TARGET_OS_IPHONE
        self.frame = CGRectFromString([decoder decodeObjectForKey:kAMComponentFrameKey]);
#else
        self.frame = NSRectFromString([decoder decodeObjectForKey:kAMComponentFrameKey]);
#endif
        
        NSArray *childComponents =
        [decoder decodeObjectForKey:kAMComponentChildComponentsKey];
        
        [self addChildComponents:childComponents];

        AMComponentBehavior *behavior = [decoder decodeObjectForKey:kAMComponentBehavorKey];
        
        if (behavior != nil) {
            [self addBehavor:behavior];
        }
        
        [self updateComponentMaxDefaultComponentNumber];
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    
    self = [super initWithDictionary:dict];
    
    if (self != nil) {
        self.descriptorIdentifier = dict[kAMComponentDescriptorKey];
        self.name = dict[kAMComponentNameKey];
        self.layoutPreset = [dict[kAMComponentLayoutPresetKey] integerValue];
        self.classPrefix = dict[kAMComponentClassPrefixKey];
        self.useCustomViewClass = [dict[kAMComponentUseCustomViewClassKey] boolValue];
        self.linkedComponentIdentifier = dict[kAMComponentLinkedComponentKey];
        self.duplicateType = [dict[kAMComponentDuplicateTypeKey] integerValue];
        self.originalDescriptorIdentifier = dict[kAMComponentOriginalDescriptorKey];
        
        self.overridingCornerRadius = dict[kAMComponentOverridingCornerRadiusKey];
        self.overridingBorderWidth = dict[kAMComponentOverridingBorderWidthKey];
        self.overridingClipped = dict[kAMComponentOverridingClippedKey];
        self.overridingAlpha = dict[kAMComponentOverridingAlphaKey];
        
        NSString *overridingBackgroundColorString = dict[kAMComponentOverridingBackgroundColorKey];
        if (overridingBackgroundColorString != nil) {
            self.overridingBackgroundColor = [AMColor colorWithHexcodePlusAlpha:overridingBackgroundColorString];
        }
        NSString *overridingBorderColorString = dict[kAMComponentOverridingBorderColorKey];
        if (overridingBorderColorString != nil) {
            self.overridingBorderColor = [AMColor colorWithHexcodePlusAlpha:overridingBorderColorString];
        }

        NSDictionary *descriptorDict = dict[kAMComponentTextDescriptorKey];
        
        if (descriptorDict != nil) {
            self.textDescriptor = [[AMCompositeTextDescriptor alloc] initWithDictionary:descriptorDict];
        }

#if TARGET_OS_IPHONE
        self.frame = CGRectFromString(dict[kAMComponentFrameKey]);
#else
        self.frame = NSRectFromString(dict[kAMComponentFrameKey]);
#endif
        
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
            
            AMComponentElement *childComponent = [self.class componentWithDictionary:childDict];
            [childComponents addObject:childComponent];
        }
        
        [self addChildComponents:childComponents];
        
        // layout objects
        
        NSMutableArray *layoutObjects = [NSMutableArray array];
        NSArray *layoutObjectDicts = dict[kAMComponentLayoutObjectsKey];
        
        for (NSDictionary *dict in layoutObjectDicts) {
            
            AMLayout *layout = [AMLayout layoutWithDictionary:dict];
            [layoutObjects addObject:layout];
        }
        
        self.layoutObjects = layoutObjects;
        
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

- (instancetype)copy {
    
    AMComponentInstance *component = super.copy;
    component.name = self.name.copy;
    component.descriptor = self.descriptor.copy;
    component.defaultName = self.defaultName.copy;
    component.frame = self.frame;
    component.textDescriptor = self.textDescriptor.copy;
    component.duplicateType = self.duplicateType;
    component.originalDescriptorIdentifier = self.originalDescriptorIdentifier.copy;
    component.layoutPreset = self.layoutPreset;
    component.layoutObjects = self.layoutObjects.copy;
    component.overridingCornerRadius = self.overridingCornerRadius;
    component.overridingBorderWidth = self.overridingBorderWidth;
    component.overridingClipped = self.overridingClipped;
    component.overridingAlpha = self.overridingAlpha;
    component.overridingBorderColor = self.overridingBorderColor;
    component.overridingBackgroundColor = self.overridingBackgroundColor;

    component.behavors = self.behavors.mutableCopy;

    component.classPrefix = self.classPrefix.copy;
    component.useCustomViewClass = self.useCustomViewClass;
    component.linkedComponent = self.linkedComponent;
    
    // only used to refer back to original parent
    // children will have this reset with the next loop
    component.parentComponent = self.parentComponent;
    
    for (AMComponentInstance *childComponent in component.childComponents) {
        childComponent.parentComponent = component;
    }
    
    NSMutableArray *children = [NSMutableArray array];
    
    for (AMComponentInstance *component in self.primChildComponents) {
        [children addObject:component.copy];
    }
    component.childComponents = children;

    return component;
}

- (instancetype)copyForPasting {
    
    AMComponentInstance *result = self.copy;
    result.identifier = [[NSUUID new] UUIDString];

    result.defaultName = nil;
    result.layoutObjects = nil;
    result.layoutPreset = result.layoutPreset;
    result.originalDescriptorIdentifier = self.descriptor.identifier;
    result.holdDescriptor = YES;
    
    AMComponentDescriptor *descriptor = self.descriptor.copy;
    
    if (result.duplicateType == AMDuplicateTypeCopied) {
        descriptor.identifier = [[NSUUID new] UUIDString];
    } else {
        descriptor = self.descriptor;
    }
    
    result.descriptor = descriptor;
    
    if ([result.name hasPrefix:kAMComponentDefaultNamePrefix]) {
        result.name = nil;
    }
    
    NSMutableArray *children = [NSMutableArray array];
    
    for (AMComponentInstance *childComponent in self.childComponents) {
        
        AMComponentInstance *childCopy = [childComponent copyForPasting];
        [children addObject:childCopy];
    }
    
    result.childComponents = children;

    return result;
}

- (NSDictionary *)exportComponent {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict addEntriesFromDictionary:[super exportComponent]];
    
    dict[kAMComponentNameKey] = self.name;
    
#if TARGET_OS_IPHONE
    dict[kAMComponentFrameKey] = NSStringFromCGRect(self.frame);
#else
    dict[kAMComponentFrameKey] = NSStringFromRect(self.frame);
#endif
    
    dict[kAMComponentDescriptorKey] = self.descriptor.identifier;
    dict[kAMComponentLayoutPresetKey] = @(self.layoutPreset);
    dict[kAMComponentDuplicateTypeKey] = @(self.duplicateType);
    
    if (self.originalDescriptorIdentifier != nil) {
        dict[kAMComponentOriginalDescriptorKey] = self.originalDescriptorIdentifier;
    }
    
    if (self.overridingCornerRadius != nil) {
        dict[kAMComponentOverridingCornerRadiusKey] = self.overridingCornerRadius;
    }
    
    if (self.overridingBorderWidth != nil) {
        dict[kAMComponentOverridingBorderWidthKey] = self.overridingBorderWidth;
    }

    if (self.overridingClipped != nil) {
        dict[kAMComponentOverridingClippedKey] = self.overridingClipped;
    }

    if (self.overridingAlpha != nil) {
        dict[kAMComponentOverridingAlphaKey] = self.overridingAlpha;
    }

    if (self.overridingBorderColor != nil) {
        dict[kAMComponentOverridingBorderColorKey] = [self.overridingBorderColor hexcodePlusAlpha];
    }

    if (self.overridingBackgroundColor != nil) {
        dict[kAMComponentOverridingBackgroundColorKey] = [self.overridingBackgroundColor hexcodePlusAlpha];
    }

    if (self.textDescriptor != nil) {
        dict[kAMComponentTextDescriptorKey] = [self.textDescriptor exportTextDescriptor];
    }

    NSMutableArray *layoutObjectDicts = [NSMutableArray array];
    
    for (AMLayout *layout in self.layoutObjects) {
        NSDictionary *dict = [layout exportLayout];
        [layoutObjectDicts addObject:dict];
    }
    
    dict[kAMComponentLayoutObjectsKey] = layoutObjectDicts;

    if (self.behavor != nil) {
        dict[kAMComponentBehavorKey] = [self.behavor exportBehavior];
    }
    
    dict[kAMComponentUseCustomViewClassKey] = @(self.useCustomViewClass);
    dict[kAMComponentTopLevelComponentKey] = @(self.isTopLevelComponent);

    if (self.linkedComponent != nil) {
        dict[kAMComponentLinkedComponentKey] = self.linkedComponent.identifier;
    }
    
    if (self.classPrefix != nil) {
        dict[kAMComponentClassPrefixKey] = self.classPrefix;
    }
    
    NSMutableDictionary *children = [NSMutableDictionary dictionary];
    
    for (AMComponentElement *childComponent in self.childComponents) {
        children[childComponent.identifier] = [childComponent exportComponent];
    }
    
    dict[kAMComponentChildComponentsKey] = children;

    return dict;
}

- (NSString *)description {
#if TARGET_OS_IPHONE
    NSString *frameString = NSStringFromCGRect(self.frame);
#else
    NSString *frameString = NSStringFromRect(self.frame);
#endif
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

+ (AMComponentInstance *)buildComponent {
    
    AMComponentDescriptor *descriptor = [AMComponentDescriptor new];
    descriptor.identifier = [[NSUUID new] UUIDString];
    descriptor.cornerRadius = 2.0f;
    descriptor.borderWidth = 1.0f;
    descriptor.alpha = 1.0f;
    
    AMComponentInstance *component = [[self alloc] init];
    component.identifier = [[NSUUID new] UUIDString];
    component.layoutPreset = AMLayoutPresetFixedSizeNearestCorner;
    component.descriptor = descriptor;
    component.holdDescriptor = YES;
    
    return component;
}

#pragma mark - Getters and Setters

- (void)setDescriptor:(AMComponentDescriptor *)descriptor {
    _descriptor = descriptor;
    self.descriptorIdentifier = descriptor.identifier;
    if (self.holdDescriptor) {
        self.strongDescriptor = descriptor;
    }
}

- (void)setFrame:(CGRect)frame {
    
    BOOL sizeChanged = (CGSizeEqualToSize(frame.size, self.frame.size) == NO);
    _frame = frame;
    if (sizeChanged) {
        [self updateChildFrames];
    }
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

- (void)setScale:(CGFloat)scale {
    _scale = scale;
    
    for (AMComponentInstance *component in self.childComponents) {
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

- (void)setParentComponent:(AMComponentInstance *)parentComponent {
    _parentComponent = parentComponent;
    
    if (parentComponent == nil) {
        self.useCustomViewClass = YES;
    }
}

- (void)setLinkedComponent:(AMComponentInstance *)linkedComponent {
    _linkedComponent = linkedComponent;
    self.linkedComponentIdentifier = linkedComponent.identifier;
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

- (AMComponentInstance *)topLevelComponent {
    
    if (self.parentComponent != nil) {
        return self.parentComponent.topLevelComponent;
    }
    
    return self;
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

- (void)setHoldDescriptor:(BOOL)holdDescriptor {
    _holdDescriptor = holdDescriptor;
    if (holdDescriptor) {
        self.strongDescriptor = self.descriptor;
    } else {
        self.strongDescriptor = nil;
    }
}

#pragma mark - Descriptor Overrides

- (CGFloat)cornerRadius {
    if (self.overridingCornerRadius != nil) {
        return self.overridingCornerRadius.floatValue;
    }
    return self.descriptor.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    if (self.isInherited) {
        self.overridingCornerRadius = @(cornerRadius);
    } else {
        self.descriptor.cornerRadius = cornerRadius;
    }
}

- (CGFloat)borderWidth {
    if (self.overridingBorderWidth != nil) {
        return self.overridingBorderWidth.floatValue;
    }
    return self.descriptor.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    if (self.isInherited) {
        self.overridingBorderWidth = @(borderWidth);
    } else {
        self.descriptor.borderWidth = borderWidth;
    }
}

- (BOOL)isClipped {
    if (self.overridingClipped != nil) {
        return self.overridingClipped.boolValue;
    }
    return self.descriptor.isClipped;
}

- (void)setClipped:(BOOL)clipped {
    if (self.isInherited) {
        self.overridingClipped = @(clipped);
    } else {
        self.descriptor.clipped = clipped;
    }
}

- (CGFloat)alpha {
    if (self.overridingAlpha != nil) {
        return self.overridingAlpha.floatValue;
    }
    return self.descriptor.alpha;
}

- (void)setAlpha:(CGFloat)alpha {
    if (self.isInherited) {
        self.overridingAlpha = @(alpha);
    } else {
        self.descriptor.alpha = alpha;
    }
}

- (AMColor *)borderColor {
    if (self.overridingBorderColor != nil) {
        return self.overridingBorderColor;
    }
    return self.descriptor.borderColor;
}

- (void)setBorderColor:(AMColor *)borderColor {
    if (self.isInherited) {
        self.overridingBorderColor = borderColor;
    } else {
        self.descriptor.borderColor = borderColor;
    }
}

- (AMColor *)backgroundColor {
    if (self.overridingBackgroundColor != nil) {
        return self.overridingBackgroundColor;
    }
    return self.descriptor.backgroundColor;
}

- (void)setBackgroundColor:(NSColor *)backgroundColor {
    if (self.isInherited) {
        self.overridingBackgroundColor = backgroundColor;
    } else {
        self.descriptor.backgroundColor = backgroundColor;
    }
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

+ (BOOL)doesHaveCommonTopLevelComponent:(NSArray *)components {
    
    NSMutableSet *topLevelComponents = [NSMutableSet set];
    BOOL allAreTopLevelComponents = components.count > 0;
    
    for (AMComponentInstance *component in components) {
        
        [topLevelComponents addObject:component.topLevelComponent];
        if (component.parentComponent != nil) {
            allAreTopLevelComponents = NO;
        }
    }
    
    return allAreTopLevelComponents || topLevelComponents.count == 1;
}

+ (BOOL)doesHaveCommonTopLevelComponent:(NSArray *)components
                          withComponent:(AMComponentInstance *)component {
    
    NSMutableArray *allComponents = [NSMutableArray array];
    [allComponents addObjectsFromArray:components];
    
    if (component != nil) {
        [allComponents addObject:component];
    }
    
    return [self doesHaveCommonTopLevelComponent:allComponents];
}

- (AMComponentInstance *)ancestorBefore:(AMComponentInstance *)component {
    
    AMComponentInstance *parentComponent = self.parentComponent;
    AMComponentInstance *result = self;
    
    while (parentComponent != nil) {
        
        if ([parentComponent.identifier isEqualToString:component.identifier]) {
            return result;
        }
        
        result = parentComponent;
        parentComponent = parentComponent.parentComponent;
    }
    
    return nil;
}

- (BOOL)isDescendent:(AMComponentInstance *)component {
    
    AMComponentInstance *parentComponent = component.parentComponent;
    
    while (parentComponent != nil) {
        
        if ([parentComponent.identifier isEqualToString:self.identifier]) {
            return YES;
        }
        
        parentComponent = parentComponent.parentComponent;
    }
    
    return NO;
}

- (void)addChildComponent:(AMComponentInstance *)component {
    if (component != nil) {
        [self addChildComponents:@[component]];
    }
}

- (void)addChildComponents:(NSArray *)components {
    
    NSMutableArray *primComponents = self.primChildComponents;
    
    for (AMComponentInstance *component in components) {
        
        if ([primComponents containsObject:component] == NO) {
            [primComponents addObject:component];
        }
        
        component.parentComponent = self;
    }
}

- (void)insertChildComponent:(AMComponentInstance *)insertedComponent
             beforeComponent:(AMComponentInstance *)siblingComponent {
    
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

- (void)insertChildComponent:(AMComponentInstance *)insertedComponent
              afterComponent:(AMComponentInstance *)siblingComponent {
    
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

- (void)removeChildComponent:(AMComponentInstance *)component {
    if (component != nil) {
        [self removeChildComponents:@[component]];
    }
}

- (void)removeChildComponents:(NSArray *)components {
    [self.primChildComponents removeObjectsInArray:components];
    
    [components enumerateObjectsUsingBlock:^(AMComponentInstance *component, NSUInteger idx, BOOL *stop) {
        component.parentComponent = nil;
    }];
}

#pragma mark - Helpers

- (void)updateProportionalLayouts {
    
    for (AMLayout *layout in self.layoutObjects) {
        
        if (self.parentComponent != nil) {
            [layout
             updateProportionalValueFromFrame:self.frame
             parentFrame:self.parentComponent.frame];
            
            for (AMComponentInstance *childComponent in self.childComponents) {
                
                [childComponent updateProportionalLayouts];
            }
        }
    }
}

- (void)updateChildFrames {
    
    for (AMComponentInstance *childComponent in self.childComponents) {
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
    
    
    for (AMComponentInstance *childComponent in self.childComponents) {
        [childComponent updateFrame];
    }
}

@end
