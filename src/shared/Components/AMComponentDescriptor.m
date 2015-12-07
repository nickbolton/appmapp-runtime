//
//  AMComponentDescriptor.m
//  AppMap
//
//  Created by Nick Bolton on 12/5/15.
//  Copyright © 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMComponentDescriptor.h"
#import "AMColor+AMColor.h"

NSString * kAMComponentTypeKey = @"type";
NSString * kAMComponentClippedKey = @"clipped";
NSString * kAMComponentBackgroundColorKey = @"backgroundColor";
NSString * kAMComponentBorderWidthKey = @"borderWidth";
NSString * kAMComponentBorderColorWidthKey = @"borderColor";
NSString * kAMComponentAlphaKey = @"alpha";
NSString * kAMComponentCornerRadiusKey = @"cornerRadius";

@implementation AMComponentDescriptor

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    [coder encodeInteger:self.componentType forKey:kAMComponentTypeKey];
    [coder encodeBool:self.isClipped forKey:kAMComponentClippedKey];
    [coder encodeObject:self.backgroundColor forKey:kAMComponentBackgroundColorKey];
    [coder encodeObject:self.borderColor forKey:kAMComponentBorderColorWidthKey];
    [coder encodeFloat:self.alpha forKey:kAMComponentAlphaKey];
    [coder encodeFloat:self.cornerRadius forKey:kAMComponentCornerRadiusKey];
    [coder encodeFloat:self.borderWidth forKey:kAMComponentBorderWidthKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super initWithCoder:decoder];
    
    if (self != nil) {
        self.componentType = [decoder decodeIntegerForKey:kAMComponentTypeKey];
        self.clipped = [decoder decodeBoolForKey:kAMComponentClippedKey];
        self.backgroundColor = [decoder decodeObjectForKey:kAMComponentBackgroundColorKey];
        self.alpha = [decoder decodeFloatForKey:kAMComponentAlphaKey];
        self.cornerRadius = [decoder decodeFloatForKey:kAMComponentCornerRadiusKey];
        self.borderWidth = [decoder decodeFloatForKey:kAMComponentBorderWidthKey];
        self.borderColor = [decoder decodeObjectForKey:kAMComponentBorderColorWidthKey];
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    
    self = [super initWithDictionary:dict];
    
    if (self != nil) {
        NSString *backgroundColorString = dict[kAMComponentBackgroundColorKey];
        NSString *borderColorString = dict[kAMComponentBorderColorWidthKey];
        
        self.componentType = [dict[kAMComponentTypeKey] integerValue];
        self.clipped = [dict[kAMComponentClippedKey] boolValue];
        self.alpha = [dict[kAMComponentAlphaKey] floatValue];
        self.cornerRadius = [dict[kAMComponentCornerRadiusKey] floatValue];
        self.borderWidth = [dict[kAMComponentBorderWidthKey] floatValue];
        self.borderColor = [AMColor colorWithHexcodePlusAlpha:borderColorString];
        self.backgroundColor = [AMColor colorWithHexcodePlusAlpha:backgroundColorString];
    }
    
    return self;
}


- (instancetype)copy {
    
    AMComponentDescriptor *component = super.copy;
    component.componentType = self.componentType;
    component.clipped = self.isClipped;
    component.backgroundColor = self.backgroundColor;
    component.alpha = self.alpha;
    component.borderWidth = self.borderWidth;
    component.borderColor = self.borderColor;
    return component;
}

- (NSDictionary *)exportComponent {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict addEntriesFromDictionary:[super exportComponent]];
    
    dict[kAMComponentTypeKey] = @(self.componentType);
    dict[kAMComponentClippedKey] = @(self.isClipped);
    dict[kAMComponentBackgroundColorKey] = [self.backgroundColor hexcodePlusAlpha];
    dict[kAMComponentBorderColorWidthKey] = [self.borderColor hexcodePlusAlpha];
    dict[kAMComponentAlphaKey] = @(self.alpha);
    dict[kAMComponentCornerRadiusKey] = @(self.cornerRadius);
    dict[kAMComponentBorderWidthKey] = @(self.borderWidth);
    
    [dict removeObjectForKey:kAMComponentChildComponentsKey];

    return dict;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\
            Descriptor(%d): %p %@",
            (int)self.componentType, self, self.identifier];
}

#pragma mark - Getters and Setters

- (BOOL)isContainer {
    return self.componentType == AMComponentContainer;
}

@end
