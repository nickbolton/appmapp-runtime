//
//  AMRuntimeStyleView.m
//  AppMap
//
//  Created by Nick Bolton on 8/27/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import "AMRuntimeStyleView.h"
#import "AMStyleLayer.h"

@implementation AMRuntimeStyleView

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self __commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self __commonInit];
    }
    return self;
}

+ (Class)layerClass {
    return [AMStyleLayer class];
}

- (void)__commonInit {
    
#if TARGET_OS_IPHONE
    self.backgroundColor = [UIColor clearColor];
#else
    self.wantsLayer = YES;
    self.layer = [[AMStyleLayer alloc] init];
#endif
}

#pragma mark - Getters and Setters

- (AMStyleLayer *)styleLayer {
    return (id)self.layer;
}

#pragma mark - Public

- (void)cleanup {
    [super cleanup];
    self.styleLayer.layerDescriptors = nil;
}

#pragma mark - Layout

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
}

@end
