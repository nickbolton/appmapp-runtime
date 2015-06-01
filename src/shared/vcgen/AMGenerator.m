//
//  AMGenerator.m
//  AppMap
//
//  Created by Nick Bolton on 1/10/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMGenerator.h"
#import "AMViewGenerator.h"
#import "AMComponent.h"
#import "AMExpandingLayout.h"
#import "NSString+NameUtilities.h"
#import "AMComponentManagerTemplate.h"

NSString * const kAMOSXFrameworkImport = @"#import <Cocoa/Cocoa.h>";
NSString * const kAMIOSFrameworkImport = @"#import <UIKit/UIKit.h>";
NSString * const kAMComponentDictionaryToken = @"COMPONENT_DICTIONARY";
NSString * const kAMMachinePropertiesToken = @"MACHINE_PROPERTIES";
NSString * const kAMFrameworkImportToken = @"FRAMEWORK_IMPORT";
NSString * const kAMClassImportsToken = @"CLASS_IMPORTS";
NSString * const kAMViewNameToken = @"VIEW_NAME";
NSString * const kAMViewBaseClassToken = @"VIEW_BASE_CLASS";
NSString * const kAMComponentManagerClassName = @"AMComponentManager";

@implementation AMGenerator

#pragma mark - Public

- (void)generateClassesWithComponentsDictionary:(NSDictionary *)componentsDictionary
                                targetDirectory:(NSURL *)targetDirectory
                                            ios:(BOOL)ios
                                    classPrefix:(NSString *)classPrefix
                    baseViewControllerClassName:(NSString *)baseViewControllerClassName
                             baseViewClassNames:(NSDictionary *)baseViewClassNames {

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
    
    AMExpandingLayout *expandingLayout = [AMExpandingLayout new];
    
    [componentsArray enumerateObjectsUsingBlock:^(NSDictionary *componentDict, NSUInteger idx, BOOL *stop) {
        
        // replace the top level components with an expanding layout
        
        NSMutableDictionary *mutableDict = componentDict.mutableCopy;
        mutableDict[@"layoutObjects"] = @[[expandingLayout exportLayout]];
        
        BOOL result =
        [self
         buildClass:mutableDict
         targetDirectory:targetDirectory
         ios:ios
         classPrefix:classPrefix
         baseViewControllerClassName:baseViewControllerClassName
         baseViewClassNames:baseViewClassNames];
        
        *stop = (result == NO);
    }];
}

- (void)generateComponentManagerWithComponentsDictionary:(NSDictionary *)componentsDictionary
                                         targetDirectory:(NSURL *)targetDirectory
                                                     ios:(BOOL)ios
                                             classPrefix:(NSString *)classPrefix {

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

    [self
     buildComponentManagerInterface:componentsArray
     targetDirectory:targetDirectory
     ios:ios];
    
    [self
     buildComponentManagerImplementation:componentsArray
     targetDirectory:targetDirectory
     classPrefix:classPrefix
     ios:ios];
}

- (void)buildComponentManagerInterface:(NSArray *)components
                       targetDirectory:(NSURL *)targetDirectory
                                   ios:(BOOL)ios {

    NSURL *url = [targetDirectory URLByAppendingPathComponent:kAMComponentManagerClassName];
    url = [url URLByAppendingPathExtension:@"h"];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:url.path]) {
        
        NSError *error = nil;
        [fm removeItemAtURL:url error:&error];
        
        if (error != nil) {
            
            NSLog(@"Error occurred removing file '%@': %@",
                  url.path, error);
        }
    }
    
    NSError *error = nil;
    
    AMComponentManagerTemplate *templateObject = [AMComponentManagerTemplate new];
    NSString *template = [templateObject interfaceContents:ios];
    
    [template
     writeToURL:url
     atomically:YES
     encoding:NSUTF8StringEncoding
     error:&error];
    
    if (error != nil) {
        
        NSLog(@"Error writing human '%@': %@",
              url.path, error);
    }
}

- (void)buildComponentManagerImplementation:(NSArray *)components
                            targetDirectory:(NSURL *)targetDirectory
                                classPrefix:(NSString *)classPrefix
                                        ios:(BOOL)ios {

    static NSString * const componentRootViewKey = @"TOP_LEVEL_COMPONENT_TO_ROOT_VIEW_DICTIONARY";
    static NSString * const componentViewControllerKey = @"COMPONENT_TO_VIEW_CONTROLLER_DICTIONARY";
    
    NSMutableString *componentRootViews = [NSMutableString string];
    [componentRootViews appendString:@"@{"];
    
    for (NSDictionary *componentDict in components) {
        
        AMComponent *component =
        [AMComponent componentWithDictionary:componentDict];
        
        NSString *viewName = [self buildViewName:component classPrefix:classPrefix];

        [componentRootViews appendFormat:@"@\"%@\" : @\"%@\", ", component.identifier, viewName];
    }
    
    [componentRootViews appendString:@"}"];

    NSMutableString *componentViewControllers = [NSMutableString string];
    [componentViewControllers appendString:@"@{"];
    
    for (NSDictionary *componentDict in components) {
        
        AMComponent *component =
        [AMComponent componentWithDictionary:componentDict];
        
        NSString *viewControllerName = [self buildViewControllerName:component.exportedName classPrefix:classPrefix];
        
        NSString *viewControllerClassName =
        [NSString stringWithFormat:@"%@ViewController", viewControllerName];
        
        [componentViewControllers appendFormat:@"@\"%@\" : @\"%@\", ", component.identifier, viewControllerClassName];
    }
    
    [componentViewControllers appendString:@"}"];
    
    NSURL *url = [targetDirectory URLByAppendingPathComponent:kAMComponentManagerClassName];
    url = [url URLByAppendingPathExtension:@"m"];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:url.path]) {
        
        NSError *error = nil;
        [fm removeItemAtURL:url error:&error];
        
        if (error != nil) {
            
            NSLog(@"Error occurred removing file '%@': %@",
                  url.path, error);
        }
    }
    
    NSError *error = nil;
    
    AMComponentManagerTemplate *templateObject = [AMComponentManagerTemplate new];
    NSString *template = [templateObject implementationContents:ios];
    
    template =
    [template
     stringByReplacingOccurrencesOfString:componentRootViewKey
     withString:componentRootViews];

    template =
    [template
     stringByReplacingOccurrencesOfString:componentViewControllerKey
     withString:componentViewControllers];

    [template
     writeToURL:url
     atomically:YES
     encoding:NSUTF8StringEncoding
     error:&error];
    
    if (error != nil) {
        
        NSLog(@"Error writing human '%@': %@",
              url.path, error);
    }
}

- (BOOL)buildClass:(NSDictionary *)componentDict
   targetDirectory:(NSURL *)targetDirectory
               ios:(BOOL)ios
       classPrefix:(NSString *)classPrefix
baseViewControllerClassName:(NSString *)baseViewControllerClassName
baseViewClassNames:(NSDictionary *)baseViewClassNames {
    [self doesNotRecognizeSelector:_cmd];
    return NO;
}

- (NSString *)buildBaseViewNameForComponentType:(AMComponentType)componentType
                             baseViewClassNames:(NSDictionary *)baseViewClassNames
                                            ios:(BOOL)ios {
    
    NSString *name = baseViewClassNames[@(componentType)];
    
    if (name.length > 0) {
        return name;
    }
    
    NSDictionary *defaultClassNameDictionary =
    @{
      @(AMComponentContainer) : @"NSView",
      @(AMComponentButton) : @"NSButton",
      };
    
    if (ios) {
        
        defaultClassNameDictionary =
        @{
          @(AMComponentContainer) : @"UIView",
          @(AMComponentButton) : @"UIButton",
          };
    }
    
    name = defaultClassNameDictionary[@(componentType)];
    
    if (name == nil) {
        name = defaultClassNameDictionary[@(AMComponentContainer)];
    }
    
    return name;
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

- (NSString *)buildRootViewName:(AMComponent *)component {
    
    NSString *name = [component.exportedName stringByAppendingString:@"View"];
    return name;
}

- (NSString *)buildMachineProperty:(AMComponent *)childComponent
                               ios:(BOOL)ios
                         interface:(BOOL)interface
                     viewBaseClass:(NSString *)viewBaseClass
                       classPrefix:(NSString *)classPrefix {
    
    NSString *viewClass = [self buildViewName:childComponent classPrefix:classPrefix];
    NSString *propertyName = [self buildRootViewName:childComponent];
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
        className = [classPrefix stringByAppendingString:component.exportedName.properName];
    } else {
        className = component.exportedName.properName;
    }
    
    return [className stringByAppendingString:suffix];
}

- (NSString *)buildViewControllerName:(NSString *)name
                          classPrefix:(NSString *)classPrefix {
    
    if (classPrefix.length > 0) {
        return [classPrefix stringByAppendingString:name.properName];
    }
    return name.properName;
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
