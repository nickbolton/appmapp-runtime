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

#pragma mark - Setup

- (void)setupAction {
    
    id target = self;
    SEL action = @selector(buttonTriggered);

#if TARGET_OS_IPHONE
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
#else
    self.target = target;
    self.action = action;
#endif
}

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
    [self setupAction];
}

#pragma mark - Actions

- (void)buttonTriggered {
    
    AMNavigatingButtonBehavior *behavior = (id)self.component.behavor;
    if ([behavior isKindOfClass:[AMNavigatingButtonBehavior class]]) {
        
        if ([self.runtimeDelegate respondsToSelector:@selector(navigateToComponentWithIdentifier:navigationType:)]) {
            
            if (self.component.linkedComponentIdentifier != nil) {
                [self.runtimeDelegate
                 navigateToComponentWithIdentifier:self.component.linkedComponentIdentifier
                 navigationType:behavior.navigationType];
            }
        }
    }
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
