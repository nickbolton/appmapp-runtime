//
//  NSString+AMGenerator.h
//  AppMap
//
//  Created by Nick Bolton on 1/10/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AMGenerator)

+ (NSString *)indentString:(NSInteger)level;
+ (NSString *)stringToken:(NSString *)string;
+ (NSString *)numberToken:(NSNumber *)string;

@end
