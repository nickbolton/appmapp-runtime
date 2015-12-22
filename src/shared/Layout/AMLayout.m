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
static NSString * kAMLayoutProportionalKey = @"proportional";
static NSString * kAMLayoutProportionalValueKey = @"proportionalValue";

@interface AMLayout()

@property (nonatomic, weak, readwrite) AMView<AMComponentAware> *view;
@property (nonatomic, weak, readwrite) AMView<AMComponentAware> *relatedView;
@property (nonatomic, weak, readwrite) AMView<AMComponentAware> *commonAncestorView;

@end

@implementation AMLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.multiplier = 1.0f;
        self.priority = AMLayoutPriorityRequired;
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
        _attribute = [decoder decodeIntegerForKey:kAMLayoutAttributeKey];
        _relation = [decoder decodeIntegerForKey:kAMLayoutRelationKey];
        _multiplier = [decoder decodeFloatForKey:kAMLayoutMultiplierKey];
        _componentIdentifier = [decoder decodeObjectForKey:kAMLayoutComponentIdentifierKey];
        _relatedComponentIdentifier = [decoder decodeObjectForKey:kAMLayoutRelatedComponentIdentifierKey];
        _commonAncestorComponentIdentifier = [decoder decodeObjectForKey:kAMLayoutCommonAncestorComponentIdentifier];
        _relatedAttribute = [decoder decodeIntegerForKey:kAMLayoutRelatedAttributeKey];
        _offset = [decoder decodeFloatForKey:kAMLayoutOffsetKey];
        _priority = [decoder decodeFloatForKey:kAMLayoutPriorityKey];
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
        _attribute = [dict[kAMLayoutAttributeKey] integerValue];
        _relation = [dict[kAMLayoutRelationKey] integerValue];
        _multiplier = [dict[kAMLayoutMultiplierKey] floatValue];
        _componentIdentifier = dict[kAMLayoutComponentIdentifierKey];
        _relatedComponentIdentifier = dict[kAMLayoutRelatedComponentIdentifierKey];
        _commonAncestorComponentIdentifier = dict[kAMLayoutCommonAncestorComponentIdentifier];
        _relatedAttribute = [dict[kAMLayoutRelatedAttributeKey] integerValue];
        _offset = [dict[kAMLayoutOffsetKey] floatValue];
        _priority = [dict[kAMLayoutPriorityKey] floatValue];
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
    dict[kAMLayoutAttributeKey] = @(self.attribute);
    dict[kAMLayoutRelationKey] = @(self.relation);
    dict[kAMLayoutMultiplierKey] = @(self.multiplier);
    dict[kAMLayoutComponentIdentifierKey] = self.componentIdentifier;
    dict[kAMLayoutRelatedComponentIdentifierKey] = self.relatedComponentIdentifier;
    dict[kAMLayoutCommonAncestorComponentIdentifier] = self.commonAncestorComponentIdentifier;
    dict[kAMLayoutRelatedAttributeKey] = @(self.relatedAttribute);
    dict[kAMLayoutOffsetKey] = @(self.offset);
    dict[kAMLayoutPriorityKey] = @(self.priority);
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
    result.proportional = self.isProportional;
    result.proportionalValue = self.proportionalValue;

    return result;
}

#pragma mark - Getters and Setters

- (NSString *)viewIdentifier {
    
    if (_viewIdentifier == nil) {
        _viewIdentifier = NSStringFromClass(self.view.class);
    }
    return _viewIdentifier;
}

- (void)setPriority:(AMLayoutPriority)priority {
    _priority = priority;
    self.constraint.priority = priority;
#if TARGET_OS_IPHONE
    [self.view layoutIfNeeded];
#else
    [self.view layoutSubtreeIfNeeded];
#endif
}

- (void)setOffset:(CGFloat)offset {
    [self setOffset:offset proportionalOffset:0.0f inAnimation:NO];
}

- (void)setOffset:(CGFloat)offset proportionalOffset:(CGFloat)proportionalOffset inAnimation:(BOOL)inAnimation {
    _offset = offset;
    if (inAnimation) {
        self.constraint.animator.constant = [self proportionalLayoutOffset];
    } else {
        self.constraint.constant = [self proportionalLayoutOffset];
    }
#if TARGET_OS_IPHONE
    [self.view layoutIfNeeded];
#else
    [self.view layoutSubtreeIfNeeded];
#endif
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
        _view = [self.layoutProvider viewWithComponentIdentifier:self.componentIdentifier];
    }
    
    return _view;
}

- (AMView *)relatedView {
    if (_relatedView == nil && self.attribute != NSLayoutAttributeWidth && self.attribute != NSLayoutAttributeHeight) {
        _relatedView = [self.layoutProvider viewWithComponentIdentifier:self.relatedComponentIdentifier];
    }
    
    return _relatedView;
}

- (AMView *)commonAncestorView {
    if (_commonAncestorView == nil) {
        _commonAncestorView = [self.layoutProvider viewWithComponentIdentifier:self.commonAncestorComponentIdentifier];
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
    self.constraint.priority = self.priority;
}

- (void)updateLayoutInAnimation:(BOOL)inAnimation {
    [self createConstraintIfNecessary];
    self.constraint.priority = self.priority;
    
//    NSLog(@"update with frame: %@", NSStringFromCGRect(frame));
    
    AMComponent *component = [self.layoutProvider componentWithComponentIdentifier:self.componentIdentifier];
    AMComponent *relatedComponent = [self.layoutProvider componentWithComponentIdentifier:self.relatedComponentIdentifier];
    AMComponent *commonComponent = [self.layoutProvider componentWithComponentIdentifier:self.commonAncestorComponentIdentifier];
    
    if (component == nil) {
        return;
    }
    
    CGFloat offset = 0.0f;
    CGFloat proportionalOffset = 0.0f;

    if (self.isProportional) {
        
        self.proportionalValue =
        [AMLayoutComponentHelpers
         proportionalValueForComponent:component
         attribute:self.attribute
         relatedComponent:relatedComponent
         relatedAttribute:self.relatedAttribute
         commonAncestorComponent:commonComponent];

        proportionalOffset = [self proportionalOffset];
    } else {
        offset = [self fixedLayoutOffsetForComponent:component relatedComponent:relatedComponent];
    }
    
    [self setOffset:offset proportionalOffset:proportionalOffset inAnimation:inAnimation];
#if TARGET_OS_IPHONE
    [self.view layoutIfNeeded];
#else
    [self.view layoutSubtreeIfNeeded];
#endif
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

#pragma mark - Proportional Frame Adjustments

//- (CGRect)adjustComponentFrame {
//    return [self adjustComponentFrameMaintainingSize:NO];
//}
//
//- (CGRect)adjustComponentFrameMaintainingSize:(BOOL)maintainSize {
//
//    AMComponent *component = self.view.component;
//    CGRect result = component.frame;
//
//    if (self.isProportional) {
//        
//        AMComponent *relatedComponent = self.relatedView.component;
//        AMComponent *ancestorComponent = self.commonAncestorView.component;
//        
//        if (component != nil && relatedComponent != nil && ancestorComponent != nil) {
//            CGRect frameInCommonSpace = [self frameInCommonAncestorFromComponent:component];
//            CGRect relatedFrameInCommonSpace = [self frameInCommonAncestorFromComponent:relatedComponent];
//            CGFloat relatedValue = [self relatedValueForFrame:relatedFrameInCommonSpace];
//            CGFloat proportionalValue = [self proportionalOffset];
//            CGRect result = frameInCommonSpace;
//            
//            switch (self.attribute) {
//                    
//                case NSLayoutAttributeTop:
//                    return [self adjustedFrameForProportionalTop:frameInCommonSpace proportionalValue:proportionalValue forComponent:component maintainSize:maintainSize];
//                    break;
//                    
//                case NSLayoutAttributeLeft:
//                    return [self adjustedFrameForProportionalLeft:frameInCommonSpace proportionalValue:proportionalValue forComponent:component maintainSize:maintainSize];
//                    break;
//                    
//                case NSLayoutAttributeBottom:
//                    return [self adjustedFrameForProportionalBottom:frameInCommonSpace proportionalValue:proportionalValue forComponent:component maintainSize:maintainSize];
//                    break;
//                    
//                case NSLayoutAttributeRight:
//                    return [self adjustedFrameForProportionalRight:frameInCommonSpace proportionalValue:proportionalValue forComponent:component maintainSize:maintainSize];
//                    break;
//                    
//                case NSLayoutAttributeCenterY:
//                    return [self adjustedFrameForProportionalCenterY:frameInCommonSpace proportionalValue:proportionalValue forComponent:component maintainSize:maintainSize];
//                    break;
//                    
//                case NSLayoutAttributeCenterX:
//                    return [self adjustedFrameForProportionalCenterX:frameInCommonSpace proportionalValue:proportionalValue forComponent:component maintainSize:maintainSize];
//                    break;
//                    
//                case NSLayoutAttributeHeight:
//                    return [self adjustedFrameForProportionalHeight:frameInCommonSpace proportionalValue:proportionalValue forComponent:component maintainSize:maintainSize];
//                    break;
//                    
//                case NSLayoutAttributeWidth:
//                    return [self adjustedFrameForProportionalWidth:frameInCommonSpace proportionalValue:proportionalValue forComponent:component maintainSize:maintainSize];
//                    break;
//                    
//
//                default:
//                    break;
//            }
//            
//            result = [self.commonAncestorView.component convertAncestorFrame:result toComponent:component];
//        }
//    }
//    
//    return result;
//}

- (CGFloat)proportionalOffset {
    
    CGFloat result = 0.0f;
    
    if (self.isProportional) {

        AMComponent *component = self.view.component;
        AMComponent *relatedComponent = self.relatedView.component;

        result =
        [AMLayoutComponentHelpers
         proportionalOffsetForComponent:component
         attribute:self.attribute
         relatedComponent:relatedComponent
         relatedAttribute:self.relatedAttribute
         proportionalValue:self.proportionalValue];
    }
    
    return result;
}

//- (CGRect)adjustedFrameForProportionalTop:(CGRect)frame
//                        proportionalValue:(CGFloat)proportionalValue
//                             forComponent:(AMComponent *)component
//                             maintainSize:(BOOL)maintainSize {
//    
//    CGRect result = frame;
//    result.origin.y = proportionalValue;
//    
//    return result;
//}
//
//- (CGRect)adjustedFrameForProportionalLeft:(CGRect)frame
//                         proportionalValue:(CGFloat)proportionalValue
//                              forComponent:(AMComponent *)component
//                              maintainSize:(BOOL)maintainSize {
//    
//    CGRect result = frame;
//    result.origin.x = proportionalValue;
//    
//    return result;
//}
//
//- (CGRect)adjustedFrameForProportionalBottom:(CGRect)frame
//                           proportionalValue:(CGFloat)proportionalValue
//                                forComponent:(AMComponent *)component
//                                maintainSize:(BOOL)maintainSize {
//
//    CGRect result = frame;
//    result.origin.y = CGRectGetHeight(parentFrame) - CGRectGetHeight(frame) - (self.proportionalValue * CGRectGetHeight(parentFrame));
//
//}
//
//- (CGRect)adjustedFrameForProportionalRight:(CGRect)frame
//                          proportionalValue:(CGFloat)proportionalValue
//                               forComponent:(AMComponent *)component
//                               maintainSize:(BOOL)maintainSize {
//    
//}
//
//- (CGRect)adjustedFrameForProportionalCenterY:(CGRect)frame
//                            proportionalValue:(CGFloat)proportionalValue
//                                 forComponent:(AMComponent *)component
//                                 maintainSize:(BOOL)maintainSize {
//    
//}
//
//- (CGRect)adjustedFrameForProportionalCenterX:(CGRect)frame
//                            proportionalValue:(CGFloat)proportionalValue
//                                 forComponent:(AMComponent *)component
//                                 maintainSize:(BOOL)maintainSize {
//    
//}
//
//- (CGRect)adjustedFrameForProportionalHeight:(CGRect)frame
//                           proportionalValue:(CGFloat)proportionalValue
//                                forComponent:(AMComponent *)component
//                                maintainSize:(BOOL)maintainSize {
//    
//}
//
//- (CGRect)adjustedFrameForProportionalWidth:(CGRect)frame
//                          proportionalValue:(CGFloat)proportionalValue
//                               forComponent:(AMComponent *)component
//                               maintainSize:(BOOL)maintainSize {
//    
//}

#pragma mark - Constraint Creation

- (void)createConstraintIfNecessary {

    if (self.view != nil &&
        (self.constraint == nil ||
         self.constraint.multiplier != self.multiplier)) {
            
        if (self.relatedComponentIdentifier == nil || self.relatedView != nil) {
            self.constraint = [self buildConstraint];

            [self deactivatePreviousConstraints];
            
            [self.commonAncestorView addConstraint:self.constraint];
#if TARGET_OS_IPHONE
            [self.view layoutIfNeeded];
#else
            [self.view layoutSubtreeIfNeeded];
#endif
            
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

- (CGFloat)proportionalLayoutOffset {
    CGFloat offset = self.offset + [self proportionalOffset];

    return offset;
}

- (NSLayoutConstraint *)buildConstraint {
    
    CGFloat offset = [self proportionalLayoutOffset];
    
    return
    [NSLayoutConstraint
     constraintWithItem:self.view
     attribute:self.attribute
     relatedBy:self.relation
     toItem:self.relatedView
     attribute:self.relatedAttribute
     multiplier:self.multiplier
     constant:offset];
}

- (UIEdgeInsets)updateProportionalFrameBoundaries:(UIEdgeInsets)frameBoundaries
           basedOnRelatedAttributeWithRelatedSize:(CGSize)relatedSize
                                    originalFrame:(CGRect)originalFrame {

    if (self.isProportional) {
        switch (self.relatedAttribute) {
            case NSLayoutAttributeTop:
                return [self updateProportionalFrameBoundaries:frameBoundaries basedOnRelatedTopAttributeWithRelatedSize:relatedSize originalFrame:originalFrame];
                break;
                
            case NSLayoutAttributeLeft:
                return [self updateProportionalFrameBoundaries:frameBoundaries basedOnRelatedLeftAttributeWithRelatedSize:relatedSize originalFrame:originalFrame];
                break;
                
            case NSLayoutAttributeBottom:
                return [self updateProportionalFrameBoundaries:frameBoundaries basedOnRelatedBottomAttributeWithRelatedSize:relatedSize originalFrame:originalFrame];
                break;
                
            case NSLayoutAttributeRight:
                return [self updateProportionalFrameBoundaries:frameBoundaries basedOnRelatedRightAttributeWithRelatedSize:relatedSize originalFrame:originalFrame];
                break;
                
            case NSLayoutAttributeCenterY:
                return [self updateProportionalFrameBoundaries:frameBoundaries basedOnRelatedCenterYAttributeWithRelatedSize:relatedSize originalFrame:originalFrame];
                break;
                
            case NSLayoutAttributeCenterX:
                return [self updateProportionalFrameBoundaries:frameBoundaries basedOnRelatedCenterXAttributeWithRelatedSize:relatedSize originalFrame:originalFrame];
                break;
    
            default:
                break;
        }
    }
    return frameBoundaries;
}

- (UIEdgeInsets)updateProportionalFrameBoundaries:(UIEdgeInsets)frameBoundaries
        basedOnRelatedTopAttributeWithRelatedSize:(CGSize)relatedSize
                                    originalFrame:(CGRect)originalFrame {

    UIEdgeInsets result = frameBoundaries;
    result.top = self.proportionalValue * relatedSize.height;

    return result;
}

- (UIEdgeInsets)updateProportionalFrameBoundaries:(UIEdgeInsets)frameBoundaries
     basedOnRelatedBottomAttributeWithRelatedSize:(CGSize)relatedSize
                                    originalFrame:(CGRect)originalFrame {

    UIEdgeInsets result = frameBoundaries;
    CGFloat height = CGRectGetHeight(originalFrame);
    result.bottom = self.proportionalValue * relatedSize.height;
    result.top = result.bottom - height;
    return result;
}

- (UIEdgeInsets)updateProportionalFrameBoundaries:(UIEdgeInsets)frameBoundaries
       basedOnRelatedLeftAttributeWithRelatedSize:(CGSize)relatedSize
                                    originalFrame:(CGRect)originalFrame {

    UIEdgeInsets result = frameBoundaries;
    result.left = self.proportionalValue * relatedSize.width;
    
    return result;
}

- (UIEdgeInsets)updateProportionalFrameBoundaries:(UIEdgeInsets)frameBoundaries
      basedOnRelatedRightAttributeWithRelatedSize:(CGSize)relatedSize
                                    originalFrame:(CGRect)originalFrame {

    UIEdgeInsets result = frameBoundaries;
    CGFloat width = CGRectGetWidth(originalFrame);
    result.right = self.proportionalValue * relatedSize.width;
    result.left = result.right - width;

    return result;
}

- (UIEdgeInsets)updateProportionalFrameBoundaries:(UIEdgeInsets)frameBoundaries
    basedOnRelatedCenterYAttributeWithRelatedSize:(CGSize)relatedSize
                                    originalFrame:(CGRect)originalFrame {

    UIEdgeInsets result = frameBoundaries;
    result.top =
    (self.proportionalValue * relatedSize.height) - (CGRectGetHeight(originalFrame) / 2.0f);
    
    return result;
}

- (UIEdgeInsets)updateProportionalFrameBoundaries:(UIEdgeInsets)frameBoundaries
    basedOnRelatedCenterXAttributeWithRelatedSize:(CGSize)relatedSize
                                    originalFrame:(CGRect)originalFrame {

    UIEdgeInsets result = frameBoundaries;
    result.left =
    (self.proportionalValue * relatedSize.width) - (CGRectGetWidth(originalFrame) / 2.0f);
    
    return result;
}

@end
