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
@property (nonatomic, strong) NSMutableDictionary *resourceCache;
@property (nonatomic, strong) NSMutableDictionary *componentCache;

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
    
    self.resourceCache = [NSMutableDictionary dictionary];
    self.componentCache = [NSMutableDictionary dictionary];
    
    self.factoryClasses =
    @{
      @(AMComponentContainer) : NSStringFromClass([AMAppMapContainerFactory class]),
      @(AMComponentText) : NSStringFromClass([AMAppMapLabelFactory class]),
      };
}

- (AMRuntimeView *)buildViewFromComponent:(AMComponent *)component
                              inContainer:(NSView *)container {

    NSString *classString = self.factoryClasses[@(component.componentType)];
    
    NSAssert(classString != nil,
             @"No view factory found for component type: %d",
             (int)component.componentType);
    
    Class clazz = NSClassFromString(classString);
    return [[clazz new] buildViewFromComponent:component inContainer:container];
}

- (AMRuntimeView *)buildViewFromResourceName:(NSString *)resourceName
                               componentName:(NSString *)componentName
                                 inContainer:(NSView *)container {
    
    if (resourceName == nil) {
        NSLog(@"no resourceName!");
        return nil;
    }

    if (componentName == nil) {
        NSLog(@"no componentName!");
        return nil;
    }
    
    if (container == nil) {
        NSLog(@"no container!");
        return nil;
    }
    
    NSMutableDictionary *componentCache =
    [self componentCacheForResourceName:resourceName];
    
    AMComponent *component = componentCache[componentName];
    
    if (component == nil) {

        NSDictionary *resourceDict = self.resourceCache[resourceName];
        
        if (resourceDict == nil) {
            
            NSBundle *bundle = [NSBundle mainBundle];
            NSURL *resourceURL = [bundle pathForResource:resourceName ofType:@"dict"];
            if (resourceURL != nil) {
                
                resourceDict =
                [NSDictionary dictionaryWithContentsOfURL:resourceURL];
            }
            
            if (resourceDict != nil) {
                self.resourceCache[resourceName] = resourceDict;
            } else {
                NSLog(@"no resource found named: %@", resourceName);
                return nil;
            }
        }
        
        if (componentCache.count <= 0) {
            
            [self loadComponentResourceWithDictionary:resourceDict resourceName:resourceName];
            component = componentCache[componentName];
        }
        
        if (component == nil) {
            NSLog(@"No component found named: %@ in resource: ", componentName, resourceName);
            return nil;
        }
    }
    
    return [self buildViewFromComponent:component inContainer:container];
}

- (void)loadComponentResourceWithDictionary:(NSDictionary *)resourceDict
                               resourceName:(NSString *)resourceName {
    
    
    NSMutableDictionary *componentCache =
    [self componentCacheForResourceName:resourceName];
    
    [resourceDict enumerateKeysAndObjectsUsingBlock:^(NSString *name, NSDictionary *componentDict, BOOL *stop) {
        
        NSString *className = componentDict[kAMComponentClassNameKey];
        AMComponent *component =
        [[NSClassFromString(className) alloc] initWithDictionary:componentDict];
        
        componentCache[name] = component;
        
        [self
         cacheChildComponents:component.childComponents
         parentComponentPath:name
         componentCache:componentCache];
    }];
}

- (void)cacheChildComponents:(NSArray *)childComponents
                parentComponentPath:(NSString *)parentComponentPath
              componentCache:(NSMutableDictionary *)componentCache {
    
    [childComponents enumerateObjectsUsingBlock:^(AMComponent *childComponent, NSUInteger idx, BOOL *stop) {
       
        NSString *name =
        [parentComponentPath
         stringByAppendingPathExtension:childComponent.exportedName];
        
        componentCache[name] = childComponent;
        
        [self
         cacheChildComponents:childComponent.childComponents
         parentComponentPath:name
         componentCache:componentCache];
    }];
}

#pragma mark - Getters and Setters

- (NSMutableDictionary *)componentCacheForResourceName:(NSString *)resourceName {
    
    NSMutableDictionary *cache = self.componentCache[resourceName];
    if (cache == nil) {
        cache = [NSMutableDictionary dictionary];
        self.componentCache[resourceName] = cache;
    }
    
    return cache;
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
