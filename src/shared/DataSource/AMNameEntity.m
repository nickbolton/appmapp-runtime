//
//  AMNameEntity.m
//  AppMap
//
//  Created by Nick Bolton on 10/16/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import "AMNameEntity.h"

static NSString * kAMNameEntityNameKey = @"name";
static NSString * kAMNameEntityLastUsedKey = @"lastUsed";

@interface AMNameEntity()

@property (nonatomic, readwrite) NSString *name;
@property (nonatomic, readwrite) NSDate *lastUsed;

@end

@implementation AMNameEntity

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    if (self) {
        
        self.name = dictionary[kAMNameEntityNameKey];
        self.lastUsed = dictionary[kAMNameEntityLastUsedKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeObject:self.name forKey:kAMNameEntityNameKey];
    [coder encodeObject:self.lastUsed forKey:kAMNameEntityLastUsedKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    
    if (self != nil) {
        
        self.name = [decoder decodeObjectForKey:kAMNameEntityNameKey];
        self.lastUsed = [decoder decodeObjectForKey:kAMNameEntityLastUsedKey];
    }
    
    return self;
}

- (instancetype)initWithName:(NSString *)name
                    lastUsed:(NSDate *)lastUsed {
    
    self = [super init];
    if (self) {
        self.name = name;
        self.lastUsed = lastUsed;
    }
    return self;
}

- (NSDictionary *)exportNameEntity {
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    if (self.name != nil) {
        result[kAMNameEntityNameKey] = self;
    }
    
    if (self.lastUsed != nil) {
        result[kAMNameEntityLastUsedKey] = self.lastUsed;
    }
    
    return result;
}

@end
