//
//  AMRuntimeView.h
//  AppMap
//
//  Created by Nick Bolton on 1/8/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AMLayout;
@class AMComponent;

NSString * const kAMRuntimeViewLayoutDidChangeNotification;

@interface AMRuntimeView : NSView

@property (nonatomic, strong) AMLayout *layoutObject;
@property (nonatomic, strong) AMComponent *component;

- (void)clearLayout;
- (void)layoutDidChange;

@end
