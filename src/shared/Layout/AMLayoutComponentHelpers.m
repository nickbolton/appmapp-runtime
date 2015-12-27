//
//  AMLayoutComponentHelpers.m
//  AppMap
//
//  Created by Nick Bolton on 12/21/15.
//  Copyright © 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMLayoutComponentHelpers.h"
#import "AMComponent.h"

@implementation AMLayoutComponentHelpers

+ (CGRect)frameInCommonAncestorComponent:(AMComponent *)commonComponent
                           fromComponent:(AMComponent *)component {
    
    CGRect result = [component convertComponentFrameToAncestorComponent:commonComponent];
    
    return result;
}

+ (CGFloat)relatedValueForFrame:(CGRect)frame attribute:(NSLayoutAttribute)attribute {
    
    switch (attribute) {
            
        case NSLayoutAttributeTop:
            return CGRectGetMinY(frame);
            break;
            
        case NSLayoutAttributeLeft:
            return CGRectGetMinX(frame);
            break;
            
        case NSLayoutAttributeBottom:
            return CGRectGetMaxY(frame);
            break;
            
        case NSLayoutAttributeRight:
            return CGRectGetMaxX(frame);
            break;
            
        case NSLayoutAttributeCenterY:
            return CGRectGetMidY(frame);
            break;
            
        case NSLayoutAttributeCenterX:
            return CGRectGetMidX(frame);
            break;
            
        case NSLayoutAttributeHeight:
            return CGRectGetHeight(frame);
            break;
            
        case NSLayoutAttributeWidth:
            return CGRectGetWidth(frame);
            break;
            
        default:
            break;
    }
    
    return 0.0f;
}

+ (NSLayoutAttribute)proportionalAttribute:(NSLayoutAttribute)attribute {
    
    switch (attribute) {
            
        case NSLayoutAttributeTop:
        case NSLayoutAttributeBottom:
        case NSLayoutAttributeCenterY:
        case NSLayoutAttributeHeight:
            return NSLayoutAttributeHeight;
            break;
            
        case NSLayoutAttributeLeft:
        case NSLayoutAttributeRight:
        case NSLayoutAttributeCenterX:
        case NSLayoutAttributeWidth:
            return NSLayoutAttributeWidth;
            break;
            
        default:
            break;
    }
    
    return NSLayoutAttributeNotAnAttribute;
}

+ (CGFloat)proportionalValueForComponent:(AMComponent *)component
                               attribute:(NSLayoutAttribute)attribute
                   proportionalComponent:(AMComponent *)proportionalComponent {
    
    CGFloat result = 0.0f;
    
    CGRect frame = component.frame;
    CGRect commonFrame = proportionalComponent.frame;
    
    NSLayoutAttribute proportionalAttribute = [self proportionalAttribute:attribute];
    CGFloat relatedValue = [self relatedValueForFrame:commonFrame attribute:proportionalAttribute];
    
    switch (attribute) {
            
        case NSLayoutAttributeTop:
            result = CGRectGetMinY(frame) / relatedValue;
            break;
            
        case NSLayoutAttributeLeft:
            result = CGRectGetMinX(frame) / relatedValue;
            break;
            
        case NSLayoutAttributeBottom:
            result = (relatedValue - CGRectGetMaxY(frame)) / relatedValue;
            break;
            
        case NSLayoutAttributeRight:
            result = (relatedValue - CGRectGetMaxX(frame)) / relatedValue;
            break;
            
        case NSLayoutAttributeCenterY:
            result = (relatedValue/2.0f - CGRectGetMidY(frame)) / relatedValue;
            break;
            
        case NSLayoutAttributeCenterX:
            result = (relatedValue/2.0f - CGRectGetMidX(frame)) / relatedValue;
            break;
            
        case NSLayoutAttributeHeight:
            result = CGRectGetHeight(frame) / relatedValue;
            break;
            
        case NSLayoutAttributeWidth:
            result = CGRectGetWidth(frame) / relatedValue;
            break;
            
        default:
            break;
    }
    
    return result;
}

//+ (CGFloat)proportionalValueForComponent:(AMComponent *)component
//                               attribute:(NSLayoutAttribute)attribute
//                        relatedComponent:(AMComponent *)relatedComponent
//                        relatedAttribute:(NSLayoutAttribute)relatedAttribute
//                 commonAncestorComponent:(AMComponent *)commonAncestorComponent {
//    
//    CGFloat result = 0.0f;
//    
//    CGRect frameInCommonSpace = [self frameInCommonAncestorComponent:commonAncestorComponent fromComponent:component];
//    CGRect relatedFrameInCommonSpace = [self frameInCommonAncestorComponent:commonAncestorComponent fromComponent:relatedComponent];
//    
//    CGFloat relatedValue = [self relatedValueForFrame:relatedFrameInCommonSpace attribute:relatedAttribute];
//    
//    switch (attribute) {
//            
//        case NSLayoutAttributeTop:
//            result = CGRectGetMinY(frameInCommonSpace) / relatedValue;
//            break;
//            
//        case NSLayoutAttributeLeft:
//            result = CGRectGetMinX(frameInCommonSpace) / relatedValue;
//            break;
//            
//        case NSLayoutAttributeBottom:
//            result = CGRectGetMaxY(frameInCommonSpace) / relatedValue;
//            break;
//            
//        case NSLayoutAttributeRight:
//            result = CGRectGetMaxX(frameInCommonSpace) / relatedValue;
//            break;
//            
//        case NSLayoutAttributeCenterY:
//            result = CGRectGetMidY(frameInCommonSpace) / relatedValue;
//            break;
//            
//        case NSLayoutAttributeCenterX:
//            result = CGRectGetMidX(frameInCommonSpace) / relatedValue;
//            break;
//            
//        case NSLayoutAttributeHeight:
//            result = CGRectGetHeight(frameInCommonSpace) / relatedValue;
//            break;
//            
//        case NSLayoutAttributeWidth:
//            result = CGRectGetWidth(frameInCommonSpace) / relatedValue;
//            break;
//            
//        default:
//            break;
//    }
//    
//    return result;
//}

+ (CGFloat)proportionalConstantForComponent:(AMComponent *)component
                                  attribute:(NSLayoutAttribute)attribute
                      proportionalComponent:(AMComponent *)proportionalComponent
                          proportionalValue:(CGFloat)proportionalValue {
    
    CGFloat result = 0.0f;
    
    if (component != nil) {
        
        CGRect relatedFrame = proportionalComponent.frame;
        
        NSLayoutAttribute proportionalAttribute = [self proportionalAttribute:attribute];
        CGFloat relatedValue = [self relatedValueForFrame:relatedFrame attribute:proportionalAttribute];
        
        result = proportionalValue * relatedValue;
        
        if (attribute == NSLayoutAttributeRight || attribute == NSLayoutAttributeBottom ||
            attribute == NSLayoutAttributeCenterX || attribute == NSLayoutAttributeCenterY) {
            result = -result;
        }
    }
    
    return result;
}

//+ (CGFloat)proportionalOffsetForComponent:(AMComponent *)component
//                                attribute:(NSLayoutAttribute)attribute
//                        proportionalValue:(CGFloat)proportionalValue
//                         relatedComponent:(AMComponent *)relatedComponent
//                  commonAncestorComponent:(AMComponent *)commonAncestorComponent {
//    
//    CGFloat result = 0.0f;
//    
//    if (component != nil && relatedComponent != nil && commonAncestorComponent != nil) {
//        
//        CGRect relatedFrameInCommonSpace =
//        [self
//         frameInCommonAncestorComponent:commonAncestorComponent
//         fromComponent:relatedComponent];
//        
//        CGFloat relatedValue =
//        [AMLayoutComponentHelpers
//         relatedValueForFrame:relatedFrameInCommonSpace
//         attribute:attribute];
//        
//        result = proportionalValue * relatedValue - relatedValue;
//    }
//    
//    return result / 2.0f;
//}

@end
