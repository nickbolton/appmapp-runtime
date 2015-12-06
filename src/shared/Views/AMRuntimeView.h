//
//  AMRuntimeView.h
//  AppMap
//
//  Created by Nick Bolton on 1/8/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AppMap.h"
#import "AppMapTypes.h"
#import "AMNavigatingButtonBehavior.h"

@class AMLayout;
@class AMComponentInstance;

@protocol AMRuntimeDelegate <NSObject>

@optional
- (void)navigateToComponentWithIdentifier:(NSString *)componentIdentifier
                           navigationType:(AMNavigationType)navigationType;

@end

@protocol AMRuntimeView <AMRuntimeDelegate>

@property (nonatomic, weak) id <AMRuntimeDelegate> runtimeDelegate;

- (AMComponentInstance *)component;
- (void)setComponent:(AMComponentInstance *)component;

- (void)clearConstraints;
- (void)setBaseAttributes;

@end

extern NSString * const kAMRuntimeViewConstraintsDidChangeNotification;

@interface AMRuntimeView : AMView<AMRuntimeView>

@property (nonatomic, weak) id <AMRuntimeDelegate> runtimeDelegate;

@end
