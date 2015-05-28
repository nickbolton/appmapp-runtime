//
//  AMViewControllerMachineTemplate.m
//  amgen
//
//  Created by Nick Bolton on 5/28/15.
//  Copyright (c) 2015 Pixelbleed. All rights reserved.
//

#import "AMViewControllerMachineTemplate.h"

@implementation AMViewControllerMachineTemplate

- (NSString *)interfaceContents {
    
    return @"// DO NOT EDIT. This file is machine-generated and constantly overwritten.\n\
// Make changes to VIEW_CONTROLLER_NAME.h instead.\n\
FRAMEWORK_IMPORT\n\
CLASS_IMPORTS\n\
@interface _VIEW_CONTROLLER_NAME : VIEW_CONTROLLER_BASE_CLASS\n\
\n\
MACHINE_PROPERTIES\n\
@end\n\
";
}

- (NSString *)implementationContents {
    
    return @"// DO NOT EDIT. This file is machine-generated and constantly overwritten.\n\
// Make changes to VIEW_CONTROLLER_NAME.m instead.\n\
\n\
#import \"_VIEW_CONTROLLER_NAME.h\"\n\
#import \"AMAppMap.h\"\n\
#import \"AMLayouts.h\"\n\
\n\
@interface _VIEW_CONTROLLER_NAME ()\n\
\n\
@property (nonatomic, strong) AMComponent *component;\n\
MACHINE_PROPERTIES\n\
@end\n\
\n\
@implementation _VIEW_CONTROLLER_NAME\n\
\n\
#pragma mark - Setup\n\
\n\
- (void)_setupComponent {\n\
\n\
    NSDictionary *componentDict =\n\
    COMPONENT_DICTIONARY;\n\
\n\
    self.component = [AMComponent componentWithDictionary:componentDict];\n\
}\n\
\n\
- (void)_setupRootView {\n\
\n\
    [[AMAppMap sharedInstance]\n\
     buildViewFromComponent:self.component\n\
     inContainer:self.view\n\
     bindingObject:self];\n\
}\n\
\n\
#pragma mark - View Controller Lifecycle\n\
\n\
- (void)viewDidLoad {\n\
    [super viewDidLoad];\n\
    [self _setupComponent];\n\
    [self _setupRootView];\n\
}\n\
@end\n\
";
}

@end
