//
//  AMTextDescriptor.h
//  AppMap
//
//  Created by Nick Bolton on 1/3/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//
#import "AppMap.h"

extern NSString * const kAMTextDescriptorClassNameKey;

@interface AMTextDescriptor : NSObject <NSCopying, NSCoding>

@property (nonatomic) CGFloat kerning;
@property (nonatomic) CGFloat leading;
@property (nonatomic) NSTextAlignment textAlignment;
@property (nonatomic, strong) NSString *text;
@property (nonatomic) CGFloat baselineAdjustment;
@property (nonatomic) BOOL underline;
@property (nonatomic, strong) NSDictionary *attributes;
@property (nonatomic, readonly) NSAttributedString *attributedString;
@property (nonatomic, strong) AMFont *font;
@property (nonatomic, strong) AMColor *textColor;
@property (nonatomic) BOOL systemFont;

+ (AMTextDescriptor *)newlineDescriptor:(CGFloat)lineHeight;

- (instancetype)initWithText:(NSString *)text;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)exportTextDescriptor;
- (void)clearCache;

@end
