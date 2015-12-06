//
//  AMViewGenerator.m
//  AppMap
//
//  Created by Nick Bolton on 1/10/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMViewGenerator.h"
#import "AMComponentInstance.h"
#import "NSString+AMGenerator.h"
#import "AMViewHumanTemplate.h"
#import "AMViewMachineTemplate.h"

static NSString * const kAMBaseViewClassNameToken = @"BASE_VIEW_CLASS_NAME";

@implementation AMViewGenerator

- (BOOL)buildClass:(NSDictionary *)componentDict
   targetDirectory:(NSURL *)targetDirectory
               ios:(BOOL)ios
       classPrefix:(NSString *)classPrefix
baseViewControllerClassName:(NSString *)baseViewControllerClassName
baseViewClassNames:(NSDictionary *)baseViewClassNames {
    
    AMComponentInstance *component =
    [AMComponentInstance componentWithDictionary:componentDict];

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
         baseViewClassNames:baseViewClassNames];
    }
    
    if (YES || component.useCustomViewClass) {

        NSFileManager *fm = [NSFileManager defaultManager];
        
        NSString *humanViewName =
        [self buildViewName:component classPrefix:classPrefix];
        
        NSString *machineViewName =
        [@"_" stringByAppendingString:humanViewName];
        
        NSString *baseViewName =
        [self
         buildBaseViewNameForComponentType:component.componentType
         baseViewClassNames:baseViewClassNames
         ios:ios];
        
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
         viewName:humanViewName
         ios:ios];
        
        [self
         generateHumanFileIfNeeded:humanImplementationURL
         interface:NO
         viewName:humanViewName
         ios:ios];
        
        [self
         generateMachineFile:machineInterfaceURL
         interface:YES
         ios:ios
         viewName:humanViewName
         viewBaseClass:baseViewName
         classPrefix:classPrefix
         baseViewClassNames:baseViewClassNames
         componentDictionary:componentDict
         component:component];
        
        [self
         generateMachineFile:machineImplementationURL
         interface:NO
         ios:ios
         viewName:humanViewName
         viewBaseClass:baseViewName
         classPrefix:classPrefix
         baseViewClassNames:baseViewClassNames
         componentDictionary:componentDict
         component:component];
    }
    
    return YES;
}

- (BOOL)generateHumanFileIfNeeded:(NSURL *)url
                        interface:(BOOL)interface
                         viewName:(NSString *)viewName
                              ios:(BOOL)ios {
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:url.path] == NO) {
        
        NSError *error = nil;
        
        AMViewHumanTemplate *templateObject = [AMViewHumanTemplate new];
        NSString *template =
        interface ? [templateObject interfaceContents:ios] : [templateObject implementationContents:ios];
        
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
         baseViewClassNames:(NSDictionary *)baseViewClassNames
        componentDictionary:(NSDictionary *)componentDictionary
                  component:(AMComponentInstance *)component {
    
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
        template = [templateObject interfaceContents:ios];
    } else if ([componentDictionary[kAMComponentTopLevelComponentKey] boolValue]) {
        template = [templateObject rootImplementationContents:ios];
    } else {
        template = [templateObject implementationContents:ios];
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

    template =
    [template
     stringByReplacingOccurrencesOfString:kAMBaseViewClassNameToken
     withString:[self baseViewClassForType:component.componentType]];
    
    template =
    [template stringByReplacingOccurrencesOfString:kAMViewNameToken withString:viewName];

    template =
    [template
     stringByReplacingOccurrencesOfString:kAMMachinePropertiesToken
     withString:[self buildMachineProperties:component ios:ios interface:interface viewBaseClass:viewBaseClass classPrefix:classPrefix baseViewClassNames:baseViewClassNames]];
    
    template =
    [template
     stringByReplacingOccurrencesOfString:kAMFrameworkImportToken
     withString:frameworkImport];
    
    template =
    [template
     stringByReplacingOccurrencesOfString:kAMClassDeclarationsToken
     withString:[self buildClassDeclarations:component.childComponents ios:ios classPrefix:classPrefix baseViewClassNames:baseViewClassNames]];
    
    template =
    [template
     stringByReplacingOccurrencesOfString:kAMClassImportsToken
     withString:[self buildClassImports:component.childComponents ios:ios classPrefix:classPrefix baseViewClassNames:baseViewClassNames]];

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

- (NSString *)baseViewClassForType:(AMComponentType)type {
    
    NSDictionary *dictionary =
    @{
      @(AMComponentContainer) : @"AMRuntimeView",
      @(AMComponentButton) : @"AMRuntimeButton",
      };
    
    NSString *className = dictionary[@(type)];
    
    if (className == nil) {
        className = dictionary[@(AMComponentContainer)];
    }
    return className;
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
