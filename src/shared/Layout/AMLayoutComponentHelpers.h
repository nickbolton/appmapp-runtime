//
//  AMLayoutComponentHelpers.h
//  AppMap
//
//  Created by Nick Bolton on 12/21/15.
//  Copyright © 2015 Pixelbleed LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMComponent;

@interface AMLayoutComponentHelpers : NSObject

+ (CGFloat)proportionalValueForComponent:(AMComponent *)component
                               attribute:(NSLayoutAttribute)attribute
                        relatedComponent:(AMComponent *)relatedComponent
                        relatedAttribute:(NSLayoutAttribute)relatedAttribute
                 commonAncestorComponent:(AMComponent *)commonAncestorComponent;

+ (CGFloat)relatedValueForFrame:(CGRect)frame attribute:(NSLayoutAttribute)attribute;

+ (CGFloat)proportionalOffsetForComponent:(AMComponent *)component
                                attribute:(NSLayoutAttribute)attribute
                         relatedComponent:(AMComponent *)relatedComponent
                         relatedAttribute:(NSLayoutAttribute)relatedAttribute
                        proportionalValue:(CGFloat)proportionalValue;

@end
