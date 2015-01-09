//
//  AMTextDescriptor.h
//  AppMap
//
//  Created by Nick Bolton on 1/3/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//
#import "AMBaseTextDescriptor.h"

@interface AMTextDescriptor : AMBaseTextDescriptor

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic) BOOL systemFont;

+ (AMTextDescriptor *)newlineDescriptor:(CGFloat)lineHeight;

@end
