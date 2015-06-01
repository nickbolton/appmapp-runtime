//
//  AMViewMachineTemplate.h
//  amgen
//
//  Created by Nick Bolton on 5/28/15.
//  Copyright (c) 2015 Pixelbleed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMTemplateProtocol.h"

@interface AMViewMachineTemplate : NSObject<AMTemplateProtocol>

- (NSString *)rootImplementationContents:(BOOL)ios;

@end
