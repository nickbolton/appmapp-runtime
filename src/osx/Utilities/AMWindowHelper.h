//
//  AMWindowHelper.h
//  AppMap
//
//  Created by Nick Bolton on 5/28/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMWindowHelper : NSObject

@property (nonatomic) CGFloat windowScale;

+ (instancetype)sharedInstance;

@end
