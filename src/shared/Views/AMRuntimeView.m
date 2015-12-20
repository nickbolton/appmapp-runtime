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

#pragma mark - AMRuntimeDelegate Conformance

- (void)navigateToComponentWithIdentifier:(NSString *)componentIdentifier
                           navigationType:(AMNavigationType)navigationType {

    // just delegate on up the chain
    // it will eventually be handled by the view controller
    
    [self.runtimeDelegate
     navigateToComponentWithIdentifier:componentIdentifier
     navigationType:navigationType];
}

#pragma mark - Private

- (void)setBaseAttributes {
    [self.helper setBaseAttributes:self];
}

#pragma mark - Layout

//- (void)layout {
//    [self.helper layoutView:self];
//}
//
//- (void)layoutSubviews {
//    [self.helper layoutView:self];
//}

#pragma mark - Constraints

- (void)clearConstraints {
    [self.helper clearConstraints:self];
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.helper updateConstraintsFromComponent:self];
}

@end
