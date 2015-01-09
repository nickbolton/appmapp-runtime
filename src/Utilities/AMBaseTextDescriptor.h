//
//  AMBaseTextDescriptor.h
//  AppMap
//
//  Created by Nick Bolton on 1/3/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

@interface AMBaseTextDescriptor : NSObject <NSCopying, NSCoding>

@property (nonatomic) CGFloat kerning;
@property (nonatomic) CGFloat leading;
@property (nonatomic) NSTextAlignment textAlignment;
@property (nonatomic, strong) NSString *text;
@property (nonatomic) CGFloat baselineAdjustment;
@property (nonatomic) BOOL underline;
@property (nonatomic, strong) NSDictionary *attributes;
@property (nonatomic, readonly) NSAttributedString *attributedString;

- (instancetype)initWithText:(NSString *)text;

- (void)clearCache;

@end
