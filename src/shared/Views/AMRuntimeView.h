//
//  AMRuntimeView.h
//  AppMap
//
//  Created by Nick Bolton on 1/8/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AppMap.h"
#import "AppMapTypes.h"

@class AMLayout;
@class AMComponent;

@protocol AMRuntimeView <NSObject>

- (NSArray *)layoutObjects;
- (void)setLayoutObjects:(NSArray *)layoutObjects;
- (void)clearLayoutObjects;
- (void)addLayoutObject:(AMLayout *)layoutObject;
- (void)removeLayoutObject:(AMLayout *)layoutObject;

- (AMComponent *)component;
- (void)setComponent:(AMComponent *)component;

- (void)clearConstraints;
- (void)setBaseAttributes;

@end

extern NSString * const kAMRuntimeViewConstraintsDidChangeNotification;

@interface AMRuntimeView : AMView<AMRuntimeView>

@end
