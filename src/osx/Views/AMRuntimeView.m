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
#import "AMRuntimeViewHelper.h"

NSString * const kAMRuntimeViewLayoutDidChangeNotification = @"kAMRuntimeViewLayoutDidChangeNotification";

@interface AMRuntimeView()

@property (nonatomic, strong) AMLayout *layoutObject;
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

#pragma mark - Private

- (void)setBaseAttributes {
    [self.helper setBaseAttributes:self];
    [self doit];
}

- (void)doit {
    
    NSLog(@"view: %@ - %@", self, NSStringFromRect(self.frame));
    
    [self setNeedsUpdateConstraints:YES];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self doit];
    });
}

#pragma mark - Layout

- (void)layout {
    [self.helper layoutView:self];
}

- (void)clearLayout {
    [self.helper clearLayout:self];
}

- (void)layoutDidChange {
    [self.helper layoutDidChange:self];
}

#pragma mark - Constraints

- (void)updateConstraints {
    [super updateConstraints];
    [self.helper updateConstraintsFromComponent:self];
}

@end
