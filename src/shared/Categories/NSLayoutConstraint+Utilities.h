//
//  NSLayoutConstraint+Utilities.h
//  AppMap
//
//  Created by Nick Bolton on 4/5/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>

@interface NSLayoutConstraint (Utilities)

- (NSLayoutConstraint *)animator;

@end
#endif