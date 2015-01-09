//
//  AMWindow.m
//  AppMapMacExample
//
//  Created by Nick Bolton on 1/8/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMWindow.h"
#import "AMAppMap.h"

@implementation AMWindow

- (void)setContentView:(id)contentView {
    [super setContentView:contentView];
    [self loadRootView];
}

- (void)loadRootView {
    
    [[AMAppMap sharedInstance]
     buildViewFromResourceName:@"rootView"
     componentName:@"container0"
     inContainer:self.contentView];
}

@end
