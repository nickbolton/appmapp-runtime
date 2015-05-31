//
//  AMComponentBehavior.h
//  AppMap
//
//  Created by Nick Bolton on 5/31/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMComponent.h"

@interface AMComponentBehavior : NSObject

@property (nonatomic, readonly) AMComponentType componentType;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)exportBehavior;

@end
