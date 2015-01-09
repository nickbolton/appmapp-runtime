//
//  NSColor+AppMap.m
//  AppMap
//
//  Created by Nick Bolton on 1/8/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "NSColor+AppMap.h"

@implementation NSColor (AppMap)

- (NSString *)hexcodePlusAlpha {

    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    
    if ([self.colorSpaceName isEqualToString:NSCalibratedWhiteColorSpace]) {
        
        red = self.whiteComponent;
        blue = self.whiteComponent;
        green = self.whiteComponent;
        alpha = self.alphaComponent;
        
    } else {
        
        [self getRed:&red green:&green blue:&blue alpha:&alpha];
    }
    
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
