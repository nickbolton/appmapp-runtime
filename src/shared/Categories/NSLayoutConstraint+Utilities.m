//
//  NSLayoutConstraint+Utilities.m
//  AppMap
//
//  Created by Nick Bolton on 4/5/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "NSLayoutConstraint+Utilities.h"

@implementation NSLayoutConstraint (Utilities)

#if TARGET_OS_IPHONE

- (id)animator {
    return self;
}
#endif

@end
