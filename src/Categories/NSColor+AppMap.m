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

+ (NSColor *)colorWithHexcodePlusAlpha:(NSString *)colorString {
 
    NSArray *components = [colorString componentsSeparatedByString:@"-"];
    NSString *hexString = components.firstObject;
    NSString *alphaString = @"1.0";
    
    if (components.count > 1) {
        alphaString = components[1];
    }
    
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    
    if ([scanner scanHexInt:&rgbValue]) {
        
        NSScanner *alphaScanner = [NSScanner scannerWithString:alphaString];
        float alphaValue = 1.0f;
        
        if ([alphaScanner scanFloat:&alphaValue] == NO) {
            alphaValue = 1.0f;
        }
        
        return
        [NSColor
         colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0
         green:((rgbValue & 0xFF00) >> 8)/255.0
         blue:(rgbValue & 0xFF)/255.0
         alpha:alphaValue];
    }
    
    return nil;
}

@end
