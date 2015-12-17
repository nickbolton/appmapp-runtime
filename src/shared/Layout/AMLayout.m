//
//  AMLayout.m
//  AppMap
//
//  Created by Nick Bolton on 12/28/14.
//  Copyright (c) 2014 Pixelbleed LLC. All rights reserved.
//

#import "AMLayout.h"

static NSString * kAMLayoutClassNameKey = @"className";
static NSString * kAMLayoutAttributeKey = @"attribute";
static NSString * kAMLayoutRelationKey = @"relation";
static NSString * kAMLayoutMultiplierKey = @"multiplier";
static NSString * kAMLayoutRelatedComponentIdentifierKey = @"relatedComponentIdentifier";
static NSString * kAMLayoutRelatedAttributeKey = @"relatedAttribute";
static NSString * kAMLayoutOffsetKey = @"offset";
static NSString * kAMLayoutPriorityKey = @"priority";

@interface AMLayout()

@end

@implementation AMLayout

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInteger:self.attribute forKey:kAMLayoutAttributeKey];
    [coder encodeInteger:self.relation forKey:kAMLayoutRelationKey];
    [coder encodeFloat:self.multiplier forKey:kAMLayoutMultiplierKey];
    [coder encodeObject:self.relatedComponentIdentifier forKey:kAMLayoutRelatedComponentIdentifierKey];
    [coder encodeInteger:self.relatedAttribute forKey:kAMLayoutRelatedAttributeKey];
    [coder encodeFloat:self.offset forKey:kAMLayoutOffsetKey];
    [coder encodeFloat:self.priority forKey:kAMLayoutPriorityKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    
    if (self != nil) {
        self.attribute = [decoder decodeIntegerForKey:kAMLayoutAttributeKey];
        self.relation = [decoder decodeIntegerForKey:kAMLayoutRelationKey];
        self.multiplier = [decoder decodeFloatForKey:kAMLayoutMultiplierKey];
        self.relatedComponentIdentifier = [decoder decodeObjectForKey:kAMLayoutRelatedComponentIdentifierKey];
        self.relatedAttribute = [decoder decodeIntegerForKey:kAMLayoutRelatedAttributeKey];
        self.offset = [decoder decodeFloatForKey:kAMLayoutOffsetKey];
        self.priority = [decoder decodeFloatForKey:kAMLayoutPriorityKey];
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    
    self = [super init];
    
    if (self != nil) {
        self.attribute = [dict[kAMLayoutAttributeKey] integerValue];
        self.relation = [dict[kAMLayoutRelationKey] integerValue];
        self.multiplier = [dict[kAMLayoutMultiplierKey] floatValue];
        self.relatedComponentIdentifier = dict[kAMLayoutRelatedComponentIdentifierKey];
        self.relatedAttribute = [dict[kAMLayoutRelatedAttributeKey] integerValue];
        self.offset = [dict[kAMLayoutOffsetKey] floatValue];
        self.priority = [dict[kAMLayoutPriorityKey] floatValue];
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
    dict[kAMLayoutRelatedComponentIdentifierKey] = self.relatedComponentIdentifier;
    dict[kAMLayoutRelatedAttributeKey] = @(self.relatedAttribute);
    dict[kAMLayoutOffsetKey] = @(self.offset);
    dict[kAMLayoutPriorityKey] = @(self.priority);

    return dict;
}

#pragma mark - Getters and Setters

- (NSString *)viewIdentifier {
    
    if (_viewIdentifier == nil) {
        _viewIdentifier = NSStringFromClass(self.view.class);
    }
    return _viewIdentifier;
}

- (BOOL)isHorizontal {
    
    switch (self.attribute) {
        case NSLayoutAttributeLeft:
        case NSLayoutAttributeLeading:
        case NSLayoutAttributeCenterX:
        case NSLayoutAttributeRight:
        case NSLayoutAttributeTrailing:
        case NSLayoutAttributeWidth:
            return YES;
            break;
            
        default:
            break;
    }
    
    return NO;
}

#pragma mark - Public

- (void)clearLayout {
    self.constraint = nil;
}

- (void)createConstraintIfNecessary {

    if (self.view != nil &&
        (self.constraint == nil ||
         self.constraint.multiplier != self.multiplier ||
         self.constraint.priority != self.priority)) {
            
        [self clearLayout];
            
        if (self.view.superview != nil) {
            self.constraint = [self buildConstraint];
            self.constraint.priority = self.priority;
            
#if DEBUG
            self.constraint.identifier =
            [NSString
             stringWithFormat:@"%@:%@",
             self.viewIdentifier, NSStringFromClass(self.class)];
#endif
        }
    }
}

- (void)applyConstraintIfNecessary {
    [self doesNotRecognizeSelector:_cmd];
}

- (NSLayoutConstraint *)buildConstraint {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
