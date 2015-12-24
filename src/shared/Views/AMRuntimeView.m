//
//  AMRuntimeView.m
//  AppMap
//
//  Created by Nick Bolton on 1/8/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMRuntimeView.h"
#import "AMComponent.h"
#import "AMRuntimeViewHelper.h"

NSString * const kAMRuntimeViewConstraintsDidChangeNotification = @"kAMRuntimeViewConstraintsDidChangeNotification";

@interface AMRuntimeView()

@property (nonatomic, strong) AMComponent *component;
@property (nonatomic, strong) AMRuntimeViewHelper *helper;

@end

@implementation AMRuntimeView

@synthesize layoutProvider = _layoutProvider;
@synthesize runtimeDelegate = _runtimeDelegate;

#pragma mark - Getters and Setters

- (AMRuntimeViewHelper *)helper {
    
    if (_helper == nil) {
        _helper = [AMRuntimeViewHelper new];
    }
    
    return _helper;
}

- (void)setComponent:(AMComponent *)component {
    _component = component;
    [self.helper setComponent:component forView:self];
}

- (BOOL)isFlipped {
    return YES;
}

#pragma mark - AMRuntimeDelegate Conformance

- (void)navigateToComponentWithIdentifier:(NSString *)componentIdentifier
                           navigationType:(AMNavigationType)navigationType {

    // just delegate on up the chain
    // it will eventually be handled by the view controller
    
    [self.runtimeDelegate
     navigateToComponentWithIdentifier:componentIdentifier
     navigationType:navigationType];
}

#pragma mark - AMLayoutProvider

- (AMView<AMComponentAware> *)viewWithComponentIdentifier:(NSString *)componentIdentifier {
 
    if ([self.component.identifier isEqualToString:componentIdentifier]) {
        return self;
    }
    
    // breadth-first
    
    for (AMRuntimeView *childView in self.subviews) {
        if ([childView isKindOfClass:[AMRuntimeView class]]) {
            if ([childView.component.identifier isEqualToString:componentIdentifier]) {
                return childView;
            }
        }
    }
    for (AMRuntimeView *childView in self.subviews) {
        if ([childView isKindOfClass:[AMRuntimeView class]]) {
            
            AMView<AMComponentAware> *result = [childView viewWithComponentIdentifier:componentIdentifier];
            if (result != nil) {
                return result;
            }
        }
    }
    
    return nil;
}

- (AMComponent *)componentWithComponentIdentifier:(NSString *)componentIdentifier {
    AMView<AMComponentAware> *view = [self viewWithComponentIdentifier:componentIdentifier];
    return view.component;
}

#pragma mark - Private

- (void)setBaseAttributes {
    [self.helper setBaseAttributes:self];
}

#pragma mark - Layout

- (void)resetLayout {
    
    [self clearLayout];
    
    for (AMLayout *layout in self.component.allLayoutObjects) {
        layout.layoutProvider = self.layoutProvider;
        [layout addLayout];
    }
}

- (void)clearLayout {
    
    for (AMLayout *layoutObject in self.component.allLayoutObjects) {
        [layoutObject clearLayout];
    }
}

#pragma mark - Constraints

- (void)clearConstraints {
    [self.helper clearConstraints:self];
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.helper updateConstraintsFromComponent:self];
}

@end
