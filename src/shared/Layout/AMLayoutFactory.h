//
//  AMLayoutFactory.h
//  AppMap
//
//  Created by Nick Bolton on 12/28/14.
//  Copyright (c) 2014 Pixelbleed LLC. All rights reserved.
//
#import "AppMap.h"

@class AMLayout;

@interface AMLayoutFactory : NSObject

- (AMLayout *)buildLayoutOfType:(AMLayoutType)layoutType;

+ (instancetype)sharedInstance;

@end
