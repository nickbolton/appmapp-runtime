//
//  AMWindowHelper.m
//  AppMap
//
//  Created by Nick Bolton on 5/28/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMWindowHelper.h"

@implementation AMWindowHelper

#pragma mark - Singleton Methods

+ (instancetype)sharedInstance {
    
    static dispatch_once_t predicate;
    static AMWindowHelper *sharedInstance = nil;
    
    dispatch_once(&predicate, ^{
        sharedInstance = [AMWindowHelper new];
    });
    
    return sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

@end
