//
//  AMViewMachineTemplate.m
//  amgen
//
//  Created by Nick Bolton on 5/28/15.
//  Copyright (c) 2015 Pixelbleed. All rights reserved.
//

#import "AMViewMachineTemplate.h"

@implementation AMViewMachineTemplate

- (NSString *)interfaceContents {
    
    return @"// DO NOT EDIT. This file is machine-generated and constantly overwritten.\n\
// Make changes to VIEW_NAME.h instead.\n\
FRAMEWORK_IMPORT\n\
#import \"AMRuntimeView.h\"\n\
CLASS_IMPORTS\n\
@interface _VIEW_NAME : AMRuntimeView\n\
\n\
MACHINE_PROPERTIES\n\
@end\n\
";
}

- (NSString *)implementationContents {
    
    return @"// DO NOT EDIT. This file is machine-generated and constantly overwritten.\n\
// Make changes to VIEW_NAME.m instead.\n\
\n\
#import \"_VIEW_NAME.h\"\n\
#import \"AMAppMap.h\"\n\
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

@end
