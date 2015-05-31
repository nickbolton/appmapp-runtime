//
//  AMComponentManagerTemplate.m
//  AppMap
//
//  Created by Nick Bolton on 5/31/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMComponentManagerTemplate.h"

@implementation AMComponentManagerTemplate

- (NSString *)interfaceContents {
    
    return @"// DO NOT EDIT. This file is machine-generated and constantly overwritten.\n\
#import <Foundation/Foundation.h>\n\
\n\
@class AMComponent;\n\
\n\
@interface AMComponentManager : NSObject\n\
\n\
+ (instancetype)sharedInstance;\n\
\n\
- (Class)rootClassForComponent:(AMComponent *)component;\n\
- (Class)viewControllerClassForComponent:(AMComponent *)component;\n\
\n\
@end\n\
";
}

- (NSString *)implementationContents {
    
    return @"// DO NOT EDIT. This file is machine-generated and constantly overwritten.\n\
#import \"AMComponentManager.h\"\n\
#import \"AMComponent.h\"\n\
\n\
@interface AMComponentManager()\n\
\n\
@end\n\
\n\
@implementation AMComponentManager\n\
\n\
#pragma mark - Public\n\
\n\
- (Class)rootClassForComponent:(AMComponent *)component {\n\
\n\
    NSDictionary * const dictionary =\n\
    TOP_LEVEL_COMPONENT_TO_ROOT_VIEW_DICTIONARY;\n\
\n\
    NSString *className = dictionary[component.identifier];\n\
\n\
    if (className != nil) {\n\
        return NSClassFromString(className);\n\
    }\n\
    return Nil;\n\
}\n\
\n\
- (Class)viewControllerClassForComponent:(AMComponent *)component {\n\
\n\
    NSDictionary * const dictionary =\n\
    COMPONENT_TO_VIEW_CONTROLLER_DICTIONARY;\n\
\n\
    NSString *className = dictionary[component.identifier];\n\
\n\
    if (className != nil) {\n\
        return NSClassFromString(className);\n\
    }\n\
    return Nil;\n\
}\n\
\n\
#pragma mark - Singleton Methods\n\
\n\
+ (id)sharedInstance {\n\
\n\
    static dispatch_once_t predicate;\n\
    static AMComponentManager *sharedInstance = nil;\n\
\n\
    dispatch_once(&predicate, ^{\n\
        sharedInstance = [AMComponentManager new];\n\
    });\n\
\n\
    return sharedInstance;\n\
}\n\
\n\
- (id)copyWithZone:(NSZone *)zone {\n\
    return self;\n\
}\n\
\n\
@end\n\
";
}

@end