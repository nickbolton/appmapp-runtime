//
//  AMComponentElement.m
//  AppMapTest
//
//  Created by Nick Bolton on 8/1/14.
//  Copyright (c) 2014 Nick Bolton. All rights reserved.
//

#import "AMComponentElement.h"
#import "AppMap.h"
#import "AMView+Geometry.h"

NSString * const kAMComponentClassNameKey = @"class-name";
NSString * const kAMComponentsKey = @"components";

NSString * kAMComponentIdentifierKey = @"identifier";

@interface AMComponentElement()

@end

@implementation AMComponentElement

- (void)encodeWithCoder:(NSCoder *)coder {    
    [coder encodeObject:self.identifier forKey:kAMComponentIdentifierKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    
    if (self != nil) {
        self.identifier = [decoder decodeObjectForKey:kAMComponentIdentifierKey];
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    
    self = [super init];
    
    if (self != nil) {
        self.identifier = dict[kAMComponentIdentifierKey];
    }
    
    return self;
}

+ (instancetype)componentWithDictionary:(NSDictionary *)dict {
    
    NSString *className = dict[kAMComponentClassNameKey];
    AMComponentElement *component =
    [[NSClassFromString(className) alloc] initWithDictionary:dict];
    
    return component;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return [self copy];
}

- (instancetype)copy {
    
    AMComponentElement *component = [[self.class alloc] init];
    component.identifier = self.identifier.copy;
    
    return component;
}

+ (NSDictionary *)exportComponents:(NSArray *)components {
    
    NSMutableDictionary *componentDictionaries = [NSMutableDictionary dictionary];
    
    [components enumerateObjectsUsingBlock:^(AMComponentElement *component, NSUInteger idx, BOOL *stop) {
        
        NSDictionary *componentDict = [component exportComponent];
        componentDictionaries[component.identifier] = componentDict;
    }];
    
    NSDictionary *dict =
    @{
      kAMComponentsKey : componentDictionaries,
      };
    
    return dict;
}

- (NSDictionary *)exportComponent {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[kAMComponentIdentifierKey] = self.identifier;

    return dict;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"ComponentElement(%d): %p %@",
    (int)self.componentType, self, self.identifier];
}

#pragma mark - Getters and Setters

- (BOOL)isEqualToComponent:(AMComponentElement *)object {
    return
    [self.identifier isEqualToString:object.identifier];
}

@end
