//
//  AMLayoutFactory.m
//  AppMap
//
//  Created by Nick Bolton on 12/28/14.
//  Copyright (c) 2014 Pixelbleed LLC. All rights reserved.
//

#import "AMLayoutFactory.h"
#import "AMPositionLayout.h"
#import "AMAnchoredTopLayout.h"
#import "AMAnchoredBottomLayout.h"
#import "AMAnchoredLeftLayout.h"
#import "AMAnchoredRightLayout.h"
#import "AMAnchoredTopLeftLayout.h"
#import "AMAnchoredTopRightLayout.h"
#import "AMAnchoredBottomLeftLayout.h"
#import "AMAnchoredBottomRightLayout.h"

@interface AMLayoutFactory()

@property (nonatomic, strong) NSDictionary *classes;

@end

@implementation AMLayoutFactory

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    
    self.classes =
    @{
      @(AMLayoutTypePosition) : NSStringFromClass([AMPositionLayout class]),
      @(AMLayoutTypeAnchoredTop) : NSStringFromClass([AMAnchoredTopLayout class]),
      @(AMLayoutTypeAnchoredBottom) : NSStringFromClass([AMAnchoredBottomLayout class]),
      @(AMLayoutTypeAnchoredLeft) : NSStringFromClass([AMAnchoredLeftLayout class]),
      @(AMLayoutTypeAnchoredRight) : NSStringFromClass([AMAnchoredRightLayout class]),
      @(AMLayoutTypeAnchoredTopLeft) : NSStringFromClass([AMAnchoredTopLeftLayout class]),
      @(AMLayoutTypeAnchoredTopRight) : NSStringFromClass([AMAnchoredTopRightLayout class]),
      @(AMLayoutTypeAnchoredBottomLeft) : NSStringFromClass([AMAnchoredBottomLeftLayout class]),
      @(AMLayoutTypeAnchoredBottomRight) : NSStringFromClass([AMAnchoredBottomRightLayout class]),
      };
}

- (AMLayout *)buildLayoutOfType:(AMLayoutType)layoutType {
    
    NSString *classString = self.classes[@(layoutType)];
    
    NSAssert(classString != nil,
             @"No layout found for type: %ld",
             layoutType);
    
    Class clazz = NSClassFromString(classString);
    
    return [clazz new];
}

#pragma mark - Singleton Methods

+ (instancetype)sharedInstance {
    
    static dispatch_once_t predicate;
    static AMLayoutFactory *sharedInstance = nil;
    
    dispatch_once(&predicate, ^{
        sharedInstance = [AMLayoutFactory new];
    });
    
    return sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

@end
