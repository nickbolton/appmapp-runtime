//
//  AMRuntimeView.m
//  AppMap
//
//  Created by Nick Bolton on 1/8/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMRuntimeView.h"
#import "AMComponent.h"
#import "AMLayoutFactory.h"

NSString * const kAMRuntimeViewLayoutDidChangeNotification = @"kAMRuntimeViewLayoutDidChangeNotification";

@implementation AMRuntimeView

#pragma mark - Getters and Setters

- (void)setComponent:(AMComponent *)component {
    _component = component;
    
    self.layoutObject =
    [[AMLayoutFactory sharedInstance] buildLayoutOfType:component.layoutType];
    
    [self setBaseAttributes];
    [self setNeedsUpdateConstraints:YES];
}

#pragma mark - Private

- (void)setBaseAttributes {
    
    self.wantsLayer = YES;
//    self.layer. = self.component.isClipped;
    self.alphaValue = self.component.alpha;
    self.layer.borderWidth = self.component.borderWidth;
    self.layer.borderColor = self.component.borderColor.CGColor;
    self.layer.cornerRadius = self.component.cornerRadius;
    self.layer.backgroundColor = self.component.backgroundColor.CGColor;
}

#pragma mark - Layout

- (void)clearLayout {
    [self.layoutObject clearLayout];
}

- (void)layoutDidChange {
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kAMRuntimeViewLayoutDidChangeNotification
     object:self
     userInfo:nil];
}

#pragma mark - Constraints

- (void)updateConstraints {
    [super updateConstraints];
    [self updateConstraintsFromComponent];
}

- (void)updateConstraintsFromComponent {
    
    CGRect frame = self.component.frame;    
    [self.layoutObject updateLayoutWithFrame:frame];
}

@end
