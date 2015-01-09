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

@property (nonatomic, readonly) NSString *viewClass;

- (NSView <AMRuntimeView> *)buildViewFromComponent:(AMComponent *)component
                                       inContainer:(NSView *)container;

@end
