//
//  AMGenerator.h
//  AppMap
//
//  Created by Nick Bolton on 1/10/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kAMOSXFrameworkImport;
extern NSString * const kAMIOSFrameworkImport;
extern NSString * const kAMComponentDictionaryToken;
extern NSString * const kAMMachinePropertiesToken;
extern NSString * const kAMClassImportsToken;
extern NSString * const kAMFrameworkImportToken;
extern NSString * const kAMOSXBaseViewClassName;
extern NSString * const kAMIOSBaseViewClassName;

@class AMComponent;

@interface AMGenerator : NSObject

- (void)generateClassesWithComponentsDictionary:(NSDictionary *)componentsDictionary
                                targetDirectory:(NSURL *)targetDirectory
                                            ios:(BOOL)ios
                                    classPrefix:(NSString *)classPrefix
                    baseViewControllerClassName:(NSString *)baseViewControllerClassName
                              baseViewClassName:(NSString *)baseViewClassName;

- (BOOL)buildClass:(NSDictionary *)componentDict
   targetDirectory:(NSURL *)targetDirectory
               ios:(BOOL)ios
       classPrefix:(NSString *)classPrefix
baseViewControllerClassName:(NSString *)baseViewControllerClassName
 baseViewClassName:(NSString *)baseViewClassName;

- (NSString *)buildViewName:(AMComponent *)component
                classPrefix:(NSString *)classPrefix;

- (NSString *)buildMachineProperties:(AMComponent *)component
                                 ios:(BOOL)ios
                           interface:(BOOL)interface
                       viewBaseClass:(NSString *)viewBaseClass
                         classPrefix:(NSString *)classPrefix;

- (NSString *)buildMachineProperty:(AMComponent *)childComponent
                               ios:(BOOL)ios
                         interface:(BOOL)interface
                     viewBaseClass:(NSString *)viewBaseClass
                       classPrefix:(NSString *)classPrefix;

- (NSString *)buildClassImports:(NSArray *)components
                    classPrefix:(NSString *)classPrefix;

- (NSString *)buildClassImport:(AMComponent *)component
                   classPrefix:(NSString *)classPrefix;

@end
