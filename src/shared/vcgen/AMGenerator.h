//
//  AMGenerator.h
//  AppMap
//
//  Created by Nick Bolton on 1/10/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppMapComponentTypes.h"

extern NSString * const kAMOSXFrameworkImport;
extern NSString * const kAMIOSFrameworkImport;
extern NSString * const kAMComponentDictionaryToken;
extern NSString * const kAMMachinePropertiesToken;
extern NSString * const kAMClassImportsToken;
extern NSString * const kAMFrameworkImportToken;
extern NSString * const kAMViewNameToken;
extern NSString * const kAMViewBaseClassToken;

@class AMComponent;

@interface AMGenerator : NSObject

- (void)generateComponentManagerWithComponentsDictionary:(NSDictionary *)componentsDictionary
                                         targetDirectory:(NSURL *)targetDirectory
                                                     ios:(BOOL)ios
                                             classPrefix:(NSString *)classPrefix;

- (void)generateClassesWithComponentsDictionary:(NSDictionary *)componentsDictionary
                                targetDirectory:(NSURL *)targetDirectory
                                            ios:(BOOL)ios
                                    classPrefix:(NSString *)classPrefix
                    baseViewControllerClassName:(NSString *)baseViewControllerClassName
                             baseViewClassNames:(NSDictionary *)baseViewClassNames;

- (BOOL)buildClass:(NSDictionary *)componentDict
   targetDirectory:(NSURL *)targetDirectory
               ios:(BOOL)ios
       classPrefix:(NSString *)classPrefix
baseViewControllerClassName:(NSString *)baseViewControllerClassName
baseViewClassNames:(NSDictionary *)baseViewClassNames;

- (NSString *)buildViewName:(AMComponent *)component
                classPrefix:(NSString *)classPrefix;

- (NSString *)buildViewControllerName:(NSString *)name
                          classPrefix:(NSString *)classPrefix;

- (NSString *)buildBaseViewNameForComponentType:(AMComponentType)componentType
                             baseViewClassNames:(NSDictionary *)baseViewClassNames
                                            ios:(BOOL)ios;

- (NSString *)buildRootViewName:(AMComponent *)component;

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
