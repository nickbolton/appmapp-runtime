//
//  AMLayout.m
//  AppMap
//
//  Created by Nick Bolton on 12/28/14.
//  Copyright (c) 2014 Pixelbleed LLC. All rights reserved.
//

#import "AMLayout.h"
#import "AMExpandingLayout.h"

static NSString * kAMLayoutClassNameKey = @"className";
static NSString * kAMLayoutAttributeKey = @"attribute";
static NSString * kAMLayoutRelationKey = @"relation";
static NSString * kAMLayoutMultiplierKey = @"multiplier";
static NSString * kAMLayoutComponentIdentifierKey = @"componentIdentifier";
static NSString * kAMLayoutRelatedComponentIdentifierKey = @"relatedComponentIdentifier";
static NSString * kAMLayoutCommonAncestorComponentIdentifier = @"commonAncestorComponentIdentifier";
static NSString * kAMLayoutRelatedAttributeKey = @"relatedAttribute";
static NSString * kAMLayoutOffsetKey = @"offset";
static NSString * kAMLayoutPriorityKey = @"priority";
static NSString * kAMLayoutReferenceFrameKey = @"referenceFrame";

@interface AMLayout()

@property (nonatomic, weak, readwrite) AMView *view;
@property (nonatomic, weak, readwrite) AMView *relatedView;
@property (nonatomic, weak, readwrite) AMView *commonAncestorView;

@end

@implementation AMLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.multiplier = 1.0f;
        self.priority = NSLayoutPriorityRequired;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInteger:self.attribute forKey:kAMLayoutAttributeKey];
    [coder encodeInteger:self.relation forKey:kAMLayoutRelationKey];
    [coder encodeFloat:self.multiplier forKey:kAMLayoutMultiplierKey];
    [coder encodeObject:self.componentIdentifier forKey:kAMLayoutComponentIdentifierKey];
    [coder encodeObject:self.relatedComponentIdentifier forKey:kAMLayoutRelatedComponentIdentifierKey];
    [coder encodeObject:self.commonAncestorComponentIdentifier forKey:kAMLayoutCommonAncestorComponentIdentifier];
    [coder encodeInteger:self.relatedAttribute forKey:kAMLayoutRelatedAttributeKey];
    [coder encodeFloat:self.offset forKey:kAMLayoutOffsetKey];
    [coder encodeFloat:self.priority forKey:kAMLayoutPriorityKey];
    [coder encodeObject:NSStringFromCGRect(self.referenceFrame) forKey:kAMLayoutReferenceFrameKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    
    if (self != nil) {
        _attribute = [decoder decodeIntegerForKey:kAMLayoutAttributeKey];
        _relation = [decoder decodeIntegerForKey:kAMLayoutRelationKey];
        _multiplier = [decoder decodeFloatForKey:kAMLayoutMultiplierKey];
        _componentIdentifier = [decoder decodeObjectForKey:kAMLayoutComponentIdentifierKey];
        _relatedComponentIdentifier = [decoder decodeObjectForKey:kAMLayoutRelatedComponentIdentifierKey];
        _commonAncestorComponentIdentifier = [decoder decodeObjectForKey:kAMLayoutCommonAncestorComponentIdentifier];
        _relatedAttribute = [decoder decodeIntegerForKey:kAMLayoutRelatedAttributeKey];
        _offset = [decoder decodeFloatForKey:kAMLayoutOffsetKey];
        _priority = [decoder decodeFloatForKey:kAMLayoutPriorityKey];
        _referenceFrame = CGRectFromString([decoder decodeObjectForKey:kAMLayoutReferenceFrameKey]);
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    
    self = [super init];
    
    if (self != nil) {
        _attribute = [dict[kAMLayoutAttributeKey] integerValue];
        _relation = [dict[kAMLayoutRelationKey] integerValue];
        _multiplier = [dict[kAMLayoutMultiplierKey] floatValue];
        _componentIdentifier = dict[kAMLayoutComponentIdentifierKey];
        _relatedComponentIdentifier = dict[kAMLayoutRelatedComponentIdentifierKey];
        _commonAncestorComponentIdentifier = dict[kAMLayoutCommonAncestorComponentIdentifier];
        _relatedAttribute = [dict[kAMLayoutRelatedAttributeKey] integerValue];
        _offset = [dict[kAMLayoutOffsetKey] floatValue];
        _priority = [dict[kAMLayoutPriorityKey] floatValue];
        _referenceFrame = CGRectFromString(dict[kAMLayoutReferenceFrameKey]);
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
    dict[kAMLayoutAttributeKey] = @(self.attribute);
    dict[kAMLayoutRelationKey] = @(self.relation);
    dict[kAMLayoutMultiplierKey] = @(self.multiplier);
    dict[kAMLayoutComponentIdentifierKey] = self.componentIdentifier;
    dict[kAMLayoutRelatedComponentIdentifierKey] = self.relatedComponentIdentifier;
    dict[kAMLayoutCommonAncestorComponentIdentifier] = self.commonAncestorComponentIdentifier;
    dict[kAMLayoutRelatedAttributeKey] = @(self.relatedAttribute);
    dict[kAMLayoutOffsetKey] = @(self.offset);
    dict[kAMLayoutPriorityKey] = @(self.priority);
    dict[kAMLayoutReferenceFrameKey] = NSStringFromCGRect(self.referenceFrame);
    
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
    
    AMLayout *result = [[self.class alloc] init];
    result.attribute = self.attribute;
    result.relation = self.relation;
    result.multiplier = self.multiplier;
    result.componentIdentifier = self.commonAncestorComponentIdentifier;
    result.relatedComponentIdentifier = self.relatedComponentIdentifier;
    result.commonAncestorComponentIdentifier = self.commonAncestorComponentIdentifier;
    result.relatedAttribute = self.relatedAttribute;
    result.offset = self.offset;
    result.priority = self.priority;
    result.referenceFrame = self.referenceFrame;

    return result;
}

#pragma mark - Getters and Setters

- (NSString *)viewIdentifier {
    
    if (_viewIdentifier == nil) {
        _viewIdentifier = NSStringFromClass(self.view.class);
    }
    return _viewIdentifier;
}

- (void)setPriority:(NSLayoutPriority)priority {
    _priority = priority;
    self.constraint.priority = priority;
    [self.view layoutIfNeeded];
}

- (void)setOffset:(CGFloat)offset {
}

- (void)setOffset:(CGFloat)offset inAnimation:(BOOL)inAnimation {
    _offset = offset;
    if (inAnimation) {
        self.constraint.animator.constant = offset;
    } else {
        self.constraint.constant = offset;
    }
    [self.view layoutIfNeeded];
}

- (void)setComponentIdentifier:(NSString *)componentIdentifier {
    _componentIdentifier = componentIdentifier;
}

- (void)setRelatedComponentIdentifier:(NSString *)relatedComponentIdentifier {
    _relatedComponentIdentifier = relatedComponentIdentifier;
}

#pragma mark - Public

- (AMView *)view {
    if (_view == nil) {
        _view = [self.viewProvider viewWithComponentIdentifier:self.componentIdentifier];
    }
    
    return _view;
}

- (AMView *)relatedView {
    if (_relatedView == nil && self.attribute != NSLayoutAttributeWidth && self.attribute != NSLayoutAttributeHeight) {
        _relatedView = [self.viewProvider viewWithComponentIdentifier:self.relatedComponentIdentifier];
    }
    
    return _relatedView;
}

- (AMView *)commonAncestorView {
    if (_commonAncestorView == nil) {
        _commonAncestorView = [self.viewProvider viewWithComponentIdentifier:self.commonAncestorComponentIdentifier];
    }
    
    return _commonAncestorView;
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
    self.view = nil;
    self.relatedView = nil;
    self.commonAncestorView = nil;
    self.constraint = nil;
}

- (void)addLayout {
    [self createConstraintIfNecessary];
    self.constraint.priority = self.priority;
}

- (void)updateLayoutWithFrame:(CGRect)frame
                  inAnimation:(BOOL)inAnimation {
    [self createConstraintIfNecessary];
    self.constraint.priority = self.priority;
    
//    NSLog(@"update with frame: %@", NSStringFromCGRect(frame));
    
    switch (self.attribute) {
        case NSLayoutAttributeLeft:
            [self setOffset:CGRectGetMinX(frame) inAnimation:inAnimation];
            break;
            
        case NSLayoutAttributeTop:
            [self setOffset:CGRectGetMinY(frame) inAnimation:inAnimation];
            break;
            
        case NSLayoutAttributeWidth:
            [self setOffset:CGRectGetWidth(frame) inAnimation:inAnimation];
            break;

        case NSLayoutAttributeHeight:
            [self setOffset:CGRectGetHeight(frame) inAnimation:inAnimation];
            break;

        default:
            break;
    }
    
    [self.view layoutIfNeeded];
}

- (CGRect)adjustedFrame:(CGRect)frame
           forComponent:(AMComponent *)component
                  scale:(CGFloat)scale {
    return [self adjustedFrame:frame forComponent:component maintainSize:NO scale:scale];
}

- (CGRect)adjustedFrame:(CGRect)frame
           forComponent:(AMComponent *)component
           maintainSize:(BOOL)maintainSize
                  scale:(CGFloat)scale {
    return frame;
}

- (void)createConstraintIfNecessary {

    if (self.view != nil &&
        (self.constraint == nil ||
         self.constraint.multiplier != self.multiplier)) {
            
        if (self.relatedComponentIdentifier == nil || self.relatedView != nil) {
            self.constraint = [self buildConstraint];

            [self deactivatePreviousConstraints];
            
            [self.commonAncestorView addConstraint:self.constraint];
            [self.view layoutIfNeeded];
            
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

- (NSLayoutConstraint *)buildConstraint {
    return
    [NSLayoutConstraint
     constraintWithItem:self.view
     attribute:self.attribute
     relatedBy:self.relation
     toItem:self.relatedView
     attribute:self.relatedAttribute
     multiplier:self.multiplier
     constant:self.offset];
}

@end
