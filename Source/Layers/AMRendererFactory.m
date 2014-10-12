//
//  AMRendererFactory.m
//  AppMap
//
//  Created by Nick Bolton on 8/24/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import "AMRendererFactory.h"
#import "AMLayerDescriptor.h"
#import "AMStyleLayerRenderer.h"

@implementation AMRendererFactory

- (id)init {
    self = [super init];
    
    if (self != nil) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
}

- (AMStyleLayerRenderer *)buildRendererForDescriptor:(AMLayerDescriptor *)descriptor {
    return [[descriptor.rendererClass alloc] initWithDescriptor:descriptor];
}

#pragma mark - Singleton Methods

+ (instancetype)sharedInstance {
    
    static dispatch_once_t predicate;
    static AMRendererFactory *sharedInstance = nil;
    
    dispatch_once(&predicate, ^{
        sharedInstance = [[AMRendererFactory alloc] init];
    });
    
    return sharedInstance;
}

@end
