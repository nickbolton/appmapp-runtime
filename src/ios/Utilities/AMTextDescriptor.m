//
//  AMTextDescriptor.m
//  AppMap
//
//  Created by Nick Bolton on 1/3/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMTextDescriptor.h"
#import "NSColor+AppMap.h"

static NSString * const kAMTextDescriptorSystemFamily = @"system-family";
static NSString * const kAMTextDescriptorFontFamilyKey = @"fontFamily";
static NSString * const kAMTextDescriptorFontSizeKey = @"fontSize";
static NSString * const kAMBaseTextDescriptorTextColorKey = @"textColor";

@implementation AMTextDescriptor

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        
        NSString *fontFamily = [decoder decodeObjectForKey:kAMTextDescriptorFontFamilyKey];
        CGFloat fontSize = [decoder decodeFloatForKey:kAMTextDescriptorFontSizeKey];

        if (fontSize <= 0.0f) {
            fontSize = 16.0f;
        }

#if TARGET_OS_IPHONE
        UIFont *font;
        if ([fontFamily isEqualToString:@"system-family"]) {
            font = [UIFont systemFontOfSize:fontSize];
        } else {
            font = [UIFont fontWithName:fontFamily size:fontSize];
        }
#else
        NSFont *font;
        if ([fontFamily isEqualToString:@"system-family"]) {
            font = [NSFont systemFontOfSize:fontSize];
        } else {
            font = [NSFont fontWithName:fontFamily size:fontSize];
        }
#endif

        self.font = font;
        self.textColor = [decoder decodeObjectForKey:kAMBaseTextDescriptorTextColorKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    
    [super encodeWithCoder:coder];
    
    if (self.systemFont) {
        [coder encodeObject:kAMTextDescriptorSystemFamily forKey:kAMTextDescriptorFontFamilyKey];
    } else {
        [coder encodeObject:self.font.familyName forKey:kAMTextDescriptorFontFamilyKey];
    }
    
    [coder encodeFloat:self.font.pointSize forKey:kAMTextDescriptorFontSizeKey];
    [coder encodeObject:self.textColor forKey:kAMBaseTextDescriptorTextColorKey];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    
    self = [super initWithDictionary:dict];
    
    if (self != nil) {
        
        NSString *fontFamily = dict[kAMTextDescriptorFontFamilyKey];
        CGFloat fontSize = [dict[kAMTextDescriptorFontSizeKey] floatValue];
        NSString *textColorString = dict[kAMBaseTextDescriptorTextColorKey];
        
        if (fontSize <= 0.0f) {
            fontSize = 16.0f;
        }
        
#if TARGET_OS_IPHONE
        UIFont *font;
        if ([fontFamily isEqualToString:@"system-family"]) {
            font = [UIFont systemFontOfSize:fontSize];
        } else {
            font = [UIFont fontWithName:fontFamily size:fontSize];
        }
#else
        NSFont *font;
        if ([fontFamily isEqualToString:@"system-family"]) {
            font = [NSFont systemFontOfSize:fontSize];
        } else {
            font = [NSFont fontWithName:fontFamily size:fontSize];
        }
#endif
        
        self.font = font;
        self.textColor = [NSColor colorWithHexcodePlusAlpha:textColorString];
    }
    
    return self;
}

+ (AMTextDescriptor *)newlineDescriptor:(CGFloat)lineHeight {
    
    AMTextDescriptor *textDescriptor =
    [[AMTextDescriptor alloc] initWithText:@"\n"];
    
    textDescriptor.font = [NSFont systemFontOfSize:lineHeight];
    
    return textDescriptor;
}

- (instancetype)copy {
    
    AMTextDescriptor *wrapperCopy = [AMTextDescriptor new];
    wrapperCopy.kerning = self.kerning;
    wrapperCopy.leading = self.leading;
    wrapperCopy.font = self.font.copy;
    wrapperCopy.textColor = self.textColor.copy;
    wrapperCopy.textAlignment = self.textAlignment;
    wrapperCopy.text = self.text.copy;
    wrapperCopy.baselineAdjustment = self.baselineAdjustment;
    wrapperCopy.underline = self.underline;
    wrapperCopy.systemFont = self.systemFont;

    return wrapperCopy;
}

- (NSDictionary *)exportTextDescriptor {
    
    NSMutableDictionary *dict = [[super exportTextDescriptor] mutableCopy];
    
    if (self.systemFont) {
        dict[kAMTextDescriptorFontFamilyKey] = kAMTextDescriptorSystemFamily;
    } else {
        dict[kAMTextDescriptorFontFamilyKey] = self.font.familyName;
    }
    dict[kAMTextDescriptorFontSizeKey] = @(self.font.pointSize);
    dict[kAMBaseTextDescriptorTextColorKey] = [self.textColor hexcodePlusAlpha];

    return dict;
}

#pragma mark - Getters and Setters

- (void)setFont:(NSFont *)font {
    _font = font;
    [self clearCache];
}

- (void)setTextColor:(NSColor *)textColor {
    _textColor = textColor;
    [self clearCache];
}

- (NSDictionary *)attributes {

    NSMutableDictionary *result = super.attributes.mutableCopy;
    
    if (self.font != nil) {
        result[NSFontAttributeName] = self.font;
    }
    
    if (self.textColor != nil) {
        result[NSForegroundColorAttributeName] = self.textColor;
    }

    return result;
}

@end
