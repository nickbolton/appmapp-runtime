//
//  AMButtonBehavior.m
//  AppMap
//
//  Created by Nick Bolton on 5/31/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMButtonBehavior.h"

@implementation AMButtonBehavior

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    
    if (self != nil) {
    }
    
    return self;
}

- (NSDictionary *)exportBehavior {
    return @{};
}

- (AMComponentType)componentType {
    return AMComponentButton;
}

@end
