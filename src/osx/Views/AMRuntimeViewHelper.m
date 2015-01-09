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

@implementation AMRuntimeViewHelper

- (void)setBaseAttributes:(NSView <AMRuntimeView> *)view {
    
    view.wantsLayer = YES;
    //    view.layer. = self.component.isClipped;
    view.alphaValue = view.component.alpha;
    view.layer.borderWidth = view.component.borderWidth;
    view.layer.borderColor = view.component.borderColor.CGColor;
    view.layer.cornerRadius = view.component.cornerRadius;
    view.layer.backgroundColor = view.component.backgroundColor.CGColor;
}

#pragma mark - Getters and Setters

- (void)setComponent:(AMComponent *)component forView:(NSView<AMRuntimeView> *)view {
    
    view.layoutObject =
    [[AMLayoutFactory sharedInstance] buildLayoutOfType:component.layoutType];
    
    view.layoutObject.view = view;
    
    [view setBaseAttributes];
    [self updateConstraintsFromComponent:view];
}

#pragma mark - Layout

- (void)layoutView:(NSView<AMRuntimeView> *)view {
    [view.superview layout];
    [view setNeedsUpdateConstraints:YES];
}

- (void)clearLayout:(NSView<AMRuntimeView> *)view {
    [view.layoutObject clearLayout];
    [view setNeedsUpdateConstraints:YES];
}

- (void)layoutDidChange:(NSView<AMRuntimeView> *)runtimeView {
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kAMRuntimeViewLayoutDidChangeNotification
     object:runtimeView
     userInfo:nil];
}

#pragma mark - Constraints

- (void)updateConstraintsFromComponent:(NSView<AMRuntimeView> *)view {
    CGRect frame = view.component.frame;
    [view.layoutObject updateLayoutWithFrame:frame];
}

@end
