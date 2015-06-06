//
//  AMAutocompleteManager.h
//  AppMap
//
//  Created by Nick Bolton on 10/16/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTAutocompleteTextField.h"

@class AMDataSource;

@interface AMAutocompleteManager : NSObject <HTAutocompleteDataSource>

@property (nonatomic, weak) AMDataSource *dataSource;

+ (instancetype)sharedInstance;

@end
