//
//  AMAppMapViewFactory.h
//  AppMap
//
//  Created by Nick Bolton on 1/4/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMRuntimeView.h"

@class AMComponentInstance;

@interface AMAppMapViewFactory : NSObject

- (AMView <AMRuntimeView> *)buildViewFromComponent:(AMComponentInstance *)component
                                       inContainer:(AMView *)container
                                     bindingObject:(id)bindingObject;

@end
