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
#import "AMComponentAware.h"

@class AMLayout;
@class AMComponent;

@protocol AMRuntimeDelegate <NSObject>

@optional
- (void)navigateToComponentWithIdentifier:(NSString *)componentIdentifier
                           navigationType:(AMNavigationType)navigationType;

@end

@protocol AMRuntimeView <AMRuntimeDelegate, AMComponentAware, AMLayoutProvider>

@property (nonatomic, weak) id <AMLayoutProvider> layoutProvider;
@property (nonatomic, weak) id <AMRuntimeDelegate> runtimeDelegate;

- (void)clearConstraints;
- (void)setBaseAttributes;
- (void)resetLayout;

@end

extern NSString * const kAMRuntimeViewConstraintsDidChangeNotification;

@interface AMRuntimeView : AMView<AMRuntimeView>

@property (nonatomic, weak) id <AMRuntimeDelegate> runtimeDelegate;

@end
