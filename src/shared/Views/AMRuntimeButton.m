//
//  AMRuntimeButton.m
//  AppMap
//
//  Created by Nick Bolton on 5/30/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMRuntimeButton.h"
#import "AMRuntimeViewHelper.h"

@interface AMRuntimeButton()

@property (nonatomic, strong) AMComponent *component;
@property (nonatomic, strong) AMRuntimeViewHelper *helper;

@end


@implementation AMRuntimeButton

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

#pragma mark - Private

- (void)setBaseAttributes {
    [self.helper setBaseAttributes:self];
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
