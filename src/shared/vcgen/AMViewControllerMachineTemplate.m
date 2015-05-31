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
#import \"AMComponentManager.h\"\n\
#import \"AMRuntimeView.h\"\n\
\n\
@interface _VIEW_CONTROLLER_NAME ()<AMRuntimeDelegate>\n\
\n\
MACHINE_PROPERTIES\n\
@end\n\
\n\
@implementation _VIEW_CONTROLLER_NAME\n\
\n\
#pragma mark - Setup\n\
\n\
#pragma mark - View Controller Lifecycle\n\
\n\
- (void)loadView {\n\
    self.ROOT_VIEW_NAME = [VIEW_NAME new];\n\
    self.view = self.ROOT_VIEW_NAME;\n\
}\n\
\n\
- (void)viewDidLoad {\n\
    [super viewDidLoad];\n\
}\n\
\n\
#pragma mark - AMRuntimeDelegate Conformance\n\
\n\
- (void)navigateToComponent:(AMComponent *)component\n\
navigationType:(AMNavigationType)navigationType {\n\
\n\
    Class viewControllerClass =\n\
    [[AMComponentManager sharedInstance]\n\
     viewControllerClassForComponent:component];\n\
\n\
    if (viewControllerClass != Nil) {\n\
\n\
        UIViewController *viewController = [viewControllerClass new];\n\
\n\
        switch (navigationType) {\n\
\n\
            case AMNavigationTypePush:\n\
\n\
                [self.navigationController\n\
                 pushViewController:viewController\n\
                 animated:YES];\n\
\n\
                break;\n\
\n\
            case AMNavigationTypePresent:\n\
\n\
                [self presentViewController:viewController animated:YES completion:nil];\n\
\n\
                break;\n\
\n\
            default:\n\
                break;\n\
        }\n\
    }\n\
}\n\
@end\n\
";
}

@end
