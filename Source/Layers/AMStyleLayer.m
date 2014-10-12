//
//  AMStyleLayer.m
//  AppMap
//
//  Created by Nick Bolton on 8/24/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import "AMStyleLayer.h"
#import "AMLayerDescriptor.h"
#import "AMStyleLayerRenderer.h"
#import "AMRuntimeStyleView.h"

@interface AMStyleLayer()

@end

@implementation AMStyleLayer

- (id)init {
    self = [super init];
    
    if (self != nil) {
        self.needsDisplayOnBoundsChange = YES;
        self.delegate = self;
        self.backgroundColor = [UIColor clearColor].CGColor;
    }
    
    return self;
}

#pragma mark - Getters and Setters

- (void)setLayerDescriptors:(NSArray *)layerDescriptors {
    _layerDescriptors = layerDescriptors.copy;
    [self setNeedsDisplay];
}

- (void)setNeedsDisplay {
    [super setNeedsDisplay];
}

#pragma mark - Layout

- (void)layoutSublayers {
    [super layoutSublayers];
    [self setNeedsDisplay];
}

#pragma mark - Drawing

- (void)drawInContext:(CGContextRef)ctx {
    [super drawInContext:ctx];
    [self drawStyleLayersInContext:ctx];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    [self drawStyleLayersInContext:ctx];
}

- (void)drawStyleLayersInContext:(CGContextRef)ctx {

    if (self.styleLayerDrawingDisabled) {
        return;
    }

//    kCGBlendModeNormal,
//    kCGBlendModeMultiply,
//    kCGBlendModeScreen,
//    kCGBlendModeOverlay,
//    kCGBlendModeDarken,
//    kCGBlendModeLighten,
//    kCGBlendModeColorDodge,
//    kCGBlendModeColorBurn,
//    kCGBlendModeSoftLight,
//    kCGBlendModeHardLight,
//    kCGBlendModeDifference,
//    kCGBlendModeExclusion,
//    kCGBlendModeHue,
//    kCGBlendModeSaturation,
//    kCGBlendModeColor,
//    kCGBlendModeLuminosity
//    kCGBlendModeClear,			/* R = 0 */
//    kCGBlendModeCopy,			/* R = S */
//    kCGBlendModeSourceIn,		/* R = S*Da */
//    kCGBlendModeSourceOut,		/* R = S*(1 - Da) */
//    kCGBlendModeSourceAtop,		/* R = S*Da + D*(1 - Sa) */
//    kCGBlendModeDestinationOver,	/* R = S*(1 - Da) + D */
//    kCGBlendModeDestinationIn,		/* R = D*Sa */
//    kCGBlendModeDestinationOut,		/* R = D*(1 - Sa) */
//    kCGBlendModeDestinationAtop,	/* R = S*(1 - Da) + D*Sa */
//    kCGBlendModeXOR,			/* R = S*(1 - Da) + D*(1 - Sa) */
//    kCGBlendModePlusDarker,		/* R = MAX(0, (1 - D) + (1 - S)) */
//    kCGBlendModePlusLighter		/* R = MIN(1, S + D) */

    CGContextSaveGState(ctx);
    
    AMRuntimeView *baseView = [self.styleDelegate styleLayerBaseView:self];
    CGFloat canvasScale = [self.styleDelegate styleLayerCanvasScale:self];
    
    NSEnumerationOptions options =
    self.isBehind ? NSEnumerationReverse : 0;

    [self.layerDescriptors enumerateObjectsWithOptions:options usingBlock:^(AMLayerDescriptor *descriptor, NSUInteger idx, BOOL *stop) {

        descriptor.path = [UIBezierPath bezierPathWithRect:self.bounds];
        AMStyleLayerRenderer *renderer = descriptor.layerRenderer;
        
        CGContextSetBlendMode(ctx, descriptor.blendMode);
        [renderer renderInContext:ctx inRootLayer:self baseView:baseView scale:canvasScale];
    }];

    CGContextRestoreGState(ctx);
}

@end
