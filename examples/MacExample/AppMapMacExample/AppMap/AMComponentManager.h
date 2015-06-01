// DO NOT EDIT. This file is machine-generated and constantly overwritten.
#import <Foundation/Foundation.h>

@class AMComponent;

@interface AMComponentManager : NSObject

+ (instancetype)sharedInstance;

- (Class)rootClassForComponentIdentifier:(NSString *)componentIdentifier;
- (Class)viewControllerClassForComponentIdentifier:(NSString *)componentIdentifier;

@end
