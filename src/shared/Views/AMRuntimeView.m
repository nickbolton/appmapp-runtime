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

NSString * const kAMRuntimeViewConstraintsDidChangeNotification = @"kAMRuntimeViewConstraintsDidChangeNotification";

@interface AMRuntimeView()

@property (nonatomic, strong) NSMutableArray *_layoutObjects;
@property (nonatomic, strong) AMComponent *component;
@property (nonatomic, strong) AMRuntimeViewHelper *helper;

@end

@implementation AMRuntimeView

- (id)init {
    self = [super init];
    
    if (self != nil) {
        self._layoutObjects = [NSMutableArray array];
    }
    
    return self;
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
}

#pragma mark - Private

- (void)setBaseAttributes {
    [self.helper setBaseAttributes:self];
}

#pragma mark - Layout

- (NSArray *)layoutObjects {
    return self._layoutObjects.copy;
}

- (void)setLayoutObjects:(NSArray *)layoutObjects {
    [self clearLayoutObjects];
    [self._layoutObjects addObjectsFromArray:layoutObjects];
}

- (void)clearLayoutObjects {
    [self clearConstraints];
    [self._layoutObjects removeAllObjects];
}

- (void)addLayoutObject:(AMLayout *)layoutObject {
    [self clearConstraints];
    [self._layoutObjects addObject:layoutObject];
}

- (void)removeLayoutObject:(AMLayout *)layoutObject {
    [self clearConstraints];
    [self._layoutObjects removeObject:layoutObject];
}

- (void)layout {
    [self.helper layoutView:self];
}

- (void)layoutSubviews {
    [self.helper layoutView:self];
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
