//
//  AMViewHumanTemplate.m
//  amgen
//
//  Created by Nick Bolton on 5/28/15.
//  Copyright (c) 2015 Pixelbleed. All rights reserved.
//

#import "AMViewHumanTemplate.h"

@implementation AMViewHumanTemplate

- (NSString *)interfaceContents:(BOOL)ios {
    
    return @"#import \"_VIEW_NAME.h\"\n\
\n\
@interface VIEW_NAME : _VIEW_NAME\n\
// Custom interface goes here.\n\
@end\n\
";
}

- (NSString *)implementationContents:(BOOL)ios {
    
    return @"#import \"VIEW_NAME.h\"\n\
\n\
@interface VIEW_NAME ()\n\
// Private interface goes here.\n\
@end\n\
\n\
@implementation VIEW_NAME\n\
// Custom logic goes here.\n\
@end\n\
";
}

@end
