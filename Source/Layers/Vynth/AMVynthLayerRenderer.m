//
//  AMVynthLayerRenderer.m
//  AppMap
//
//  Created by Nick Bolton on 8/26/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import "AMVynthLayerRenderer.h"
#import "AMView.h"
#import "AMRuntimeView.h"
#import "AMVynthLayerDescriptor.h"
#import "AMStyleLayer.h"
#import <Accelerate/Accelerate.h>
#import "NYXImagesKit.h"
#import "GPUImage.h"
#import "AMFadeFilter.h"

#if TARGET_OS_IPHONE == 0
#import "NSBezierPath+Utilities.h"
#endif

@interface AMVynthLayerRenderer()

@property (nonatomic, readonly) AMVynthLayerDescriptor *vynthDescriptor;

@end

@implementation AMVynthLayerRenderer

#pragma mark - Getters and Setters

- (AMVynthLayerDescriptor *)vynthDescriptor {
    return (id)self.descriptor;
}

#pragma mark - Layout

- (void)layoutLayerInRootLayer:(AMStyleLayer *)rootLayer
                      baseView:(AMRuntimeView *)baseView
                      baseRect:(CGRect)baseRect
                         scale:(CGFloat)scale {
    
    scale = 1.0f;
    [super layoutLayerInRootLayer:rootLayer baseView:baseView baseRect:baseRect scale:scale];
    [self layoutLayer:rootLayer baseView:baseView baseRect:baseRect scale:scale];
}

- (void)layoutLayer:(AMStyleLayer *)rootLayer
           baseView:(AMRuntimeView *)baseView
           baseRect:(CGRect)baseRect
              scale:(CGFloat)scale {
    
    scale = 1.0f;
    
    if (self.layer == nil) {
        self.layer = [CALayer layer];
    }
    
    NSLog(@"frame: %@", NSStringFromCGRect(baseRect));
    AMVynthLayerDescriptor *descriptor = self.vynthDescriptor;
    
    CGRect frame = rootLayer.bounds;
    
    UIEdgeInsets insets = descriptor.insets;
    
    CGFloat blurRadiusInset = descriptor.blurRadius * scale;
    
    if (blurRadiusInset > 0.0f) {
        
        if (insets.top >= 0.0f) {
            
            if (descriptor.isBase == NO) {
                insets.top = MAX(insets.top, blurRadiusInset);
            }
            
        } else {
            insets.top += blurRadiusInset;
        }
        
        if (insets.bottom >= 0.0f) {
            
            if (descriptor.isBase == NO) {
                insets.bottom = MAX(insets.bottom, blurRadiusInset);
            }
            
        } else {
            insets.bottom += blurRadiusInset;
        }

        if (insets.left >= 0.0f) {
            
            if (descriptor.isBase == NO) {
                insets.left = MAX(insets.left, blurRadiusInset);
            }
            
        } else {
            insets.left += blurRadiusInset;
        }

        if (insets.right >= 0.0f) {
            
            if (descriptor.isBase == NO) {
                insets.right = MAX(insets.right, blurRadiusInset);
            }
            
        } else {
            insets.right += blurRadiusInset;
        }
    }
    
    frame.origin.x = scale * insets.left;
    frame.origin.y = scale * insets.top;
    
    CGFloat maxX = CGRectGetMaxX(baseRect) - insets.right;
    CGFloat maxY = CGRectGetMaxY(baseRect) - insets.bottom;
    
    frame.size.width = scale * MAX(0.0f, maxX - CGRectGetMinX(frame));
    frame.size.height = scale * MAX(0.0f, maxY - CGRectGetMinY(frame));
    
    if (descriptor.type == AMVynthTypeInverted) {
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:frame];
        CGRect intersection = CGRectIntersection(frame, baseRect);
        
#if TARGET_OS_IPHONE
        [maskPath appendPath:[UIBezierPath bezierPathWithRect:intersection]];
#else
        [maskPath appendBezierPathWithRect:intersection];
#endif
        
        CAShapeLayer *mask = (id)self.layer.mask;
        
        if (mask == nil || [mask isKindOfClass:[CAShapeLayer class]] == NO) {
            mask = [CAShapeLayer layer];
            mask.fillRule = kCAFillRuleEvenOdd;
        }
        
        mask.path = maskPath.CGPath;
        
        self.layer.mask = mask;
    }
    
    self.layer.bounds = frame;
}

- (UIImage *)imageFromLayer:(CALayer *)layer {
    
    UIGraphicsBeginImageContextWithOptions(layer.bounds.size, YES, layer.contentsScale);
    
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return outputImage;
}

#pragma mark - Rendering

- (void)renderInContext:(CGContextRef)context
            inRootLayer:(AMStyleLayer *)rootLayer
               baseView:(AMRuntimeView *)baseView
                  scale:(CGFloat)scale {
    
    AMVynthLayerDescriptor *descriptor = self.vynthDescriptor;
    CGFloat cornerRadius = scale * baseView.layer.cornerRadius;
    
    if (cornerRadius > 0.0f &&
        (descriptor.isClipped == NO ||
         descriptor.isBehind == NO)) {
            
            CGFloat minInset = MIN(scale * descriptor.insets.top, scale * descriptor.insets.bottom);
            minInset = MIN(minInset, scale * descriptor.insets.left);
            minInset = MIN(minInset, scale * descriptor.insets.right);
            cornerRadius -= minInset;
        }

    self.layer.opacity = descriptor.alpha;
    self.layer.cornerRadius = cornerRadius;
    
    UIColor *color = self.vynthDescriptor.color;
    if (color == nil) {
        color = [UIColor clearColor];
    }
    
    if (descriptor.blurRadius <= 0.0f) {
        self.layer.backgroundColor = color.CGColor;
    }

    [self.layer setNeedsDisplay];
    
    if (descriptor.blurRadius > 0.0f) {
        
        CGFloat scaleFactor = 1.0f + (.01f * descriptor.blurRadius);
        
        CGSize forcedSize = CGSizeMake(self.layer.bounds.size.width * scaleFactor, self.layer.bounds.size.height * scaleFactor);
        CGFloat widthDelta = forcedSize.width - self.layer.bounds.size.width;
        CGFloat heightDelta = forcedSize.height - self.layer.bounds.size.height;

        CGRect frame = self.layer.bounds;
        frame.size.width += widthDelta;
        frame.size.height += heightDelta;
        
        frame = CGRectIntegral(frame);

        self.layer.bounds = frame;
        
        UIImage *image = [self imageFromLayer:self.layer];
        [self writeImage:image toFileNamed:@"source-image.png"];
        UIImage *blurredImage = [self blurredImage:image withRadius:descriptor.blurRadius*scale forcedSize:forcedSize];
        [self writeImage:blurredImage toFileNamed:@"blurred-image.png"];
        
        frame.origin.x -= widthDelta/2.0f;
        frame.origin.y -= heightDelta/2.0f;

        frame = CGRectIntegral(frame);

        CGContextDrawImage(context, frame, blurredImage.CGImage);
        
    } else {
        [self.layer renderInContext:context];
    }
}

- (void)writeImage:(UIImage *)image toFileNamed:(NSString *)filename {
    
    NSLog(@"image: %@", image);
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *filePath =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:filename];
    
    if ([fm fileExistsAtPath:filePath]) {
        [fm removeItemAtPath:filePath error:NULL];
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:filePath atomically:YES];
    
    NSLog(@"imageFile: %@", filePath);
}

- (UIImage *)blurredImage:(UIImage *)sourceImage
               withRadius:(CGFloat)radius
               forcedSize:(CGSize)forcedSize {
    
    NSTimeInterval t1 = [NSDate timeIntervalSinceReferenceDate];
    
    AMFadeFilter *fadeFilter = [AMFadeFilter new];
    fadeFilter.pixelRadius = radius;
    fadeFilter.size = sourceImage.size;
    
    GPUImageGaussianBlurFilter *blurFilter = [GPUImageGaussianBlurFilter new];
    blurFilter.blurRadiusInPixels = radius;
    
    GPUImageTransformFilter *transformFilter = [GPUImageTransformFilter new];
    
    CGFloat xScale = forcedSize.width / sourceImage.size.width;
    CGFloat yScale = forcedSize.height / sourceImage.size.height;
    
    [transformFilter forceProcessingAtSize:forcedSize];
    [transformFilter setAffineTransform:CGAffineTransformMakeScale(2, 2)];
    
    [fadeFilter addTarget:transformFilter];
    [transformFilter addTarget:blurFilter];
    
    CGImageRef processedImage =
    [fadeFilter newCGImageByFilteringImage:sourceImage];
    
    NSLog(@"init took: %f", [NSDate timeIntervalSinceReferenceDate] - t1);
    
    UIImage *result = [UIImage imageWithCGImage:processedImage];
    
    [fadeFilter removeTarget:transformFilter];
    [transformFilter removeTarget:blurFilter];
    
    return result;
}

- (UIImage *)blurredImage2:(UIImage *)sourceImage
               withRadius:(CGFloat)radius {
    
    NSTimeInterval t1 = [NSDate timeIntervalSinceReferenceDate];


    AMFadeFilter *fadeFilter = [AMFadeFilter new];
    fadeFilter.pixelRadius = radius;
    fadeFilter.size = self.layer.bounds.size;
    
    GPUImageGaussianBlurFilter *blurFilter = [GPUImageGaussianBlurFilter new];
    blurFilter.blurRadiusInPixels = radius;
    
    GPUImageTransformFilter *transformFilter = [GPUImageTransformFilter new];
    
    [transformFilter forceProcessingAtSize:CGSizeMake(sourceImage.size.width * 1.4, sourceImage.size.height * 1.4)];
    [transformFilter setAffineTransform:CGAffineTransformMakeScale(0.7, 0.7)];

    //Force processing at scale factor 1.4 and affine scale with scale factor 1 / 1.4 = 0.7
//    [transformFilter forceProcessingAtSize:CGSizeMake(sourceImage.size.width * 1.4, sourceImage.size.height * 1.4)];
//    [transformFilter setAffineTransform:CGAffineTransformMakeScale(0.7, 0.7)];
    
    //Setup desired blur filter
//    blurFilter.blurRadiusInPixels = radius;
//    blurFilter.blurPasses = 20;
    
    //Chain Image->Transform->Blur->Output

//    [transformFilter addTarget:blurFilter];
    
    [fadeFilter addTarget:transformFilter];
    [transformFilter addTarget:blurFilter];
    
    CGImageRef processedImage =
    [fadeFilter newCGImageByFilteringImage:sourceImage];

    NSLog(@"init took: %f", [NSDate timeIntervalSinceReferenceDate] - t1);

    UIImage *edgesFadedImage = [UIImage imageWithCGImage:processedImage];
    
    [fadeFilter removeTarget:transformFilter];
    [transformFilter removeTarget:blurFilter];
    
    return edgesFadedImage;
}

static float __f_gaussianblur_kernel_5x5[25] = {
    1.0f/256.0f,  4.0f/256.0f,  6.0f/256.0f,  4.0f/256.0f, 1.0f/256.0f,
    4.0f/256.0f, 16.0f/256.0f, 24.0f/256.0f, 16.0f/256.0f, 4.0f/256.0f,
    6.0f/256.0f, 24.0f/256.0f, 36.0f/256.0f, 24.0f/256.0f, 6.0f/256.0f,
    4.0f/256.0f, 16.0f/256.0f, 24.0f/256.0f, 16.0f/256.0f, 4.0f/256.0f,
    1.0f/256.0f,  4.0f/256.0f,  6.0f/256.0f,  4.0f/256.0f, 1.0f/256.0f
};

static int16_t __s_gaussianblur_kernel_5x5[25] = {
    1, 4, 6, 4, 1,
    4, 16, 24, 16, 4,
    6, 24, 36, 24, 6,
    4, 16, 24, 16, 4,
    1, 4, 6, 4, 1
};

- (void)drawImageBlur:(UIImage *)image inContext:(CGContextRef)context {
    
    NSInteger bias = 10;
    
    /// Create an ARGB bitmap context
    const size_t width = image.size.width;
    const size_t height = image.size.height;
    const size_t bytesPerRow = width * kNyxNumberOfComponentsPerARBGPixel;
    
    /// Draw the image in the bitmap context
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, width, height), image.CGImage);
    
    /// Grab the image raw data
    UInt8* data = (UInt8*)CGBitmapContextGetData(context);
    if (!data)
    {
        return;
    }
    
    /// vImage (iOS 5)
    if ((&vImageConvolveWithBias_ARGB8888))
    {
        const size_t n = sizeof(UInt8) * width * height * 4;
        void* outt = malloc(n);
        vImage_Buffer src = {data, height, width, bytesPerRow};
        vImage_Buffer dest = {outt, height, width, bytesPerRow};
        vImageConvolveWithBias_ARGB8888(&src, &dest, NULL, 0, 0, __s_gaussianblur_kernel_5x5, 5, 5, 256/*divisor*/, bias, NULL, kvImageCopyInPlace);
        memcpy(data, outt, n);
        free(outt);
    }
    else
    {
        const size_t pixelsCount = width * height;
        const size_t n = sizeof(float) * pixelsCount;
        float* dataAsFloat = malloc(n);
        float* resultAsFloat = malloc(n);
        
        /// Red components
        vDSP_vfltu8(data + 1, 4, dataAsFloat, 1, pixelsCount);
        vDSP_f5x5(dataAsFloat, height, width, __f_gaussianblur_kernel_5x5, resultAsFloat);
        vDSP_vfixu8(resultAsFloat, 1, data + 1, 4, pixelsCount);
        
        /// Green components
        vDSP_vfltu8(data + 2, 4, dataAsFloat, 1, pixelsCount);
        vDSP_f5x5(dataAsFloat, height, width, __f_gaussianblur_kernel_5x5, resultAsFloat);
        vDSP_vfixu8(resultAsFloat, 1, data + 2, 4, pixelsCount);
        
        /// Blue components
        vDSP_vfltu8(data + 3, 4, dataAsFloat, 1, pixelsCount);
        vDSP_f5x5(dataAsFloat, height, width, __f_gaussianblur_kernel_5x5, resultAsFloat);
        vDSP_vfixu8(resultAsFloat, 1, data + 3, 4, pixelsCount);
        
        free(resultAsFloat);
        free(dataAsFloat);
    }
}

- (UIImage *)blurredImage:(UIImage *)image
               withRadius:(CGFloat)radius
               iterations:(NSUInteger)iterations
                tintColor:(UIColor *)tintColor {

    //image must be nonzero size
    if (floorf(image.size.width) * floorf(image.size.height) <= 0.0f) return image;
    
    //boxsize must be an odd integer
    uint32_t boxSize = (uint32_t)(radius * image.scale);
    if (boxSize % 2 == 0) boxSize ++;
    
    //create image buffers
    CGImageRef imageRef = image.CGImage;
    vImage_Buffer buffer1, buffer2;
    buffer1.width = buffer2.width = CGImageGetWidth(imageRef);
    buffer1.height = buffer2.height = CGImageGetHeight(imageRef);
    buffer1.rowBytes = buffer2.rowBytes = CGImageGetBytesPerRow(imageRef);
    size_t bytes = buffer1.rowBytes * buffer1.height;
    buffer1.data = malloc(bytes);
    buffer2.data = malloc(bytes);
    
    //create temp buffer
    void *tempBuffer = malloc((size_t)vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, NULL, 0, 0, boxSize, boxSize,
                                                                 NULL, kvImageEdgeExtend + kvImageGetTempBufferSize));
    
    //copy image data
    CFDataRef dataSource = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
    memcpy(buffer1.data, CFDataGetBytePtr(dataSource), bytes);
    CFRelease(dataSource);
    
    for (NSUInteger i = 0; i < iterations; i++)
    {
        //perform blur
        vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, tempBuffer, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        
        //swap buffers
        void *temp = buffer1.data;
        buffer1.data = buffer2.data;
        buffer2.data = temp;
    }
    
    //free buffers
    free(buffer2.data);
    free(tempBuffer);
    
    //create image context from buffer
    CGContextRef ctx = CGBitmapContextCreate(buffer1.data, buffer1.width, buffer1.height,
                                             8, buffer1.rowBytes, CGImageGetColorSpace(imageRef),
                                             CGImageGetBitmapInfo(imageRef));
    
    //apply tint
    if (tintColor && CGColorGetAlpha(tintColor.CGColor) > 0.0f)
    {
//        CGContextSetFillColorWithColor(ctx, tintColor.CGColor);
//        CGContextSetBlendMode(ctx, kCGBlendModeOverlay);
//        CGContextFillRect(ctx, CGRectMake(0, 0, buffer1.width, buffer1.height));
    }
    
    //create image from context
    imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    CGContextRelease(ctx);
    free(buffer1.data);
    return result;
}

- (void)drawShadowInContext:(CGContextRef)context scale:(CGFloat)scale {
    
    AMVynthLayerDescriptor *descriptor = self.vynthDescriptor;
    
    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), descriptor.blurRadius*scale/3.0f, descriptor.color.CGColor);
    CGContextSetFillColorWithColor(context, descriptor.color.CGColor);
    CGContextFillRect(context, self.layer.bounds);
}

@end
