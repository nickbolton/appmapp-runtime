//
//  AMAppMap.h
//  AppMap
//
//  Created by Nick Bolton on 10/12/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import "AMRuntimeView.h"
#import "AMComponent.h"
#import "AMLayoutFactory.h"

@interface AMAppMap : NSObject

+ (instancetype)sharedInstance;

- (AMRuntimeView *)buildViewFromComponent:(AMComponent *)component
                              inContainer:(AMView *)container;

- (AMRuntimeView *)buildViewFromComponent:(AMComponent *)component
                              inContainer:(AMView *)container
                            bindingObject:(id)bindingObject;

@end
