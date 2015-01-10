//
//  AMAppMapContainerFactory.m
//  AppMap
//
//  Created by Nick Bolton on 1/4/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMAppMapContainerFactory.h"

@implementation AMAppMapContainerFactory

- (NSString *)viewClass {
    return NSStringFromClass([AMRuntimeView class]);
}

@end