//
//  AMRuntimeViewHelper.h
//  AppMap
//
//  Created by Nick Bolton on 1/9/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMRuntimeView.h"

@class AMComponent;

@interface AMRuntimeViewHelper : NSObject

- (void)setBaseAttributes:(NSView <AMRuntimeView> *)view;
- (void)setComponent:(AMComponent *)component forView:(NSView<AMRuntimeView> *)view;
- (void)layoutView:(NSView<AMRuntimeView> *)view;
- (void)clearLayout:(NSView<AMRuntimeView> *)view;
- (void)layoutDidChange:(NSView<AMRuntimeView> *)runtimeView;
- (void)updateConstraintsFromComponent:(NSView<AMRuntimeView> *)view;

@end
