//
//  NSString+AMGenerator.m
//  AppMap
//
//  Created by Nick Bolton on 1/10/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "NSString+AMGenerator.h"

@implementation NSString (AMGenerator)

+ (NSString *)indentString:(NSInteger)level {
    
    NSMutableString *result = [NSMutableString string];
    for (NSInteger i = 0; i < level; i++) {
        [result appendString:@"    "];
    }
    return result;
}

+ (NSString *)stringToken:(NSString *)string {
    return [NSString stringWithFormat:@"@\"%@\"", string];
}

+ (NSString *)numberToken:(NSNumber *)number {
    return [NSString stringWithFormat:@"@(%@)", number];
}

@end
