//
//  AMLayoutPresetHelper.m
//  AppMap
//
//  Created by Nick Bolton on 3/28/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMLayoutPresetHelper.h"
#import "AMComponent.h"
#import "AMLayout.h"

typedef NS_ENUM(NSInteger, AMLayoutHorizontalPosition) {
    
    AMLayoutHorizontalPositionLeft = 0,
    AMLayoutHorizontalPositionRight,
    AMLayoutHorizontalPositionCentered,
};

typedef NS_ENUM(NSInteger, AMLayoutVerticalPosition) {
    
    AMLayoutVerticalPositionTop = 0,
    AMLayoutVerticalPositionBottom,
    AMLayoutVerticalPositionCentered,
};

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
          [NSValue valueWithPointer:@selector(layoutTypesForAMLayoutPresetFixedSizeRelativeCenter:)],
          [NSValue valueWithPointer:@selector(layoutTypesForAMLayoutPresetFixedSizeFixedCenter:)],
          [NSValue valueWithPointer:@selector(layoutTypesForAMLayoutPresetFixedSizeFixedPosition:)],
          [NSValue valueWithPointer:@selector(layoutTypesForAMLayoutPresetFixedYPosHeightLeftRightMargins:)],
          [NSValue valueWithPointer:@selector(layoutTypesForAMLayoutPresetFixedXPosWidthTopBottomMargins:)],
          [NSValue valueWithPointer:@selector(layoutTypesForAMLayoutPresetFixedMargins:)],
          [NSValue valueWithPointer:@selector(layoutTypesForAMLayoutPresetProportionalMargins:)],
          [NSValue valueWithPointer:@selector(layoutTypesForAMLayoutPresetExpanding:)],
          ];
    }
    
    return self;
}

- (NSArray *)layoutObjectsForComponent:(AMComponent *)component
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

#warning TODO AMLayoutPresetHelper
- (NSLayoutAttribute)horizontalLayoutTypePosition:(AMComponent *)component
                                                    center:(BOOL)center {
 
    if (center) {
        static CGFloat const centeringThreshold = .01f;
        
        CGFloat horizontalCenterPercent = 0.0f;
        
        if (CGRectGetWidth(component.parentComponent.frame) != 0.0f) {
            
            horizontalCenterPercent =
            CGRectGetMidX(component.frame) / CGRectGetWidth(component.parentComponent.frame);
        }
        
        if (ABS(horizontalCenterPercent - .5f) <= centeringThreshold) {
            return NSLayoutAttributeCenterX;
        }
    }
    
    CGFloat leftDistance = ABS(CGRectGetMinX(component.frame));
    
    CGFloat rightDistance =
    ABS(CGRectGetWidth(component.parentComponent.frame) - CGRectGetMaxX(component.frame));
    
    if (rightDistance < leftDistance) {
        return NSLayoutAttributeRight;
    }
    
    return NSLayoutAttributeLeft;
}

- (AMLayoutType)horizontalLayoutObjectBasedOnPosition:(AMComponent *)component
                                               center:(BOOL)center {

    AMLayout *layoutObject = [AMLayout new];
    layoutObject.attribute =
    [self horizontalLayoutTypePosition:component center:center];
    
    return AMLayoutTypeLeft;
}

- (AMLayoutType)horizontalProportionalLayoutTypeBasedOnPosition:(AMComponent *)component {
    
    NSLayoutAttributeLeft position =
    [self horizontalLayoutTypePosition:component center:NO];
    
    if (position == AMLayoutHorizontalPositionRight) {
        return AMLayoutTypeProportionalRight;
    }
    
    return AMLayoutTypeProportionalLeft;
}

- (AMLayoutVerticalPosition)verticalLayoutTypePosition:(AMComponent *)component
                                                center:(BOOL)center {

//    if (center) {
//        
//        static CGFloat const centeringThreshold = .01f;
//        
//        CGFloat verticalCenterPercent = 0.0f;
//        
//        if (CGRectGetHeight(component.parentComponent.frame) != 0.0f) {
//            
//            verticalCenterPercent =
//            CGRectGetMidY(component.frame) / CGRectGetHeight(component.parentComponent.frame);
//        }
//        
//        if (ABS(verticalCenterPercent - .5f) <= centeringThreshold) {
//            return AMLayoutVerticalPositionCentered;
//        }
//    }
//    
//    CGFloat topDistance = ABS(CGRectGetMinY(component.frame));
//    
//    CGFloat bottomDistance =
//    ABS(CGRectGetHeight(component.parentComponent.frame) - CGRectGetMaxY(component.frame));
//    
//    if (bottomDistance < topDistance) {
//        return AMLayoutVerticalPositionBottom;
//    }
    
    return AMLayoutVerticalPositionTop;
}

- (AMLayoutType)verticalAnchoredLayoutTypeBasedOnPosition:(AMComponent *)component
                                                   center:(BOOL)center {
    
    AMLayoutVerticalPosition position =
    [self verticalLayoutTypePosition:component center:center];
    
    switch (position) {
        case AMLayoutVerticalPositionTop:
            return AMLayoutTypeTop;
            break;
            
        case AMLayoutVerticalPositionBottom:
            return AMLayoutTypeBottom;
            break;
            
        case AMLayoutVerticalPositionCentered:
            return AMLayoutTypeCenterVertically;
            break;
    }
    
    return AMLayoutTypeTop;
}

- (AMLayoutType)verticalProportionalLayoutTypeBasedOnPosition:(AMComponent *)component {
    
    AMLayoutVerticalPosition position =
    [self verticalLayoutTypePosition:component center:NO];
    
    if (position == AMLayoutVerticalPositionBottom) {
        return AMLayoutTypeProportionalBottom;
    }
    
    return AMLayoutTypeProportionalTop;
}

//AMLayoutPresetFixedSizeNearestCorner = 0,
- (NSArray *)layoutTypesForAMLayoutPresetFixedSizeNearestCorner:(AMComponent *)component {
    
    if (component.parentComponent == nil) {
        return @[@(AMLayoutTypePosition)];
    }
    
    NSMutableArray *layoutTypes = [NSMutableArray array];
    
    // horizontal
    
    AMLayoutType leftOrRightLayout = [self horizontalAnchoredLayoutTypeBasedOnPosition:component center:NO];
    [layoutTypes addObject:@(AMLayoutTypeFixedWidth)];
    [layoutTypes addObject:@(leftOrRightLayout)];
    
    // vertical
    
    AMLayoutType topOrBottomLayout = [self verticalAnchoredLayoutTypeBasedOnPosition:component center:NO];
    [layoutTypes addObject:@(AMLayoutTypeFixedHeight)];
    [layoutTypes addObject:@(topOrBottomLayout)];
    
    return layoutTypes;
}

//AMLayoutPresetFixedSizeRelativePosition,
- (NSArray *)layoutTypesForAMLayoutPresetFixedSizeRelativePosition:(AMComponent *)component {
    
    if (component.parentComponent == nil) {
        return @[@(AMLayoutTypePosition)];
    }
    
    NSMutableArray *layoutTypes = [NSMutableArray array];
    
    // horizontal
    
    AMLayoutType leftOrRightLayout = [self horizontalProportionalLayoutTypeBasedOnPosition:component];
    [layoutTypes addObject:@(AMLayoutTypeFixedWidth)];
    [layoutTypes addObject:@(leftOrRightLayout)];
    
    // vertical
    
    AMLayoutType topOrBottomLayout = [self verticalProportionalLayoutTypeBasedOnPosition:component];
    [layoutTypes addObject:@(AMLayoutTypeFixedHeight)];
    [layoutTypes addObject:@(topOrBottomLayout)];
    
    return layoutTypes;
}

//AMLayoutPresetFixedSizeRelativeCenter,
- (NSArray *)layoutTypesForAMLayoutPresetFixedSizeRelativeCenter:(AMComponent *)component {
    
    NSMutableArray *layoutTypes = [NSMutableArray array];
    
    // horizontal
    
    [layoutTypes addObject:@(AMLayoutTypeFixedWidth)];
    [layoutTypes addObject:@(AMLayoutTypeProportionalHorizontalCenter)];
    
    // vertical
    
    [layoutTypes addObject:@(AMLayoutTypeFixedHeight)];
    [layoutTypes addObject:@(AMLayoutTypeProportionalVerticalCenter)];
    
    return layoutTypes;
}

//AMLayoutPresetFixedSizeFixedCenter,
- (NSArray *)layoutTypesForAMLayoutPresetFixedSizeFixedCenter:(AMComponent *)component {
    
    NSMutableArray *layoutTypes = [NSMutableArray array];
    
    // horizontal
    
    [layoutTypes addObject:@(AMLayoutTypeFixedWidth)];
    [layoutTypes addObject:@(AMLayoutTypeCenterHorizontally)];
    
    // vertical
    
    [layoutTypes addObject:@(AMLayoutTypeFixedHeight)];
    [layoutTypes addObject:@(AMLayoutTypeCenterVertically)];
    
    return layoutTypes;
}

//AMLayoutPresetFixedSizeFixedPosition,
- (NSArray *)layoutTypesForAMLayoutPresetFixedSizeFixedPosition:(AMComponent *)component {
    
    NSMutableArray *layoutTypes = [NSMutableArray array];
    
    // horizontal
    
    [layoutTypes addObject:@(AMLayoutTypeFixedWidth)];
    [layoutTypes addObject:@(AMLayoutTypeLeft)];
    
    // vertical
    
    [layoutTypes addObject:@(AMLayoutTypeFixedHeight)];
    [layoutTypes addObject:@(AMLayoutTypeTop)];
    
    return layoutTypes;
}

//AMLayoutPresetFixedYPosHeightLeftRightMargins,
- (NSArray *)layoutTypesForAMLayoutPresetFixedYPosHeightLeftRightMargins:(AMComponent *)component {

    if (component.parentComponent == nil) {
        return @[@(AMLayoutTypePosition)];
    }
    
    NSMutableArray *layoutTypes = [NSMutableArray array];
    
    AMLayoutType topOrBottomLayout = [self verticalAnchoredLayoutTypeBasedOnPosition:component center:NO];
    
    [layoutTypes addObject:@(AMLayoutTypeLeft)];
    [layoutTypes addObject:@(AMLayoutTypeRight)];
    [layoutTypes addObject:@(topOrBottomLayout)];
    [layoutTypes addObject:@(AMLayoutTypeFixedHeight)];
    
    return layoutTypes;
}

//AMLayoutPresetFixedXPosWidthTopBottomMargins,
- (NSArray *)layoutTypesForAMLayoutPresetFixedXPosWidthTopBottomMargins:(AMComponent *)component {

    if (component.parentComponent == nil) {
        return @[@(AMLayoutTypePosition)];
    }
    
    NSMutableArray *layoutTypes = [NSMutableArray array];
    
    AMLayoutType leftOrRightLayout = [self horizontalAnchoredLayoutTypeBasedOnPosition:component center:YES];
    
    [layoutTypes addObject:@(AMLayoutTypeTop)];
    [layoutTypes addObject:@(AMLayoutTypeBottom)];
    [layoutTypes addObject:@(leftOrRightLayout)];
    [layoutTypes addObject:@(AMLayoutTypeFixedWidth)];
    
    return layoutTypes;
}

//AMLayoutPresetFixedMargins,
- (NSArray *)layoutTypesForAMLayoutPresetFixedMargins:(AMComponent *)component {

    if (component.parentComponent == nil) {
        return @[@(AMLayoutTypePosition)];
    }
    
    NSMutableArray *layoutTypes = [NSMutableArray array];
    
    [layoutTypes addObject:@(AMLayoutTypeLeft)];
    [layoutTypes addObject:@(AMLayoutTypeRight)];
    [layoutTypes addObject:@(AMLayoutTypeTop)];
    [layoutTypes addObject:@(AMLayoutTypeBottom)];
    
    return layoutTypes;
}

//AMLayoutPresetProportionalMargins,
- (NSArray *)layoutTypesForAMLayoutPresetProportionalMargins:(AMComponent *)component {

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

//AMLayoutPresetExpanding
- (NSArray *)layoutTypesForAMLayoutPresetExpanding:(AMComponent *)component {
#warning TODO layoutTypesForAMLayoutPresetExpanding
    return nil;
}

@end
