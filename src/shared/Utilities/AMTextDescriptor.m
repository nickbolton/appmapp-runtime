//
//  AMTextDescriptor.m
//  AppMap
//
//  Created by Nick Bolton on 1/3/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMTextDescriptor.h"
#import "AMColor+AMColor.h"

NSString * const kAMTextDescriptorClassNameKey = @"class-name";

static NSString * const kAMTextDescriptorKerningKey = @"kerning";
static NSString * const kAMTextDescriptorLeadingKey = @"leading";
static NSString * const kAMTextDescriptorTextAlignmentKey = @"textAlignment";
static NSString * const kAMTextDescriptorTextKey = @"text";
static NSString * const kAMTextDescriptorBaselineAdjustmentKey = @"baselineAdjustment";
static NSString * const kAMTextDescriptorUnderlineKey = @"underline";
static NSString * const kAMTextDescriptorSystemFamily = @"system-family";
static NSString * const kAMTextDescriptorFontFamilyKey = @"fontFamily";
static NSString * const kAMTextDescriptorFontSizeKey = @"fontSize";
static NSString * const kAMTextDescriptorTextColorKey = @"textColor";

@interface AMTextDescriptor()

@property (nonatomic, readwrite) NSAttributedString *attributedString;

@end

@implementation AMTextDescriptor

@synthesize text = _text;

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.kerning = [decoder decodeFloatForKey:kAMTextDescriptorKerningKey];
        self.leading = [decoder decodeFloatForKey:kAMTextDescriptorLeadingKey];
        self.baselineAdjustment = [decoder decodeFloatForKey:kAMTextDescriptorBaselineAdjustmentKey];
        self.textAlignment = [decoder decodeInt32ForKey:kAMTextDescriptorTextAlignmentKey];
        self.text = [decoder decodeObjectForKey:kAMTextDescriptorTextKey];
        self.underline = [decoder decodeBoolForKey:kAMTextDescriptorUnderlineKey];
        
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
        self.textColor = [decoder decodeObjectForKey:kAMTextDescriptorTextColorKey];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {

    [coder encodeFloat:self.kerning forKey:kAMTextDescriptorKerningKey];
    [coder encodeFloat:self.leading forKey:kAMTextDescriptorLeadingKey];
    [coder encodeFloat:self.baselineAdjustment forKey:kAMTextDescriptorBaselineAdjustmentKey];
    [coder encodeInt32:self.textAlignment forKey:kAMTextDescriptorTextAlignmentKey];
    [coder encodeObject:self.text forKey:kAMTextDescriptorTextKey];
    [coder encodeBool:self.underline forKey:kAMTextDescriptorUnderlineKey];
    
    if (self.systemFont) {
        [coder encodeObject:kAMTextDescriptorSystemFamily forKey:kAMTextDescriptorFontFamilyKey];
    } else {
        [coder encodeObject:self.font.familyName forKey:kAMTextDescriptorFontFamilyKey];
    }
    
    [coder encodeFloat:self.font.pointSize forKey:kAMTextDescriptorFontSizeKey];
    [coder encodeObject:self.textColor forKey:kAMTextDescriptorTextColorKey];
}

- (instancetype)initWithText:(NSString *)text {
    self = [super init];
    
    if (self != nil) {
        self.text = text;
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    
    self = [super init];
    
    if (self != nil) {
        self.kerning = [dict[kAMTextDescriptorKerningKey] floatValue];
        self.leading = [dict[kAMTextDescriptorLeadingKey] floatValue];
        self.textAlignment = [dict[kAMTextDescriptorTextAlignmentKey] integerValue];
        self.text = dict[kAMTextDescriptorTextKey];
        self.baselineAdjustment = [dict[kAMTextDescriptorBaselineAdjustmentKey] floatValue];
        self.underline = [dict[kAMTextDescriptorUnderlineKey] boolValue];
        
        NSString *fontFamily = dict[kAMTextDescriptorFontFamilyKey];
        CGFloat fontSize = [dict[kAMTextDescriptorFontSizeKey] floatValue];
        NSString *textColorString = dict[kAMTextDescriptorTextColorKey];
        
        if (fontSize <= 0.0f) {
            fontSize = 16.0f;
        }
        
        AMFont *font;
        if ([fontFamily isEqualToString:@"system-family"]) {
            font = [AMFont systemFontOfSize:fontSize];
        } else {
            font = [AMFont fontWithName:fontFamily size:fontSize];
        }

        self.font = font;
        self.textColor = [AMColor colorWithHexcodePlusAlpha:textColorString];
  }
    
    return self;
}

+ (AMTextDescriptor *)newlineDescriptor:(CGFloat)lineHeight {
    
    AMTextDescriptor *textDescriptor =
    [[AMTextDescriptor alloc] initWithText:@"\n"];
    
    textDescriptor.font = [AMFont systemFontOfSize:lineHeight];
    
    return textDescriptor;
}

- (instancetype)copy {
    
    AMTextDescriptor *wrapperCopy = [AMTextDescriptor new];
    wrapperCopy.kerning = self.kerning;
    wrapperCopy.leading = self.leading;
    wrapperCopy.text = self.text.copy;
    wrapperCopy.baselineAdjustment = self.baselineAdjustment;
    wrapperCopy.underline = self.underline;
    wrapperCopy.textColor = self.textColor.copy;
    wrapperCopy.textAlignment = self.textAlignment;
    wrapperCopy.systemFont = self.systemFont;

    return wrapperCopy;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return self.copy;
}

- (NSDictionary *)exportTextDescriptor {
    
    NSMutableDictionary *dict =
    [@{
      kAMTextDescriptorClassNameKey : NSStringFromClass(self.class),
      kAMTextDescriptorKerningKey : @(self.kerning),
      kAMTextDescriptorLeadingKey : @(self.leading),
      kAMTextDescriptorTextAlignmentKey : @(self.textAlignment),
      kAMTextDescriptorTextKey : (self.text != nil ? self.text : @""),
      kAMTextDescriptorBaselineAdjustmentKey : @(self.baselineAdjustment),
      kAMTextDescriptorUnderlineKey : @(self.underline),
      } mutableCopy];
    
    if (self.systemFont) {
        dict[kAMTextDescriptorFontFamilyKey] = kAMTextDescriptorSystemFamily;
    } else {
        dict[kAMTextDescriptorFontFamilyKey] = self.font.familyName;
    }
    dict[kAMTextDescriptorFontSizeKey] = @(self.font.pointSize);
    dict[kAMTextDescriptorTextColorKey] = [self.textColor hexcodePlusAlpha];
    
    return dict;
}

#pragma mark - Getters and Setters

- (void)setFont:(AMFont *)font {
    _font = font;
    [self clearCache];
}

- (void)setTextColor:(AMColor *)textColor {
    _textColor = textColor;
    [self clearCache];
}

- (void)setKerning:(CGFloat)kerning {
    _kerning = kerning;
    self.attributedString = nil;
}

- (void)setLeading:(CGFloat)leading {
    _leading = leading;
    self.attributedString = nil;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    _textAlignment = textAlignment;
    self.attributedString = nil;
}

- (void)setText:(NSString *)text {
    _text = text;
    self.attributedString = nil;
}

- (NSString *)text {
    
    if (_text == nil) {
        return @"";
    }
    return _text;
}

- (void)setBaselineAdjustment:(CGFloat)baselineAdjustment {
    _baselineAdjustment = baselineAdjustment;
    self.attributedString = nil;
}

- (void)setUnderline:(BOOL)underline {
    _underline = underline;
    self.attributedString = nil;
}

- (NSDictionary *)attributes {
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    NSMutableParagraphStyle *paragraphStyle =
    [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = self.textAlignment;
    
    if (self.leading > 0.0f) {
        paragraphStyle.minimumLineHeight = self.leading;
    }
        
    result[NSParagraphStyleAttributeName] = paragraphStyle;
    
    if (self.kerning > 0.0f) {
        result[NSKernAttributeName] = @(self.kerning);
    }
    
    if (self.underline) {
        result[NSUnderlineStyleAttributeName] = @(NSUnderlineStyleSingle);
    }
    
    if (self.baselineAdjustment != 0.0f) {
        result[NSBaselineOffsetAttributeName] = @(self.baselineAdjustment);
    }
    
    if (self.font != nil) {
        result[NSFontAttributeName] = self.font;
    }
    
    if (self.textColor != nil) {
        result[NSForegroundColorAttributeName] = self.textColor;
    }
    
    return result;
}

- (NSAttributedString *)attributedString {
    
    if (_attributedString == nil) {
        
        _attributedString =
        [[NSAttributedString alloc]
         initWithString:self.text
         attributes:self.attributes];
    }
    
    return _attributedString;
}

#pragma mark - Public

- (void)clearCache {
    self.attributedString = nil;
}

@end
