//
//  NSString+NameUtilities.m
//  amgen
//
//  Created by Nick Bolton on 5/28/15.
//  Copyright (c) 2015 Pixelbleed. All rights reserved.
//

#import "NSString+NameUtilities.h"

@implementation NSString (NameUtilities)

- (NSString *)properName {

    NSMutableString *result = [NSMutableString string];
    NSString *firstCharacter = [[self substringToIndex:1] uppercaseString];

    [result appendString:firstCharacter];

    if (self.length > 1) {
        [result appendString:[self substringFromIndex:1]];
    }

    return result;
}

@end
