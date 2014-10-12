//
//  AMLayerDescriptor.m
//  AppMap
//
//  Created by Nick Bolton on 8/24/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import "AMLayerDescriptor.h"
#import "AMRendererFactory.h"

static NSString * const kAMLayerDescriptorNameKey = @"name";
static NSString * const kAMLayerDescriptorPathKey = @"path";
static NSString * const kAMLayerDescriptorTopKey = @"top";
static NSString * const kAMLayerDescriptorLeftKey = @"left";
static NSString * const kAMLayerDescriptorBottomKey = @"bottom";
static NSString * const kAMLayerDescriptorRightKey = @"right";
static NSString * const kAMLayerDescriptorBlendModeKey = @"blendMode";
static NSString * const kAMLayerDescriptorBehindKey = @"behind";
static NSString * const kAMLayerDescriptorColorKey = @"color";
static NSString * const kAMLayerDescriptorAlphaKey = @"alpha";
static NSString * const kAMLayerDescriptorBlurRadiusKey = @"blurRadius";

@interface AMLayerDescriptor()

@property (nonatomic, readwrite) AMStyleLayerRenderer *layerRenderer;

@end

@implementation AMLayerDescriptor

- (id)init {
    self = [super init];
    
    if (self != nil) {
        self.name = @"Style";
    }
    
    return self;
}

+ (instancetype)buildDescriptor {
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.name forKey:kAMLayerDescriptorNameKey];
    [coder encodeObject:self.path forKey:kAMLayerDescriptorPathKey];
    [coder encodeFloat:self.insets.top forKey:kAMLayerDescriptorTopKey];
    [coder encodeFloat:self.insets.left forKey:kAMLayerDescriptorLeftKey];
    [coder encodeFloat:self.insets.bottom forKey:kAMLayerDescriptorBottomKey];
    [coder encodeFloat:self.insets.right forKey:kAMLayerDescriptorRightKey];
    [coder encodeInt32:self.blendMode forKey:kAMLayerDescriptorBlendModeKey];
    [coder encodeBool:self.isBehind forKey:kAMLayerDescriptorBehindKey];
    [coder encodeObject:self.color forKey:kAMLayerDescriptorColorKey];
    [coder encodeFloat:self.alpha forKey:kAMLayerDescriptorAlphaKey];
    [coder encodeFloat:self.blurRadius forKey:kAMLayerDescriptorBlurRadiusKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    
    if (self != nil) {
        
        self.name = [decoder decodeObjectForKey:kAMLayerDescriptorNameKey];
        self.path = [decoder decodeObjectForKey:kAMLayerDescriptorPathKey];
        
        UIEdgeInsets insets;
        insets.top = [decoder decodeFloatForKey:kAMLayerDescriptorTopKey];
        insets.left = [decoder decodeFloatForKey:kAMLayerDescriptorLeftKey];
        insets.bottom = [decoder decodeFloatForKey:kAMLayerDescriptorBottomKey];
        insets.right = [decoder decodeFloatForKey:kAMLayerDescriptorRightKey];
        self.insets = insets;
        
        self.blendMode = (CGBlendMode)[decoder decodeInt32ForKey:kAMLayerDescriptorBlendModeKey];
        self.behind = [decoder decodeBoolForKey:kAMLayerDescriptorBehindKey];
        self.color = [decoder decodeObjectForKey:kAMLayerDescriptorColorKey];
        self.alpha = [decoder decodeFloatForKey:kAMLayerDescriptorAlphaKey];
        self.blurRadius = [decoder decodeFloatForKey:kAMLayerDescriptorBlurRadiusKey];
    }
    
    return self;
}

#pragma mark - Getters and Setters

- (Class)layerClass {
    [self doesNotRecognizeSelector:_cmd];
    return Nil;
}

- (Class)rendererClass {
    [self doesNotRecognizeSelector:_cmd];
    return Nil;
}

- (NSString *)descriptorKey {
    return NSStringFromClass(self.layerClass);
}

- (AMStyleLayerRenderer *)layerRenderer {
    
    if (_layerRenderer == nil) {
        
        _layerRenderer =
        [[AMRendererFactory sharedInstance] buildRendererForDescriptor:self];
    }
    
    return _layerRenderer;
}

@end
