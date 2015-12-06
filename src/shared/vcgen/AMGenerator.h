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
extern NSString * const kAMClassDeclarationsToken;
extern NSString * const kAMClassImportsToken;
extern NSString * const kAMFrameworkImportToken;
extern NSString * const kAMViewNameToken;
extern NSString * const kAMViewBaseClassToken;

@class AMComponentInstance;

@interface AMGenerator : NSObject

- (void)generateComponentManagerWithComponentsDictionary:(NSDictionary *)componentsDictionary
                                         targetDirectory:(NSURL *)targetDirectory
                                                     ios:(BOOL)ios
                                             classPrefix:(NSString *)classPrefix
                                      baseViewClassNames:(NSDictionary *)baseViewClassNames;

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

- (NSString *)buildViewName:(AMComponentInstance *)component
                classPrefix:(NSString *)classPrefix;

- (NSString *)buildViewControllerName:(NSString *)name
                          classPrefix:(NSString *)classPrefix;

- (NSString *)buildBaseViewNameForComponentType:(AMComponentType)componentType
                             baseViewClassNames:(NSDictionary *)baseViewClassNames
                                            ios:(BOOL)ios;

- (NSString *)buildRootViewName:(AMComponentInstance *)component;

- (NSString *)buildMachineProperties:(AMComponentInstance *)component
                                 ios:(BOOL)ios
                           interface:(BOOL)interface
                       viewBaseClass:(NSString *)viewBaseClass
                         classPrefix:(NSString *)classPrefix
                  baseViewClassNames:(NSDictionary *)baseViewClassNames;

- (NSString *)buildMachineProperty:(AMComponentInstance *)childComponent
                               ios:(BOOL)ios
                         interface:(BOOL)interface
                     viewBaseClass:(NSString *)viewBaseClass
                       classPrefix:(NSString *)classPrefix
                baseViewClassNames:(NSDictionary *)baseViewClassNames;

- (NSString *)buildClassDeclarations:(NSArray *)components
                                 ios:(BOOL)ios
                         classPrefix:(NSString *)classPrefix
                  baseViewClassNames:(NSDictionary *)baseViewClassNames;

- (NSString *)buildClassDeclaration:(AMComponentInstance *)component
                                ios:(BOOL)ios
                        classPrefix:(NSString *)classPrefix
                 baseViewClassNames:(NSDictionary *)baseViewClassNames;

- (NSString *)buildClassImports:(NSArray *)components
                            ios:(BOOL)ios
                    classPrefix:(NSString *)classPrefix
             baseViewClassNames:(NSDictionary *)baseViewClassNames;

- (NSString *)buildClassImport:(AMComponentInstance *)component
                           ios:(BOOL)ios
                   classPrefix:(NSString *)classPrefix
            baseViewClassNames:(NSDictionary *)baseViewClassNames;

@end
