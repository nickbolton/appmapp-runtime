//
//  AppMapTypes.h
//  AppMap
//
//  Created by Nick Bolton on 5/28/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#ifndef AppMap_AppMapTypes_h
#define AppMap_AppMapTypes_h

#import <Cocoa/Cocoa.h>
#import "AppMapComponentTypes.h"

#define AMColorType NSColor
#define AMImage NSImage
#define AMView NSView
#define AMButton NSButton
#define AMImageView NSImageView
#define AMColor NSColor
#define AMFont NSFont
#define AMLabel NSTextField
#define AMViewController NSViewController
#define AMLayoutPriority NSLayoutPriority
#define AMEdgeInsets NSEdgeInsets

static const AMLayoutPriority AMLayoutPriorityRequired = NSLayoutPriorityRequired;
static const AMLayoutPriority AMLayoutPriorityDefaultHigh = NSLayoutPriorityDefaultHigh;
static const AMLayoutPriority AMLayoutPriorityDefaultLow = NSLayoutPriorityDefaultLow;
static const AMLayoutPriority AMLayoutPriorityFittingSizeLevel = NSLayoutPriorityFittingSizeCompression;

#endif
