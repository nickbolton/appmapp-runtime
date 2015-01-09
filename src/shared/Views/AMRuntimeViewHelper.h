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

- (void)setBaseAttributes:(AMView <AMRuntimeView> *)view;
- (void)setComponent:(AMComponent *)component forView:(AMView<AMRuntimeView> *)view;
- (void)layoutView:(AMView<AMRuntimeView> *)view;
- (void)clearConstraints:(AMView<AMRuntimeView> *)view;
- (void)constraintsDidChange:(AMView<AMRuntimeView> *)runtimeView;
- (void)updateConstraintsFromComponent:(AMView<AMRuntimeView> *)view;

@end
