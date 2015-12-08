//
//  AMComponentAttributes.h
//  AppMap
//
//  Created by Nick Bolton on 12/7/15.
//  Copyright © 2015 Pixelbleed LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kAMComponentFrameKey;
extern NSString *const kAMComponentLayoutObjectsKey;
extern NSString *const kAMComponentLayoutPresetKey;
extern NSString *const kAMComponentClippedKey;
extern NSString *const kAMComponentBackgroundColorKey;
extern NSString *const kAMComponentBorderWidthKey;
extern NSString *const kAMComponentBorderColorWidthKey;
extern NSString *const kAMComponentAlphaKey;
extern NSString *const kAMComponentCornerRadiusKey;

@interface AMComponentAttributes : NSObject

@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic, getter=isClipped) BOOL clipped;
@property (nonatomic) CGFloat alpha;
@property (nonatomic, strong) AMColor *borderColor;
@property (nonatomic, strong) AMColor *backgroundColor;
@property (nonatomic) CGRect frame;
@property (nonatomic, readonly) BOOL hasProportionalLayout;
@property (nonatomic, strong) NSArray *layoutObjects;
@property (nonatomic) AMLayoutPreset layoutPreset;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryRepresentation;

@end
