//
//  AMStyleLayerRenderer.m
//  AppMap
//
//  Created by Nick Bolton on 8/24/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import "AMStyleLayerRenderer.h"
#import "AMRuntimeView.h"

@interface AMStyleLayerRenderer()

@property (nonatomic, readwrite) AMLayerDescriptor *descriptor;

@end

@implementation AMStyleLayerRenderer

- (instancetype)initWithDescriptor:(AMLayerDescriptor *)descriptor {
    
    self = [super init];
    
    if (self != nil) {
        self.descriptor = descriptor;
    }
    
    return self;
}

- (void)layoutLayerInRootLayer:(AMStyleLayer *)rootLayer
                      baseView:(AMRuntimeView *)baseView
                      baseRect:(CGRect)baseRect
                         scale:(CGFloat)scale {
    
}

- (void)renderInContext:(CGContextRef)context
            inRootLayer:(AMStyleLayer *)rootLayer
               baseView:(AMRuntimeView *)baseView
                  scale:(CGFloat)scale {
}

- (void)cleanup {
    [self.layer removeFromSuperlayer];
    self.layer = nil;
    self.descriptor = nil;
}

@end
