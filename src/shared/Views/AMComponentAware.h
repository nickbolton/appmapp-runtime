//
//  AMComponentAware.h
//  AppMap
//
//  Created by Nick Bolton on 12/20/15.
//  Copyright © 2015 Pixelbleed LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMComponent;

@protocol AMComponentAware <NSObject>

- (AMComponent *)component;
- (void)setComponent:(AMComponent *)component;

@end
