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

@protocol AMRuntimeView <NSObject>

- (AMLayout *)layoutObject;
- (void)setLayoutObject:(AMLayout *)layoutObject;

- (AMComponent *)component;
- (void)setComponent:(AMComponent *)component;

- (void)clearLayout;
- (void)layoutDidChange;
- (void)setBaseAttributes;

@end

extern NSString * const kAMRuntimeViewLayoutDidChangeNotification;

@interface AMRuntimeView : NSView<AMRuntimeView>

@end
