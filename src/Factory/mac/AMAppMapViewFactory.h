//
//  AMAppMapViewFactory.h
//  AppMap
//
//  Created by Nick Bolton on 1/4/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMComponent;

@interface AMAppMapViewFactory : NSObject

- (NSView *)buildViewFromComponent:(AMComponent *)component
                       inContainer:(NSView *)container;

@end
