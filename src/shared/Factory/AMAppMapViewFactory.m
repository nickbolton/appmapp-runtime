//
//  AMAppMapViewFactory.m
//  AppMap
//
//  Created by Nick Bolton on 1/4/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMAppMapViewFactory.h"
#import "AMComponent.h"

@implementation AMAppMapViewFactory

- (NSString *)viewClass {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (AMView <AMRuntimeView> *)buildViewFromComponent:(AMComponent *)component
                                       inContainer:(AMView *)container {

    NSAssert(component != nil, @"no component given");
    NSAssert(container != nil, @"no container given");
    
    Class clazz = NSClassFromString(self.viewClass);
    
    AMView <AMRuntimeView> *view = [clazz new];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [container addSubview:view];
    
    view.component = component;
    return view;
}

@end
