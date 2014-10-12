//
//  AMRendererFactory.h
//  AppMap
//
//  Created by Nick Bolton on 8/24/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMStyleLayerRenderer;
@class AMLayerDescriptor;

@interface AMRendererFactory : NSObject

- (AMStyleLayerRenderer *)buildRendererForDescriptor:(AMLayerDescriptor *)descriptor;

+ (instancetype)sharedInstance;

@end
