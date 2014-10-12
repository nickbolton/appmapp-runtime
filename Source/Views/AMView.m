//
//  AMView.m
//  AppMap
//
//  Created by Nick Bolton on 8/27/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import "AMView.h"
#import "AMStyleLayer.h"
#import "AMComponent.h"
#import "AMLayerDescriptor.h"
#import "AMStyleLayerRenderer.h"
#import "AMRuntimeView.h"
#import "AMStyleLayer.h"
#import "AMRuntimeStyleView.h"
#import "AMCanvas.h"
#import "AMBaseView.h"
#import "Masonry.h"

@interface AMView() <AMStyleLayerDelegate>

@property (nonatomic, readwrite) AMBaseView *baseView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableArray *aboveLayerDescriptors;
@property (nonatomic, strong) NSMutableArray *belowLayerDescriptors;
@property (nonatomic, strong) NSLayoutConstraint *baseViewTopSpace;
@property (nonatomic, strong) NSLayoutConstraint *baseViewBottomSpace;
@property (nonatomic, strong) NSLayoutConstraint *baseViewLeftSpace;
@property (nonatomic, strong) NSLayoutConstraint *baseViewRightSpace;
@property (nonatomic, strong) AMRuntimeStyleView *aboveStyleView;
@property (nonatomic, strong) AMRuntimeStyleView *belowStyleView;
@property (nonatomic, weak) AMCanvas *canvas;

@end

@implementation AMView

- (instancetype)initWithBaseView:(AMBaseView *)baseView {
    
    self = [super init];
    
    if (self != nil) {
        self.baseView = baseView;
        [self __commonInit];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self __commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self __commonInit];
    }
    return self;
}

- (void)__commonInit {
    
    [self setupContentView];
    
#if TARGET_OS_IPHONE
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
#else
    self.wantsLayer = YES;
    self.layer.rasterizationScale = self.window.backingScaleFactor;
#endif
    
    self.layer.shouldRasterize = YES;
    self.layer.backgroundColor = [UIColor clearColor].CGColor;

    self.aboveLayerDescriptors = [NSMutableArray array];
    self.belowLayerDescriptors = [NSMutableArray array];
    
    self.belowStyleView = [[AMRuntimeStyleView alloc] init];
    self.belowStyleView.translatesAutoresizingMaskIntoConstraints = NO;
    self.belowStyleView.styleLayer.styleDelegate = self;
    self.belowStyleView.styleLayer.behind = YES;
    
    [self.contentView addSubview:self.belowStyleView];
    [NSLayoutConstraint expandToSuperview:self.belowStyleView];

    if (self.baseView == nil) {
        self.baseView = [[AMBaseView alloc] init];
//#if TARGET_OS_IPHONE
//        self.baseView.alpha = .5f;
//#else
//        self.baseView.alphaValue = .5f;
//#endif
    }
    
    [self.baseView removeConstraints:self.baseView.constraints.copy];
    
    if (self.baseViewTopSpace != nil) {
        [self removeConstraint:self.baseViewTopSpace];
    }

    if (self.baseViewBottomSpace != nil) {
        [self removeConstraint:self.baseViewBottomSpace];
    }

    if (self.baseViewLeftSpace != nil) {
        [self removeConstraint:self.baseViewLeftSpace];
    }

    if (self.baseViewRightSpace != nil) {
        [self removeConstraint:self.baseViewRightSpace];
    }

    self.baseView.translatesAutoresizingMaskIntoConstraints = NO;    
    
    [self.contentView addSubview:self.baseView];

    self.baseViewTopSpace =
    [NSLayoutConstraint alignToTop:self.baseView withPadding:0.0f];

    self.baseViewBottomSpace =
    [NSLayoutConstraint alignToBottom:self.baseView withPadding:0.0f];

    self.baseViewLeftSpace =
    [NSLayoutConstraint alignToLeft:self.baseView withPadding:0.0f];

    self.baseViewRightSpace =
    [NSLayoutConstraint alignToRight:self.baseView withPadding:0.0f];
    
    self.aboveStyleView = [[AMRuntimeStyleView alloc] init];
    self.aboveStyleView.translatesAutoresizingMaskIntoConstraints = NO;
    self.aboveStyleView.styleLayer.styleDelegate = self;
    [self.contentView addSubview:self.aboveStyleView];
    [NSLayoutConstraint expandToSuperview:self.aboveStyleView];
    
    [self doit];
}

- (void)doit {

    NSLog(@"===============================");
    NSLog(@"self: %@", self);
    NSLog(@"baseView: %@", self.baseView);
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self doit];
    });
}

- (void)setupContentView {
    
    UIView *view = [UIView new];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:view];
    
    [NSLayoutConstraint expandToSuperview:view];
    self.contentView = view;
}

#pragma mark - Getters and Setters

- (void)setStyleLayerDrawingDisabled:(BOOL)styleLayerDrawingDisabled {
    _styleLayerDrawingDisabled = styleLayerDrawingDisabled;
    [self updateStyleLayerVisibility];
}

- (void)setComponent:(AMComponent *)component {
    
    _component = component;
    [self setBaseAttributes];
    [self clearDescriptors];
    
    if (component != nil) {
        
        // add the descriptor for the base view
        AMLayerDescriptor *baseDescriptor = [component baseViewLayerDescriptor];
        [self.belowLayerDescriptors addObject:baseDescriptor];
    }

    NSArray *aboveDescriptors = component.layerStylesAboveBase;
    NSArray *belowDescriptors = component.layerStylesBelowBase;

    [self.aboveLayerDescriptors addObjectsFromArray:aboveDescriptors];
    [self.belowLayerDescriptors addObjectsFromArray:belowDescriptors];

    self.aboveStyleView.styleLayer.layerDescriptors = self.aboveLayerDescriptors;
    self.belowStyleView.styleLayer.layerDescriptors = self.belowLayerDescriptors;
    
    self.baseView.layer.cornerRadius = component.cornerRadius;
    
    [self updateStyleLayerVisibility];
    [self updateStyleLayerInsets];
}

- (CGFloat)canvasScale {
    return self.canvas.scaleFactor;
}

- (AMCanvas *)canvas {
    
    if (_canvas == nil) {
        
        UIView *result = self.superview;
        while (result != nil && [result isKindOfClass:[AMCanvas class]] == NO) {
            result = result.superview;
        }
        
        _canvas = (id)result;
    }
    
    return _canvas;
}

#pragma mark - Public

- (void)cleanup {
    [super cleanup];
    self.component = nil;
    [self.aboveStyleView cleanup];
    [self.belowStyleView cleanup];
}

#pragma mark - Private

- (void)setBaseAttributes {
    self.baseView.clipsToBounds = self.component.blurRadius <= 0.0f && self.component.isClipped;
    self.baseView.backgroundColor = [UIColor clearColor];
    self.contentView.alpha = self.component.alpha;
}

#pragma mark - Style Layers

- (void)updateStyleLayerVisibility {
    
    self.aboveStyleView.hidden =
    self.aboveLayerDescriptors.count == 0;
    
    self.belowStyleView.hidden =
    self.belowLayerDescriptors.count == 0;
    
    self.aboveStyleView.hidden =
    self.aboveLayerDescriptors.count == 0 ||
    self.styleLayerDrawingDisabled;
    
    self.belowStyleView.hidden =
    self.belowLayerDescriptors.count == 0 ||
    self.styleLayerDrawingDisabled;
}

#pragma mark - Descriptor Management

- (void)clearDescriptors {
    [self.aboveLayerDescriptors removeAllObjects];
    [self.belowLayerDescriptors removeAllObjects];
    self.aboveStyleView.styleLayer.layerDescriptors = self.aboveLayerDescriptors;
    self.belowStyleView.styleLayer.layerDescriptors = self.belowLayerDescriptors;
}

#pragma mark - Frame Handlers

- (CGFloat)windowScale {
    return [self.class windowScaleForView:self];
}

+ (CGFloat)windowScaleForView:(UIView *)view {
    
    CGFloat scale = 1.0f;
    
#if TARGET_OS_IPHONE
    scale = [[UIScreen mainScreen] scale];
#else
    scale = view.window.backingScaleFactor;
#endif
    
    return scale;
}

+ (CGFloat)windowScaleValue:(CGFloat)value forView:(UIView *)view {
    
    CGFloat scale = [self.class windowScaleForView:view];
    
    if (scale > 0.0f) {
        return value / scale;
    }
    return value;
}

- (CGFloat)windowScaleValue:(CGFloat)value {
    return [self.class windowScaleValue:value forView:self];
}

- (CGFloat)pixelAlignedValue:(CGFloat)value {
    return [self.class pixelAlignedValue:value forView:self];
}

+ (CGFloat)pixelAlignedValue:(CGFloat)value forView:(UIView *)view {
    
    CGFloat scale = [self.class windowScaleForView:view];
    
    if (scale > 0.0f) {
        return roundf(value * scale) / scale;
    }
    
    return value;
}

+ (CGRect)frameFromPositions:(UIEdgeInsets)positions {
    
    return
    CGRectMake(positions.left,
               positions.top,
               positions.right - positions.left,
               positions.bottom - positions.top);
}

- (CGPoint)positionCenter {
    return CGPointMake(self.horizontalCenter.constant, self.verticalCenter.constant);
}

- (CGSize)positionSize {
    return CGSizeMake(self.width.constant, self.height.constant);
}

+ (UIEdgeInsets)edgeInsetsFromCenter:(CGPoint)center andSize:(CGSize)size {
    
    CGFloat halfWidth = size.width / 2.0f;
    CGFloat halfHeight = size.height / 2.0f;
    
    CGFloat top = center.y - halfHeight;
    CGFloat bottom = center.y + halfHeight;
    CGFloat left = center.x - halfWidth;
    CGFloat right = center.x + halfWidth;
    
    return UIEdgeInsetsMake(top, left, bottom, right);
}

+ (CGRect)frameFromCenter:(CGPoint)center andSize:(CGSize)size {
    
    CGFloat halfWidth = size.width / 2.0f;
    CGFloat halfHeight = size.height / 2.0f;
    
    return
    CGRectMake(center.x - halfWidth,
               center.y - halfHeight,
               size.width,
               size.height);
}

- (UIEdgeInsets)positionEdges {
    
    CGPoint center = self.positionCenter;
    CGSize size = self.positionSize;
    return [self.class edgeInsetsFromCenter:center andSize:size];
}

#pragma mark - View Hierarchy

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self updateViewConstraints];
}

#pragma mark - Constraints

- (void)updateViewConstraints {
    
    CGPoint center =
    CGPointMake(self.scale * self.component.baseCenter.x,
                self.scale * self.component.baseCenter.y);
    
    CGSize size =
    CGSizeMake(self.scale * self.component.baseSize.width,
               self.scale * self.component.baseSize.height);
    
    [self updateConstraintsWithCenter:center andSize:size];
}

- (void)clearConstraints {
    [self.superview removeConstraint:self.verticalCenter];
    [self.superview removeConstraint:self.horizontalCenter];
    [self removeConstraint:self.width];
    [self removeConstraint:self.height];
    
    self.verticalCenter = nil;
    self.horizontalCenter = nil;
    self.width = nil;
    self.height = nil;
}

- (void)createConstraintsIfNecessary {
    
    if (self.verticalCenter == nil) {
        
        self.verticalCenter =
        [NSLayoutConstraint
         constraintWithItem:self
         attribute:NSLayoutAttributeCenterY
         relatedBy:NSLayoutRelationEqual
         toItem:self.superview
         attribute:NSLayoutAttributeTop
         multiplier:1.0f
         constant:0.0f];
        
        [self.superview addConstraint:self.verticalCenter];
    }
    
    if (self.horizontalCenter == nil) {
        
        self.horizontalCenter =
        [NSLayoutConstraint
         constraintWithItem:self
         attribute:NSLayoutAttributeCenterX
         relatedBy:NSLayoutRelationEqual
         toItem:self.superview
         attribute:NSLayoutAttributeLeft
         multiplier:1.0f
         constant:0.0f];
        
        [self.superview addConstraint:self.horizontalCenter];
    }
    
    if (self.width == nil) {
        self.width = [NSLayoutConstraint addWidthConstraint:0.0f toView:self];
    }
    
    if (self.height == nil) {
        self.height = [NSLayoutConstraint addHeightConstraint:0.0f toView:self];
    }
}

- (void)updateConstraintsWithCenter:(CGPoint)center andSize:(CGSize)size {
    
    [self createConstraintsIfNecessary];
    
    CGFloat xCenter = [self pixelAlignedValue:center.x];
    CGFloat yCenter = [self pixelAlignedValue:center.y];
    CGFloat width = [self pixelAlignedValue:size.width];
    CGFloat height = [self pixelAlignedValue:size.height];
    
    CGFloat topAdjustment = MAX(0.0f, self.baseView.styleLayerInsets.top);
    CGFloat bottomAdjustment = MAX(0.0f, self.baseView.styleLayerInsets.bottom);
    CGFloat leftAdjustment = MAX(0.0f, self.baseView.styleLayerInsets.left);
    CGFloat rightAdjustment = MAX(0.0f, self.baseView.styleLayerInsets.right);
    
    yCenter -= topAdjustment / 2.0f;
    yCenter += bottomAdjustment / 2.0f;
    
    xCenter -= leftAdjustment / 2.0f;
    xCenter += rightAdjustment / 2.0f;
    
    width += leftAdjustment + rightAdjustment;
    height += topAdjustment + bottomAdjustment;

    if (self.verticalCenter != nil) {
        
        self.verticalCenter.constant = yCenter;
        
    } else {
        
        self.verticalCenter =
        [NSLayoutConstraint
         constraintWithItem:self
         attribute:NSLayoutAttributeCenterY
         relatedBy:NSLayoutRelationEqual
         toItem:self.superview
         attribute:NSLayoutAttributeTop
         multiplier:1.0f
         constant:yCenter];
        
        [self.superview addConstraint:self.verticalCenter];
    }
    
    if (self.horizontalCenter != nil) {
        
        self.horizontalCenter.constant = xCenter;
        
    } else {
        
        self.horizontalCenter =
        [NSLayoutConstraint
         constraintWithItem:self
         attribute:NSLayoutAttributeCenterX
         relatedBy:NSLayoutRelationEqual
         toItem:self.superview
         attribute:NSLayoutAttributeLeft
         multiplier:1.0f
         constant:xCenter];
        
        [self.superview addConstraint:self.horizontalCenter];
    }
    
    if (self.width != nil) {
        self.width.constant = width;
    } else {
        self.width = [NSLayoutConstraint addWidthConstraint:width toView:self];
    }
    
    if (self.height != nil) {
        self.height.constant = height;
    } else {
        self.height = [NSLayoutConstraint addHeightConstraint:height toView:self];
    }
    
    [self updateBaseViewContraints];

    [self constraintsDidChange];
}

- (void)constraintsDidChange {
}

#pragma mark - Layout

#if TARGET_OS_IPHONE
- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateLayouts];
}
#else
- (void)layout {
    [super layout];
    [self updateLayouts];
}
#endif

- (void)updateLayouts {
    
    CGFloat scale = 1.0f;//self.canvasScale;
    
    [self.aboveLayerDescriptors enumerateObjectsUsingBlock:^(AMLayerDescriptor *descriptor, NSUInteger idx, BOOL *stop) {
        
        AMStyleLayerRenderer *renderer = descriptor.layerRenderer;
        [renderer
         layoutLayerInRootLayer:self.aboveStyleView.styleLayer
         baseView:self.baseView
         baseRect:self.baseView.frame
         scale:scale];
    }];
    
    [self.belowLayerDescriptors enumerateObjectsUsingBlock:^(AMLayerDescriptor *descriptor, NSUInteger idx, BOOL *stop) {
        
        AMStyleLayerRenderer *renderer = descriptor.layerRenderer;
        [renderer
         layoutLayerInRootLayer:self.belowStyleView.styleLayer
         baseView:self.baseView
         baseRect:self.baseView.frame
         scale:scale];
    }];
}

- (void)updateStyleLayerInsets {

    __block UIEdgeInsets totalInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    
    [self.aboveLayerDescriptors enumerateObjectsUsingBlock:^(AMLayerDescriptor *descriptor, NSUInteger idx, BOOL *stop) {
        
        if (descriptor.isClipped == NO) {
            
            totalInsets.top = MAX(totalInsets.top, -descriptor.insets.top);
            totalInsets.left = MAX(totalInsets.left, -descriptor.insets.left);
            totalInsets.bottom = MAX(totalInsets.bottom, -descriptor.insets.bottom);
            totalInsets.right = MAX(totalInsets.right, -descriptor.insets.right);
        }
    }];
    
    [self.belowLayerDescriptors enumerateObjectsUsingBlock:^(AMLayerDescriptor *descriptor, NSUInteger idx, BOOL *stop) {
        
        if (descriptor.isClipped == NO) {
            totalInsets.top = MAX(totalInsets.top, -descriptor.insets.top);
            totalInsets.left = MAX(totalInsets.left, -descriptor.insets.left);
            totalInsets.bottom = MAX(totalInsets.bottom, -descriptor.insets.bottom);
            totalInsets.right = MAX(totalInsets.right, -descriptor.insets.right);
        }
    }];
    
    UIEdgeInsets styleLayerInsets;
    styleLayerInsets.top = -totalInsets.top;
    styleLayerInsets.bottom = totalInsets.bottom;
    styleLayerInsets.left = -totalInsets.left;
    styleLayerInsets.right = totalInsets.right;
    
    self.baseView.styleLayerInsets = styleLayerInsets;
}

- (void)updateBaseViewContraints {
    
    UIEdgeInsets styleLayerInsets = self.baseView.styleLayerInsets;
    styleLayerInsets.top = -styleLayerInsets.top;
    styleLayerInsets.left = -styleLayerInsets.left;
    
    CGFloat scale = 1.0f;//self.canvasScale;
    
    CGFloat topSpace = MAX(0.0f, styleLayerInsets.top);
    CGFloat bottomSpace = -MAX(0.0f, styleLayerInsets.bottom);
    CGFloat leftSpace = MAX(0.0f, styleLayerInsets.left);
    CGFloat rightSpace = -MAX(0.0f, styleLayerInsets.right);
    
    self.baseViewTopSpace.constant = topSpace * scale;
    self.baseViewBottomSpace.constant = bottomSpace * scale;
    self.baseViewLeftSpace.constant = leftSpace * scale;
    self.baseViewRightSpace.constant = rightSpace * scale;
    
#if TARGET_OS_IPHONE
    [self.baseView layoutIfNeeded];
#else
    [self.baseView layout];
#endif

    [self updateLayouts];
}

#pragma mark - AMStyleLayerDelegate Conformance

- (AMRuntimeView *)styleLayerBaseView:(AMStyleLayer *)styleLayer {
    return self.baseView;
}

- (AMRuntimeStyleView *)styleLayerStyleView:(AMStyleLayer *)styleLayer {
    
    if (self.aboveStyleView.layer == styleLayer) {
        return self.aboveStyleView;
    } else if (self.belowStyleView.layer == styleLayer) {
        return self.belowStyleView;
    }
    return nil;
}

- (CGFloat)styleLayerCanvasScale:(AMStyleLayer *)styleLayer {
    return self.canvas.scaleFactor;
}

@end
