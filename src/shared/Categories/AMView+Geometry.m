//
//  AMView+Geometry.m
//  AppMap
//
//  Created by Nick Bolton on 5/28/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMView+Geometry.h"

#if !TARGET_OS_IPHONE
#import "AMWindowHelper.h"
#endif

@implementation AMView (Geometry)

CGFloat AMPixelAlignedValue(CGFloat value) {
    
    CGFloat windowScale = AMWindowScale();
    return roundf(value * windowScale) / windowScale;
}

CGPoint AMPixelAlignedCGPoint(CGPoint point) {
    
    CGPoint result;
    result.x = AMPixelAlignedValue(point.x);
    result.y = AMPixelAlignedValue(point.y);
    
    return result;
}

extern CGSize AMPixelAlignedCGSize(CGSize size) {
    
    CGSize result;
    result.width = AMPixelAlignedValue(size.width);
    result.height = AMPixelAlignedValue(size.height);
    
    return result;
}

CGRect AMPixelAlignedCGRect(CGRect frame) {
    
    CGRect result;// = CGRectIntegral(frame);
    result.origin.x = AMPixelAlignedValue(frame.origin.x);
    result.origin.y = AMPixelAlignedValue(frame.origin.y);
    result.size.width = AMPixelAlignedValue(frame.size.width);
    result.size.height = AMPixelAlignedValue(frame.size.height);
    
    return result;
}

CGFloat AMWindowScale() {
    
    CGFloat scale = 1.0f;
    
#if TARGET_OS_IPHONE
    scale = [[UIScreen mainScreen] scale];
#else
    scale = [[AMWindowHelper sharedInstance] windowScale];
#endif
    
    return MAX(1.0f, scale);
}

CGFloat AMWindowScaleValue(CGFloat value) {
    
    CGFloat scale = AMWindowScale();
    
    if (scale > 0.0f) {
        return value / scale;
    }
    return value;
}

CGSize AMNormalizedSize(CGSize size, CGFloat scale) {
    
    if (scale == 0.0f) {
        return CGSizeZero;
    }
    
    return
    CGSizeMake(size.width / scale,
               size.height / scale);
}

CGPoint AMNormalizedPoint(CGPoint point, CGFloat scale) {
    
    if (scale == 0.0f) {
        return CGPointZero;
    }
    
    return
    CGPointMake(point.x / scale,
                point.y / scale);
}

CGRect AMNormalizedFrame(CGRect frame, CGFloat scale) {
    
    if (scale == 0.0f){
        return CGRectZero;
    }
    
    return
    CGRectMake(frame.origin.x / scale,
               frame.origin.y / scale,
               frame.size.width / scale,
               frame.size.height / scale);
}

CGRect AMScaledFrame(CGRect frame, CGFloat scale) {
    
    return
    CGRectMake(frame.origin.x * scale,
               frame.origin.y * scale,
               frame.size.width * scale,
               frame.size.height * scale);
}

CGSize AMScaledSize(CGSize size, CGFloat scale) {
    
    return
    CGSizeMake(size.width * scale,
               size.height * scale);
}

CGPoint AMScaledPoint(CGPoint point, CGFloat scale) {
    
    return
    CGPointMake(point.x * scale,
                point.y * scale);
}
@end
