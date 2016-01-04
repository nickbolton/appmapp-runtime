//
//  AMLayout.m
//  AppMap
//
//  Created by Nick Bolton on 12/28/14.
//  Copyright (c) 2014 Pixelbleed LLC. All rights reserved.
//

#import "AMLayout.h"
#import "AMExpandingLayout.h"
#import "AMLayoutComponentHelpers.h"

static NSString * kAMLayoutClassNameKey = @"className";
static NSString * kAMLayoutIdentifierKey = @"identifier";
static NSString * kAMLayoutDefaultLayoutKey = @"defaultLayout";
static NSString * kAMLayoutAttributeKey = @"attribute";
static NSString * kAMLayoutRelationKey = @"relation";
static NSString * kAMLayoutMultiplierKey = @"multiplier";
static NSString * kAMLayoutComponentIdentifierKey = @"componentIdentifier";
static NSString * kAMLayoutRelatedComponentIdentifierKey = @"relatedComponentIdentifier";
static NSString * kAMLayoutCommonAncestorComponentIdentifier = @"commonAncestorComponentIdentifier";
static NSString * kAMLayoutRelatedAttributeKey = @"relatedAttribute";
static NSString * kAMLayoutConstantKey = @"constant";
static NSString * kAMLayoutPriorityKey = @"priority";
static NSString * kAMLayoutReferenceFrameKey = @"referenceFrame";
static NSString * kAMLayoutProportionalComponentIdentifierKey = @"proportionalComponentIdentifier";
static NSString * kAMLayoutProportionalKey = @"proportional";
static NSString * kAMLayoutProportionalValueKey = @"proportionalValue";

@interface AMLayout()

@property (nonatomic, weak, readwrite) AMView<AMComponentAware> *view;
@property (nonatomic, weak, readwrite) AMView<AMComponentAware> *relatedView;
@property (nonatomic, weak, readwrite) AMView<AMComponentAware> *commonAncestorView;
@property (nonatomic, weak, readwrite) AMView<AMComponentAware> *proportionalView;

@property (nonatomic, weak, readwrite) AMComponent *component;
@property (nonatomic, weak, readwrite) AMComponent *relatedComponent;
@property (nonatomic, weak, readwrite) AMComponent *commonAncestorComponent;
@property (nonatomic, weak, readwrite) AMComponent *proportionalComponent;

@end

@implementation AMLayout

@synthesize identifier = _identifier;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.multiplier = 1.0f;
        self.priority = AMLayoutPriorityRequired;
        self.enabled = YES;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.identifier forKey:kAMLayoutIdentifierKey];
    [coder encodeBool:self.isDefaultLayout forKey:kAMLayoutDefaultLayoutKey];
    [coder encodeInteger:self.attribute forKey:kAMLayoutAttributeKey];
    [coder encodeInteger:self.relation forKey:kAMLayoutRelationKey];
    [coder encodeFloat:self.multiplier forKey:kAMLayoutMultiplierKey];
    [coder encodeObject:self.componentIdentifier forKey:kAMLayoutComponentIdentifierKey];
    [coder encodeObject:self.relatedComponentIdentifier forKey:kAMLayoutRelatedComponentIdentifierKey];
    [coder encodeObject:self.commonAncestorComponentIdentifier forKey:kAMLayoutCommonAncestorComponentIdentifier];
    [coder encodeInteger:self.relatedAttribute forKey:kAMLayoutRelatedAttributeKey];
    [coder encodeFloat:self.constant forKey:kAMLayoutConstantKey];
    [coder encodeFloat:self.priority forKey:kAMLayoutPriorityKey];
    [coder encodeObject:self.proportionalComponentIdentifier forKey:kAMLayoutProportionalComponentIdentifierKey];
    [coder encodeBool:self.isProportional forKey:kAMLayoutProportionalKey];
    [coder encodeFloat:self.proportionalValue forKey:kAMLayoutProportionalValueKey];
#if TARGET_OS_IPHONE
    [coder encodeObject:NSStringFromCGRect(self.referenceFrame) forKey:kAMLayoutReferenceFrameKey];
#else
    [coder encodeObject:NSStringFromRect(self.referenceFrame) forKey:kAMLayoutReferenceFrameKey];
#endif
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    
    if (self != nil) {
        _identifier = [decoder decodeObjectForKey:kAMLayoutIdentifierKey];
        _defaultLayout = [decoder decodeBoolForKey:kAMLayoutDefaultLayoutKey];
        _attribute = [decoder decodeIntegerForKey:kAMLayoutAttributeKey];
        _relation = [decoder decodeIntegerForKey:kAMLayoutRelationKey];
        _multiplier = [decoder decodeFloatForKey:kAMLayoutMultiplierKey];
        _componentIdentifier = [decoder decodeObjectForKey:kAMLayoutComponentIdentifierKey];
        _relatedComponentIdentifier = [decoder decodeObjectForKey:kAMLayoutRelatedComponentIdentifierKey];
        _commonAncestorComponentIdentifier = [decoder decodeObjectForKey:kAMLayoutCommonAncestorComponentIdentifier];
        _relatedAttribute = [decoder decodeIntegerForKey:kAMLayoutRelatedAttributeKey];
        _constant = [decoder decodeFloatForKey:kAMLayoutConstantKey];
        _priority = [decoder decodeFloatForKey:kAMLayoutPriorityKey];
        _proportionalComponentIdentifier = [decoder decodeObjectForKey:kAMLayoutProportionalComponentIdentifierKey];
        _proportional = [decoder decodeBoolForKey:kAMLayoutProportionalKey];
        _proportionalValue = [decoder decodeFloatForKey:kAMLayoutProportionalValueKey];
#if TARGET_OS_IPHONE
        _referenceFrame = CGRectFromString([decoder decodeObjectForKey:kAMLayoutReferenceFrameKey]);
#else
        _referenceFrame = NSRectFromString([decoder decodeObjectForKey:kAMLayoutReferenceFrameKey]);
#endif
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    
    self = [super init];
    
    if (self != nil) {
        _identifier = dict[kAMLayoutIdentifierKey];
        _defaultLayout = [dict[kAMLayoutDefaultLayoutKey] boolValue];
        _attribute = [dict[kAMLayoutAttributeKey] integerValue];
        _relation = [dict[kAMLayoutRelationKey] integerValue];
        _multiplier = [dict[kAMLayoutMultiplierKey] floatValue];
        _componentIdentifier = dict[kAMLayoutComponentIdentifierKey];
        _relatedComponentIdentifier = dict[kAMLayoutRelatedComponentIdentifierKey];
        _commonAncestorComponentIdentifier = dict[kAMLayoutCommonAncestorComponentIdentifier];
        _relatedAttribute = [dict[kAMLayoutRelatedAttributeKey] integerValue];
        _constant = [dict[kAMLayoutConstantKey] floatValue];
        _priority = [dict[kAMLayoutPriorityKey] floatValue];
        _proportionalComponentIdentifier = dict[kAMLayoutProportionalComponentIdentifierKey];
        _proportional = [dict[kAMLayoutProportionalKey] boolValue];
        _proportionalValue = [dict[kAMLayoutProportionalValueKey] floatValue];
#if TARGET_OS_IPHONE
        _referenceFrame = CGRectFromString(dict[kAMLayoutReferenceFrameKey]);
#else
        _referenceFrame = NSRectFromString(dict[kAMLayoutReferenceFrameKey]);
#endif
    }
    
    return self;
}

+ (instancetype)layoutWithDictionary:(NSDictionary *)dict {
    
    NSString *className = dict[kAMLayoutClassNameKey];
    AMLayout *layout =
    [[NSClassFromString(className) alloc] initWithDictionary:dict];
    
    return layout;
}

- (NSDictionary *)exportLayout {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[kAMLayoutClassNameKey] = NSStringFromClass(self.class);
    dict[kAMLayoutIdentifierKey] = self.identifier;
    dict[kAMLayoutDefaultLayoutKey] = @(self.isDefaultLayout);
    dict[kAMLayoutAttributeKey] = @(self.attribute);
    dict[kAMLayoutRelationKey] = @(self.relation);
    dict[kAMLayoutMultiplierKey] = @(self.multiplier);
    dict[kAMLayoutComponentIdentifierKey] = self.componentIdentifier;
    dict[kAMLayoutRelatedComponentIdentifierKey] = self.relatedComponentIdentifier;
    dict[kAMLayoutCommonAncestorComponentIdentifier] = self.commonAncestorComponentIdentifier;
    dict[kAMLayoutRelatedAttributeKey] = @(self.relatedAttribute);
    dict[kAMLayoutConstantKey] = @(self.constant);
    dict[kAMLayoutPriorityKey] = @(self.priority);
    dict[kAMLayoutProportionalComponentIdentifierKey] = self.proportionalComponentIdentifier;
    dict[kAMLayoutProportionalKey] = @(self.isProportional);
    dict[kAMLayoutProportionalValueKey] = @(self.proportionalValue);
#if TARGET_OS_IPHONE
    dict[kAMLayoutReferenceFrameKey] = NSStringFromCGRect(self.referenceFrame);
#else
    dict[kAMLayoutReferenceFrameKey] = NSStringFromRect(self.referenceFrame);
#endif

    return dict;
}

- (NSDictionary *)debuggingDictionary {
    
    NSMutableDictionary *result = [self exportLayout].mutableCopy;
    
    result[@"view"] = self.view;
    result[@"view-related"] = self.relatedView;
    result[@"view-common"] = self.commonAncestorView;
    return result;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return [self copy];
}

- (instancetype)copy {
    
    AMLayout *result = [self.class new];
    result.identifier = self.identifier;
    result.enabled = self.isEnabled;
    result.defaultLayout = self.isDefaultLayout;
    result.attribute = self.attribute;
    result.relation = self.relation;
    result.multiplier = self.multiplier;
    result.componentIdentifier = self.componentIdentifier;
    result.relatedComponentIdentifier = self.relatedComponentIdentifier;
    result.commonAncestorComponentIdentifier = self.commonAncestorComponentIdentifier;
    result.relatedAttribute = self.relatedAttribute;
    result.constant = self.constant;
    result.priority = self.priority;
    result.referenceFrame = self.referenceFrame;
    result.proportionalComponentIdentifier = self.proportionalComponentIdentifier;
    result.proportional = self.isProportional;
    result.proportionalValue = self.proportionalValue;
    result.layoutProvider = self.layoutProvider;

    return result;
}

- (NSString *)description {
    NSString *proportional = self.isProportional ? @"P " : @"";
    NSString *disabled = self.isEnabled == NO ? @"D " : @"";
    return
    [NSString stringWithFormat:@"%@ %@%@%ld->%ld %f %f",
     self.identifier, disabled, proportional, self.attribute, self.relatedAttribute, self.constant, self.proportionalValue];
}

#pragma mark - Getters and Setters

- (NSString *)viewIdentifier {
    
    if (_viewIdentifier == nil) {
        _viewIdentifier = NSStringFromClass(self.view.class);
    }
    return _viewIdentifier;
}

- (NSString *)identifier {
    
    if (_identifier == nil) {
        _identifier = [[NSUUID UUID] UUIDString];
    }
    
    return _identifier;
}

- (void)setComponentIdentifier:(NSString *)componentIdentifier {
    _componentIdentifier = componentIdentifier;
    _component = nil;
    _view = nil;
}

- (void)setRelatedComponentIdentifier:(NSString *)relatedComponentIdentifier {
    _relatedComponentIdentifier = relatedComponentIdentifier;
    _relatedComponent = nil;
    _relatedView = nil;
}

- (void)setCommonAncestorComponentIdentifier:(NSString *)commonAncestorComponentIdentifier {
    _commonAncestorComponentIdentifier = commonAncestorComponentIdentifier;
    _commonAncestorComponent = nil;
    _commonAncestorView = nil;
}

- (void)layoutViewIfNeeded {
#if TARGET_OS_IPHONE
    [self.view layoutIfNeeded];
#else
    [self.view layoutSubtreeIfNeeded];
#endif
}

- (void)setPriority:(AMLayoutPriority)priority {
    _priority = priority;
    if (self.constraint != nil) {
        [self clearLayout];
        [self addLayout];
        [self layoutViewIfNeeded];
    }
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    if (self.constraint != nil) {
        if (self.constraint.isActive != enabled) {
            self.constraint.active = enabled;
        }
    } else if (enabled) {
        [self addLayout];
    }
    [self layoutViewIfNeeded];
}

- (void)setConstant:(CGFloat)constant {
    [self setConstant:constant inAnimation:NO];
}

- (void)setConstant:(CGFloat)constant inAnimation:(BOOL)inAnimation {
    _constant = constant;
    if (self.constraint != nil && self.isEnabled) {
        if (inAnimation) {
            self.constraint.animator.constant = [self resolvedConstant];
        } else {
            self.constraint.constant = [self resolvedConstant];
        }
        [self layoutViewIfNeeded];
    }
}

- (void)changeProportional:(BOOL)proportional {

    CGFloat proportionalConstant = [self proportionalConstant];
    self.proportional = proportional;
    
    CGFloat constant = 0.0f;
    
    if (proportional) {
        if (self.proportionalComponentIdentifier.length <= 0) {
            self.proportionalComponentIdentifier = self.component.parentComponent.identifier;
        }
        
        self.proportionalValue =
        [AMLayoutComponentHelpers
         proportionalValueForComponent:self.component
         attribute:self.attribute
         proportionalComponent:self.commonAncestorComponent];
        
        proportionalConstant = [self proportionalConstant];
        
    } else {
        constant = proportionalConstant;
    }
    
    [self setConstant:constant inAnimation:NO];
    
    self.component.layoutPreset = AMLayoutPresetCustom;
}

#pragma mark - Public

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[AMLayout class]]) {
        return [self isEqualToLayout:object];
    }
    
    return NO;
}

- (BOOL)isEqualTo:(id)object {
    if ([object isKindOfClass:[AMLayout class]]) {
        return [self isEqualToLayout:object];
    }
    
    return NO;
}

- (NSUInteger)hash {
    return self.identifier.hash;
}

- (BOOL)isEqualToLayout:(AMLayout *)object {
    return [self.identifier isEqualToString:object.identifier];
}

- (AMView<AMComponentAware> *)view {
    if (_view == nil) {
        if (self.componentIdentifier != nil) {
            _view = [self.layoutProvider viewWithComponentIdentifier:self.componentIdentifier];
        }
    }
    
    return _view;
}

- (AMView<AMComponentAware> *)relatedView {
    if (_relatedView == nil && self.attribute != NSLayoutAttributeWidth && self.attribute != NSLayoutAttributeHeight) {
        _relatedView = [self.layoutProvider viewWithComponentIdentifier:self.relatedComponentIdentifier];
    }
    
    return _relatedView;
}

- (AMView<AMComponentAware> *)commonAncestorView {
    if (_commonAncestorView == nil) {
        _commonAncestorView = [self.layoutProvider viewWithComponentIdentifier:self.commonAncestorComponentIdentifier];
    }
    
    return _commonAncestorView;
}

- (AMView<AMComponentAware> *)proportionalView {
    if (_proportionalView == nil) {
        _proportionalView = [self.layoutProvider viewWithComponentIdentifier:self.proportionalComponentIdentifier];
    }
    
    return _proportionalView;
}

- (AMComponent *)component {
    if (_component == nil) {
        _component = [self.layoutProvider componentWithComponentIdentifier:self.componentIdentifier];
    }
    
    return _component;
}

- (AMComponent *)relatedComponent {
    if (_relatedComponent == nil) {
        _relatedComponent = [self.layoutProvider componentWithComponentIdentifier:self.relatedComponentIdentifier];
    }
    
    return _relatedComponent;
}

- (AMComponent *)commonAncestorComponent {
    if (_commonAncestorComponent == nil) {
        _commonAncestorComponent = [self.layoutProvider componentWithComponentIdentifier:self.commonAncestorComponentIdentifier];
    }
    
    return _commonAncestorComponent;
}

- (AMComponent *)proportionalComponent {
    if (_proportionalComponent == nil) {
        _proportionalComponent = [self.layoutProvider componentWithComponentIdentifier:self.proportionalComponentIdentifier];
    }
    
    return _proportionalComponent;
}

- (BOOL)isSizing {
    return self.attribute == NSLayoutAttributeWidth || self.attribute == NSLayoutAttributeHeight;
}

- (BOOL)isHorizontal {
    return [self.class isHorizontalLayoutType:self.attribute];
}

- (BOOL)isVertical {
    return [self.class isVerticalLayoutType:self.attribute];
}

+ (BOOL)isHorizontalLayoutType:(NSLayoutAttribute)layoutType {
    
    switch (layoutType) {
        case NSLayoutAttributeWidth:
        case NSLayoutAttributeLeft:
        case NSLayoutAttributeRight:
        case NSLayoutAttributeCenterX:
            return YES;
            break;
            
        default:
            break;
    }
    
    return NO;
}

+ (BOOL)isVerticalLayoutType:(NSLayoutAttribute)layoutType {
    
    switch (layoutType) {
        case NSLayoutAttributeHeight:
        case NSLayoutAttributeTop:
        case NSLayoutAttributeBottom:
        case NSLayoutAttributeCenterY:
            return YES;
            break;
            
        default:
            break;
    }
    
    return NO;
}

- (void)clearLayout {
    if (self.constraint != nil) {
        [self.commonAncestorView removeConstraint:self.constraint];
    }
    [self clearAllConstraints];
    self.view = nil;
    self.relatedView = nil;
    self.commonAncestorView = nil;
    self.constraint = nil;
}

- (void)clearAllConstraints {
        
    for (NSLayoutConstraint *constraint in self.view.constraints) {
        if (constraint.firstItem == self.view && constraint.secondItem == nil) {
            [self.view removeConstraint:constraint];
        }
    }
    for (NSLayoutConstraint *constraint in self.commonAncestorView.constraints) {
        if ((constraint.firstItem == self.view && constraint.secondItem == self.relatedView) ||
            (constraint.firstItem == self.relatedView && constraint.secondItem == self.view)) {
            [self.commonAncestorView removeConstraint:constraint];
        }
    }
}

- (void)addLayout {
    [self createConstraintIfNecessary];
}

- (void)updateLayoutInAnimation:(BOOL)inAnimation {
    [self createConstraintIfNecessary];
    
//    NSLog(@"update with frame: %@", NSStringFromCGRect(frame));
    
    AMComponent *component = self.component;
    AMComponent *relatedComponent = self.relatedComponent;
    
    if (component == nil) {
        return;
    }
    
    CGFloat constant = 0.0f;

    if (self.isProportional) {
        
        self.proportionalValue =
        [AMLayoutComponentHelpers
         proportionalValueForComponent:component
         attribute:self.attribute
         proportionalComponent:self.proportionalComponent];

    } else {
        constant = [self fixedLayoutOffsetForComponent:component relatedComponent:relatedComponent];
    }
    
    [self setConstant:constant inAnimation:inAnimation];
    [self layoutViewIfNeeded];
}

- (CGFloat)fixedLayoutOffsetForComponent:(AMComponent *)component
                        relatedComponent:(AMComponent *)relatedComponent {
    
    CGFloat offset = 0.0f;

    if (component.parentComponent == nil) {
        
        // top level component
        
        switch (self.attribute) {
            case NSLayoutAttributeTop:
                offset = CGRectGetMinY(component.frame);
                break;
                
            case NSLayoutAttributeLeft:
                offset = CGRectGetMinX(component.frame);
                break;
                
            case NSLayoutAttributeWidth:
                offset = CGRectGetWidth(component.frame);
                break;
                
            case NSLayoutAttributeHeight:
                offset = CGRectGetHeight(component.frame);
                break;
                
            default:
                break;
        }
        
    } else {
        
        if (self.isSizing) {
            
            switch (self.attribute) {
                case NSLayoutAttributeWidth:
                    offset = CGRectGetWidth(component.frame);
                    break;
                    
                case NSLayoutAttributeHeight:
                    offset = CGRectGetHeight(component.frame);
                    break;
                    
                default:
                    break;
            }
            
        } else {
            
            offset =
            [component
             distanceFromAttribute:self.attribute
             toComponent:relatedComponent
             relatedAttribute:self.relatedAttribute];
            
            //            NSLog(@"frame: %@, attribute: %ld, offset: %f", NSStringFromCGRect(component.frame), self.attribute, offset);
        }
    }

    return offset;
}

- (CGFloat)proportionalConstant {
    
    CGFloat result = 0.0f;
    
    if (self.isProportional) {

        result =
        [AMLayoutComponentHelpers
         proportionalConstantForComponent:self.component
         attribute:self.attribute
         proportionalComponent:self.proportionalComponent
         proportionalValue:self.proportionalValue];
    }
    
    return result;
}

#pragma mark - Constraint Creation

- (void)createConstraintIfNecessary {

    if (self.view != nil &&
        (self.constraint == nil ||
         self.constraint.multiplier != self.multiplier ||
         self.constraint.priority != self.priority)) {
            
        BOOL defaultLayoutOk =
        self.isDefaultLayout &&
        (self.relatedComponentIdentifier == nil || self.relatedView != nil);
            
        BOOL regularLayoutOk =
        (self.isDefaultLayout == NO) &&
        self.relatedComponentIdentifier != nil;
            
        if (defaultLayoutOk || regularLayoutOk) {
            self.constraint = [self buildConstraint];
            self.constraint.priority = self.priority;

            [self deactivatePreviousConstraints];
            
            [self.commonAncestorView addConstraint:self.constraint];
            [self layoutViewIfNeeded];
            
#if DEBUG
            self.constraint.identifier =
            [NSString
             stringWithFormat:@"%@:%@",
             self.viewIdentifier, NSStringFromClass(self.class)];
#endif
        }
    }
}

- (void)deactivatePreviousConstraints {
    
    if (self.isSizing) {
        for (NSLayoutConstraint *constraint in self.view.constraints) {
            if (constraint.firstItem == self.view && constraint.firstAttribute == self.attribute) {
                constraint.active = NO;
            }
        }
    } else {
        for (NSLayoutConstraint *constraint in self.relatedView.constraints) {
            if ((constraint.firstItem == self.view && constraint.firstAttribute == self.attribute) ||
                (constraint.secondItem == self.view && constraint.secondAttribute == self.attribute)) {
                constraint.active = NO;
            }
        }
    }
}

- (CGFloat)resolvedConstant {
    CGFloat constant = self.constant + [self proportionalConstant];

    return constant;
}

- (NSLayoutConstraint *)buildConstraint {
    
    CGFloat constant = [self resolvedConstant];
    
    return
    [NSLayoutConstraint
     constraintWithItem:self.view
     attribute:self.attribute
     relatedBy:self.relation
     toItem:self.relatedView
     attribute:self.relatedAttribute
     multiplier:self.multiplier
     constant:constant];
}

- (CGRect)updateFrame:(CGRect)frame
basedOnRelatedAttributeWithRelatedSize:(CGSize)relatedSize
        originalFrame:(CGRect)originalFrame
     allLayoutObjects:(NSArray *)allLayoutObjects {

    switch (self.relatedAttribute) {
        case NSLayoutAttributeTop:
            return [self updateFrame:frame basedOnRelatedTopAttributeWithRelatedSize:relatedSize originalFrame:originalFrame allLayoutObjects:allLayoutObjects];
            break;
            
        case NSLayoutAttributeLeft:
            return [self updateFrame:frame basedOnRelatedLeftAttributeWithRelatedSize:relatedSize originalFrame:originalFrame allLayoutObjects:allLayoutObjects];
            break;
            
        case NSLayoutAttributeBottom:
            return [self updateFrame:frame basedOnRelatedBottomAttributeWithRelatedSize:relatedSize originalFrame:originalFrame allLayoutObjects:allLayoutObjects];
            break;
            
        case NSLayoutAttributeRight:
            return [self updateFrame:frame basedOnRelatedRightAttributeWithRelatedSize:relatedSize originalFrame:originalFrame allLayoutObjects:allLayoutObjects];
            break;
            
        case NSLayoutAttributeCenterY:
            return [self updateFrame:frame basedOnRelatedCenterYAttributeWithRelatedSize:relatedSize originalFrame:originalFrame allLayoutObjects:allLayoutObjects];
            break;
            
        case NSLayoutAttributeCenterX:
            return [self updateFrame:frame basedOnRelatedCenterXAttributeWithRelatedSize:relatedSize originalFrame:originalFrame allLayoutObjects:allLayoutObjects];
            break;
            
        default:
            break;
    }

    return frame;
}

- (BOOL)hasLeftLayoutObject:(NSArray *)layoutObjects {
    for (AMLayout *layoutObject in layoutObjects) {
        if (layoutObject.attribute == NSLayoutAttributeLeft) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)hasTopLayoutObject:(NSArray *)layoutObjects {
    for (AMLayout *layoutObject in layoutObjects) {
        if (layoutObject.attribute == NSLayoutAttributeTop) {
            return YES;
        }
    }
    
    return NO;
}

- (CGRect)updateFrame:(CGRect)frame
basedOnRelatedTopAttributeWithRelatedSize:(CGSize)relatedSize
        originalFrame:(CGRect)originalFrame
     allLayoutObjects:(NSArray *)allLayoutObjects {
    
    CGRect result = frame;
    result.origin.y = self.constant;
    
    if (self.isProportional) {
        result.origin.y += self.proportionalValue * relatedSize.height;
    }
    
    return result;
}

- (CGRect)updateFrame:(CGRect)frame
basedOnRelatedBottomAttributeWithRelatedSize:(CGSize)relatedSize
        originalFrame:(CGRect)originalFrame
     allLayoutObjects:(NSArray *)allLayoutObjects {
    
    CGRect result = frame;
    CGFloat bottomMargin = self.constant;
    
    if (self.isProportional) {
        bottomMargin -= self.proportionalValue * relatedSize.height;
    }
    
    CGFloat maxY = relatedSize.height + bottomMargin;
    
    if ([self hasTopLayoutObject:allLayoutObjects]) {
        result.size.height = MAX(0.0f, maxY - CGRectGetMinY(result));
    } else {
        result.origin.y = maxY - CGRectGetHeight(result);
    }
    
    return result;
}

- (CGRect)updateFrame:(CGRect)frame
basedOnRelatedLeftAttributeWithRelatedSize:(CGSize)relatedSize
        originalFrame:(CGRect)originalFrame
     allLayoutObjects:(NSArray *)allLayoutObjects {
    
    CGRect result = frame;
    result.origin.x = self.constant;
    
    if (self.isProportional) {
        result.origin.x += self.proportionalValue * relatedSize.width;
    }
    
    return result;
}

- (CGRect)updateFrame:(CGRect)frame
basedOnRelatedRightAttributeWithRelatedSize:(CGSize)relatedSize
        originalFrame:(CGRect)originalFrame
     allLayoutObjects:(NSArray *)allLayoutObjects {
    
    CGRect result = frame;
    CGFloat rightMargin = self.constant;
    
    if (self.isProportional) {
        rightMargin -= self.proportionalValue * relatedSize.width;
    }
    
    CGFloat maxX = relatedSize.width + rightMargin;
    
    if ([self hasLeftLayoutObject:allLayoutObjects]) {
        result.size.width = MAX(0.0f, maxX - CGRectGetMinX(result));
    } else {
        result.origin.x = maxX - CGRectGetWidth(result);
    }
    
    return result;
}

- (CGRect)updateFrame:(CGRect)frame
basedOnRelatedCenterYAttributeWithRelatedSize:(CGSize)relatedSize
        originalFrame:(CGRect)originalFrame
     allLayoutObjects:(NSArray *)allLayoutObjects {
    
    CGRect result = frame;
    result.origin.y = self.constant;
    
    if (self.isProportional) {
        result.origin.y += (relatedSize.height / 2.0f) - self.proportionalValue * relatedSize.height - (CGRectGetHeight(originalFrame) / 2.0f);
    } else {
        result.origin.y += (relatedSize.height - CGRectGetHeight(originalFrame)) / 2.0f;
    }
    
    return result;
}

- (CGRect)updateFrame:(CGRect)frame
basedOnRelatedCenterXAttributeWithRelatedSize:(CGSize)relatedSize
        originalFrame:(CGRect)originalFrame
     allLayoutObjects:(NSArray *)allLayoutObjects {
    
    CGRect result = frame;
    result.origin.x = self.constant;
    
    if (self.isProportional) {
        result.origin.x += (relatedSize.width / 2.0f) - self.proportionalValue * relatedSize.width - (CGRectGetWidth(originalFrame) / 2.0f);
    } else {
        result.origin.x += (relatedSize.width - CGRectGetWidth(originalFrame)) / 2.0f;
    }
    
    return result;
}

@end
