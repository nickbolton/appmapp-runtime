//
//  NSLayoutConstraint+Utilities.h
//  AppMap
//
//  Created by Nick Bolton on 4/5/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

@interface NSLayoutConstraint (Utilities)

#if TARGET_OS_IPHONE
- (NSLayoutConstraint *)animator;
#endif

@end
