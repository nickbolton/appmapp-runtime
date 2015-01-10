//
//  AMViewControllerGenerator.m
//  AppMap
//
//  Created by Nick Bolton on 1/9/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMViewControllerGenerator.h"
#import "AMAppMap.h"

static NSString * const kAMViewControllerNameToken = @"VIEW_CONTROLLER_NAME";
static NSString * const kAMViewControllerBaseClassToken = @"VIEW_CONTROLLER_BASE_CLASS";
static NSString * const kAMComponentDictionaryToken = @"COMPONENT_DICTIONARY";
static NSString * const kAMMachinePropertiesToken = @"MACHINE_PROPERTIES";
static NSString * const kAMFrameworkImportToken = @"FRAMEWORK_IMPORT";

static NSString * const kAMOSXBaseClassName = @"NSViewController";
static NSString * const kAMOSXViewClassName = @"NSView";
static NSString * const kAMOSXFrameworkImport = @"#import <Cocoa/Cocoa.h>";

static NSString * const kAMIOSBaseClassName = @"UIViewController";
static NSString * const kAMIOSViewClassName = @"UIView";
static NSString * const kAMIOSFrameworkImport = @"#import <UIKit/UIKit.h>";

@implementation AMViewControllerGenerator

- (void)generateViewControllersWithComponentsDictionary:(NSDictionary *)componentsDictionary
                                        targetDirectory:(NSURL *)targetDirectory
                                                    ios:(BOOL)ios
                                            classPrefix:(NSString *)classPrefix
                            baseViewControllerClassName:(NSString *)baseViewControllerClassName {
    
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
         buildViewController:componentDict
         targetDirectory:targetDirectory
         ios:ios
         classPrefix:classPrefix
         baseViewControllerClassName:baseViewControllerClassName];
        
        *stop = (result == NO);
    }];
}

- (BOOL)buildViewController:(NSDictionary *)componentDict
            targetDirectory:(NSURL *)targetDirectory
                        ios:(BOOL)ios
                classPrefix:(NSString *)classPrefix
baseViewControllerClassName:(NSString *)baseViewControllerClassName {

    NSFileManager *fm = [NSFileManager defaultManager];
    
    AMComponent *component =
    [[AMAppMap sharedInstance]
     loadComponentWithDictionary:componentDict];
    
    NSString *humanViewControllerName =
    [self buildViewControllerName:component.exportedName classPrefix:classPrefix];

    NSString *machineViewControllerName =
    [@"_" stringByAppendingString:humanViewControllerName];
    
    NSString *baseViewControllerName =
    [self buildBaseViewControllerName:baseViewControllerClassName ios:ios];
    
    NSURL *componentDirectoryURL =
    [targetDirectory URLByAppendingPathComponent:component.exportedName];
    
    if ([fm fileExistsAtPath:componentDirectoryURL.path] == NO) {
        
        NSError *error = nil;
        
        [fm
         createDirectoryAtURL:componentDirectoryURL
         withIntermediateDirectories:YES
         attributes:nil
         error:&error];
        
        if (error != nil) {
            NSLog(@"Failed to create component directory '%@': %@",
                  componentDirectoryURL.path, error);
            return NO;
        }
    }
    
    NSString *humanViewControllerClassName =
    [NSString stringWithFormat:@"%@ViewController", humanViewControllerName];

    NSString *machineViewControllerClassName =
    [NSString stringWithFormat:@"%@ViewController", machineViewControllerName];
    
    NSURL *humanInterfaceURL =
    [componentDirectoryURL URLByAppendingPathComponent:humanViewControllerClassName];
    humanInterfaceURL = [humanInterfaceURL URLByAppendingPathExtension:@"h"];

    NSURL *humanImplementationURL =
    [componentDirectoryURL URLByAppendingPathComponent:humanViewControllerClassName];
    humanImplementationURL = [humanImplementationURL URLByAppendingPathExtension:@"m"];

    NSURL *machineInterfaceURL =
    [componentDirectoryURL URLByAppendingPathComponent:machineViewControllerClassName];
    machineInterfaceURL = [machineInterfaceURL URLByAppendingPathExtension:@"h"];
    
    NSURL *machineImplementationURL =
    [componentDirectoryURL URLByAppendingPathComponent:machineViewControllerClassName];
    machineImplementationURL = [machineImplementationURL URLByAppendingPathExtension:@"m"];

    [self
     generateHumanFileIfNeeded:humanInterfaceURL
     interface:YES
     viewControllerName:humanViewControllerClassName];

    [self
     generateHumanFileIfNeeded:humanImplementationURL
     interface:NO
     viewControllerName:humanViewControllerClassName];
    
    [self
     generateMachineFile:machineInterfaceURL
     interface:YES
     ios:ios
     viewControllerName:humanViewControllerClassName
     viewControllerBaseClass:baseViewControllerName
     componentDictionary:componentDict
     component:component];

    [self
     generateMachineFile:machineImplementationURL
     interface:NO
     ios:ios
     viewControllerName:humanViewControllerClassName
     viewControllerBaseClass:baseViewControllerName
     componentDictionary:componentDict
     component:component];

    return YES;
}

- (NSString *)buildViewControllerName:(NSString *)name
                   classPrefix:(NSString *)classPrefix {

    if (classPrefix.length > 0) {
        return [classPrefix stringByAppendingString:name];
    }
    return name;
}

- (NSString *)buildBaseViewControllerName:(NSString *)name
                                      ios:(BOOL)ios {
    if (name.length > 0) {
        return name;
    }
    
    if (ios) {
        return kAMIOSBaseClassName;
    }
    
    return kAMOSXBaseClassName;
}

- (BOOL)generateHumanFileIfNeeded:(NSURL *)url
                        interface:(BOOL)interface
           viewControllerName:(NSString *)viewControllerName {

    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:url.path] == NO) {
        
        static NSString * const filename = @"AMViewControllerHumanTemplate";
        
        NSString *suffix = interface ? @"_h" : @"_m";
        
        NSURL *templateURL =
        [[NSBundle mainBundle]
         URLForResource:[filename stringByAppendingString:suffix]
         withExtension:nil];
        
        NSError *error = nil;
        NSString *template =
        [NSString
         stringWithContentsOfURL:templateURL
         encoding:NSUTF8StringEncoding
         error:&error];
        
        if (error != nil) {
            
            NSLog(@"Error reading human template '%@': %@",
                  templateURL.path, error);
            
            return NO;
        }
        
        template =
        [template
         stringByReplacingOccurrencesOfString:kAMViewControllerNameToken
         withString:viewControllerName];
        
        [template
         writeToURL:url
         atomically:YES
         encoding:NSUTF8StringEncoding
         error:&error];
        
        if (error != nil) {
            
            NSLog(@"Error writing human '%@': %@",
                  url.path, error);
            
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)generateMachineFile:(NSURL *)url
                  interface:(BOOL)interface
                        ios:(BOOL)ios
         viewControllerName:(NSString *)viewControllerName
    viewControllerBaseClass:(NSString *)viewControllerBaseClass
        componentDictionary:(NSDictionary *)componentDictionary
                  component:(AMComponent *)component {
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:url.path]) {
        
        NSError *error = nil;
        [fm removeItemAtURL:url error:&error];
        
        if (error != nil) {
            
            NSLog(@"Error occurred removing machine file '%@': %@",
                  url.path, error);
            
            return NO;
        }
    }
    
    static NSString * const filename = @"AMViewControllerMachineTemplate";
    
    NSString *suffix = interface ? @"_h" : @"_m";
    
    NSURL *templateURL =
    [[NSBundle mainBundle]
     URLForResource:[filename stringByAppendingString:suffix]
     withExtension:nil];
    
    NSError *error = nil;
    NSString *template =
    [NSString
     stringWithContentsOfURL:templateURL
     encoding:NSUTF8StringEncoding
     error:&error];
    
    if (error != nil) {
        
        NSLog(@"Error reading machine template '%@': %@",
              templateURL.path, error);
        
        return NO;
    }
    
    NSString *frameworkImport =
    ios ? kAMIOSFrameworkImport : kAMOSXFrameworkImport;
    
    template =
    [template
     stringByReplacingOccurrencesOfString:kAMViewControllerNameToken
     withString:viewControllerName];
    
    template =
    [template
     stringByReplacingOccurrencesOfString:kAMViewControllerBaseClassToken
     withString:viewControllerBaseClass];
    
    template =
    [template
     stringByReplacingOccurrencesOfString:kAMComponentDictionaryToken
     withString:[self buildComponentReplacement:componentDictionary indentLevel:1]];
    
    template =
    [template
     stringByReplacingOccurrencesOfString:kAMMachinePropertiesToken
     withString:[self buildMachineProperties:component ios:ios interface:interface]];
    
    template =
    [template
     stringByReplacingOccurrencesOfString:kAMFrameworkImportToken
     withString:frameworkImport];
    
    [template
     writeToURL:url
     atomically:YES
     encoding:NSUTF8StringEncoding
     error:&error];
    
    if (error != nil) {
        
        NSLog(@"Error writing machine '%@': %@",
              url.path, error);
        
        return NO;
    }

    return YES;
}

- (NSString *)buildMachineProperties:(AMComponent *)component ios:(BOOL)ios interface:(BOOL)interface {

    NSMutableString *result = [NSMutableString string];
    
    [component.childComponents enumerateObjectsUsingBlock:^(AMComponent *childComponent, NSUInteger idx, BOOL *stop) {
        
        NSString *propertyString = [self buildMachineProperty:childComponent ios:ios interface:interface];
        [result appendString:propertyString];
        [result appendString:@"\n"];
    }];
    
    return  result;
}

- (NSString *)buildMachineProperty:(AMComponent *)childComponent ios:(BOOL)ios interface:(BOOL)interface {
    
    NSString *viewClass = ios ? kAMIOSViewClassName : kAMOSXViewClassName;
    NSString *propertyName = childComponent.exportedName;
    NSString *readQualifier = interface ? @"readonly" : @"readwrite";
    
    return
    [NSString
     stringWithFormat:@"@property (nonatomic, %@) %@ *%@;",
     readQualifier, viewClass, propertyName];
}

- (NSString *)buildComponentReplacement:(NSDictionary *)dictionary indentLevel:(NSInteger)indentLevel {
    
    NSMutableString *result = [NSMutableString stringWithString:@"@{\n"];
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        
        if ([key isEqualToString:kAMComponentChildComponentsKey] == NO) {
            
            [result appendString:@"    "];
            [result appendString:[self indentString:indentLevel]];
            
            NSString *keyToken = [self stringToken:key];
            NSString *valueToken;
            
            if ([obj isKindOfClass:[NSString class]]) {
                valueToken = [self stringToken:obj];
            } else {
                valueToken = [NSString stringWithFormat:@"@(%@)", obj];
            }
            
            [result appendString:keyToken];
            [result appendString:@" : "];
            [result appendString:valueToken];
            [result appendString:@",\n"];
        }
    }];
    
    NSDictionary *childComponentsDictionary = dictionary[kAMComponentChildComponentsKey];
    
    NSString *keyToken = [self stringToken:kAMComponentChildComponentsKey];
    NSMutableString *childComponents = [NSMutableString stringWithString:@"    "];
    [childComponents appendString:[self indentString:indentLevel]];
    [childComponents appendString:keyToken];
    [childComponents appendString:@" : @["];
    
    if (childComponentsDictionary.count > 0) {
        [childComponents appendString:@"\n    "];
        [childComponents appendString:[self indentString:indentLevel+1]];
    }
    
    [childComponentsDictionary enumerateKeysAndObjectsUsingBlock:^(id key, NSDictionary *childDictionary, BOOL *stop) {
        
        NSString *child =
        [self buildComponentReplacement:childDictionary indentLevel:indentLevel+1];
        
        [childComponents appendString:child];
        
        [childComponents appendString:@",\n"];
    }];
    
    if (childComponentsDictionary.count > 0) {
        [childComponents appendString:@"    "];
        [childComponents appendString:[self indentString:indentLevel]];
    }
    
    [childComponents appendString:@"],\n"];
    
    [result appendString:childComponents];
    
    [result appendString:@"    "];
    [result appendString:[self indentString:indentLevel-1]];
    [result appendString:@"}"];
    
    return result;
}

- (NSString *)indentString:(NSInteger)level {
    
    NSMutableString *result = [NSMutableString string];
    for (NSInteger i = 0; i < level; i++) {
        [result appendString:@"    "];
    }
    return result;
}

- (NSString *)stringToken:(NSString *)string {
    return [NSString stringWithFormat:@"@\"%@\"", string];
}

@end
