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
#import "AMLayoutFactory.h"
#import "AMLayout.h"

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
    
    NSMutableArray *layoutObjects = [NSMutableArray array];
    
    for (NSNumber *layoutType in component.layoutTypes) {
        
        AMLayout *layoutObject =
        [[AMLayoutFactory sharedInstance] buildLayoutOfType:layoutType.integerValue];
        
        layoutObject.view = view;
        [layoutObjects addObject:layoutObject];
    }
    
    if (layoutObjects.count > 0) {

        view.layoutObjects = layoutObjects;

    } else {
        
        AMLayout *layoutObject =
        [[AMLayoutFactory sharedInstance] buildLayoutOfType:AMLayoutTypePosition];

        layoutObject.view = view;
        view.layoutObjects = @[layoutObject];
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
    
    for (AMLayout *layoutObject in view.layoutObjects) {
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
    CGRect frame = view.component.frame;
    CGRect parentFrame = view.component.parentComponent.frame;
    
    for (AMLayout *layoutObject in view.layoutObjects) {
        
        [layoutObject
         updateLayoutWithFrame:frame
         multiplier:1.0f
         priority:AMLayoutPriorityRequired
         parentFrame:parentFrame];
    }
    [self constraintsDidChange:view];
}

@end
