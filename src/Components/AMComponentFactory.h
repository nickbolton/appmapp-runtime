//
//  AMComponentFactory.h
//  Prototype
//
//  Created by Nick Bolton on 8/13/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//


typedef NS_ENUM(NSInteger, AMComponentType) {
    
    AMComponentContainer = 0,
    AMComponentText,
    AMComponentTextField,
    AMComponentButton,
};

@interface AMComponentFactory : NSObject

+ (instancetype)sharedInstance;

- (AMComponent *)buildComponentWithComponentType:(AMComponentType)componentType;

@end
