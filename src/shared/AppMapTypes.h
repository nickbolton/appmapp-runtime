//
//  AppMapTypes.h
//  AppMapMacExample
//
//  Created by Nick Bolton on 1/9/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#ifndef AppMapMacExample_AppMapTypes_h
#define AppMapMacExample_AppMapTypes_h

typedef NS_ENUM(NSInteger, AMComponentType) {
    
    AMComponentContainer = 0,
    AMComponentText,
    AMComponentTextField,
    AMComponentButton,
};

typedef NS_ENUM(NSInteger, AMLayoutType) {
    
    AMLayoutTypePosition = 0,
    AMLayoutTypeFixedWidth,
    AMLayoutTypeFixedHeight,
    AMLayoutTypeAnchoredTop,
    AMLayoutTypeAnchoredBottom,
    AMLayoutTypeAnchoredLeft,
    AMLayoutTypeAnchoredRight,
    AMLayoutTypeCenterHorizontally,
    AMLayoutTypeCenterVertically,
};

#if TARGET_OS_IPHONE
#define AMColorType UIColor
typedef UIView AMView;
typedef UIColor AMColor;
typedef UIFont AMFont;
typedef UILabel AMLabel;
typedef UIViewController AMViewController;
#else
#define AMColorType NSColor
typedef NSView AMView;
typedef NSColor AMColor;
typedef NSFont AMFont;
typedef NSTextField AMLabel;
typedef NSViewController AMViewController;
#endif

#endif
