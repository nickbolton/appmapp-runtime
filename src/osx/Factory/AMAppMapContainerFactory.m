//
//  AMAppMapContainerFactory.m
//  AppMap
//
//  Created by Nick Bolton on 1/4/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMAppMapContainerFactory.h"
#import "AMAppMap.h"

@implementation AMAppMapContainerFactory

- (AMRuntimeView *)buildViewFromComponent:(AMComponent *)component
                              inContainer:(NSView *)container {
    
    NSAssert(component != nil, @"no component given");
    NSAssert(container != nil, @"no container given");
    
    AMRuntimeView *view = [AMRuntimeView new];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [container addSubview:view];
    
    AMLayout *layout =
    [[AMLayoutFactory sharedInstance] buildLayoutOfType:component.layoutType];
    
    layout.view = view;
    view.layoutObject = layout;
    
    [layout updateLayoutWithFrame:component.frame];
    
    return view;
}

@end