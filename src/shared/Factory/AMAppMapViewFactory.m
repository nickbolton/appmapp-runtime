//
//  AMAppMapViewFactory.m
//  AppMap
//
//  Created by Nick Bolton on 1/4/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMAppMapViewFactory.h"
#import "AMComponent.h"
#import "AMAppMap.h"
#import "NSString+NameUtilities.h"
#import "AMComponentManagerProtocol.h"

@implementation AMAppMapViewFactory

- (AMView <AMRuntimeView> *)buildViewFromComponent:(AMComponent *)component
                                       inContainer:(AMView *)container
                                     bindingObject:(id)bindingObject {

    NSAssert(component != nil, @"no component given");
    NSAssert(container != nil, @"no container given");
    
    NSString *classPrefix =
    component.classPrefix != nil ? component.classPrefix : @"";
    
    Class viewClass;
    
    NSString *viewName =
    [NSString stringWithFormat:@"%@View",
     component.exportedName.properName];

    if (component.useCustomViewClass) {
        
        NSString *viewClassName =
        [NSString stringWithFormat:@"%@%@",
         classPrefix, viewName];
        
        viewClass = NSClassFromString(viewClassName);
        
    } else {
        
        static NSString * const componentManagerClassName = @"AMComponentManager";
        
        Class componentManagerClass = NSClassFromString(componentManagerClassName);
        
        NSAssert(componentManagerClass != Nil, @"no %@ class found", componentManagerClassName);
        
        id<AMComponentManager> componentManager = [componentManagerClass performSelector:@selector(sharedInstance)];
        
        viewClass = [componentManager defaultClassNameForComponentType:component.componentType];
        
        NSAssert(viewClass != Nil, @"no default class found for component type '%ld'", component.componentType);
    }
    
    AMView <AMRuntimeView> *view = [viewClass new];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [container addSubview:view];
    
    view.component = component;
    
    NSString *setterName =
    [NSString stringWithFormat:@"set%@:", viewName];
    
    SEL setter = NSSelectorFromString(setterName);
    
    if ([bindingObject respondsToSelector:setter]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [bindingObject performSelector:setter withObject:view];
#pragma clang diagnostic pop
    }
    
    if ([bindingObject conformsToProtocol:@protocol(AMRuntimeDelegate)]) {
        view.runtimeDelegate = bindingObject;
    }
    
    [component.childComponents enumerateObjectsUsingBlock:^(AMComponent *childComponent, NSUInteger idx, BOOL *stop) {
        
        [[AMAppMap sharedInstance]
         buildViewFromComponent:childComponent
         inContainer:view
         bindingObject:view];
    }];
    
    return view;
}

@end
