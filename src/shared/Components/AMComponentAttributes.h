//
//  AMComponentAttributes.h
//  AppMap
//
//  Created by Nick Bolton on 12/7/15.
//  Copyright © 2015 Pixelbleed LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AMComponentAttributes : NSObject


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryRepresentation;

@end
