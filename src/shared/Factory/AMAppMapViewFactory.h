//
//  AMAppMapViewFactory.h
//  AppMap
//
//  Created by Nick Bolton on 1/4/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMRuntimeView.h"

@class AMComponent;

@interface AMAppMapViewFactory : NSObject

- (AMView <AMRuntimeView> *)buildViewFromComponent:(AMComponent *)component
                                       inContainer:(AMView *)container
                                     bindingObject:(id)bindingObject;

@end
