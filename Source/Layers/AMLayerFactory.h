//
//  AMLayerFactory.h
//  AppMap
//
//  Created by Nick Bolton on 10/7/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AMLayerType) {
    AMLayerTypeVynth = 0,
};

@class AMLayerDescriptor;

@interface AMLayerFactory : NSObject

+ (instancetype)sharedInstance;

- (id)buildLayerDescriptorOfType:(AMLayerType)type;

@end
