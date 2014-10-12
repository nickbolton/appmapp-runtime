//
//  AMView.h
//  AppMap
//
//  Created by Nick Bolton on 8/27/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//
#import "AMRuntimeView.h"

@class AMComponent;
@class AMStyleLayer;
@class AMLayerDescriptor;
@class AMBaseView;

@interface AMView : AMRuntimeView

@property (nonatomic, readonly) AMBaseView *baseView;
@property (nonatomic, strong) AMComponent *component;
@property (nonatomic) BOOL styleLayerDrawingDisabled;
@property (nonatomic) CGFloat scale;

@property (nonatomic) NSLayoutConstraint *verticalCenter;
@property (nonatomic) NSLayoutConstraint *horizontalCenter;
@property (nonatomic) NSLayoutConstraint *width;
@property (nonatomic) NSLayoutConstraint *height;
@property (nonatomic, readonly) CGPoint positionCenter;
@property (nonatomic, readonly) CGSize positionSize;
@property (nonatomic, readonly) UIEdgeInsets positionEdges;

+ (CGFloat)pixelAlignedValue:(CGFloat)value forView:(UIView *)view;
- (CGFloat)pixelAlignedValue:(CGFloat)value;
+ (CGFloat)windowScaleForView:(UIView *)view;
- (CGFloat)windowScale;
+ (CGFloat)windowScaleValue:(CGFloat)value forView:(UIView *)view;
- (CGFloat)windowScaleValue:(CGFloat)value;

+ (CGRect)frameFromPositions:(UIEdgeInsets)positions;
+ (UIEdgeInsets)edgeInsetsFromCenter:(CGPoint)center andSize:(CGSize)size;
+ (CGRect)frameFromCenter:(CGPoint)center andSize:(CGSize)size;

- (instancetype)initWithBaseView:(AMBaseView *)baseView;
- (void)updateBaseViewContraints;
- (void)updateConstraintsFromLayerStyles;
- (void)updateConstraintsWithCenter:(CGPoint)center andSize:(CGSize)size;
- (void)clearConstraints;
- (void)constraintsDidChange;

@end
