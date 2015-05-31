//
//  AMNavigatingButtonBehavior.m
//  AppMap
//
//  Created by Nick Bolton on 5/31/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMNavigatingButtonBehavior.h"

static NSString * const kAMNavigationBehaviorTypeKey = @"navigationType";

@implementation AMNavigatingButtonBehavior

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInteger:self.navigationType forKey:kAMNavigationBehaviorTypeKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    
    if (self != nil) {        
        self.navigationType = [decoder decodeIntegerForKey:kAMNavigationBehaviorTypeKey];
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    
    if (self != nil) {
        self.navigationType = [dictionary[kAMNavigationBehaviorTypeKey] integerValue];
    }
    
    return self;
}

- (NSDictionary *)exportBehavior {
    return @{kAMNavigationBehaviorTypeKey : @(self.navigationType)};
}

- (AMComponentType)componentType {
    return AMComponentButton;
}

@end
