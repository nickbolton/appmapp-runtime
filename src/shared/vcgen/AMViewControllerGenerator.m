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
#import "AMViewControllerHumanTemplate.h"
#import "AMViewControllerMachineTemplate.h"
#import "NSString+NameUtilities.h"

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
        return [classPrefix stringByAppendingString:name.properName];
    }
    return name.properName;
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
        
        NSError *error = nil;
        
        AMViewControllerHumanTemplate *templateObject = [AMViewControllerHumanTemplate new];
        NSString *template =
        interface ? templateObject.interfaceContents : templateObject.implementationContents;

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
    
    NSError *error = nil;
    
    AMViewControllerMachineTemplate *templateObject = [AMViewControllerMachineTemplate new];
    NSString *template =
    interface ? templateObject.interfaceContents : templateObject.implementationContents;
    
    NSString *frameworkImport =
    ios ? kAMIOSFrameworkImport : kAMOSXFrameworkImport;
    
    NSString *humanViewName =
    [self buildViewName:component classPrefix:classPrefix];
    
    template =
    [template
     stringByReplacingOccurrencesOfString:kAMViewControllerNameToken
     withString:viewControllerName];
        
    template =
    [template stringByReplacingOccurrencesOfString:kAMViewNameToken withString:humanViewName];
    
    template =
    [template
     stringByReplacingOccurrencesOfString:kAMViewControllerBaseClassToken
     withString:viewControllerBaseClass];

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

@end
