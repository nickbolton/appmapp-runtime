//
//  AMImageAsset.m
//  Prototype
//
//  Created by Nick Bolton on 8/8/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import "AMImageAsset.h"

static NSString * const kAMImageAssetNameKey = @"name";
static NSString * const kAMImageAssetScaleKey = @"scale";
static NSString * const kAMImageAssetDataKey = @"imageData";

@interface AMImageAsset()

#if TARGET_OS_IPHONE
@property (nonatomic, readwrite) UIImage *image;
#else
@property (nonatomic, readwrite) NSImage *image;
#endif
@property (nonatomic, readwrite) NSString *name;
@property (nonatomic, readwrite) CGFloat scale;

@end

@implementation AMImageAsset

- (void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeObject:self.name forKey:kAMImageAssetNameKey];
    [coder encodeFloat:self.scale forKey:kAMImageAssetScaleKey];
    [coder encodeObject:self.image.pngData forKey:kAMImageAssetDataKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    
    if (self != nil) {
        self.name = [decoder decodeObjectForKey:kAMImageAssetNameKey];
        self.scale = [decoder decodeFloatForKey:kAMImageAssetScaleKey];
        NSData *imageData = [decoder decodeObjectForKey:kAMImageAssetDataKey];
        self.image = [[UIImage alloc] initWithData:imageData];
    }
    
    return self;
}

#if TARGET_OS_IPHONE
- (instancetype)initWithName:(NSString *)name
                       image:(UIImage *)image
                       scale:(CGFloat)scale {
#else
- (instancetype)initWithName:(NSString *)name
                       image:(NSImage *)image
                       scale:(CGFloat)scale {
#endif

    self = [super init];
    
    if (self != nil) {
        self.name = name;
        self.image = image;
        self.scale = scale;
    }
    
    return self;
}

- (id)copy {

    return
    [[AMImageAsset alloc]
     initWithName:self.name.copy
     image:self.image.copy
     scale:self.scale];
}

- (BOOL)isEqualToImageAsset:(AMImageAsset *)object {
    
    return
    [self.name isEqualToString:object.name] &&
    self.scale == object.scale &&
    [self.image isEqualToImage:object.image];
}

@end
