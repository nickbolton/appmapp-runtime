//
//  AMComponentBehavior.m
//  AppMap
//
//  Created by Nick Bolton on 5/31/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMComponentBehavior.h"

NSString * const kAMComponentBehaviorClassKey = @"class";

@implementation AMComponentBehavior

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self != nil) {
    }
    
    return self;
}

- (AMComponentType)componentType {
    return AMComponentContainer;
}

- (NSDictionary *)exportBehavior {
    return @{kAMComponentBehaviorClassKey : NSStringFromClass(self.class)};
}

@end
