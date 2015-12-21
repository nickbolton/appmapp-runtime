//
//  AMViewMachineTemplate.m
//  amgen
//
//  Created by Nick Bolton on 5/28/15.
//  Copyright (c) 2015 Pixelbleed. All rights reserved.
//

#import "AMViewMachineTemplate.h"

@implementation AMViewMachineTemplate

- (NSString *)interfaceContents:(BOOL)ios {
    
    return @"// DO NOT EDIT. This file is machine-generated and constantly overwritten.\n\
// Make changes to VIEW_NAME.h instead.\n\
FRAMEWORK_IMPORT\n\
#import \"BASE_VIEW_CLASS_NAME.h\"\n\
\n\
CLASS_DECLARATIONS\n\
@interface _VIEW_NAME : BASE_VIEW_CLASS_NAME\n\
\n\
MACHINE_PROPERTIES\n\
@end\n\
";
}

- (NSString *)implementationContents:(BOOL)ios {
    
    return @"// DO NOT EDIT. This file is machine-generated and constantly overwritten.\n\
// Make changes to VIEW_NAME.m instead.\n\
\n\
#import \"_VIEW_NAME.h\"\n\
#import \"AMAppMap.h\"\n\
CLASS_IMPORTS\n\
\n\
@interface _VIEW_NAME ()\n\
\n\
MACHINE_PROPERTIES\n\
@end\n\
\n\
@implementation _VIEW_NAME\n\
\n\
#pragma mark - Setup\n\
\n\
#pragma mark - View Controller Lifecycle\n\
\n\
@end\n\
";
}

- (NSString *)rootImplementationContents:(BOOL)ios {
    
    return @"// DO NOT EDIT. This file is machine-generated and constantly overwritten.\n\
// Make changes to VIEW_NAME.m instead.\n\
\n\
#import \"_VIEW_NAME.h\"\n\
#import \"AMAppMap.h\"\n\
CLASS_IMPORTS\n\
\n\
@interface _VIEW_NAME ()\n\
\n\
MACHINE_PROPERTIES\n\
@end\n\
\n\
@implementation _VIEW_NAME\n\
\n\
- (instancetype)init {\n\
    self = [super init];\n\
    if (self) {\n\
        [self _setupComponent];\n\
    }\n\
    return self;\n\
}\n\
\n\
#pragma mark - Setup\n\
- (void)_setupComponent {\n\
\n\
    NSDictionary *componentDict =\n\
    COMPONENT_DICTIONARY;\n\
\n\
    self.component = [AMComponent componentWithDictionary:componentDict];\n\
\n\
    for (AMComponent *childComponent in self.component.childComponents) {\n\
\n\
        [[AMAppMap sharedInstance]\n\
         buildViewFromComponent:childComponent\n\
         inContainer:self\n\
         layoutProvider:self\n\
         bindingObject:self];\n\
    }\n\
\n\
}\n\
\n\
#pragma mark - View Controller Lifecycle\n\
\n\
@end\n\
";
}

@end
