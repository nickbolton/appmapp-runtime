//
//  AMRuntimeStyleView.h
//  AppMap
//
//  Created by Nick Bolton on 8/27/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import "AMRuntimeView.h"

@class AMStyleLayer;

@interface AMRuntimeStyleView : AMRuntimeView

@property (nonatomic, readonly) AMStyleLayer *styleLayer;

@end
