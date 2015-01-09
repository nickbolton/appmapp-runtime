//
//  AMAppMap.m
//  AppMap
//
//  Created by Nick Bolton on 10/12/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import "AMAppMap.h"
#import "AMDataSource.h"
#import "AMComponent.h"
#import "AMView.h"
#import "AMAppMapContainerFactory.h"
#import "AMAppMapLabelFactory.h"

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

#if TARGET_OS_IPHONE
- (UIView *)buildViewFromComponent:(AMComponent *)component
                       inContainer:(UIView *)container {
#else
- (NSView *)buildViewFromComponent:(AMComponent *)component
                       inContainer:(NSView *)container {
#endif

    NSString *classString = self.factoryClasses[@(component.componentType)];
    
    NSAssert(classString != nil,
             @"No view factory found for component type: %d",
             (int)component.componentType);
    
    Class clazz = NSClassFromString(classString);
    return [[clazz new] buildViewFromComponent:component inContainer:container];
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
