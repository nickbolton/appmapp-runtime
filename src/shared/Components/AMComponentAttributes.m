//
//  AMComponentAttributes.m
//  AppMap
//
//  Created by Nick Bolton on 12/7/15.
//  Copyright © 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMComponentAttributes.h"
#import "AMColor+AMColor.h"

@implementation AMComponentAttributes

- (void)encodeWithCoder:(NSCoder *)coder {
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    
    if (self != nil) {
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    
    self = [super init];
    
    if (self != nil) {
        
    }
    
    return self;
}

- (instancetype)copy {
    
    AMComponentAttributes *attributes = [self.class new];
    
    return attributes;
}

- (NSDictionary *)dictionaryRepresentation {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    return dict;
}

#pragma mark - Getters and Setters

- (void)setLayoutPreset:(AMLayoutPreset)layoutPreset {
}

@end
