//
//  AMLayoutComponentHelpers.h
//  AppMap
//
//  Created by Nick Bolton on 12/21/15.
//  Copyright © 2015 Pixelbleed LLC. All rights reserved.
//

#import "AppMap.h"

@class AMComponent;

@interface AMLayoutComponentHelpers : NSObject

+ (CGFloat)proportionalValueForComponent:(AMComponent *)component
                               attribute:(NSLayoutAttribute)attribute
                   proportionalComponent:(AMComponent *)proportionalComponent;

+ (CGFloat)relatedValueForFrame:(CGRect)frame attribute:(NSLayoutAttribute)attribute;

+ (CGFloat)proportionalConstantForComponent:(AMComponent *)component
                                  attribute:(NSLayoutAttribute)attribute
                      proportionalComponent:(AMComponent *)proportionalComponent
                          proportionalValue:(CGFloat)proportionalValue;

@end
