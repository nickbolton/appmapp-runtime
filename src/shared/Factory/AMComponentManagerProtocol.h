//
//  AMComponentManager.h
//  AppMap
//
//  Created by Nick Bolton on 6/1/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMComponent.h"

@protocol AMComponentManager <NSObject>

- (Class)rootClassForComponentIdentifier:(NSString *)componentIdentifier;
- (Class)viewControllerClassForComponentIdentifier:(NSString *)componentIdentifier;
- (Class)defaultClassNameForComponentType:(AMComponentType)componentType;

@end
