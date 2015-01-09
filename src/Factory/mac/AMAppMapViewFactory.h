//
//  AMAppMapViewFactory.h
//  AppMap
//
//  Created by Nick Bolton on 1/4/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMComponent;
@class AMRuntimeView;

@interface AMAppMapViewFactory : NSObject

- (AMRuntimeView *)buildViewFromComponent:(AMComponent *)component
                              inContainer:(NSView *)container;

@end
