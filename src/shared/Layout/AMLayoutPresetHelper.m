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

- (AMLayoutType)horizontalLayoutTypeBasedOnPosition:(AMComponent *)component
                                             center:(BOOL)center {
    
    static CGFloat const centeringThreshold = .01f;

    CGFloat horizontalCenterPercent = 0.0f;
    
    if (CGRectGetWidth(component.parentComponent.frame) != 0.0f) {
        
        horizontalCenterPercent =
        CGRectGetMidX(component.frame) / CGRectGetWidth(component.parentComponent.frame);
    }
    
    if (center && ABS(horizontalCenterPercent - .5f) <= centeringThreshold) {
        return AMLayoutTypeCenterHorizontally;
    }

    if (horizontalCenterPercent > .5f) {
        return AMLayoutTypeAnchoredRight;
    }
    
    return AMLayoutTypeAnchoredLeft;
}

- (AMLayoutType)verticalLayoutTypeBasedOnPosition:(AMComponent *)component
                                           center:(BOOL)center {
    
    static CGFloat const centeringThreshold = .01f;

    CGFloat verticalCenterPercent = 0.0f;
    
    if (CGRectGetHeight(component.parentComponent.frame) != 0.0f) {
        
        verticalCenterPercent =
        CGRectGetMidY(component.frame) / CGRectGetHeight(component.parentComponent.frame);
    }
    
    if (center && ABS(verticalCenterPercent - .5f) <= centeringThreshold) {
        return AMLayoutTypeCenterVertically;
    }
    
    if (verticalCenterPercent > .5f) {
        return AMLayoutTypeAnchoredBottom;
    }
    
    return AMLayoutTypeAnchoredTop;
}

//AMLayoutPresetFixedSizeNearestCorner = 0,
- (NSArray *)layoutTypesForAMLayoutPresetFixedSizeNearestCorner:(AMComponent *)component {
    
    if (component.parentComponent == nil) {
        return @[@(AMLayoutTypePosition)];
    }
    
    NSMutableArray *layoutTypes = [NSMutableArray array];
    
    // horizontal
    
    AMLayoutType leftOrRightLayout = [self horizontalLayoutTypeBasedOnPosition:component center:NO];
    [layoutTypes addObject:@(AMLayoutTypeFixedWidth)];
    [layoutTypes addObject:@(leftOrRightLayout)];
    
    // vertical
    
    AMLayoutType topOrBottomLayout = [self verticalLayoutTypeBasedOnPosition:component center:NO];
    [layoutTypes addObject:@(AMLayoutTypeFixedHeight)];
    [layoutTypes addObject:@(topOrBottomLayout)];
    
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
    
    AMLayoutType leftOrRightLayout = [self horizontalLayoutTypeBasedOnPosition:component center:YES];
    [layoutTypes addObject:@(AMLayoutTypeFixedWidth)];
    [layoutTypes addObject:@(leftOrRightLayout)];
    
    // vertical
    
    AMLayoutType topOrBottomLayout = [self verticalLayoutTypeBasedOnPosition:component center:YES];
    [layoutTypes addObject:@(AMLayoutTypeFixedHeight)];
    [layoutTypes addObject:@(topOrBottomLayout)];
    
    return layoutTypes;
}

//AMLayoutPresetFixedSizeFixedPosition,
- (NSArray *)layoutTypesForAMLayoutPresetFixedSizeFixedPosition:(AMComponent *)component {
    return @[@(AMLayoutTypePosition)];
}

//AMLayoutPresetFixedYPosHeightLeftRightMargins,
- (NSArray *)layoutTypesForAMLayoutPresetFixedYPosHeightLeftRightMargins:(AMComponent *)component {

//    return @[@(AMLayoutTypePosition)];

    if (component.parentComponent == nil) {
        return @[@(AMLayoutTypePosition)];
    }
    
    NSMutableArray *layoutTypes = [NSMutableArray array];
    
    AMLayoutType topOrBottomLayout = [self verticalLayoutTypeBasedOnPosition:component center:NO];
    
    [layoutTypes addObject:@(AMLayoutTypeAnchoredLeft)];
    [layoutTypes addObject:@(AMLayoutTypeAnchoredRight)];
    [layoutTypes addObject:@(topOrBottomLayout)];
    [layoutTypes addObject:@(AMLayoutTypeFixedHeight)];
    
    return layoutTypes;
}

//AMLayoutPresetFixedXPosWidthTopBottomMargins,
- (NSArray *)layoutTypesForAMLayoutPresetFixedXPosWidthTopBottomMargins:(AMComponent *)component {
    
//    return @[@(AMLayoutTypePosition)];

    if (component.parentComponent == nil) {
        return @[@(AMLayoutTypePosition)];
    }
    
    NSMutableArray *layoutTypes = [NSMutableArray array];
    
    AMLayoutType leftOrRightLayout = [self horizontalLayoutTypeBasedOnPosition:component center:YES];
    
    [layoutTypes addObject:@(AMLayoutTypeAnchoredTop)];
    [layoutTypes addObject:@(AMLayoutTypeAnchoredBottom)];
    [layoutTypes addObject:@(leftOrRightLayout)];
    [layoutTypes addObject:@(AMLayoutTypeFixedWidth)];
    
    return layoutTypes;
}

//AMLayoutPresetFixedMargins,
- (NSArray *)layoutTypesForAMLayoutPresetFixedMargins:(AMComponent *)component {

//    return @[@(AMLayoutTypePosition)];

    if (component.parentComponent == nil) {
        return @[@(AMLayoutTypePosition)];
    }
    
    NSMutableArray *layoutTypes = [NSMutableArray array];
    
    [layoutTypes addObject:@(AMLayoutTypeAnchoredLeft)];
    [layoutTypes addObject:@(AMLayoutTypeAnchoredRight)];
    [layoutTypes addObject:@(AMLayoutTypeAnchoredTop)];
    [layoutTypes addObject:@(AMLayoutTypeAnchoredBottom)];
    
    return layoutTypes;
}

//AMLayoutPresetProportionalMargins,
- (NSArray *)layoutTypesForAMLayoutPresetProportionalMargins:(AMComponent *)component {

//    return @[@(AMLayoutTypePosition)];

    if (component.parentComponent == nil) {
        return @[@(AMLayoutTypePosition)];
    }
    
    NSMutableArray *layoutTypes = [NSMutableArray array];
    
    [layoutTypes addObject:@(AMLayoutTypeProportionalLeft)];
    [layoutTypes addObject:@(AMLayoutTypeProportionalRight)];
    [layoutTypes addObject:@(AMLayoutTypeProportionalTop)];
    [layoutTypes addObject:@(AMLayoutTypeProportionalBottom)];
    
    return layoutTypes;
}

@end
