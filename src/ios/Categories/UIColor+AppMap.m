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
    
    return [NSString stringWithFormat:@"%f,%f,%f,%f", red, green, blue, alpha];
}

@end
