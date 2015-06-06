//
//  AMImageAsset.h
//  Prototype
//
//  Created by Nick Bolton on 8/8/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMImageAsset : NSObject <NSCoding>

#if TARGET_OS_IPHONE
@property (nonatomic, readonly) UIImage *image;
#else
@property (nonatomic, readonly) NSImage *image;
#endif

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) CGFloat scale;

#if TARGET_OS_IPHONE
- (instancetype)initWithName:(NSString *)name
                       image:(UIImage *)image
                       scale:(CGFloat)scale;
#else
- (instancetype)initWithName:(NSString *)name
                       image:(NSImage *)image
                       scale:(CGFloat)scale;
#endif

- (BOOL)isEqualToImageAsset:(AMImageAsset *)object;

@end
