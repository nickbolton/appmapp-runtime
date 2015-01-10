//
//  AMViewControllerGenerator.h
//  AppMap
//
//  Created by Nick Bolton on 1/9/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMViewControllerGenerator : NSObject

- (void)generateViewControllersWithComponentsDictionary:(NSDictionary *)componentDictionary
                                        targetDirectory:(NSURL *)targetDirectory
                                                    ios:(BOOL)ios
                                            classPrefix:(NSString *)classPrefix
                            baseViewControllerClassName:(NSString *)baseViewControllerClassName;

@end
