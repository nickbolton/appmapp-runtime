//
//  AMRuntimeTextField.m
//  AppMap
//
//  Created by Nick Bolton on 1/8/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMRuntimeTextField.h"
#import "AMRuntimeViewHelper.h"
#import "AMComponent.h"
#import "AMTextComponent.h"
#import "AMCompositeTextDescriptor.h"

@interface AMRuntimeTextField()

@property (nonatomic, strong) AMLayout *layoutObject;
@property (nonatomic, strong) AMComponent *component;
@property (nonatomic, strong) AMTextComponent *textComponent;
@property (nonatomic, strong) AMRuntimeViewHelper *helper;

@end

@implementation AMRuntimeTextField

#pragma mark - Getters and Setters

- (void)setComponent:(AMComponent *)component {
    _component = component;
    [self.helper setComponent:component forView:self];
}

- (AMTextComponent *)textComponent {
    NSAssert([self.component isKindOfClass:[AMTextComponent class]],
             @"component not an AMTextComponent");
    return (id)self.component;
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
    self.attributedStringValue = self.textComponent.textDescriptor.attributedString;
    
    NSFont *font = nil;
    
    if (self.attributedStringValue.length > 0) {
        
        font =
        [self.attributedStringValue
         attribute:NSFontAttributeName
         atIndex:0
         effectiveRange:NULL];
    }
    
    if (font == nil) {
        font = [NSFont systemFontOfSize:16.0f];
    }
    
    self.font = font;
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
