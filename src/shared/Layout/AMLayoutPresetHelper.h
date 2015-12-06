//
//  AMLayoutPresetHelper.h
//  AppMap
//
//  Created by Nick Bolton on 3/28/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AppMapTypes.h"

@class AMComponentInstance;

@interface AMLayoutPresetHelper : NSObject

- (NSArray *)layoutTypesForComponent:(AMComponentInstance *)component
                        layoutPreset:(AMLayoutPreset)layoutPreset;

@end
