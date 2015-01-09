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
        [AMColor
         colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0
         green:((rgbValue & 0xFF00) >> 8)/255.0
         blue:(rgbValue & 0xFF)/255.0
         alpha:alphaValue];
    }
    
    return nil;
}

@end
