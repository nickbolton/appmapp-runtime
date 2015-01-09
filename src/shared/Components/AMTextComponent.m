//
//  AMTextComponent.m
//  AppMap
//
//  Created by Nick Bolton on 1/1/15.
//  Copyright (c) 2015 Pixelbleed. All rights reserved.
//

#import "AMTextComponent.h"
#import "AMCompositeTextDescriptor.h"
#import "AMLabel.h"

static NSString * kAMTextComponentTextDescriptorKey = @"textDescriptor";

@implementation AMTextComponent

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    [coder encodeObject:self.textDescriptor forKey:kAMTextComponentTextDescriptorKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super initWithCoder:decoder];
    
    if (self != nil) {
        self.textDescriptor = [decoder decodeObjectForKey:kAMTextComponentTextDescriptorKey];
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    
    self = [super initWithDictionary:dict];
    
    if (self != nil) {
        
        NSDictionary *descriptorDict = dict[kAMTextComponentTextDescriptorKey];
        
        self.textDescriptor =
        [[AMCompositeTextDescriptor alloc] initWithDictionary:descriptorDict];
    }
    
    return self;
}

- (id)copy {
    
    AMTextComponent *component = super.copy;
    component.textDescriptor = self.textDescriptor.copy;
    
    return component;
}

- (NSDictionary *)exportComponent {
    
    NSMutableDictionary *dict = [[super exportComponent] mutableCopy];
    dict[kAMTextComponentTextDescriptorKey] = [self.textDescriptor exportTextDescriptor];
    
    return dict;
}

#pragma mark - Getters and Setters

- (AMComponentType)componentType {
    return AMComponentText;
}

@end
