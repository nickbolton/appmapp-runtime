//
//  AMComponentFactory.h
//  Prototype
//
//  Created by Nick Bolton on 8/13/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//
#import "AppMap.h"
#import "AppMapTypes.h"

@class AMComponent;

@interface AMComponentFactory : NSObject

+ (instancetype)sharedInstance;

- (AMComponent *)buildComponentWithComponentType:(AMComponentType)componentType;

@end
