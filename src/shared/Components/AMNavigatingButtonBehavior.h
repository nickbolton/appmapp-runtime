//
//  AMNavigatingButtonBehavior.h
//  AppMap
//
//  Created by Nick Bolton on 5/31/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMButtonBehavior.h"

typedef NS_ENUM(NSInteger, AMNavigationType) {
    AMNavigationTypePresent = 0,
    AMNavigationTypeDismiss,
    AMNavigationTypePush,
    AMNavigationTypePop,
};

@interface AMNavigatingButtonBehavior : AMButtonBehavior

@property (nonatomic) AMNavigationType navigationType;

@end
