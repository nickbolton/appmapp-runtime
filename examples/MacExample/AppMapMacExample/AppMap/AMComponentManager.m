// DO NOT EDIT. This file is machine-generated and constantly overwritten.
#import "AMComponentManager.h"
#import "AMComponent.h"

@interface AMComponentManager()

@end

@implementation AMComponentManager

#pragma mark - Public

- (Class)rootClassForComponentIdentifier:(NSString *)componentIdentifier {

    NSDictionary * const dictionary =
    @{@"323839F4-E33A-48CA-A298-7958DCEBE130" : @"ThirdViewView", @"944E8B5D-D3D9-4CC2-9D88-F9FE4AB84AC7" : @"RootViewView", };

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
    @{@"323839F4-E33A-48CA-A298-7958DCEBE130" : @"ThirdViewViewController", @"944E8B5D-D3D9-4CC2-9D88-F9FE4AB84AC7" : @"RootViewViewController", };

    if (componentIdentifier != nil) {

        NSString *className = dictionary[componentIdentifier];

        if (className != nil) {
            return NSClassFromString(className);
        }
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
