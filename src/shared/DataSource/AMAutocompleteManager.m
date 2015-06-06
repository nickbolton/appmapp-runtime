//
//  AMAutocompleteManager.m
//  AppMap
//
//  Created by Nick Bolton on 10/16/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import "AMAutocompleteManager.h"
#import "AMDataSource.h"

@implementation AMAutocompleteManager

#pragma mark - HTAutocompleteTextFieldDelegate

- (NSString *)textField:(HTAutocompleteTextField *)textField
    completionForPrefix:(NSString *)prefix
             ignoreCase:(BOOL)ignoreCase {
    
    NSArray *results = [self.dataSource nameCompletions:prefix];
    
    NSString *completion = results.firstObject;
    
    if (completion.length > 0) {
        return [completion substringFromIndex:prefix.length];
    }
    
    return @"";
}

#pragma mark - Singleton Methods

+ (id)sharedInstance {
    
    static dispatch_once_t predicate;
    static AMAutocompleteManager *sharedInstance = nil;
    
    dispatch_once(&predicate, ^{
        sharedInstance = [[AMAutocompleteManager alloc] init];
    });
    
    return sharedInstance;
}

@end
