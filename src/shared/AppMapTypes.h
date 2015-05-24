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
    AMLayoutTypeExpanding,
    AMLayoutTypeFixedWidth,
    AMLayoutTypeFixedHeight,
    AMLayoutTypeAnchoredTop,
    AMLayoutTypeAnchoredBottom,
    AMLayoutTypeAnchoredLeft,
    AMLayoutTypeAnchoredRight,
    AMLayoutTypeCenterHorizontally,
    AMLayoutTypeCenterVertically,
    AMLayoutTypeProportionalTop,
    AMLayoutTypeProportionalBottom,
    AMLayoutTypeProportionalLeft,
    AMLayoutTypeProportionalRight,
    AMLayoutTypeProportionalHorizontalCenter,
    AMLayoutTypeProportionalVerticalCenter,
};

typedef NS_ENUM(NSInteger, AMLayoutPreset) {
    AMLayoutPresetFixedSizeNearestCorner = 0,
    AMLayoutPresetFixedSizeRelativeCorner,
    AMLayoutPresetFixedSizeRelativeCenter,
    AMLayoutPresetFixedSizeFixedCenter,
    AMLayoutPresetFixedSizeFixedPosition,
    AMLayoutPresetFixedYPosHeightLeftRightMargins,
    AMLayoutPresetFixedXPosWidthTopBottomMargins,
    AMLayoutPresetFixedMargins,
    AMLayoutPresetProportionalMargins,
    AMLayoutPresetCustom,
};

#if TARGET_OS_IPHONE

#define AMColorType UIColor
typedef UIImage AMImage;
typedef UIView AMView;
typedef UIImageView AMImageView;
typedef UIColor AMColor;
typedef UIFont AMFont;
typedef UILabel AMLabel;
typedef UIViewController AMViewController;
typedef UILayoutPriority AMLayoutPriority;

static const AMLayoutPriority AMLayoutPriorityRequired = UILayoutPriorityRequired;
static const AMLayoutPriority AMLayoutPriorityDefaultHigh = UILayoutPriorityDefaultHigh;
static const AMLayoutPriority AMLayoutPriorityDefaultLow = UILayoutPriorityDefaultLow;
static const AMLayoutPriority AMLayoutPriorityFittingSizeLevel = UILayoutPriorityFittingSizeLevel;

#else

#define AMColorType NSColor
typedef NSImage AMImage;
typedef NSView AMView;
typedef NSImageView AMImageView;
typedef NSColor AMColor;
typedef NSFont AMFont;
typedef NSTextField AMLabel;
typedef NSViewController AMViewController;
typedef NSLayoutPriority AMLayoutPriority;

static const AMLayoutPriority AMLayoutPriorityRequired = NSLayoutPriorityRequired;
static const AMLayoutPriority AMLayoutPriorityDefaultHigh = NSLayoutPriorityDefaultHigh;
static const AMLayoutPriority AMLayoutPriorityDefaultLow = NSLayoutPriorityDefaultLow;
static const AMLayoutPriority AMLayoutPriorityFittingSizeLevel = NSLayoutPriorityFittingSizeCompression;

#endif

#endif
