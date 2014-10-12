//
//  AMAppMap.h
//  AppMap
//
//  Created by Nick Bolton on 10/12/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMDataSource;
@class AMView;
@class AMComponent;

@interface AMAppMap : NSObject

- (AMView *)viewWithIdentifier:(NSString *)identifier
                    dataSource:(AMDataSource *)dataSource;
- (AMView *)viewWithIdentifier:(NSString *)identifier
                    dataSource:(AMDataSource *)dataSource
                 baseViewClass:(Class)baseViewClass;

- (AMView *)viewWithComponent:(AMComponent *)component;
- (AMView *)viewWithComponent:(AMComponent *)component baseViewClass:(Class)baseViewClass;

@end
