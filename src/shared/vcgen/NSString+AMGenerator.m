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

+ (NSString *)literalStringForObject:(id)obj {
    
    if ([obj isKindOfClass:[NSString class]]) {
        return [NSString stringToken:obj];
    } else if ([obj isKindOfClass:[NSArray class]]) {
        
        NSArray *array = obj;
        
        NSMutableString *result = [NSMutableString string];
        [result appendString:@"@["];
        
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            NSString *valueToken = [NSString literalStringForObject:obj];
            
            [result appendString:valueToken];
            [result appendString:@","];
        }];
        
        [result appendString:@"]"];
        
        return result;
        
    } else if ([obj isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *dict = obj;
        
        NSMutableString *result = [NSMutableString string];
        [result appendString:@"@{"];

        [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
            
            NSString *keyToken = [NSString stringToken:key];
            NSString *valueToken = [NSString literalStringForObject:obj];
            
            [result appendString:keyToken];
            [result appendString:@" : "];
            [result appendString:valueToken];
            [result appendString:@","];
        }];
        
        [result appendString:@"}"];

        return result;

    } else if ([obj isKindOfClass:[NSNumber class]]) {
        return [NSString numberToken:obj];
    }

    NSAssert(YES, @"Unsupported object type: %@ - %@", NSStringFromClass([obj class]), obj);
    
    return @"";
}

@end
