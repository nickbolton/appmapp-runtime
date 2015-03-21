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

extern NSString * const kAMComponentsKey;

@interface AMAppMap : NSObject

+ (instancetype)sharedInstance;

- (AMComponent *)loadComponentWithDictionary:(NSDictionary *)componentDict;

- (AMRuntimeView *)buildViewFromComponent:(AMComponent *)component
                              inContainer:(AMView *)container;

- (AMRuntimeView *)buildViewFromComponent:(AMComponent *)component
                              inContainer:(AMView *)container
                            bindingObject:(id)bindingObject;

@end
