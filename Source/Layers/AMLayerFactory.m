//
//  AMLayerFactory.m
//  AppMap
//
//  Created by Nick Bolton on 10/7/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import "AMLayerFactory.h"
#import "AMVynthLayerDescriptor.h"

@interface AMLayerFactory()

@property (nonatomic, strong) NSDictionary *descriptorClasses;

@end

@implementation AMLayerFactory

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    
    self.descriptorClasses =
    @{
      @(AMLayerTypeVynth) : NSStringFromClass([AMVynthLayerDescriptor class]),
      };
}

- (id)buildLayerDescriptorOfType:(AMLayerType)type {
    
    NSString *classString = self.descriptorClasses[@(type)];
    
    NSAssert(classString != nil,
             @"No layer descriptor found for type: %d",
             type);
    
    Class clazz = NSClassFromString(classString);
    
    return [clazz buildDescriptor];
}

#pragma mark - Singleton Methods

+ (id)sharedInstance {
    
    static dispatch_once_t predicate;
    static AMLayerFactory *sharedInstance = nil;
    
    dispatch_once(&predicate, ^{
        sharedInstance = [[AMLayerFactory alloc] init];
    });
    
    return sharedInstance;
}

@end
