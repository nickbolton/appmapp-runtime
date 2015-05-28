//
//  AMViewControllerGenerator.m
//  AppMap
//
//  Created by Nick Bolton on 1/9/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMViewControllerGenerator.h"
#import "AMViewGenerator.h"
#import "NSString+AMGenerator.h"
#import "AMComponent.h"

static NSString * const kAMViewControllerNameToken = @"VIEW_CONTROLLER_NAME";
static NSString * const kAMViewControllerBaseClassToken = @"VIEW_CONTROLLER_BASE_CLASS";

static NSString * const kAMOSXBaseViewControllerClassName = @"NSViewController";
static NSString * const kAMIOSBaseViewControllerClassName = @"UIViewController";

@implementation AMViewControllerGenerator

- (BOOL)buildClass:(NSDictionary *)componentDict
            targetDirectory:(NSURL *)targetDirectory
                        ios:(BOOL)ios
                classPrefix:(NSString *)classPrefix
baseViewControllerClassName:(NSString *)baseViewControllerClassName
 baseViewClassName:(NSString *)baseViewClassName {

    NSDictionary *viewComponentsDict =
    @{
      kAMComponentsKey : @[componentDict],
      };
    
    AMViewGenerator *viewGenerator = [AMViewGenerator new];
    [viewGenerator
     generateClassesWithComponentsDictionary:viewComponentsDict
     targetDirectory:targetDirectory
     ios:ios
     classPrefix:classPrefix
     baseViewControllerClassName:baseViewControllerClassName
     baseViewClassName:baseViewClassName];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    AMComponent *component =
    [AMComponent componentWithDictionary:componentDict];
    
    NSString *humanViewControllerName =
    [self buildViewControllerName:component.exportedName classPrefix:classPrefix];

    NSString *machineViewControllerName =
    [@"_" stringByAppendingString:humanViewControllerName];
    
    NSString *baseViewControllerName =
    [self buildBaseViewControllerName:baseViewControllerClassName ios:ios];
    
    NSURL *componentDirectoryURL =
    [targetDirectory URLByAppendingPathComponent:component.exportedName];
    
    componentDirectoryURL =
    [componentDirectoryURL URLByAppendingPathComponent:@"ViewControllers"];

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

    NSString *viewSubClassName =
    [self buildViewName:component classPrefix:classPrefix];

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
     viewBaseClass:viewSubClassName
     classPrefix:classPrefix
     componentDictionary:componentDict
     component:component];

    [self
     generateMachineFile:machineImplementationURL
     interface:NO
     ios:ios
     viewControllerName:humanViewControllerClassName
     viewControllerBaseClass:baseViewControllerName
     viewBaseClass:viewSubClassName
     classPrefix:classPrefix
     componentDictionary:componentDict
     component:component];

    return YES;
}

- (NSString *)buildViewControllerName:(NSString *)name
                   classPrefix:(NSString *)classPrefix {

    if (classPrefix.length > 0) {
        return [classPrefix stringByAppendingString:name.capitalizedString];
    }
    return name.capitalizedString;
}

- (NSString *)buildBaseViewControllerName:(NSString *)name
                                      ios:(BOOL)ios {
    if (name.length > 0) {
        return name;
    }
    
    if (ios) {
        return kAMIOSBaseViewControllerClassName;
    }
    
    return kAMOSXBaseViewControllerClassName;
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
              viewBaseClass:(NSString *)viewBaseClass
                classPrefix:(NSString *)classPrefix
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
     withString:[self buildComponentReplacement:componentDictionary indentLevel:1 prefixIndent:0 classPrefix:classPrefix]];
    
    template =
    [template
     stringByReplacingOccurrencesOfString:kAMMachinePropertiesToken
     withString:[self buildMachineProperty:component ios:ios interface:interface viewBaseClass:viewBaseClass classPrefix:classPrefix]];
    
    template =
    [template
     stringByReplacingOccurrencesOfString:kAMFrameworkImportToken
     withString:frameworkImport];

    template =
    [template
     stringByReplacingOccurrencesOfString:kAMClassImportsToken
     withString:[self buildClassImport:component classPrefix:classPrefix]];
    
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

- (NSString *)buildComponentReplacement:(NSDictionary *)dictionary
                            indentLevel:(NSInteger)indentLevel
                           prefixIndent:(NSInteger)prefixIndent
                            classPrefix:(NSString *)classPrefix {
    
    NSMutableString *result = [NSMutableString stringWithString:@""];
    [result appendString:[NSString indentString:prefixIndent]];
    [result appendString:@"@{\n"];
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        
        if ([key isEqualToString:kAMComponentChildComponentsKey] == NO) {
            
            [result appendString:@"    "];
            [result appendString:[NSString indentString:indentLevel]];
            
            NSString *keyToken = [NSString stringToken:key];
            NSString *valueToken;
            
            if ([obj isKindOfClass:[NSString class]]) {
                valueToken = [NSString stringToken:obj];
            } else {
                valueToken = [NSString numberToken:obj];
            }
            
            [result appendString:keyToken];
            [result appendString:@" : "];
            [result appendString:valueToken];
            [result appendString:@",\n"];
        }
    }];
    
    if (classPrefix != nil) {
        
        NSString *classPrefixKeyToken = [NSString stringToken:kAMComponentClassPrefixKey];
        NSString *classPrefixValueToken = [NSString stringToken:classPrefix];
        
        [result appendString:classPrefixKeyToken];
        [result appendString:@" : "];
        [result appendString:classPrefixValueToken];
        [result appendString:@",\n"];
    }
    
    NSDictionary *childComponentsDictionary = dictionary[kAMComponentChildComponentsKey];
    
    NSString *keyToken = [NSString stringToken:kAMComponentChildComponentsKey];
    NSMutableString *childComponents = [NSMutableString stringWithString:@""];
    [childComponents appendString:[NSString indentString:indentLevel+1]];
    [childComponents appendString:keyToken];
    [childComponents appendString:@" : @["];
    
    if (childComponentsDictionary.count > 0) {
        [childComponents appendString:@"\n"];
        [childComponents appendString:[NSString indentString:indentLevel+2]];
    }
    
    NSArray *childComponentsArray = childComponentsDictionary.allValues;
    
    [childComponentsArray enumerateObjectsUsingBlock:^(NSDictionary *childDictionary, NSUInteger idx, BOOL *stop) {
        
        NSInteger prefixIndent = idx > 0 ? indentLevel : 0;
        
        NSString *child =
        [self buildComponentReplacement:childDictionary indentLevel:indentLevel+1 prefixIndent:prefixIndent classPrefix:classPrefix];
        
        [childComponents appendString:child];
        
        [childComponents appendString:@",\n"];
        
        if (idx < (childComponentsArray.count-1)) {
            [childComponents appendString:[NSString indentString:indentLevel+1]];
        }
    }];
    
    if (childComponentsDictionary.count > 0) {
        [childComponents appendString:[NSString indentString:indentLevel+1]];
    }
    
    [childComponents appendString:@"],\n"];
    
    [result appendString:childComponents];
    
    [result appendString:[NSString indentString:indentLevel+1]];
    [result appendString:@"}"];
    
    return result;
}

@end
