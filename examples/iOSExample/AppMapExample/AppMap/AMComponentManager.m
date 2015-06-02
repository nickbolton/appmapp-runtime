// DO NOT EDIT. This file is machine-generated and constantly overwritten.
#import "AMComponentManager.h"
#import "AMComponent.h"

@interface AMComponentManager()

@end

@implementation AMComponentManager

#pragma mark - Public

- (Class)rootClassForComponentIdentifier:(NSString *)componentIdentifier {

    NSDictionary * const dictionary =
    @{@"53104E62-C773-4F9D-8A81-8374C62E0C4D" : @"RootViewView", @"E4E7099D-0BD7-42C4-AAD1-B9A536F5F4A2" : @"SecondViewView", };

    if (componentIdentifier != nil) {

        NSString *className = dictionary[componentIdentifier];

        if (className != nil) {
            return NSClassFromString(className);
        }
    }
    return Nil;
}

- (Class)viewControllerClassForComponentIdentifier:(NSString *)componentIdentifier {

    NSDictionary * const dictionary =
    @{@"53104E62-C773-4F9D-8A81-8374C62E0C4D" : @"RootViewViewController", @"E4E7099D-0BD7-42C4-AAD1-B9A536F5F4A2" : @"SecondViewViewController", };

    if (componentIdentifier != nil) {

        NSString *className = dictionary[componentIdentifier];

        if (className != nil) {
            return NSClassFromString(className);
        }
    }
    return Nil;
}

- (Class)defaultClassNameForComponentType:(AMComponentType)componentType {
    NSDictionary * const dictionary =
    @{@(0) : @"AMRuntimeView", @(1) : @"AMRuntimeButton", @(2) : @"AMRuntimeView", @(3) : @"AMRuntimeView", };

    NSString *className = dictionary[@(componentType)];

    if (className != nil) {
        return NSClassFromString(className);
    }
    return Nil;
}

#pragma mark - Singleton Methods

+ (id)sharedInstance {

    static dispatch_once_t predicate;
    static AMComponentManager *sharedInstance = nil;

    dispatch_once(&predicate, ^{
        sharedInstance = [AMComponentManager new];
    });

    return sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

@end
