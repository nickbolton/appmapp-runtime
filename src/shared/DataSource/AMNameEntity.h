//
//  AMNameEntity.h
//  AppMap
//
//  Created by Nick Bolton on 10/16/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMNameEntity : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSDate *lastUsed;

- (instancetype)initWithName:(NSString *)name
                    lastUsed:(NSDate *)lastUsed;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)exportNameEntity;

@end
