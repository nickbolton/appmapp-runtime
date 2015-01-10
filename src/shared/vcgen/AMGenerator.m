//
//  AMGenerator.m
//  AppMap
//
//  Created by Nick Bolton on 1/10/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMGenerator.h"
#import "AMAppMap.h"
#import "AMViewGenerator.h"

NSString * const kAMOSXFrameworkImport = @"#import <Cocoa/Cocoa.h>";
NSString * const kAMIOSFrameworkImport = @"#import <UIKit/UIKit.h>";
NSString * const kAMComponentDictionaryToken = @"COMPONENT_DICTIONARY";
NSString * const kAMMachinePropertiesToken = @"MACHINE_PROPERTIES";
NSString * const kAMFrameworkImportToken = @"FRAMEWORK_IMPORT";
NSString * const kAMClassImportsToken = @"CLASS_IMPORTS";
NSString * const kAMOSXBaseViewClassName = @"NSView";
NSString * const kAMIOSBaseViewClassName = @"UIView";

@implementation AMGenerator

#pragma mark - Public

- (void)generateClassesWithComponentsDictionary:(NSDictionary *)componentsDictionary
                                targetDirectory:(NSURL *)targetDirectory
                                            ios:(BOOL)ios
                                    classPrefix:(NSString *)classPrefix
                    baseViewControllerClassName:(NSString *)baseViewControllerClassName
                              baseViewClassName:(NSString *)baseViewClassName {

    id components = componentsDictionary[kAMComponentsKey];
    NSArray *componentsArray = components;
    
    if ([components isKindOfClass:[NSArray class]]) {
        componentsArray = components;
    } else if ([components isKindOfClass:[NSDictionary class]]) {
        componentsArray = ((NSDictionary *)components).allValues;
    } else {
        NSLog(@"couldn't find components array in components dictionary");
        return;
    }
    
    [componentsArray enumerateObjectsUsingBlock:^(NSDictionary *componentDict, NSUInteger idx, BOOL *stop) {
        
        BOOL result =
        [self
         buildClass:componentDict
         targetDirectory:targetDirectory
         ios:ios
         classPrefix:classPrefix
         baseViewControllerClassName:baseViewControllerClassName
         baseViewClassName:baseViewClassName];
        
        *stop = (result == NO);
    }];
}

- (BOOL)buildClass:(NSDictionary *)componentDict
   targetDirectory:(NSURL *)targetDirectory
               ios:(BOOL)ios
       classPrefix:(NSString *)classPrefix
baseViewControllerClassName:(NSString *)baseViewControllerClassName
 baseViewClassName:(NSString *)baseViewClassName {
    [self doesNotRecognizeSelector:_cmd];
    return NO;
}

- (NSString *)buildMachineProperties:(AMComponent *)component
                                 ios:(BOOL)ios
                           interface:(BOOL)interface
                       viewBaseClass:(NSString *)viewBaseClass
                         classPrefix:(NSString *)classPrefix {
    
    NSMutableString *result = [NSMutableString string];
    
    [component.childComponents enumerateObjectsUsingBlock:^(AMComponent *childComponent, NSUInteger idx, BOOL *stop) {
        
        NSString *propertyString =
        [self
         buildMachineProperty:childComponent
         ios:ios
         interface:interface
         viewBaseClass:viewBaseClass
         classPrefix:classPrefix];
        
        [result appendString:propertyString];
        [result appendString:@"\n"];
    }];
    
    return  result;
}

- (NSString *)buildMachineProperty:(AMComponent *)childComponent
                               ios:(BOOL)ios
                         interface:(BOOL)interface
                     viewBaseClass:(NSString *)viewBaseClass
                       classPrefix:(NSString *)classPrefix {
    
    NSString *viewClass = [self buildViewName:childComponent classPrefix:classPrefix];
    NSString *propertyName = [childComponent.exportedName stringByAppendingString:@"View"];
    NSString *readQualifier = interface ? @"readonly" : @"readwrite";
    
    return
    [NSString
     stringWithFormat:@"@property (nonatomic, %@) %@ *%@;",
     readQualifier, viewClass, propertyName];
}

- (NSString *)buildViewName:(AMComponent *)component
                classPrefix:(NSString *)classPrefix {
    
    NSString *suffix = @"View";
    NSString *className;

    if (classPrefix.length > 0) {
        className = [classPrefix stringByAppendingString:component.exportedName.capitalizedString];
    } else {
        className = component.exportedName.capitalizedString;
    }
    
    return [className stringByAppendingString:suffix];
}

- (NSString *)buildClassImports:(NSArray *)components
                    classPrefix:(NSString *)classPrefix {
    
    NSMutableString *result = [NSMutableString string];
    
    [components enumerateObjectsUsingBlock:^(AMComponent *childComponent, NSUInteger idx, BOOL *stop) {
        
        [result appendString:[self buildClassImport:childComponent classPrefix:classPrefix]];
    }];
    
    return result;
}

- (NSString *)buildClassImport:(AMComponent *)component
                   classPrefix:(NSString *)classPrefix {
    
    NSString *viewClassName =
    [self buildViewName:component classPrefix:classPrefix];
    
    return
    [NSString stringWithFormat:@"#import \"%@.h\"\n", viewClassName];
}

@end
