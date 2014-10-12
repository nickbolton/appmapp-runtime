//
//  AMLayerDescriptor.h
//  AppMap
//
//  Created by Nick Bolton on 8/24/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMStyleLayerRenderer;

@interface AMLayerDescriptor : NSObject <NSCoding>

@property (nonatomic, readonly) Class rendererClass;
@property (nonatomic, readonly) AMStyleLayerRenderer *layerRenderer;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) UIEdgeInsets insets;
@property (nonatomic) UIColor *color;
@property (nonatomic) CGFloat alpha;
@property (nonatomic) CGFloat blurRadius;
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, getter=isBehind) BOOL behind;
@property (nonatomic, getter=isBase) BOOL base;
@property (nonatomic, getter=isClipped) BOOL clipped;
@property (nonatomic) CGBlendMode blendMode;
@property (nonatomic, readonly) NSString *descriptorKey;

+ (instancetype)buildDescriptor;

@end
