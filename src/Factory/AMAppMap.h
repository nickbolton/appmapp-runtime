//
//  AMAppMap.h
//  AppMap
//
//  Created by Nick Bolton on 10/12/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMDataSource;
@class AMView;
@class AMComponent;

@interface AMAppMap : NSObject

+ (instancetype)sharedInstance;

#if TARGET_OS_IPHONE
- (UIView *)buildViewFromComponent:(AMComponent *)component
                       inContainer:(UIView *)container;
#else
- (NSView *)buildViewFromComponent:(AMComponent *)component
                       inContainer:(NSView *)container;
#endif

@end
