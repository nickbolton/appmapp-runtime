//
//  AMAppMap.m
//  AppMap
//
//  Created by Nick Bolton on 10/12/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import "AMAppMap.h"
#import "AMComponent.h"
#import "AMAppMapContainerFactory.h"
#import "AMAppMapLabelFactory.h"

NSString * const kAMComponentsKey = @"components";

@interface AMAppMap()

@property (nonatomic, strong) NSDictionary *factoryClasses;

@end

@implementation AMAppMap

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {

    self.factoryClasses =
    @{
      @(AMComponentContainer) : NSStringFromClass([AMAppMapContainerFactory class]),
      @(AMComponentText) : NSStringFromClass([AMAppMapLabelFactory class]),
      };
}

- (AMRuntimeView *)buildViewFromComponent:(AMComponent *)component
                              inContainer:(AMView *)container {
    return
    [self
     buildViewFromComponent:component
     inContainer:container
     bindingObject:nil];
}

- (AMRuntimeView *)buildViewFromComponent:(AMComponent *)component
                              inContainer:(AMView *)container
                            bindingObject:(id)bindingObject {

    NSString *classString = self.factoryClasses[@(component.componentType)];
    
    NSAssert(classString != nil,
             @"No view factory found for component type: %d",
             (int)component.componentType);
    
    Class clazz = NSClassFromString(classString);
    return [[clazz new] buildViewFromComponent:component inContainer:container bindingObject:bindingObject];
}

- (AMComponent *)loadComponentWithDictionary:(NSDictionary *)componentDict {
    
    NSString *className = componentDict[kAMComponentClassNameKey];
    AMComponent *component =
    [[NSClassFromString(className) alloc] initWithDictionary:componentDict];
    return component;
}

#pragma mark - Singleton Methods

+ (id)sharedInstance {
    
    static dispatch_once_t predicate;
    static AMAppMap *sharedInstance = nil;
    
    dispatch_once(&predicate, ^{
        sharedInstance = [[AMAppMap alloc] init];
    });
    
    return sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}


@end
