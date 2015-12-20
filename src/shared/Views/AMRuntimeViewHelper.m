//
//  AMRuntimeViewHelper.m
//  AppMap
//
//  Created by Nick Bolton on 1/9/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMRuntimeViewHelper.h"
#import "AMComponent.h"
#import "AMRuntimeView.h"
#import "AMLayout.h"
#import "AMExpandingLayout.h"
#import "AMView+Geometry.h"
#import "AMLayoutPresetHelper.h"

@implementation AMRuntimeViewHelper

- (void)setBaseAttributes:(AMView <AMRuntimeView> *)view {
    
#if TARGET_OS_IPHONE
    view.alpha = view.component.alpha;
    view.backgroundColor = view.component.backgroundColor;
#else
    view.wantsLayer = YES;
    //    view.layer. = self.component.isClipped;
    view.alphaValue = view.component.alpha;
    view.layer.backgroundColor = view.component.backgroundColor.CGColor;
#endif
    
    view.layer.borderWidth = view.component.borderWidth;
    view.layer.borderColor = view.component.borderColor.CGColor;
    view.layer.cornerRadius = view.component.cornerRadius;
}

#pragma mark - Getters and Setters

- (void)setComponent:(AMComponent *)component forView:(AMView<AMRuntimeView> *)view {
    
    for (AMLayout *layout in component.layoutObjects) {
#warning TODO setup view provider
    }
    
    if (component.layoutObjects.count <= 0) {
        
        AMLayoutPresetHelper *presetHelper = [AMLayoutPresetHelper new];
        NSArray *layoutObjects = [presetHelper layoutObjectsForComponent:component layoutPreset:AMLayoutPresetFixedSizeFixedPosition];

        component.layoutObjects = layoutObjects;
    }
    
    [view setBaseAttributes];
    [self updateConstraintsFromComponent:view];
}

#pragma mark - Layout

- (void)layoutView:(AMView<AMRuntimeView> *)view {
#if TARGET_OS_IPHONE
    [view.superview layoutSubviews];
    [view setNeedsUpdateConstraints];
#else
    [view.superview layout];
    [view setNeedsUpdateConstraints:YES];
#endif
}

- (void)clearConstraints:(AMView<AMRuntimeView> *)view {
    
    for (AMLayout *layoutObject in view.component.layoutObjects) {
        [layoutObject clearLayout];
    }
    
#if TARGET_OS_IPHONE
    [view setNeedsUpdateConstraints];
#else
    [view setNeedsUpdateConstraints:YES];
#endif
}

- (void)constraintsDidChange:(AMView<AMRuntimeView> *)runtimeView {
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kAMRuntimeViewConstraintsDidChangeNotification
     object:runtimeView
     userInfo:nil];
}

#pragma mark - Constraints

- (void)updateConstraintsFromComponent:(AMView<AMRuntimeView> *)view {
    
    CGRect frame = AMPixelAlignedCGRect(view.component.frame);
    CGRect parentFrame = AMPixelAlignedCGRect(view.component.parentComponent.frame);
    
    for (AMLayout *layoutObject in view.component.layoutObjects) {
#warning TODO update layout
        
#if DEBUG
        layoutObject.viewIdentifier = view.component.name;
#endif
    }
    [self constraintsDidChange:view];
}

@end
