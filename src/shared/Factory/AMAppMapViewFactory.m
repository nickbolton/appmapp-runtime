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

@implementation AMAppMapViewFactory

- (NSString *)viewClass {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (AMView <AMRuntimeView> *)buildViewFromComponent:(AMComponent *)component
                                       inContainer:(AMView *)container
                                     bindingObject:(id)bindingObject {

    NSAssert(component != nil, @"no component given");
    NSAssert(container != nil, @"no container given");
    
    Class clazz = NSClassFromString(self.viewClass);
    
    AMView <AMRuntimeView> *view = [clazz new];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [container addSubview:view];
    
    view.component = component;

    NSString *setterName =
    [NSString stringWithFormat:@"set%@%@:",
     [component.exportedName substringToIndex:1].uppercaseString,
     (component.exportedName.length > 1 ? [component.exportedName substringFromIndex:1] : @"")];
    
    SEL setter = NSSelectorFromString(setterName);
    
    if ([bindingObject respondsToSelector:setter]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [bindingObject performSelector:setter withObject:view];
#pragma clang diagnostic pop
    }
    
    [component.childComponents enumerateObjectsUsingBlock:^(AMComponent *childComponent, NSUInteger idx, BOOL *stop) {
        
        [[AMAppMap sharedInstance]
         buildViewFromComponent:childComponent
         inContainer:view
         bindingObject:bindingObject];
    }];
    
    return view;
}

@end
