//
//  AMColor+AMColor.m
//  AppMapMacExample
//
//  Created by Nick Bolton on 1/9/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMColor+AMColor.h"

@implementation AMColorType (AMColor)

+ (AMColor *)colorWithHexcodePlusAlpha:(NSString *)colorString {
    
    NSArray *components = [colorString componentsSeparatedByString:@","];
    
    if (components.count != 4) {
        return nil;
    }
    
    NSScanner *scanner;
    float red;
    float green;
    float blue;
    float alpha;
    
    scanner = [NSScanner scannerWithString:components[0]];
    if ([scanner scanFloat:&red] == NO) {
        return nil;
    }

    scanner = [NSScanner scannerWithString:components[1]];
    if ([scanner scanFloat:&green] == NO) {
        return nil;
    }

    scanner = [NSScanner scannerWithString:components[2]];
    if ([scanner scanFloat:&blue] == NO) {
        return nil;
    }

    scanner = [NSScanner scannerWithString:components[3]];
    if ([scanner scanFloat:&alpha] == NO) {
        return nil;
    }

#if TARGET_OS_IPHONE
    
    return
    [AMColor
     colorWithRed:red
     green:green
     blue:blue
     alpha:alpha];
    
#else

    return
    [AMColor
     colorWithCalibratedRed:red
     green:green
     blue:blue
     alpha:alpha];
#endif
}

@end
