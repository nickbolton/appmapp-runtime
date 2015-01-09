//
//  AMBaseTextDescriptor.m
//  AppMap
//
//  Created by Nick Bolton on 1/3/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMBaseTextDescriptor.h"

static NSString * const kAMBaseTextDescriptorKerningKey = @"kerning";
static NSString * const kAMBaseTextDescriptorLeadingKey = @"leading";
static NSString * const kAMBaseTextDescriptorTextAlignmentKey = @"textAlignment";
static NSString * const kAMBaseTextDescriptorTextKey = @"text";
static NSString * const kAMBaseTextDescriptorBaselineAdjustmentKey = @"baselineAdjustment";
static NSString * const kAMBaseTextDescriptorUnderlineKey = @"underline";

@interface AMBaseTextDescriptor()

@property (nonatomic, readwrite) NSAttributedString *attributedString;

@end

@implementation AMBaseTextDescriptor

@synthesize text = _text;

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.kerning = [decoder decodeFloatForKey:kAMBaseTextDescriptorKerningKey];
        self.leading = [decoder decodeFloatForKey:kAMBaseTextDescriptorLeadingKey];
        self.baselineAdjustment = [decoder decodeFloatForKey:kAMBaseTextDescriptorBaselineAdjustmentKey];
        self.textAlignment = [decoder decodeInt32ForKey:kAMBaseTextDescriptorTextAlignmentKey];
        self.text = [decoder decodeObjectForKey:kAMBaseTextDescriptorTextKey];
        self.underline = [decoder decodeBoolForKey:kAMBaseTextDescriptorUnderlineKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {

    [coder encodeFloat:self.kerning forKey:kAMBaseTextDescriptorKerningKey];
    [coder encodeFloat:self.leading forKey:kAMBaseTextDescriptorLeadingKey];
    [coder encodeFloat:self.baselineAdjustment forKey:kAMBaseTextDescriptorBaselineAdjustmentKey];
    [coder encodeInt32:self.textAlignment forKey:kAMBaseTextDescriptorTextAlignmentKey];
    [coder encodeObject:self.text forKey:kAMBaseTextDescriptorTextKey];
    [coder encodeBool:self.underline forKey:kAMBaseTextDescriptorUnderlineKey];
}

- (instancetype)initWithText:(NSString *)text {
    self = [super init];
    
    if (self != nil) {
        self.text = text;
    }
    
    return self;
}

- (instancetype)copy {
    
    AMBaseTextDescriptor *wrapperCopy = [AMBaseTextDescriptor new];
    wrapperCopy.kerning = self.kerning;
    wrapperCopy.leading = self.leading;
    wrapperCopy.text = self.text.copy;
    wrapperCopy.baselineAdjustment = self.baselineAdjustment;
    wrapperCopy.underline = self.underline;

    return wrapperCopy;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return self.copy;
}

#pragma mark - Getters and Setters

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
