//
//  AMLayoutFactory.m
//  AppMap
//
//  Created by Nick Bolton on 12/28/14.
//  Copyright (c) 2014 Pixelbleed LLC. All rights reserved.
//

#import "AMLayoutFactory.h"
#import "AMPositionLayout.h"
#import "AMTopLayout.h"
#import "AMBottomLayout.h"
#import "AMLeftLayout.h"
#import "AMRightLayout.h"
#import "AMCenterHorizontallyLayout.h"
#import "AMCenterVerticallyLayout.h"
#import "AMFixedHeightLayout.h"
#import "AMFixedWidthLayout.h"

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
      @(AMLayoutTypeTop) : NSStringFromClass([AMTopLayout class]),
      @(AMLayoutTypeBottom) : NSStringFromClass([AMBottomLayout class]),
      @(AMLayoutTypeLeft) : NSStringFromClass([AMLeftLayout class]),
      @(AMLayoutTypeRight) : NSStringFromClass([AMRightLayout class]),
      @(AMLayoutTypeCenterHorizontally) : NSStringFromClass([AMCenterHorizontallyLayout class]),
      @(AMLayoutTypeCenterVertically) : NSStringFromClass([AMCenterVerticallyLayout class]),
      @(AMLayoutTypeFixedWidth) : NSStringFromClass([AMFixedWidthLayout class]),
      @(AMLayoutTypeFixedHeight) : NSStringFromClass([AMFixedHeightLayout class]),
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
