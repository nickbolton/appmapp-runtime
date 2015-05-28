//
//  AMView+Geometry.h
//  AppMap
//
//  Created by Nick Bolton on 5/28/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//
#import "AppMapTypes.h"

@interface AMView (Geometry)

extern CGFloat AMPixelAlignedValue(CGFloat value);
extern CGPoint AMPixelAlignedCGPoint(CGPoint point);
extern CGSize AMPixelAlignedCGSize(CGSize size);
extern CGRect AMPixelAlignedCGRect(CGRect frame);
extern CGFloat AMWindowScale();
extern CGFloat AMWindowScaleValue(CGFloat value);
extern CGSize AMNormalizedSize(CGSize size, CGFloat scale);
extern CGPoint AMNormalizedPoint(CGPoint point, CGFloat scale);
extern CGRect AMNormalizedFrame(CGRect frame, CGFloat scale);
extern CGRect AMScaledFrame(CGRect frame, CGFloat scale);
extern CGSize AMScaledSize(CGSize size, CGFloat scale);
extern CGPoint AMScaledPoint(CGPoint point, CGFloat scale);

@end
