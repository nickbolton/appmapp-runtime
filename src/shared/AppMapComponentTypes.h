//
//  AppMapComponentTypes.h
//  AppMapExample
//
//  Created by Nick Bolton on 5/28/15.
//  Copyright (c) 2015 Pixelbleed. All rights reserved.
//

#ifndef AppMapExample_AppMapComponentTypes_h
#define AppMapExample_AppMapComponentTypes_h

typedef NS_ENUM(NSInteger, AMComponentType) {
    
    AMComponentContainer = 0,
    AMComponentButton,
    AMComponentText,
    AMComponentTextField,
    AMComponentTypeCount,
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

typedef NS_ENUM(NSInteger, AMDuplicateType) {
    AMDuplicateTypeCopied = 0,
    AMDuplicateTypeMirrored,
    AMDuplicateTypeExcluded,
};

#endif
