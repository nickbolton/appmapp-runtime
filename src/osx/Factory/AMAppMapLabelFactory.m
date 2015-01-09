//
//  AMAppMapLabelFactory.m
//  AppMap
//
//  Created by Nick Bolton on 1/4/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMAppMapLabelFactory.h"
#import "AMRuntimeTextField.h"

@implementation AMAppMapLabelFactory

- (NSString *)viewClass {
    return NSStringFromClass([AMRuntimeTextField class]);
}

@end
