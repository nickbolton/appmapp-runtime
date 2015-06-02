// DO NOT EDIT. This file is machine-generated and constantly overwritten.
#import <Foundation/Foundation.h>
#import "AMComponentManagerProtocol.h"

@class AMComponent;

@interface AMComponentManager : NSObject<AMComponentManager>

+ (instancetype)sharedInstance;

- (Class)rootClassForComponentIdentifier:(NSString *)componentIdentifier;
- (Class)viewControllerClassForComponentIdentifier:(NSString *)componentIdentifier;
- (Class)defaultClassNameForComponentType:(AMComponentType)componentType;

@end
