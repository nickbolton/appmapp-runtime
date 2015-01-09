//
//  UIColor+AppMap.m
//  AppMap
//
//  Created by Nick Bolton on 1/8/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "UIColor+AppMap.h"

@implementation UIColor (AppMap)

- (NSString *)hexcodePlusAlpha {

    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    
    red *= 255.0f;
    green *= 255.0f;
    blue *= 255.0f;
    
    NSInteger hexcode =
    (NSInteger)(red * 255) * 256 * 256 +
    (NSInteger)(green * 255) * 256 +
    (NSInteger)(blue * 255) * 1;
    
    return [NSString stringWithFormat:@"%ld-%f", (long)hexcode, alpha];
}

@end
