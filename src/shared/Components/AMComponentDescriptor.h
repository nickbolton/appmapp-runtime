//
//  AMComponentDescriptor.h
//  AppMap
//
//  Created by Nick Bolton on 12/5/15.
//  Copyright © 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMComponentElement.h"

extern NSString * kAMComponentTypeKey;
extern NSString * kAMComponentClippedKey;
extern NSString * kAMComponentBackgroundColorKey;
extern NSString * kAMComponentBorderWidthKey;
extern NSString * kAMComponentBorderColorWidthKey;
extern NSString * kAMComponentAlphaKey;
extern NSString * kAMComponentCornerRadiusKey;

@interface AMComponentDescriptor : AMComponentElement

@property (nonatomic, readonly) BOOL isContainer;

@end
