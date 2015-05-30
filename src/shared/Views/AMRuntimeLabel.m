//
//  AMRuntimeLabel.m
//  AppMap
//
//  Created by Nick Bolton on 1/8/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMRuntimeLabel.h"
#import "AMRuntimeViewHelper.h"
#import "AMComponent.h"
#import "AMCompositeTextDescriptor.h"

@interface AMRuntimeLabel()

@property (nonatomic, strong) AMLayout *layoutObject;
@property (nonatomic, strong) AMComponent *component;
@property (nonatomic, strong) AMRuntimeViewHelper *helper;

@end

@implementation AMRuntimeLabel

#pragma mark - Getters and Setters

- (void)setComponent:(AMComponent *)component {
    _component = component;
    NSAssert(component.componentType == AMComponentText,
             @"component not an AMComponentText");
    [self.helper setComponent:component forView:self];
}

- (AMRuntimeViewHelper *)helper {
    
    if (_helper == nil) {
        _helper = [AMRuntimeViewHelper new];
    }
    
    return _helper;
}

#pragma mark - Private

- (void)setBaseAttributes {
    [self.helper setBaseAttributes:self];
    [self updateFromTextDescriptor];
}

- (void)updateFromTextDescriptor {
    
    NSAttributedString *attributedString =
    self.component.textDescriptor.attributedString;
    
#if TARGET_OS_IPHONE
    self.attributedText = attributedString;
#else
    self.attributedStringValue = attributedString;
#endif
    
    AMFont *font = nil;
    
    if (attributedString.length > 0) {
        
        font =
        [attributedString
         attribute:NSFontAttributeName
         atIndex:0
         effectiveRange:NULL];
    }
    
    if (font == nil) {
        font = [AMFont systemFontOfSize:16.0f];
    }
    
    self.font = font;
}

#pragma mark - Layout

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
