//
//  AMLayout.h
//  AppMap
//
//  Created by Nick Bolton on 12/28/14.
//  Copyright (c) 2014 Pixelbleed LLC. All rights reserved.
//
#import "AMView.h"

typedef NS_ENUM(NSInteger, AMLayoutType) {
    
    AMLayoutTypePosition = 0,
    AMLayoutTypeAnchoredTop,
    AMLayoutTypeAnchoredBottom,
    AMLayoutTypeAnchoredLeft,
    AMLayoutTypeAnchoredRight,
    AMLayoutTypeAnchoredTopLeft,
    AMLayoutTypeAnchoredTopRight,
    AMLayoutTypeAnchoredBottomLeft,
    AMLayoutTypeAnchoredBottomRight,
};

@interface AMLayout : NSObject

@property (nonatomic, weak) NSView *view;

- (void)clearLayout;
- (void)updateLayoutWithFrame:(CGRect)frame;
- (void)createConstraintsIfNecessary;

@end
