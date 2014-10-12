//
//  AMFadeFilter.m
//  AppMap
//
//  Created by Nick Bolton on 10/5/14.
//  Copyright (c) 2014 Pixelbleed. All rights reserved.
//

#import "AMFadeFilter.h"

@interface AMFadeFilter() {
    
    GLfloat _widthUniform;
    GLfloat _heightUniform;
    GLfloat _radiusUniform;
}

@end

@implementation AMFadeFilter

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
NSString *const kGPUImageFadeFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 uniform lowp float width;
 uniform lowp float height;
 uniform lowp float radius;
 
 lowp float pixelDistance(lowp vec2 p1, lowp vec2 p2) {
     lowp float dx = p1.x - p2.x;
     lowp float dy = p1.y - p2.y;
     return sqrt(dx*dx + dy*dy);
 }
 
 void main()
 {
     lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     lowp float textureWidth = width;
     lowp float textureHeight = height;
     
     lowp float hMinDistance = radius / textureWidth;
     lowp float vMinDistance = radius / textureHeight;
     
     lowp float distanceToEdgeX = textureCoordinate.x;
     distanceToEdgeX = min(distanceToEdgeX, 1.0-textureCoordinate.x);
     
     lowp float distanceToEdgeY = textureCoordinate.y;
     distanceToEdgeY = min(distanceToEdgeY, 1.0-textureCoordinate.y);
     
     lowp float distanceToEdge = min(distanceToEdgeX, distanceToEdgeY);
     
     lowp float opacity = 1.0;
     lowp float xOpacity = 1.0;
     lowp float yOpacity = 1.0;
     
     if (distanceToEdgeX <= hMinDistance) {
         xOpacity = distanceToEdgeX/hMinDistance;
     }
     
     if (distanceToEdgeY <= vMinDistance) {
         yOpacity = distanceToEdgeY/vMinDistance;
     }
     
     lowp float factor = 0.50;
     
     if (xOpacity < 1.0 && yOpacity < 1.0) {
         opacity = xOpacity * yOpacity;
     } else if (xOpacity < 1.0) {
         opacity = xOpacity;
     } else if (yOpacity < 1.0){
         opacity = yOpacity;
     }
     
     gl_FragColor = vec4(textureColor.rgb, textureColor.a * opacity);
 }
 );
#else
NSString *const kGPUImageFadeFragmentShaderString = SHADER_STRING
(
 varying vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 void main()
 {
     vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     
     float opacity = 1 - ((sqrt(abs(pow((0.5-textureCoordinate.x),2.0)+pow((0.5-textureCoordinate.y),2.0))))/0.5);
     
     gl_FragColor = vec4(textureColor.rgb, textureColor.a * opacity);
 }
 );
#endif

#pragma mark -
#pragma mark Initialization and teardown

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageFadeFragmentShaderString]))
    {
        return nil;
    }
    
    _widthUniform = [filterProgram uniformIndex:@"width"];
    _heightUniform = [filterProgram uniformIndex:@"height"];
    _radiusUniform = [filterProgram uniformIndex:@"radius"];
    
    
    
    return self;
}

#pragma mark - Getters and Setters

- (void)setSize:(CGSize)size {
    _size = size;
    [self setFloat:_size.width forUniform:_widthUniform program:filterProgram];
    [self setFloat:_size.height forUniform:_heightUniform program:filterProgram];
}

- (void)setPixelRadius:(CGFloat)pixelRadius {
    _pixelRadius = pixelRadius;
    [self setFloat:_pixelRadius forUniform:_radiusUniform program:filterProgram];
}

@end
