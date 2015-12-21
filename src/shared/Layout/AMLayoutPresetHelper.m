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
    
    CGFloat offset =
    [component
     distanceFromAttribute:attribute
     toComponent:component.parentComponent
     relatedAttribute:attribute];
    
    AMLayout *layoutObject = [AMLayout new];
    layoutObject.attribute = attribute;
    layoutObject.relatedAttribute = attribute;
    layoutObject.offset = offset;
    
    return layoutObject;
}

- (AMLayout *)horizontalProportionalLayoutBasedOnPosition:(AMComponent *)component {
    
    NSLayoutAttribute attribute =
    [self horizontalLayoutTypePosition:component center:NO];
    
    if (attribute != NSLayoutAttributeRight) {
        attribute = NSLayoutAttributeLeft;
    }
    
    CGFloat offset =
    [component
     distanceFromAttribute:attribute
     toComponent:component.parentComponent
     relatedAttribute:attribute];
    
    AMLayout *layoutObject = [AMLayout new];
    layoutObject.attribute = attribute;
    layoutObject.relatedAttribute = attribute;
    layoutObject.offset = offset;
    
    return layoutObject;
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
    
    CGFloat offset =
    [component
     distanceFromAttribute:attribute
     toComponent:component.parentComponent
     relatedAttribute:attribute];
    
    AMLayout *layoutObject = [AMLayout new];
    layoutObject.attribute = attribute;
    layoutObject.relatedAttribute = attribute;
    layoutObject.offset = offset;
    
    return layoutObject;
}

- (AMLayout *)verticalProportionalLayoutBasedOnPosition:(AMComponent *)component {
    
    NSLayoutAttribute attribute =
    [self verticalLayoutTypePosition:component center:NO];
    
    if (attribute != NSLayoutAttributeBottom) {
        attribute = NSLayoutAttributeTop;
    }
    
    CGFloat offset =
    [component
     distanceFromAttribute:attribute
     toComponent:component.parentComponent
     relatedAttribute:attribute];
    
    AMLayout *layoutObject = [AMLayout new];
    layoutObject.attribute = attribute;
    layoutObject.relatedAttribute = attribute;
    layoutObject.offset = offset;

    return layoutObject;
}

//AMLayoutPresetFixedSizeNearestCorner = 0,
- (NSArray *)layoutObjectsForAMLayoutPresetFixedSizeNearestCorner:(AMComponent *)component {
    
    if (component.parentComponent == nil) {
        return [self layoutObjectsForAMLayoutPresetFixedSizeFixedPosition:component];
    }
    
    NSMutableArray *layoutTypes = [NSMutableArray array];
    
    // horizontal
    
    AMLayout* leftOrRightLayout = [self horizontalLayoutBasedOnPosition:component center:NO];
    
    AMLayout *widthLayout = [AMLayout new];
    widthLayout.attribute = NSLayoutAttributeWidth;
    widthLayout.offset = CGRectGetWidth(component.frame);
    
    [layoutTypes addObject:leftOrRightLayout];
    [layoutTypes addObject:widthLayout];
    
    // vertical
    
    AMLayout *topOrBottomLayout = [self verticalLayoutBasedOnPosition:component center:NO];
    
    AMLayout *heightLayout = [AMLayout new];
    heightLayout.attribute = NSLayoutAttributeHeight;
    heightLayout.offset = CGRectGetHeight(component.frame);
    
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
    
    AMLayout *widthLayout = [AMLayout new];
    widthLayout.attribute = NSLayoutAttributeWidth;
    widthLayout.offset = CGRectGetWidth(component.frame);
    
    [layoutTypes addObject:leftOrRightLayout];
    [layoutTypes addObject:widthLayout];
    
    // vertical
    
    AMLayout *topOrBottomLayout = [self verticalProportionalLayoutBasedOnPosition:component];
    
    AMLayout *heightLayout = [AMLayout new];
    heightLayout.attribute = NSLayoutAttributeHeight;
    heightLayout.offset = CGRectGetHeight(component.frame);

    [layoutTypes addObject:topOrBottomLayout];
    [layoutTypes addObject:heightLayout];
    
    return layoutTypes;
}

//AMLayoutPresetFixedSizeRelativeCenter,
- (NSArray *)layoutObjectsForAMLayoutPresetFixedSizeRelativeCenter:(AMComponent *)component {
    
    NSMutableArray *layoutTypes = [NSMutableArray array];
    
    AMLayout *centerXLayout = [AMLayout new];
    centerXLayout.attribute = NSLayoutAttributeCenterX;
    centerXLayout.relatedAttribute = centerXLayout.attribute;
    centerXLayout.offset =
    [component
     distanceFromAttribute:NSLayoutAttributeCenterX
     toComponent:component.parentComponent
     relatedAttribute:NSLayoutAttributeCenterX];
    
    AMLayout *centerYLayout = [AMLayout new];
    centerYLayout.attribute = NSLayoutAttributeCenterY;
    centerYLayout.relatedAttribute = centerYLayout.attribute;
    centerYLayout.offset =
    [component
     distanceFromAttribute:NSLayoutAttributeCenterY
     toComponent:component.parentComponent
     relatedAttribute:NSLayoutAttributeCenterY];
    
    AMLayout *widthLayout = [AMLayout new];
    widthLayout.attribute = NSLayoutAttributeWidth;
    widthLayout.offset = CGRectGetWidth(component.frame);

    AMLayout *heightLayout = [AMLayout new];
    heightLayout.attribute = NSLayoutAttributeHeight;
    heightLayout.offset = CGRectGetHeight(component.frame);

    [layoutTypes addObject:centerXLayout];
    [layoutTypes addObject:centerYLayout];
    [layoutTypes addObject:widthLayout];
    [layoutTypes addObject:heightLayout];
    
    return layoutTypes;
}

//AMLayoutPresetFixedSizeFixedCenter,
- (NSArray *)layoutObjectsForAMLayoutPresetFixedSizeFixedCenter:(AMComponent *)component {
    
    NSMutableArray *layoutTypes = [NSMutableArray array];
    
    AMLayout *centerXLayout = [AMLayout new];
    centerXLayout.attribute = NSLayoutAttributeCenterX;
    centerXLayout.relatedAttribute = centerXLayout.attribute;
    centerXLayout.offset =
    [component
     distanceFromAttribute:NSLayoutAttributeCenterX
     toComponent:component.parentComponent
     relatedAttribute:NSLayoutAttributeCenterX];
    
    AMLayout *centerYLayout = [AMLayout new];
    centerYLayout.attribute = NSLayoutAttributeCenterY;
    centerYLayout.relatedAttribute = centerYLayout.attribute;
    centerYLayout.offset =
    [component
     distanceFromAttribute:NSLayoutAttributeCenterY
     toComponent:component.parentComponent
     relatedAttribute:NSLayoutAttributeCenterY];
    
    AMLayout *widthLayout = [AMLayout new];
    widthLayout.attribute = NSLayoutAttributeWidth;
    widthLayout.offset = CGRectGetWidth(component.frame);

    AMLayout *heightLayout = [AMLayout new];
    heightLayout.attribute = NSLayoutAttributeHeight;
    heightLayout.offset = CGRectGetHeight(component.frame);

    [layoutTypes addObject:centerXLayout];
    [layoutTypes addObject:centerYLayout];
    [layoutTypes addObject:widthLayout];
    [layoutTypes addObject:heightLayout];
    
    return layoutTypes;
}

//AMLayoutPresetFixedSizeFixedPosition,
- (NSArray *)layoutObjectsForAMLayoutPresetFixedSizeFixedPosition:(AMComponent *)component {
    
    NSMutableArray *layoutTypes = [NSMutableArray array];
    
    AMLayout* leftLayout = [AMLayout new];
    leftLayout.attribute = NSLayoutAttributeLeft;
    leftLayout.relatedAttribute = leftLayout.attribute;
    leftLayout.offset =
    [component
     distanceFromAttribute:NSLayoutAttributeLeft
     toComponent:component.parentComponent
     relatedAttribute:NSLayoutAttributeLeft];
    
    AMLayout *widthLayout = [AMLayout new];
    widthLayout.attribute = NSLayoutAttributeWidth;
    widthLayout.offset = CGRectGetWidth(component.frame);

    [layoutTypes addObject:leftLayout];
    [layoutTypes addObject:widthLayout];
    
    // vertical
    
    AMLayout *topLayout = [AMLayout new];
    topLayout.attribute = NSLayoutAttributeTop;
    topLayout.relatedAttribute = topLayout.attribute;
    topLayout.offset =
    [component
     distanceFromAttribute:NSLayoutAttributeTop
     toComponent:component.parentComponent
     relatedAttribute:NSLayoutAttributeTop];
    
    AMLayout *heightLayout = [AMLayout new];
    heightLayout.attribute = NSLayoutAttributeHeight;
    heightLayout.offset = CGRectGetHeight(component.frame);

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

    AMLayout *leftLayout = [AMLayout new];
    leftLayout.attribute = NSLayoutAttributeLeft;
    leftLayout.relatedAttribute = leftLayout.attribute;
    leftLayout.offset =
    [component
     distanceFromAttribute:NSLayoutAttributeLeft
     toComponent:component.parentComponent
     relatedAttribute:NSLayoutAttributeLeft];

    AMLayout *rightLayout = [AMLayout new];
    rightLayout.attribute = NSLayoutAttributeRight;
    rightLayout.relatedAttribute = rightLayout.attribute;
    rightLayout.offset =
    [component
     distanceFromAttribute:NSLayoutAttributeRight
     toComponent:component.parentComponent
     relatedAttribute:NSLayoutAttributeRight];

    AMLayout *heightLayout = [AMLayout new];
    heightLayout.attribute = NSLayoutAttributeHeight;
    heightLayout.offset = CGRectGetHeight(component.frame);

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
    
    AMLayout *topLayout = [AMLayout new];
    topLayout.attribute = NSLayoutAttributeTop;
    topLayout.relatedAttribute = topLayout.attribute;
    topLayout.offset =
    [component
     distanceFromAttribute:NSLayoutAttributeTop
     toComponent:component.parentComponent
     relatedAttribute:NSLayoutAttributeTop];
    
    AMLayout *bottomLayout = [AMLayout new];
    bottomLayout.attribute = NSLayoutAttributeBottom;
    bottomLayout.relatedAttribute = bottomLayout.attribute;
    bottomLayout.offset =
    [component
     distanceFromAttribute:NSLayoutAttributeBottom
     toComponent:component.parentComponent
     relatedAttribute:NSLayoutAttributeBottom];

    AMLayout *widthLayout = [AMLayout new];
    widthLayout.attribute = NSLayoutAttributeWidth;
    widthLayout.offset = CGRectGetWidth(component.frame);

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
    
    AMLayout *topLayout = [AMLayout new];
    topLayout.attribute = NSLayoutAttributeTop;
    topLayout.relatedAttribute = topLayout.attribute;
    topLayout.offset =
    [component
     distanceFromAttribute:NSLayoutAttributeTop
     toComponent:component.parentComponent
     relatedAttribute:NSLayoutAttributeTop];
    
    AMLayout *bottomLayout = [AMLayout new];
    bottomLayout.attribute = NSLayoutAttributeBottom;
    bottomLayout.relatedAttribute = bottomLayout.attribute;
    bottomLayout.offset =
    [component
     distanceFromAttribute:NSLayoutAttributeBottom
     toComponent:component.parentComponent
     relatedAttribute:NSLayoutAttributeBottom];
    
    AMLayout *leftLayout = [AMLayout new];
    leftLayout.attribute = NSLayoutAttributeLeft;
    leftLayout.relatedAttribute = leftLayout.attribute;
    leftLayout.offset =
    [component
     distanceFromAttribute:NSLayoutAttributeLeft
     toComponent:component.parentComponent
     relatedAttribute:NSLayoutAttributeLeft];
    
    AMLayout *rightLayout = [AMLayout new];
    rightLayout.attribute = NSLayoutAttributeRight;
    rightLayout.relatedAttribute = rightLayout.attribute;
    rightLayout.offset =
    [component
     distanceFromAttribute:NSLayoutAttributeRight
     toComponent:component.parentComponent
     relatedAttribute:NSLayoutAttributeRight];

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
    
    AMLayout *topLayout = [AMLayout new];
    topLayout.attribute = NSLayoutAttributeTop;
    topLayout.relatedAttribute = topLayout.attribute;
    topLayout.offset =
    [component
     distanceFromAttribute:NSLayoutAttributeTop
     toComponent:component.parentComponent
     relatedAttribute:NSLayoutAttributeTop];
    
    AMLayout *bottomLayout = [AMLayout new];
    bottomLayout.attribute = NSLayoutAttributeBottom;
    bottomLayout.relatedAttribute = bottomLayout.attribute;
    bottomLayout.offset =
    [component
     distanceFromAttribute:NSLayoutAttributeBottom
     toComponent:component.parentComponent
     relatedAttribute:NSLayoutAttributeBottom];
    
    AMLayout *leftLayout = [AMLayout new];
    leftLayout.attribute = NSLayoutAttributeLeft;
    leftLayout.relatedAttribute = leftLayout.attribute;
    leftLayout.offset =
    [component
     distanceFromAttribute:NSLayoutAttributeLeft
     toComponent:component.parentComponent
     relatedAttribute:NSLayoutAttributeLeft];
    
    AMLayout *rightLayout = [AMLayout new];
    rightLayout.attribute = NSLayoutAttributeRight;
    rightLayout.relatedAttribute = rightLayout.attribute;
    rightLayout.offset =
    [component
     distanceFromAttribute:NSLayoutAttributeRight
     toComponent:component.parentComponent
     relatedAttribute:NSLayoutAttributeRight];
    
    [layoutTypes addObject:topLayout];
    [layoutTypes addObject:bottomLayout];
    [layoutTypes addObject:leftLayout];
    [layoutTypes addObject:rightLayout];
    
    return layoutTypes;
}

@end
