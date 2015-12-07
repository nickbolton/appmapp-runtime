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
NSString * kAMComponentBehavorKey = @"behavior";
NSString * kAMComponentClassPrefixKey = @"classPrefix";
NSString * kAMComponentLinkedComponentKey = @"linkedComponent";
NSString * kAMComponentUseCustomViewClassKey = @"useCustomViewClass";
NSString * kAMComponentTextDescriptorKey = @"textDescriptor";
NSString * kAMComponentDuplicateTypeKey = @"duplicateType";
NSString * kAMComponentOriginalIdentifierKey = @"originalIdentifier";
NSString * kAMComponentSourceDescriptorKey = @"sourceDescriptor";
NSString * kAMComponentOriginalDescriptorKey = @"originalDescriptor";

NSString * kAMComponentOverridingFrameKey = @"overridingFrame";
NSString * kAMComponentOverridingCornerRadiusKey = @"overridingCornerRadius";
NSString * kAMComponentOverridingBorderWidthKey = @"overridingBorderWidth";
NSString * kAMComponentOverridingClippedKey = @"overridingClipped";
NSString * kAMComponentOverridingAlphaKey = @"overridingAlpha";
NSString * kAMComponentOverridingBorderColorKey = @"overridingBorderColor";
NSString * kAMComponentOverridingBackgroundColorKey = @"overridingBackgroundColor";
NSString * kAMComponentOverridingLayoutPresetKey = @"overridingLayoutPreset";

static NSString * kAMComponentDefaultNamePrefix = @"Container-";
static NSInteger AMComponentMaxDefaultComponentNumber = 0;

@interface AMComponentInstance()

@property (nonatomic, readwrite) NSString *descriptorIdentifier;
@property (nonatomic, readwrite) NSString *defaultName;
@property (nonatomic, readwrite) NSString *exportedName;
@property (nonatomic, strong) NSMutableDictionary *behavors;
@property (nonatomic, readwrite) NSString *linkedComponentIdentifier;
@property (nonatomic, readwrite) NSString *originalIdentifier;
@property (nonatomic, readwrite) NSString *sourceDescriptorIdentifier;

@property (nonatomic, strong) NSString *overridingFrameString;
@property (nonatomic, strong) NSNumber *overridingCornerRadius;
@property (nonatomic, strong) NSNumber *overridingBorderWidth;
@property (nonatomic, strong) NSNumber *overridingClipped;
@property (nonatomic, strong) NSNumber *overridingAlpha;
@property (nonatomic, strong) NSNumber *overridingLayoutPreset;
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
    [coder encodeObject:self.linkedComponent.identifier forKey:kAMComponentLinkedComponentKey];
    [coder encodeObject:self.classPrefix forKey:kAMComponentClassPrefixKey];
    [coder encodeBool:self.useCustomViewClass forKey:kAMComponentUseCustomViewClassKey];
    [coder encodeObject:self.textDescriptor forKey:kAMComponentTextDescriptorKey];
    [coder encodeInteger:self.duplicateType forKey:kAMComponentDuplicateTypeKey];
    [coder encodeObject:self.originalIdentifier forKey:kAMComponentOriginalIdentifierKey];
    [coder encodeObject:self.sourceDescriptorIdentifier forKey:kAMComponentSourceDescriptorKey];
    [coder encodeObject:self.originalDescriptorIdentifier forKey:kAMComponentOriginalDescriptorKey];

    [coder encodeObject:self.overridingFrameString forKey:kAMComponentOverridingFrameKey];
    [coder encodeObject:self.overridingCornerRadius forKey:kAMComponentOverridingCornerRadiusKey];
    [coder encodeObject:self.overridingBorderWidth forKey:kAMComponentOverridingBorderWidthKey];
    [coder encodeObject:self.overridingClipped forKey:kAMComponentOverridingClippedKey];
    [coder encodeObject:self.overridingAlpha forKey:kAMComponentOverridingAlphaKey];
    [coder encodeObject:self.overridingBorderColor forKey:kAMComponentOverridingBorderColorKey];
    [coder encodeObject:self.overridingBackgroundColor forKey:kAMComponentOverridingBackgroundColorKey];
    [coder encodeObject:self.overridingLayoutPreset forKey:kAMComponentOverridingLayoutPresetKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super initWithCoder:decoder];
    
    if (self != nil) {
        self.descriptorIdentifier = [decoder decodeObjectForKey:kAMComponentDescriptorKey];
        self.name = [decoder decodeObjectForKey:kAMComponentNameKey];
        self.classPrefix = [decoder decodeObjectForKey:kAMComponentClassPrefixKey];
        self.useCustomViewClass = [decoder decodeBoolForKey:kAMComponentUseCustomViewClassKey];
        self.linkedComponentIdentifier = [decoder decodeObjectForKey:kAMComponentLinkedComponentKey];
        self.textDescriptor = [decoder decodeObjectForKey:kAMComponentTextDescriptorKey];
        self.duplicateType = [decoder decodeIntegerForKey:kAMComponentDuplicateTypeKey];
        self.originalIdentifier = [decoder decodeObjectForKey:kAMComponentOriginalIdentifierKey];
        self.sourceDescriptorIdentifier = [decoder decodeObjectForKey:kAMComponentSourceDescriptorKey];
        self.originalDescriptorIdentifier = [decoder decodeObjectForKey:kAMComponentOriginalDescriptorKey];
        
        self.overridingFrameString = [decoder decodeObjectForKey:kAMComponentOverridingFrameKey];
        self.overridingCornerRadius = [decoder decodeObjectForKey:kAMComponentOverridingCornerRadiusKey];
        self.overridingBorderWidth = [decoder decodeObjectForKey:kAMComponentOverridingBorderWidthKey];
        self.overridingClipped = [decoder decodeObjectForKey:kAMComponentOverridingClippedKey];
        self.overridingAlpha = [decoder decodeObjectForKey:kAMComponentOverridingAlphaKey];
        self.overridingBorderColor = [decoder decodeObjectForKey:kAMComponentOverridingBorderColorKey];
        self.overridingBackgroundColor = [decoder decodeObjectForKey:kAMComponentOverridingBackgroundColorKey];
        self.overridingLayoutPreset = [decoder decodeObjectForKey:kAMComponentOverridingLayoutPresetKey];
        
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
        self.classPrefix = dict[kAMComponentClassPrefixKey];
        self.useCustomViewClass = [dict[kAMComponentUseCustomViewClassKey] boolValue];
        self.linkedComponentIdentifier = dict[kAMComponentLinkedComponentKey];
        self.duplicateType = [dict[kAMComponentDuplicateTypeKey] integerValue];
        self.originalIdentifier = dict[kAMComponentOriginalIdentifierKey];
        self.sourceDescriptorIdentifier = dict[kAMComponentSourceDescriptorKey];
        self.originalDescriptorIdentifier = dict[kAMComponentOriginalDescriptorKey];
        
        self.overridingFrameString = dict[kAMComponentOverridingFrameKey];
        self.overridingCornerRadius = dict[kAMComponentOverridingCornerRadiusKey];
        self.overridingBorderWidth = dict[kAMComponentOverridingBorderWidthKey];
        self.overridingClipped = dict[kAMComponentOverridingClippedKey];
        self.overridingAlpha = dict[kAMComponentOverridingAlphaKey];
        self.overridingLayoutPreset = dict[kAMComponentOverridingLayoutPresetKey];
        
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
    [self copyToComponent:component];
    component.defaultName = self.defaultName.copy;
    component.textDescriptor = self.textDescriptor.copy;
    component.duplicateType = self.duplicateType;
    component.originalIdentifier = self.originalIdentifier.copy;
    component.sourceDescriptorIdentifier = self.sourceDescriptorIdentifier.copy;
    component.originalDescriptorIdentifier = self.originalDescriptorIdentifier.copy;
    component.overridingFrameString = self.overridingFrameString.copy;
    component.overridingCornerRadius = self.overridingCornerRadius;
    component.overridingBorderWidth = self.overridingBorderWidth;
    component.overridingClipped = self.overridingClipped;
    component.overridingAlpha = self.overridingAlpha;
    component.overridingBorderColor = self.overridingBorderColor;
    component.overridingBackgroundColor = self.overridingBackgroundColor;
    component.overridingLayoutPreset = self.overridingLayoutPreset;

    component.behavors = self.behavors.mutableCopy;

    component.classPrefix = self.classPrefix.copy;
    component.useCustomViewClass = self.useCustomViewClass;
    component.linkedComponent = self.linkedComponent;
    
    return component;
}

- (instancetype)copyForPasting {
    
    AMComponentInstance *result = self.copy;

    result.defaultName = nil;
    result.layoutObjects = nil;
    result.layoutPreset = result.layoutPreset;
    
    if (result.sourceDescriptorIdentifier == nil) {
        result.sourceDescriptorIdentifier = self.descriptor.identifier;
    }
    
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
    
    dict[kAMComponentDescriptorKey] = self.descriptor.identifier;
    dict[kAMComponentDuplicateTypeKey] = @(self.duplicateType);
    
    if (self.originalIdentifier != nil) {
        dict[kAMComponentOriginalIdentifierKey] = self.originalIdentifier;
    }
    
    if (self.sourceDescriptorIdentifier != nil) {
        dict[kAMComponentSourceDescriptorKey] = self.sourceDescriptorIdentifier;
    }

    if (self.originalDescriptorIdentifier != nil) {
        dict[kAMComponentOriginalDescriptorKey] = self.originalDescriptorIdentifier;
    }

    if (self.overridingFrameString != nil) {
        dict[kAMComponentOverridingFrameKey] = self.overridingFrameString;
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
    
    if (self.overridingLayoutPreset != nil) {
        dict[kAMComponentOverridingLayoutPresetKey] = self.overridingLayoutPreset;
    }

    if (self.textDescriptor != nil) {
        dict[kAMComponentTextDescriptorKey] = [self.textDescriptor exportTextDescriptor];
    }

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
    
    return component;
}

#pragma mark - Getters and Setters

- (void)setDuplicateType:(AMDuplicateType)duplicateType {
    _duplicateType = duplicateType;
}

- (void)setIdentifier:(NSString *)identifier {
    super.identifier = identifier;
    if (self.originalIdentifier == nil) {
        self.originalIdentifier = identifier;
    }
}

- (void)setDescriptor:(AMComponentDescriptor *)descriptor {
    CGRect oldFrame = self.frame;
    BOOL overrideFrame = self.isInherited && _descriptor != nil && [_descriptor isEqualToComponent:descriptor] == NO;
    _descriptor = descriptor;
    self.descriptorIdentifier = descriptor.identifier;
    if (self.originalDescriptorIdentifier == nil) {
        self.originalDescriptorIdentifier = self.descriptorIdentifier;
    }
    
    if (overrideFrame) {
        self.frame = oldFrame;
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

- (AMComponentInstance *)parentInstance {
    return (id)self.parentComponent;
}

- (void)setLinkedComponent:(AMComponentInstance *)linkedComponent {
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

#pragma mark - Descriptor Overrides

- (CGRect)frame {
    if (self.overridingFrameString != nil) {
        return CGRectFromString(self.overridingFrameString);
    }
    return self.descriptor.frame;
}

- (void)setFrame:(CGRect)frame {
    if (self.isInherited) {
        BOOL sizeChanged = (CGSizeEqualToSize(frame.size, self.frame.size) == NO);
        
        if (CGRectEqualToRect(frame, self.descriptor.frame)) {
            self.overridingFrameString = nil;
        } else {
            self.overridingFrameString = NSStringFromCGRect(frame);
        }
        if (sizeChanged) {
            [self updateChildFrames];
        }
    } else {
        self.descriptor.frame = frame;
    }
}

//- (AMComponentInstance *)parentComponent {
//    if (self.isInherited && super.parentComponent != nil) {
//        return (id)super.parentComponent;
//    }
//    
//    if (self.descriptor.parentComponent != nil) {
//        AMComponentInstance *parentInstance =
//        [self componentInstanceFromDescriptor:(id)self.descriptor.parentComponent];
//        return parentInstance;
//    }
//    
//    return nil;
//}
//
//- (void)setParentComponent:(AMComponentInstance *)parentComponent {
//    
//    if (self.isInherited) {
//        super.parentComponent = parentComponent;
//    } else {
//        self.descriptor.parentComponent = parentComponent.descriptor;
//    }
//    
//    if (parentComponent == nil) {
//        self.useCustomViewClass = YES;
//    }
//}

- (AMLayoutPreset)layoutPreset {
    if (self.overridingLayoutPreset != nil) {
        return self.overridingLayoutPreset.integerValue;
    }
    return self.descriptor.layoutPreset;
}

- (void)setLayoutPreset:(AMLayoutPreset)layoutPreset {
    if (self.isInherited) {
        if (layoutPreset != self.descriptor.layoutPreset) {
            self.overridingLayoutPreset = @(layoutPreset);
        } else {
            self.overridingLayoutPreset = nil;
        }
    } else {
        self.descriptor.layoutPreset = layoutPreset;
    }
}

- (NSArray *)layoutObjects {
    if (self.isInherited && super.layoutObjects.count > 0) {
        return super.layoutObjects;
    }
    return self.descriptor.layoutObjects;
}

- (void)setLayoutObjects:(NSArray *)layoutObjects {
    for (AMLayout *layoutObject in self.layoutObjects) {
        [layoutObject clearLayout];
    }
    
    if (self.isInherited) {
        if ([layoutObjects isEqualToArray:self.descriptor.layoutObjects]) {
            super.layoutObjects = nil;
        } else {
            super.layoutObjects = layoutObjects;
        }
    } else {
        self.descriptor.layoutObjects = layoutObjects;
    }
}

- (CGFloat)cornerRadius {
    if (self.overridingCornerRadius != nil) {
        return self.overridingCornerRadius.floatValue;
    }
    return self.descriptor.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    if (self.isInherited) {
        if (cornerRadius != self.descriptor.cornerRadius) {
            self.overridingCornerRadius = @(cornerRadius);
        } else {
            self.overridingCornerRadius = nil;
        }
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
        if (borderWidth != self.descriptor.borderWidth) {
            self.overridingBorderWidth = @(borderWidth);
        } else {
            self.overridingBorderWidth = nil;
        }
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
        if (clipped != self.descriptor.isClipped) {
            self.overridingClipped = @(clipped);
        } else {
            self.overridingClipped = nil;
        }
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
        if (alpha != self.descriptor.alpha) {
            self.overridingAlpha = @(alpha);
        } else {
            self.overridingAlpha = nil;
        }
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
        if ([borderColor isEqual:self.descriptor.borderColor] == NO) {
            self.overridingBorderColor = borderColor;
        } else {
            self.overridingBorderColor = nil;
        }
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
        if ([backgroundColor isEqual:self.descriptor.backgroundColor] == NO) {
            self.overridingBackgroundColor = backgroundColor;
        } else {
            self.overridingBackgroundColor = nil;
        }
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

- (instancetype)duplicate {
    AMComponentInstance *result = self.copy;
    result.identifier = [[NSUUID UUID] UUIDString];
    result.originalIdentifier = result.identifier;
    
    return result;
}


#pragma mark - Parent/Child

//- (AMComponentInstance *)componentInstanceFromDescriptor:(AMComponentDescriptor *)descriptor {
//    AMComponentInstance *instance = [AMComponentInstance new];
//    instance.descriptor = descriptor;
//    instance.identifier = descriptor.identifier;
//    return instance;
//}
//
//- (NSArray *)childComponents {
//    NSMutableArray *result = [NSMutableArray new];
//    for (AMComponentDescriptor *descriptor in self.descriptor.childComponents) {
//        AMComponentInstance *instance = [self componentInstanceFromDescriptor:descriptor];
//        instance.parentComponent = self;
//        [result addObject:instance];
//    }
//    
//    if (self.isInherited) {
//        [result addObjectsFromArray:super.childComponents];
//    }
//    return result.copy;
//}
//
//- (void)setChildComponents:(NSArray *)childComponents {
//    
//    if (self.isInherited) {
//        super.childComponents = childComponents;
//    } else {
//        self.descriptor.childComponents = [childComponents valueForKey:@"descriptor"];
//    }
//}
//
//- (void)addChildComponent:(AMComponentElement *)component {
//    
//    if ([component isKindOfClass:[AMComponentInstance class]]) {
//        AMComponentInstance *instance = (id)component;
//        
//        if (self.isInherited) {
//            [self addChildComponents:@[instance]];
//        } else {
//            [self.descriptor addChildComponent:instance.descriptor];
//        }
//    }
//}
//
//- (void)addChildComponents:(NSArray *)components {
//    if (self.isInherited) {
//        [super addChildComponents:components];
//    } else {
//        [self.descriptor addChildComponents:[components valueForKey:@"descriptor"]];
//    }
//}
//
//- (void)insertChildComponent:(AMComponentInstance *)insertedComponent
//             beforeComponent:(AMComponentInstance *)siblingComponent {
//    if (self.isInherited) {
//        [super insertChildComponent:insertedComponent beforeComponent:siblingComponent];
//    } else {
//        [self.descriptor insertChildComponent:insertedComponent.descriptor beforeComponent:siblingComponent.descriptor];
//    }
//}
//
//- (void)insertChildComponent:(AMComponentInstance *)insertedComponent
//              afterComponent:(AMComponentInstance *)siblingComponent {
//    if (self.isInherited) {
//        [super insertChildComponent:insertedComponent afterComponent:siblingComponent];
//    } else {
//        [self.descriptor insertChildComponent:insertedComponent.descriptor afterComponent:siblingComponent.descriptor];
//    }
//}
//
//- (void)removeChildComponent:(AMComponentInstance *)component {
//    if (component != nil) {
//        [self removeChildComponents:@[component]];
//        [self.descriptor removeChildComponent:component];
//    }
//}
//
//- (void)removeChildComponents:(NSArray *)components {
//    [super removeChildComponents:components];
//    [self.descriptor removeChildComponents:[components valueForKey:@"descriptor"]];
//}

@end
