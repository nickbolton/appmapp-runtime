//
//  AMLayoutFactory.h
//  AppMap
//
//  Created by Nick Bolton on 3/28/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AppMapTypes.h"

@class AMComponent;

@interface AMLayoutFactory : NSObject

- (NSArray *)layoutObjectsForComponent:(AMComponent *)component
                          layoutPreset:(AMLayoutPreset)layoutPreset;

- (AMLayout *)layoutForComponent:(AMComponent *)component
                       attribute:(NSLayoutAttribute)attribute
                relatedComponent:(AMComponent *)relatedComponent
                relatedAttribute:(NSLayoutAttribute)relatedAttribute
                    proportional:(BOOL)proportional;

- (AMLayout *)danglingLayoutForComponent:(AMComponent *)component
                               attribute:(NSLayoutAttribute)attribute
                                constant:(CGFloat)constant;
    
@end
