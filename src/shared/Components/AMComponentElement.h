//
//  AMComponentElement.h
//  AppMapTest
//
//  Created by Nick Bolton on 8/1/14.
//  Copyright (c) 2014 Nick Bolton. All rights reserved.
//

extern NSString * const kAMComponentClassNameKey;
extern NSString * const kAMComponentsKey;

extern NSString * kAMComponentIdentifierKey;

@interface AMComponentElement : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic) AMComponentType componentType;

@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic) CGFloat borderWidth;

@property (nonatomic, getter=isClipped) BOOL clipped;
@property (nonatomic) CGFloat alpha;
@property (nonatomic, readonly) BOOL isContainer;

@property (nonatomic, strong) AMColor *borderColor;
@property (nonatomic, strong) AMColor *backgroundColor;


- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)componentWithDictionary:(NSDictionary *)dict;
+ (NSDictionary *)exportComponents:(NSArray *)components;

- (BOOL)isEqualToComponent:(AMComponentElement *)object;

- (NSDictionary *)exportComponent;

@end
