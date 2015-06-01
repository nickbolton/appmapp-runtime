//
//  AMTemplateProtocol.h
//  amgen
//
//  Created by Nick Bolton on 5/28/15.
//  Copyright (c) 2015 Pixelbleed. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AMTemplateProtocol <NSObject>

- (NSString *)interfaceContents:(BOOL)ios;
- (NSString *)implementationContents:(BOOL)ios;

@end
