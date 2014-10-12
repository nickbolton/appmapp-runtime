//
//  AMRuntimeView.m
//  AppMap
//
//  Created by Nick Bolton on 8/26/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import "AMRuntimeView.h"
#import "AMStyleLayer.h"
#import "AMComponent.h"
#import "AMLayerDescriptor.h"
#import "AMStyleLayerRenderer.h"

@interface AMRuntimeView()

@end

@implementation AMRuntimeView

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.clipsToBounds = NO;
#if TARGET_OS_IPHONE == 0
    self.wantsLayer = YES;
#endif
}

#pragma mark - Getters and Setters

#if TARGET_OS_IPHONE == 0
- (BOOL)isFlipped {
    return YES;
}
#endif

#pragma mark - Public

- (void)cleanup {
    [self removeFromSuperview];
    
    [self.subviews enumerateObjectsUsingBlock:^(AMRuntimeView *childView, NSUInteger idx, BOOL *stop) {
        
        if ([childView isKindOfClass:[AMRuntimeView class]]) {
            [childView cleanup];
        }
    }];
}

@end
