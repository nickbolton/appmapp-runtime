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
static NSString * kAMLayoutProportionalValueKey = @"proportionalValue";
static NSString * kAMLayoutLayoutRelationKey = @"layoutRelation";

@interface AMLayout()

@end

@implementation AMLayout

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeFloat:self.proportionalValue forKey:kAMLayoutProportionalValueKey];
    [coder encodeInteger:self.layoutRelation forKey:kAMLayoutLayoutRelationKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    
    if (self != nil) {
        self.proportionalValue = [decoder decodeFloatForKey:kAMLayoutProportionalValueKey];
        self.layoutRelation = [decoder decodeIntegerForKey:kAMLayoutLayoutRelationKey];
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    
    self = [super init];
    
    if (self != nil) {
        self.proportionalValue = [dict[kAMLayoutProportionalValueKey] floatValue];
        self.layoutRelation = [dict[kAMLayoutLayoutRelationKey] integerValue];
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
    dict[kAMLayoutProportionalValueKey] = @(self.proportionalValue);
    dict[kAMLayoutLayoutRelationKey] = @(self.layoutRelation);
    
    return dict;
}

#pragma mark - Getters and Setters

- (NSString *)viewIdentifier {
    
    if (_viewIdentifier == nil) {
        _viewIdentifier = NSStringFromClass(self.view.class);
    }
    return _viewIdentifier;
}

#pragma mark - Public

+ (BOOL)isProportionalLayoutType:(AMLayoutType)layoutType {
    
    return
    layoutType >= AMLayoutTypeProportionalTop &&
    layoutType <= AMLayoutTypeProportionalVerticalCenter;
}

- (BOOL)isProportional {
    return [self.class isProportionalLayoutType:self.layoutType];
}

- (BOOL)isHorizontal {
    return [self.class isHorizontalLayoutType:self.layoutType];
}

- (BOOL)isVertical {
    return [self.class isVerticalLayoutType:self.layoutType];
}

+ (BOOL)isHorizontalLayoutType:(AMLayoutType)layoutType {
    
    switch (layoutType) {
        case AMLayoutTypeFixedWidth:
        case AMLayoutTypeAnchoredLeft:
        case AMLayoutTypeAnchoredRight:
        case AMLayoutTypeCenterHorizontally:
        case AMLayoutTypeProportionalLeft:
        case AMLayoutTypeProportionalRight:
        case AMLayoutTypeProportionalHorizontalCenter:
            return YES;
            break;
            
        default:
            break;
    }
    
    return NO;
}

+ (BOOL)isVerticalLayoutType:(AMLayoutType)layoutType {
    
    switch (layoutType) {
        case AMLayoutTypeFixedHeight:
        case AMLayoutTypeAnchoredTop:
        case AMLayoutTypeAnchoredBottom:
        case AMLayoutTypeCenterVertically:
        case AMLayoutTypeProportionalTop:
        case AMLayoutTypeProportionalBottom:
        case AMLayoutTypeProportionalVerticalCenter:
            return YES;
            break;
            
        default:
            break;
    }
    
    return NO;
}

- (void)clearLayout {
    self.constraint = nil;
    self.layoutApplied = NO;
}

- (void)updateLayoutWithFrame:(CGRect)frame
                   multiplier:(CGFloat)multiplier
                     priority:(AMLayoutPriority)priority
                  parentFrame:(CGRect)parentFrame
             allLayoutObjects:(NSArray *)allLayoutObjects
                       inView:(AMView *)view
                     animated:(BOOL)animated {
    self.view = view;
    [self createConstraintsIfNecessaryWithMultiplier:multiplier priority:priority];
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

- (void)createConstraintsIfNecessaryWithMultiplier:(CGFloat)multiplier
                                          priority:(AMLayoutPriority)priority {

    if (self.view != nil &&
        (self.constraint == nil ||
         self.constraint.multiplier != multiplier ||
         self.constraint.priority != priority)) {
            
        [self clearLayout];
            
        if (self.view.superview != nil) {
            self.constraint = [self buildConstraintWithMultiplier:multiplier];
            self.constraint.priority = priority;
            
#if DEBUG
            self.constraint.identifier =
            [NSString
             stringWithFormat:@"%@:%@",
             self.viewIdentifier, NSStringFromClass(self.class)];
#endif
        }
    }
}

- (void)updateProportionalValueFromFrame:(CGRect)frame parentFrame:(CGRect)parentFrame {
}

- (void)applyConstraintIfNecessary {    
    [self doesNotRecognizeSelector:_cmd];
}

- (NSLayoutConstraint *)buildConstraintWithMultiplier:(CGFloat)multiplier {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
