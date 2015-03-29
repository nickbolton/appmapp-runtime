//
//  AMLayoutPresetHelper.m
//  AppMap
//
//  Created by Nick Bolton on 3/28/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMLayoutPresetHelper.h"
#import "AMComponent.h"

@interface AMLayoutPresetHelper()

@property (nonatomic, strong) NSArray *selectors;

@end

@implementation AMLayoutPresetHelper

- (instancetype)init {
    self = [super init];
    
    if (self != nil) {
        
        self.selectors =
        @[
          [NSValue valueWithPointer:@selector(layoutTypesForAMLayoutPresetFixedSizeNearestCorner:)],
          [NSValue valueWithPointer:@selector(layoutTypesForAMLayoutPresetFixedSizeRelativePosition:)],
          [NSValue valueWithPointer:@selector(layoutTypesForAMLayoutPresetFixedSizeFixedPosition:)],
          [NSValue valueWithPointer:@selector(layoutTypesForAMLayoutPresetFixedYPosHeightLeftRightMargins:)],
          [NSValue valueWithPointer:@selector(layoutTypesForAMLayoutPresetFixedXPosWidthTopBottomMargins:)],
          [NSValue valueWithPointer:@selector(layoutTypesForAMLayoutPresetFixedMargins:)],
          [NSValue valueWithPointer:@selector(layoutTypesForAMLayoutPresetProportionalMargins:)],
          ];
    }
    
    return self;
}

- (NSArray *)layoutTypesForComponent:(AMComponent *)component
                        layoutPreset:(AMLayoutPreset)layoutPreset {

    if (component != nil && layoutPreset < self.selectors.count) {
        
        NSValue *selectorValue = self.selectors[layoutPreset];
        SEL selector = selectorValue.pointerValue;
        
        IMP imp = [self methodForSelector:selector];
        NSArray * (*func)(id, SEL, AMComponent *component) = (void *)imp;
        
        return func(self, selector, component);
    }
    
    return nil;
}

//AMLayoutPresetFixedSizeNearestCorner = 0,
- (NSArray *)layoutTypesForAMLayoutPresetFixedSizeNearestCorner:(AMComponent *)component {
    
    if (component.parentComponent == nil) {
        return @[@(AMLayoutTypePosition)];
    }
    
    NSMutableArray *layoutTypes = [NSMutableArray array];
    
    // horizontal
    
    CGFloat horizontalCenterPercent = 0.0f;
    
    if (CGRectGetWidth(component.parentComponent.frame) != 0.0f) {
        
        horizontalCenterPercent =
        CGRectGetMidX(component.frame) / CGRectGetWidth(component.parentComponent.frame);
    }
    
    [layoutTypes addObject:@(AMLayoutTypeFixedWidth)];
    
    if (horizontalCenterPercent > .5f) {
        [layoutTypes addObject:@(AMLayoutTypeAnchoredRight)];
    } else {
        [layoutTypes addObject:@(AMLayoutTypeAnchoredLeft)];
    }
    
    // vertical
    
    CGFloat verticalCenterPercent = 0.0f;
    
    if (CGRectGetHeight(component.parentComponent.frame) != 0.0f) {
        
        verticalCenterPercent =
        CGRectGetMidY(component.frame) / CGRectGetHeight(component.parentComponent.frame);
    }
    
    [layoutTypes addObject:@(AMLayoutTypeFixedHeight)];

    if (verticalCenterPercent > .5f) {
        [layoutTypes addObject:@(AMLayoutTypeAnchoredBottom)];
    } else {
        [layoutTypes addObject:@(AMLayoutTypeAnchoredTop)];
    }
    
    return layoutTypes;
}

//AMLayoutPresetFixedSizeRelativePosition,
- (NSArray *)layoutTypesForAMLayoutPresetFixedSizeRelativePosition:(AMComponent *)component {

    static CGFloat const centeringThreshold = .01f;
    
    if (component.parentComponent == nil) {
        return @[@(AMLayoutTypePosition)];
    }
    
    NSMutableArray *layoutTypes = [NSMutableArray array];
    
    // horizontal
    
    CGFloat horizontalCenterPercent = 0.0f;
    
    if (CGRectGetWidth(component.parentComponent.frame) != 0.0f) {
        
        horizontalCenterPercent =
        CGRectGetMidX(component.frame) / CGRectGetWidth(component.parentComponent.frame);
    }

    [layoutTypes addObject:@(AMLayoutTypeFixedWidth)];

    if (ABS(horizontalCenterPercent - .5f) <= centeringThreshold) {
        [layoutTypes addObject:@(AMLayoutTypeCenterHorizontally)];
    } else if (horizontalCenterPercent > .5f) {
        [layoutTypes addObject:@(AMLayoutTypeProportionalRight)];
    } else {
        [layoutTypes addObject:@(AMLayoutTypeProportionalLeft)];
    }
    
    // vertical
    
    CGFloat verticalCenterPercent = 0.0f;
    
    if (CGRectGetHeight(component.parentComponent.frame) != 0.0f) {
        
        verticalCenterPercent =
        CGRectGetMidY(component.frame) / CGRectGetHeight(component.parentComponent.frame);
    }

    [layoutTypes addObject:@(AMLayoutTypeFixedHeight)];

    if (ABS(verticalCenterPercent - .5f) <= centeringThreshold) {
        [layoutTypes addObject:@(AMLayoutTypeCenterVertically)];
    } else if (verticalCenterPercent > .5f) {
        [layoutTypes addObject:@(AMLayoutTypeProportionalBottom)];
    } else {
        [layoutTypes addObject:@(AMLayoutTypeProportionalTop)];
    }
    
    return layoutTypes;
}

//AMLayoutPresetFixedSizeFixedPosition,
- (NSArray *)layoutTypesForAMLayoutPresetFixedSizeFixedPosition:(AMComponent *)component {
    return @[@(AMLayoutTypePosition)];
}

//AMLayoutPresetFixedYPosHeightLeftRightMargins,
- (NSArray *)layoutTypesForAMLayoutPresetFixedYPosHeightLeftRightMargins:(AMComponent *)component {
    return @[@(AMLayoutTypePosition)];
}

//AMLayoutPresetFixedXPosWidthTopBottomMargins,
- (NSArray *)layoutTypesForAMLayoutPresetFixedXPosWidthTopBottomMargins:(AMComponent *)component {
    return @[@(AMLayoutTypePosition)];
}

//AMLayoutPresetFixedMargins,
- (NSArray *)layoutTypesForAMLayoutPresetFixedMargins:(AMComponent *)component {
    return @[@(AMLayoutTypePosition)];
}

//AMLayoutPresetProportionalMargins,
- (NSArray *)layoutTypesForAMLayoutPresetProportionalMargins:(AMComponent *)component {
    return @[@(AMLayoutTypePosition)];
}

@end
