//
//  AMVynthLayerDescriptor.m
//  AppMap
//
//  Created by Nick Bolton on 8/26/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import "AMVynthLayerDescriptor.h"
#import "AMVynthLayerRenderer.h"

static NSString * const kAMVynthLayerDescriptorTypeKey = @"type";
static NSString * const kAMVynthLayerDescriptorGradientTypeKey = @"gradientType";
static NSString * const kAMVynthLayerDescriptorGradientColorsKey = @"gradientColors";
static NSString * const kAMVynthLayerDescriptorGradientLocationsKey = @"gradientLocations";
static NSString * const kAMVynthLayerDescriptorMaskTypeKey = @"maskType";
static NSString * const kAMVynthLayerDescriptorMaskColorsKey = @"maskColors";
static NSString * const kAMVynthLayerDescriptorMaskLocationsKey = @"maskLocations";

@implementation AMVynthLayerDescriptor

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    [coder encodeInt32:self.type forKey:kAMVynthLayerDescriptorTypeKey];
    [coder encodeInt32:self.gradientType forKey:kAMVynthLayerDescriptorGradientTypeKey];
    [coder encodeObject:self.gradientColors forKey:kAMVynthLayerDescriptorGradientColorsKey];
    [coder encodeObject:self.gradientLocations forKey:kAMVynthLayerDescriptorGradientLocationsKey];
    [coder encodeInt32:self.maskType forKey:kAMVynthLayerDescriptorMaskTypeKey];
    [coder encodeObject:self.maskColors forKey:kAMVynthLayerDescriptorMaskColorsKey];
    [coder encodeObject:self.maskLocations forKey:kAMVynthLayerDescriptorMaskLocationsKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super initWithCoder:decoder];
    
    if (self != nil) {
        
        self.type = [decoder decodeInt32ForKey:kAMVynthLayerDescriptorTypeKey];

        self.gradientType = [decoder decodeInt32ForKey:kAMVynthLayerDescriptorGradientTypeKey];
        self.gradientColors = [decoder decodeObjectForKey:kAMVynthLayerDescriptorGradientColorsKey];
        self.gradientLocations = [decoder decodeObjectForKey:kAMVynthLayerDescriptorGradientLocationsKey];
        
        self.maskType = [decoder decodeInt32ForKey:kAMVynthLayerDescriptorMaskTypeKey];
        self.maskColors = [decoder decodeObjectForKey:kAMVynthLayerDescriptorMaskColorsKey];
        self.maskLocations = [decoder decodeObjectForKey:kAMVynthLayerDescriptorMaskLocationsKey];
    }
    
    return self;
}

- (Class)rendererClass {
    return [AMVynthLayerRenderer class];
}

+ (instancetype)buildDescriptor {
    
    AMVynthLayerDescriptor *descriptor =
    [[AMVynthLayerDescriptor alloc] init];
    descriptor.color = [UIColor clearColor];
    descriptor.insets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    descriptor.alpha = 1.0f;
    descriptor.type = AMVynthTypeNormal;

    return descriptor;
}

@end
