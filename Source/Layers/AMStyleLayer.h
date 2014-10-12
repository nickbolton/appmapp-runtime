//
//  AMStyleLayer.h
//  AppMap
//
//  Created by Nick Bolton on 8/24/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@class AMLayerDescriptor;
@class AMStyleLayer;
@class AMRuntimeView;
@class AMRuntimeStyleView;

@protocol AMStyleLayerDelegate <NSObject>

- (AMRuntimeView *)styleLayerBaseView:(AMStyleLayer *)styleLayer;
- (AMRuntimeStyleView *)styleLayerStyleView:(AMStyleLayer *)styleLayer;
- (CGFloat)styleLayerCanvasScale:(AMStyleLayer *)styleLayer;

@end

@interface AMStyleLayer : CALayer

@property (nonatomic, copy) NSArray *layerDescriptors;
@property (nonatomic) BOOL styleLayerDrawingDisabled;
@property (nonatomic) id <AMStyleLayerDelegate> styleDelegate;
@property (nonatomic, getter=isBehind) BOOL behind;

@end
