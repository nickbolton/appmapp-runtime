//
//  AMVynthLayerDescriptor.h
//  AppMap
//
//  Created by Nick Bolton on 8/26/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import "AMLayerDescriptor.h"

typedef NS_ENUM(NSInteger, AMVynthType) {
    AMVynthTypeNormal = 0,
    AMVynthTypeInverted,
};

typedef NS_ENUM(NSInteger, AMVynthGradientType) {
    
    AMVynthGradientNone = 0,
    AMVynthGradientHorizontal,
    AMVynthGradientVertical,
    AMVynthGradientRadial,
};

@interface AMVynthLayerDescriptor : AMLayerDescriptor <NSCoding>

@property (nonatomic) AMVynthType type;

@property (nonatomic) AMVynthGradientType gradientType;
@property (nonatomic) NSArray *gradientColors;
@property (nonatomic) NSArray *gradientLocations;

@property (nonatomic) AMVynthGradientType maskType;
@property (nonatomic) NSArray *maskColors;
@property (nonatomic) NSArray *maskLocations;

@end
