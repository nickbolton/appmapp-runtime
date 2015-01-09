//
//  AMRuntimeView.h
//  AppMap
//
//  Created by Nick Bolton on 1/8/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AMLayout;

@interface AMRuntimeView : NSView

@property (nonatomic, strong) AMLayout *layoutObject;

@end
