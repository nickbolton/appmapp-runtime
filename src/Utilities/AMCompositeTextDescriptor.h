//
//  AMCompositeTextDescriptor.h
//  AppMap
//
//  Created by Nick Bolton on 1/3/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMTextDescriptor.h"

@interface AMCompositeTextDescriptor : AMTextDescriptor

- (void)addTextDescriptor:(AMTextDescriptor *)textDescriptor;
- (void)removeTextDescriptor:(AMTextDescriptor *)textDescriptor;

@end
