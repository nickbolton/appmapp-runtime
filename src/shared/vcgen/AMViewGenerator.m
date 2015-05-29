//
//  AMViewGenerator.m
//  AppMap
//
//  Created by Nick Bolton on 1/10/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMViewGenerator.h"
#import "AMComponent.h"
#import "NSString+AMGenerator.h"
#import "AMViewHumanTemplate.h"
#import "AMViewMachineTemplate.h"

@implementation AMViewGenerator

- (BOOL)buildClass:(NSDictionary *)componentDict
   targetDirectory:(NSURL *)targetDirectory
               ios:(BOOL)ios
       classPrefix:(NSString *)classPrefix
baseViewControllerClassName:(NSString *)baseViewControllerClassName
 baseViewClassName:(NSString *)baseViewClassName {
    
    AMComponent *component =
    [AMComponent componentWithDictionary:componentDict];

    NSDictionary *childComponentsDict = componentDict[kAMComponentChildComponentsKey];
    
    if (childComponentsDict.count > 0) {
        
        NSDictionary *viewComponentsDict =
        @{
          kAMComponentsKey : childComponentsDict,
          };
        
        NSURL *subTargetDirectory =
        [targetDirectory URLByAppendingPathComponent:component.exportedName];
        
        AMViewGenerator *viewGenerator = [AMViewGenerator new];
        [viewGenerator
         generateClassesWithComponentsDictionary:viewComponentsDict
         targetDirectory:subTargetDirectory
         ios:ios
         classPrefix:classPrefix
         baseViewControllerClassName:baseViewControllerClassName
         baseViewClassName:baseViewClassName];
    }

    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSString *humanViewName =
    [self buildViewName:component classPrefix:classPrefix];
    
    NSString *machineViewName =
    [@"_" stringByAppendingString:humanViewName];
    
    NSString *baseViewName =
    [self buildBaseViewName:baseViewClassName ios:ios];

    NSURL *componentDirectoryURL =
    [targetDirectory URLByAppendingPathComponent:component.exportedName];
    
    componentDirectoryURL =
    [componentDirectoryURL URLByAppendingPathComponent:@"Views"];
    
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
    
    NSURL *humanInterfaceURL =
    [componentDirectoryURL URLByAppendingPathComponent:humanViewName];
    humanInterfaceURL = [humanInterfaceURL URLByAppendingPathExtension:@"h"];
    
    NSURL *humanImplementationURL =
    [componentDirectoryURL URLByAppendingPathComponent:humanViewName];
    humanImplementationURL = [humanImplementationURL URLByAppendingPathExtension:@"m"];
    
    NSURL *machineInterfaceURL =
    [componentDirectoryURL URLByAppendingPathComponent:machineViewName];
    machineInterfaceURL = [machineInterfaceURL URLByAppendingPathExtension:@"h"];
    
    NSURL *machineImplementationURL =
    [componentDirectoryURL URLByAppendingPathComponent:machineViewName];
    machineImplementationURL = [machineImplementationURL URLByAppendingPathExtension:@"m"];
    
    [self
     generateHumanFileIfNeeded:humanInterfaceURL
     interface:YES
     viewName:humanViewName];
    
    [self
     generateHumanFileIfNeeded:humanImplementationURL
     interface:NO
     viewName:humanViewName];
    
    [self
     generateMachineFile:machineInterfaceURL
     interface:YES
     ios:ios
     viewName:humanViewName
     viewBaseClass:baseViewName
     classPrefix:classPrefix
     componentDictionary:componentDict
     component:component];
    
    [self
     generateMachineFile:machineImplementationURL
     interface:NO
     ios:ios
     viewName:humanViewName
     viewBaseClass:baseViewName
     classPrefix:classPrefix
     componentDictionary:componentDict
     component:component];
    
    return YES;
}

- (NSString *)buildBaseViewName:(NSString *)name
                            ios:(BOOL)ios {
    if (name.length > 0) {
        return name;
    }
    
    if (ios) {
        return kAMIOSBaseViewClassName;
    }
    
    return kAMOSXBaseViewClassName;
}

- (BOOL)generateHumanFileIfNeeded:(NSURL *)url
                        interface:(BOOL)interface
                         viewName:(NSString *)viewName {
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:url.path] == NO) {
        
        NSError *error = nil;
        
        AMViewHumanTemplate *templateObject = [AMViewHumanTemplate new];
        NSString *template =
        interface ? templateObject.interfaceContents : templateObject.implementationContents;
        
        template =
        [template
         stringByReplacingOccurrencesOfString:kAMViewNameToken
         withString:viewName];
        
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
                   viewName:(NSString *)viewName
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
    
    NSError *error = nil;
    
    AMViewMachineTemplate *templateObject = [AMViewMachineTemplate new];
    NSString *template;
    
    if (interface) {
        template = templateObject.interfaceContents;
    } else if ([componentDictionary[kAMComponentTopLevelComponentKey] boolValue]) {
        template = templateObject.rootImplementationContents;
    } else {
        template = templateObject.implementationContents;
    }
    
    NSString *frameworkImport =
    ios ? kAMIOSFrameworkImport : kAMOSXFrameworkImport;
    
    template =
    [template
     stringByReplacingOccurrencesOfString:kAMViewNameToken
     withString:viewName];
    
    template =
    [template
     stringByReplacingOccurrencesOfString:kAMViewBaseClassToken
     withString:viewBaseClass];
    
    template =
    [template
     stringByReplacingOccurrencesOfString:kAMComponentDictionaryToken
     withString:[self buildComponentReplacement:componentDictionary indentLevel:1 prefixIndent:0 classPrefix:classPrefix]];
    
    NSLog(@"viewName: %@", viewName);
    
    template =
    [template stringByReplacingOccurrencesOfString:kAMViewNameToken withString:viewName];

    template =
    [template
     stringByReplacingOccurrencesOfString:kAMMachinePropertiesToken
     withString:[self buildMachineProperties:component ios:ios interface:interface viewBaseClass:viewBaseClass classPrefix:classPrefix]];
    
    template =
    [template
     stringByReplacingOccurrencesOfString:kAMFrameworkImportToken
     withString:frameworkImport];
    
    template =
    [template
     stringByReplacingOccurrencesOfString:kAMClassImportsToken
     withString:[self buildClassImports:component.childComponents classPrefix:classPrefix]];
    
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
            NSString *valueToken = [NSString literalStringForObject:obj];
            
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
