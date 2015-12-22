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
#import "AMLayoutComponentHelpers.h"

@interface AMLayoutPresetHelper()

@property (nonatomic, strong) NSArray *selectors;

@end

@implementation AMLayoutPresetHelper

- (instancetype)init {
    self = [super init];
    
    if (self != nil) {
        
        self.selectors =
        @[
          [NSValue valueWithPointer:@selector(layoutObjectsForAMLayoutPresetFixedSizeNearestCorner:)],
          [NSValue valueWithPointer:@selector(layoutObjectsForAMLayoutPresetFixedSizeRelativePosition:)],
          [NSValue valueWithPointer:@selector(layoutObjectsForAMLayoutPresetFixedSizeRelativeCenter:)],
          [NSValue valueWithPointer:@selector(layoutObjectsForAMLayoutPresetFixedSizeFixedCenter:)],
          [NSValue valueWithPointer:@selector(layoutObjectsForAMLayoutPresetFixedSizeFixedPosition:)],
          [NSValue valueWithPointer:@selector(layoutObjectsForAMLayoutPresetFixedYPosHeightLeftRightMargins:)],
          [NSValue valueWithPointer:@selector(layoutObjectsForAMLayoutPresetFixedXPosWidthTopBottomMargins:)],
          [NSValue valueWithPointer:@selector(layoutObjectsForAMLayoutPresetFixedMargins:)],
          [NSValue valueWithPointer:@selector(layoutObjectsForAMLayoutPresetProportionalMargins:)],
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

//AMLayoutPresetFixedSizeNearestCorner = 0,
- (NSArray *)layoutObjectsForAMLayoutPresetFixedSizeNearestCorner:(AMComponent *)component {
    
    if (component.parentComponent == nil) {
        return [self layoutObjectsForAMLayoutPresetFixedSizeFixedPosition:component];
    }
    
    NSMutableArray *layoutTypes = [NSMutableArray array];
    
    // horizontal
    
    AMLayout* leftOrRightLayout = [self horizontalLayoutBasedOnPosition:component center:NO];
    AMLayout *widthLayout = [self widthLayoutForComponent:component];
    
    [layoutTypes addObject:leftOrRightLayout];
    [layoutTypes addObject:widthLayout];
    
    // vertical
    
    AMLayout *topOrBottomLayout = [self verticalLayoutBasedOnPosition:component center:NO];
    AMLayout *heightLayout = [self heightLayoutForComponent:component];
    
    [layoutTypes addObject:topOrBottomLayout];
    [layoutTypes addObject:heightLayout];
    
    return layoutTypes;
}

//AMLayoutPresetFixedSizeRelativePosition,
- (NSArray *)layoutObjectsForAMLayoutPresetFixedSizeRelativePosition:(AMComponent *)component {
    
    if (component.parentComponent == nil) {
        return [self layoutObjectsForAMLayoutPresetFixedSizeFixedPosition:component];
    }
    
    NSMutableArray *layoutTypes = [NSMutableArray array];
    
    // horizontal
    
    AMLayout* leftOrRightLayout = [self horizontalProportionalLayoutBasedOnPosition:component];
    AMLayout *widthLayout = [self widthLayoutForComponent:component];
    
    [layoutTypes addObject:leftOrRightLayout];
    [layoutTypes addObject:widthLayout];
    
    // vertical
    
    AMLayout *topOrBottomLayout = [self verticalProportionalLayoutBasedOnPosition:component];
    AMLayout *heightLayout = [self heightLayoutForComponent:component];

    [layoutTypes addObject:topOrBottomLayout];
    [layoutTypes addObject:heightLayout];
    
    return layoutTypes;
}

//AMLayoutPresetFixedSizeRelativeCenter,
- (NSArray *)layoutObjectsForAMLayoutPresetFixedSizeRelativeCenter:(AMComponent *)component {
    
    NSMutableArray *layoutTypes = [NSMutableArray array];
    
    AMLayout *centerXLayout = [self proportionalLayoutForComponent:component attribute:NSLayoutAttributeCenterX];
    AMLayout *centerYLayout = [self proportionalLayoutForComponent:component attribute:NSLayoutAttributeCenterY];
    AMLayout *widthLayout = [self widthLayoutForComponent:component];
    AMLayout *heightLayout = [self heightLayoutForComponent:component];

    [layoutTypes addObject:centerXLayout];
    [layoutTypes addObject:centerYLayout];
    [layoutTypes addObject:widthLayout];
    [layoutTypes addObject:heightLayout];
    
    return layoutTypes;
}

//AMLayoutPresetFixedSizeFixedCenter,
- (NSArray *)layoutObjectsForAMLayoutPresetFixedSizeFixedCenter:(AMComponent *)component {
    
    NSMutableArray *layoutTypes = [NSMutableArray array];
    
    AMLayout *centerXLayout = [self fixedLayoutForComponent:component attribute:NSLayoutAttributeCenterX];
    AMLayout *centerYLayout = [self fixedLayoutForComponent:component attribute:NSLayoutAttributeCenterY];
    AMLayout *widthLayout = [self widthLayoutForComponent:component];
    AMLayout *heightLayout = [self heightLayoutForComponent:component];

    [layoutTypes addObject:centerXLayout];
    [layoutTypes addObject:centerYLayout];
    [layoutTypes addObject:widthLayout];
    [layoutTypes addObject:heightLayout];
    
    return layoutTypes;
}

//AMLayoutPresetFixedSizeFixedPosition,
- (NSArray *)layoutObjectsForAMLayoutPresetFixedSizeFixedPosition:(AMComponent *)component {
    
    NSMutableArray *layoutTypes = [NSMutableArray array];
    
    // horizontal
    
    AMLayout* leftLayout = [self fixedLayoutForComponent:component attribute:NSLayoutAttributeLeft];
    AMLayout *widthLayout = [self widthLayoutForComponent:component];

    [layoutTypes addObject:leftLayout];
    [layoutTypes addObject:widthLayout];
    
    // vertical
    
    AMLayout *topLayout = [self fixedLayoutForComponent:component attribute:NSLayoutAttributeTop];
    AMLayout *heightLayout = [self heightLayoutForComponent:component];

    [layoutTypes addObject:topLayout];
    [layoutTypes addObject:heightLayout];
    
    return layoutTypes;
}

//AMLayoutPresetFixedYPosHeightLeftRightMargins,
- (NSArray *)layoutObjectsForAMLayoutPresetFixedYPosHeightLeftRightMargins:(AMComponent *)component {

    if (component.parentComponent == nil) {
        return [self layoutObjectsForAMLayoutPresetFixedSizeFixedPosition:component];
    }
    
    NSMutableArray *layoutTypes = [NSMutableArray array];
    
    AMLayout *topOrBottomLayout = [self verticalLayoutBasedOnPosition:component center:NO];
    AMLayout *leftLayout = [self fixedLayoutForComponent:component attribute:NSLayoutAttributeLeft];
    AMLayout *rightLayout = [self fixedLayoutForComponent:component attribute:NSLayoutAttributeRight];
    AMLayout *heightLayout = [self heightLayoutForComponent:component];

    [layoutTypes addObject:topOrBottomLayout];
    [layoutTypes addObject:leftLayout];
    [layoutTypes addObject:rightLayout];
    [layoutTypes addObject:heightLayout];
    
    return layoutTypes;
}

//AMLayoutPresetFixedXPosWidthTopBottomMargins,
- (NSArray *)layoutObjectsForAMLayoutPresetFixedXPosWidthTopBottomMargins:(AMComponent *)component {

    if (component.parentComponent == nil) {
        return [self layoutObjectsForAMLayoutPresetFixedSizeFixedPosition:component];
    }
    
    NSMutableArray *layoutTypes = [NSMutableArray array];
    
    AMLayout* leftOrRightLayout = [self horizontalLayoutBasedOnPosition:component center:NO];
    AMLayout *topLayout = [self fixedLayoutForComponent:component attribute:NSLayoutAttributeTop];
    AMLayout *bottomLayout = [self fixedLayoutForComponent:component attribute:NSLayoutAttributeBottom];
    AMLayout *widthLayout = [self widthLayoutForComponent:component];

    [layoutTypes addObject:topLayout];
    [layoutTypes addObject:bottomLayout];
    [layoutTypes addObject:leftOrRightLayout];
    [layoutTypes addObject:widthLayout];
    
    return layoutTypes;
}

//AMLayoutPresetFixedMargins,
- (NSArray *)layoutObjectsForAMLayoutPresetFixedMargins:(AMComponent *)component {

    if (component.parentComponent == nil) {
        return [self layoutObjectsForAMLayoutPresetFixedSizeFixedPosition:component];
    }
    
    NSMutableArray *layoutTypes = [NSMutableArray array];
    
    AMLayout *topLayout = [self fixedLayoutForComponent:component attribute:NSLayoutAttributeTop];
    AMLayout *bottomLayout = [self fixedLayoutForComponent:component attribute:NSLayoutAttributeBottom];
    AMLayout *leftLayout = [self fixedLayoutForComponent:component attribute:NSLayoutAttributeLeft];
    AMLayout *rightLayout = [self fixedLayoutForComponent:component attribute:NSLayoutAttributeRight];

    [layoutTypes addObject:topLayout];
    [layoutTypes addObject:bottomLayout];
    [layoutTypes addObject:leftLayout];
    [layoutTypes addObject:rightLayout];
    
    return layoutTypes;
}

//AMLayoutPresetProportionalMargins,
- (NSArray *)layoutObjectsForAMLayoutPresetProportionalMargins:(AMComponent *)component {

    if (component.parentComponent == nil) {
        return [self layoutObjectsForAMLayoutPresetFixedSizeFixedPosition:component];
    }
    
    NSMutableArray *layoutTypes = [NSMutableArray array];
    
    AMLayout *topLayout = [self proportionalLayoutForComponent:component attribute:NSLayoutAttributeTop];
    AMLayout *bottomLayout = [self proportionalLayoutForComponent:component attribute:NSLayoutAttributeBottom];
    AMLayout *leftLayout = [self proportionalLayoutForComponent:component attribute:NSLayoutAttributeLeft];
    AMLayout *rightLayout = [self proportionalLayoutForComponent:component attribute:NSLayoutAttributeRight];
    
    [layoutTypes addObject:topLayout];
    [layoutTypes addObject:bottomLayout];
    [layoutTypes addObject:leftLayout];
    [layoutTypes addObject:rightLayout];
    
    return layoutTypes;
}

#pragma mark - Helpers

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

- (AMLayout *)horizontalLayoutBasedOnPosition:(AMComponent *)component
                                       center:(BOOL)center {
    NSLayoutAttribute attribute =
    [self horizontalLayoutTypePosition:component center:center];
    
    return [self fixedLayoutForComponent:component attribute:attribute];
}

- (AMLayout *)horizontalProportionalLayoutBasedOnPosition:(AMComponent *)component {
    
    NSLayoutAttribute attribute =
    [self horizontalLayoutTypePosition:component center:NO];
    
    if (attribute != NSLayoutAttributeRight) {
        attribute = NSLayoutAttributeLeft;
    }
    
    return [self proportionalLayoutForComponent:component attribute:attribute];
}

- (NSLayoutAttribute)verticalLayoutTypePosition:(AMComponent *)component
                                         center:(BOOL)center {
    
    if (center) {
        
        static CGFloat const centeringThreshold = .01f;
        
        CGFloat verticalCenterPercent = 0.0f;
        
        if (CGRectGetHeight(component.parentComponent.frame) != 0.0f) {
            
            verticalCenterPercent =
            CGRectGetMidY(component.frame) / CGRectGetHeight(component.parentComponent.frame);
        }
        
        if (ABS(verticalCenterPercent - .5f) <= centeringThreshold) {
            return NSLayoutAttributeCenterY;
        }
    }
    
    CGFloat topDistance = ABS(CGRectGetMinY(component.frame));
    
    CGFloat bottomDistance =
    ABS(CGRectGetHeight(component.parentComponent.frame) - CGRectGetMaxY(component.frame));
    
    if (bottomDistance < topDistance) {
        return NSLayoutAttributeBottom;
    }
    
    return NSLayoutAttributeTop;
}

- (AMLayout *)verticalLayoutBasedOnPosition:(AMComponent *)component
                                     center:(BOOL)center {
    
    NSLayoutAttribute attribute =
    [self verticalLayoutTypePosition:component center:center];
    
    return [self fixedLayoutForComponent:component attribute:attribute];
}

- (AMLayout *)verticalProportionalLayoutBasedOnPosition:(AMComponent *)component {
    
    NSLayoutAttribute attribute =
    [self verticalLayoutTypePosition:component center:NO];
    
    if (attribute != NSLayoutAttributeBottom) {
        attribute = NSLayoutAttributeTop;
    }
    
    return [self proportionalLayoutForComponent:component attribute:attribute];
}

#pragma mark - Factories

- (AMLayout *)fixedLayoutForComponent:(AMComponent *)component
                            attribute:(NSLayoutAttribute)attribute {
    
    AMLayout *layout = [AMLayout new];
    layout.attribute = attribute;
    layout.relatedAttribute = attribute;
    layout.offset =
    [component
     distanceFromAttribute:attribute
     toComponent:component.parentComponent
     relatedAttribute:attribute];
    
    return layout;
}

- (AMLayout *)proportionalLayoutForComponent:(AMComponent *)component
                                   attribute:(NSLayoutAttribute)attribute {
    
    AMComponent *commonAncestorComponent = component.parentComponent;
    
    CGFloat proportionalValue =
    [AMLayoutComponentHelpers
     proportionalValueForComponent:component
     attribute:attribute
     proportionalComponent:commonAncestorComponent];
    
//    CGFloat offset =
//    [AMLayoutComponentHelpers
//     proportionalOffsetForComponent:component
//     attribute:attribute
//     relatedComponent:relatedComponent
//     relatedAttribute:attribute
//     proportionalValue:proportionalValue];
    
    AMLayout *layoutObject = [AMLayout new];
    layoutObject.attribute = attribute;
    layoutObject.relatedAttribute = attribute;
    layoutObject.proportional = YES;
    layoutObject.proportionalValue = proportionalValue;
    layoutObject.proportionalComponentIdentifier = commonAncestorComponent.identifier;
    
    return layoutObject;
}

- (AMLayout *)widthLayoutForComponent:(AMComponent *)component {
    AMLayout *layout = [AMLayout new];
    layout.attribute = NSLayoutAttributeWidth;
    layout.offset = CGRectGetWidth(component.frame);

    return layout;
}

- (AMLayout *)heightLayoutForComponent:(AMComponent *)component {
    AMLayout *layout = [AMLayout new];
    layout.attribute = NSLayoutAttributeHeight;
    layout.offset = CGRectGetWidth(component.frame);
    
    return layout;
}

@end
