//
//  AMStyleLayerRenderer.h
//  AppMap
//
//  Created by Nick Bolton on 8/24/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import "AMLayerDescriptor.h"

@class AMStyleLayer;
@class AMRuntimeView;
@class AMStyleLayerRenderer;

@interface AMStyleLayerRenderer : NSObject

@property (nonatomic, readonly) AMLayerDescriptor *descriptor;
@property (nonatomic, strong) CALayer *layer;

- (instancetype)initWithDescriptor:(AMLayerDescriptor *)descriptor;

- (void)layoutLayerInRootLayer:(AMStyleLayer *)rootLayer
                      baseView:(AMRuntimeView *)baseView
                      baseRect:(CGRect)baseRect
                         scale:(CGFloat)scale;

- (void)renderInContext:(CGContextRef)context
            inRootLayer:(AMStyleLayer *)rootLayer
               baseView:(AMRuntimeView *)baseView
                  scale:(CGFloat)scale;

- (void)cleanup;

@end
