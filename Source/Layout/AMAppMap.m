//
//  AMAppMap.m
//  AppMap
//
//  Created by Nick Bolton on 10/12/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import "AMAppMap.h"
#import "AMDataSource.h"
#import "AMComponent.h"
#import "AMView.h"

@interface AMAppMap()

@property (nonatomic, strong) AMDataSource *dataSource;

@end

@implementation AMAppMap

- (AMView *)viewWithIdentifier:(NSString *)identifier dataSource:(AMDataSource *)dataSource {
    return [self viewWithIdentifier:identifier dataSource:dataSource baseViewClass:[AMView class]];
}

- (AMView *)viewWithIdentifier:(NSString *)identifier
                    dataSource:(AMDataSource *)dataSource
                 baseViewClass:(Class)baseViewClass {
    
    AMView *result = nil;
    AMComponent *component = [dataSource componentWithIdentifier:identifier];
    
    if (component != nil) {
        result = [self viewWithComponent:component baseViewClass:baseViewClass];
    }
    
    return result;
}

- (AMView *)viewWithComponent:(AMComponent *)component {
    return [self viewWithComponent:component baseViewClass:[AMView class]];
}

- (AMView *)viewWithComponent:(AMComponent *)component baseViewClass:(Class)baseViewClass {
    
    AMBuilderView *view = [[component.viewClass alloc] init];
    view.component = component;

    return view;
}

@end
