//
//  AMComponentFactory.m
//  Prototype
//
//  Created by Nick Bolton on 8/13/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import "AMComponentFactory.h"
#import "AMComponent.h"
#import "AMTextComponent.h"

@interface AMComponentFactory()

@property (nonatomic, strong) NSDictionary *componentClasses;

@end

@implementation AMComponentFactory

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    
    self.componentClasses =
    @{
      @(AMComponentContainer) : NSStringFromClass([AMComponent class]),
      @(AMComponentText) : NSStringFromClass([AMTextComponent class]),
      };
}

- (AMComponent *)buildComponentWithComponentType:(AMComponentType)componentType {

    NSString *classString = self.componentClasses[@(componentType)];
    
    NSAssert(classString != nil,
             @"No component found for component type: %d",
             (int)componentType);
    
    Class clazz = NSClassFromString(classString);
    
    AMComponent *component = [clazz buildComponent];
    
    component.backgroundColor = [[AMDesign sharedInstance] componentBackgroundColor];
    component.borderColor = [[AMDesign sharedInstance] componentBorderColor];

    return component;
}

#pragma mark - Singleton Methods

+ (id)sharedInstance {
    
    static dispatch_once_t predicate;
    static AMComponentFactory *sharedInstance = nil;
    
    dispatch_once(&predicate, ^{
        sharedInstance = [[AMComponentFactory alloc] init];
    });
    
    return sharedInstance;
}

@end
