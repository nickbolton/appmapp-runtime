//
//  AMWindow.m
//  AppMapMacExample
//
//  Created by Nick Bolton on 1/8/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMWindow.h"
#import "AMAppMap.h"
#import "RootViewView.h"

@implementation AMWindow

- (void)setContentView:(NSView *)contentView {
    [super setContentView:contentView];
    
    contentView.wantsLayer = YES;
    contentView.layer.backgroundColor =
    [NSColor
     colorWithRed:0.6352941176f
     green:0.6784313725f
     blue:0.7215686275f
     alpha:1.0f].CGColor;

    [self loadRootView];
}

- (void)loadRootView {
    
    RootViewView *view = [RootViewView new];
    view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    
    [self.contentView addSubview:view];
    view.frame = [self.contentView bounds];
}

@end
