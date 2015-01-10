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
    
    return [NSString stringWithFormat:@"%f,%f,%f,%f", red, green, blue, alpha];
}

@end
