//
//  AMComponentAttributes.m
//  AppMap
//
//  Created by Nick Bolton on 12/7/15.
//  Copyright © 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMComponentAttributes.h"
#import "AMColor+AMColor.h"

NSString *const kAMComponentFrameKey = @"frame";
NSString *const kAMComponentClippedKey = @"clipped";
NSString *const kAMComponentBackgroundColorKey = @"backgroundColor";
NSString *const kAMComponentBorderWidthKey = @"borderWidth";
NSString *const kAMComponentBorderColorWidthKey = @"borderColor";
NSString *const kAMComponentAlphaKey = @"alpha";
NSString *const kAMComponentCornerRadiusKey = @"cornerRadius";
NSString *const kAMComponentLayoutObjectsKey = @"layoutObjects";
NSString *const kAMComponentLayoutPresetKey = @"layoutPreset";

@implementation AMComponentAttributes

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeBool:self.isClipped forKey:kAMComponentClippedKey];
    [coder encodeObject:self.backgroundColor forKey:kAMComponentBackgroundColorKey];
    [coder encodeObject:self.borderColor forKey:kAMComponentBorderColorWidthKey];
    [coder encodeFloat:self.alpha forKey:kAMComponentAlphaKey];
    [coder encodeFloat:self.cornerRadius forKey:kAMComponentCornerRadiusKey];
    [coder encodeFloat:self.borderWidth forKey:kAMComponentBorderWidthKey];
    [coder encodeInteger:self.layoutPreset forKey:kAMComponentLayoutPresetKey];
    [coder encodeObject:self.layoutObjects forKey:kAMComponentLayoutObjectsKey];
    
#if TARGET_OS_IPHONE
    [coder encodeObject:NSStringFromCGRect(self.frame) forKey:kAMComponentFrameKey];
#else
    [coder encodeObject:NSStringFromRect(self.frame) forKey:kAMComponentFrameKey];
#endif
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    
    if (self != nil) {
        self.clipped = [decoder decodeBoolForKey:kAMComponentClippedKey];
        self.backgroundColor = [decoder decodeObjectForKey:kAMComponentBackgroundColorKey];
        self.alpha = [decoder decodeFloatForKey:kAMComponentAlphaKey];
        self.cornerRadius = [decoder decodeFloatForKey:kAMComponentCornerRadiusKey];
        self.borderWidth = [decoder decodeFloatForKey:kAMComponentBorderWidthKey];
        self.borderColor = [decoder decodeObjectForKey:kAMComponentBorderColorWidthKey];
        self.layoutPreset = [decoder decodeIntegerForKey:kAMComponentLayoutPresetKey];
        self.layoutObjects = [decoder decodeObjectForKey:kAMComponentLayoutObjectsKey];
        
#if TARGET_OS_IPHONE
        self.frame = CGRectFromString([decoder decodeObjectForKey:kAMComponentFrameKey]);
#else
        self.frame = NSRectFromString([decoder decodeObjectForKey:kAMComponentFrameKey]);
#endif
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    
    self = [super init];
    
    if (self != nil) {
        
        NSString *backgroundColorString = dict[kAMComponentBackgroundColorKey];
        NSString *borderColorString = dict[kAMComponentBorderColorWidthKey];
        
        self.layoutPreset = [dict[kAMComponentLayoutPresetKey] integerValue];
        self.clipped = [dict[kAMComponentClippedKey] boolValue];
        self.alpha = [dict[kAMComponentAlphaKey] floatValue];
        self.cornerRadius = [dict[kAMComponentCornerRadiusKey] floatValue];
        self.borderWidth = [dict[kAMComponentBorderWidthKey] floatValue];
        self.borderColor = [AMColor colorWithHexcodePlusAlpha:borderColorString];
        self.backgroundColor = [AMColor colorWithHexcodePlusAlpha:backgroundColorString];
        
#if TARGET_OS_IPHONE
        self.frame = CGRectFromString(dict[kAMComponentFrameKey]);
#else
        self.frame = NSRectFromString(dict[kAMComponentFrameKey]);
#endif
        
        // layout objects
        
        NSMutableArray *layoutObjects = [NSMutableArray array];
        NSArray *layoutObjectDicts = dict[kAMComponentLayoutObjectsKey];
        
        for (NSDictionary *dict in layoutObjectDicts) {
            
            AMLayout *layout = [AMLayout layoutWithDictionary:dict];
            [layoutObjects addObject:layout];
        }
        
        self.layoutObjects = layoutObjects;
    }
    
    return self;
}

- (instancetype)copy {
    
    AMComponentAttributes *attributes = [[self.class alloc] init];
    attributes.clipped = self.isClipped;
    attributes.backgroundColor = self.backgroundColor;
    attributes.alpha = self.alpha;
    attributes.borderWidth = self.borderWidth;
    attributes.borderColor = self.borderColor;
    attributes.layoutPreset = self.layoutPreset;
    attributes.layoutObjects = self.layoutObjects.copy;
    attributes.frame = self.frame;
    
    return attributes;
}

- (NSDictionary *)dictionaryRepresentation {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[kAMComponentClippedKey] = @(self.isClipped);
    dict[kAMComponentBackgroundColorKey] = [self.backgroundColor hexcodePlusAlpha];
    dict[kAMComponentBorderColorWidthKey] = [self.borderColor hexcodePlusAlpha];
    dict[kAMComponentAlphaKey] = @(self.alpha);
    dict[kAMComponentCornerRadiusKey] = @(self.cornerRadius);
    dict[kAMComponentBorderWidthKey] = @(self.borderWidth);
    dict[kAMComponentLayoutPresetKey] = @(self.layoutPreset);
    
#if TARGET_OS_IPHONE
    dict[kAMComponentFrameKey] = NSStringFromCGRect(self.frame);
#else
    dict[kAMComponentFrameKey] = NSStringFromRect(self.frame);
#endif
    
    NSMutableArray *layoutObjectDicts = [NSMutableArray array];
    
    for (AMLayout *layout in self.layoutObjects) {
        NSDictionary *dict = [layout exportLayout];
        [layoutObjectDicts addObject:dict];
    }
    
    dict[kAMComponentLayoutObjectsKey] = layoutObjectDicts;

    return dict;
}

#pragma mark - Getters and Setters

- (void)setLayoutPreset:(AMLayoutPreset)layoutPreset {
    _layoutPreset = layoutPreset;
    
    _layoutPreset = MAX(0, _layoutPreset);
    _layoutPreset = MIN(AMLayoutPresetCustom, _layoutPreset);
}

@end
