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
#import "AMProportionalTopLayout.h"
#import "AMProportionalBottomLayout.h"
#import "AMProportionalLeftLayout.h"
#import "AMProportionalRightLayout.h"
#import "AMCenterHorizontallyLayout.h"
#import "AMCenterVerticallyLayout.h"
#import "AMProportionalHorizontalCenterLayout.h"
#import "AMProportionalVerticalCenterLayout.h"
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
      @(AMLayoutTypeAnchoredTop) : NSStringFromClass([AMAnchoredTopLayout class]),
      @(AMLayoutTypeAnchoredBottom) : NSStringFromClass([AMAnchoredBottomLayout class]),
      @(AMLayoutTypeAnchoredLeft) : NSStringFromClass([AMAnchoredLeftLayout class]),
      @(AMLayoutTypeAnchoredRight) : NSStringFromClass([AMAnchoredRightLayout class]),
      @(AMLayoutTypeCenterHorizontally) : NSStringFromClass([AMCenterHorizontallyLayout class]),
      @(AMLayoutTypeCenterVertically) : NSStringFromClass([AMCenterVerticallyLayout class]),
      @(AMLayoutTypeFixedWidth) : NSStringFromClass([AMFixedWidthLayout class]),
      @(AMLayoutTypeFixedHeight) : NSStringFromClass([AMFixedHeightLayout class]),
      @(AMLayoutTypeProportionalTop) : NSStringFromClass([AMProportionalTopLayout class]),
      @(AMLayoutTypeProportionalBottom) : NSStringFromClass([AMProportionalBottomLayout class]),
      @(AMLayoutTypeProportionalLeft) : NSStringFromClass([AMProportionalLeftLayout class]),
      @(AMLayoutTypeProportionalRight) : NSStringFromClass([AMProportionalRightLayout class]),
      @(AMLayoutTypeProportionalHorizontalCenter) : NSStringFromClass([AMProportionalHorizontalCenterLayout class]),
      @(AMLayoutTypeProportionalVerticalCenter) : NSStringFromClass([AMProportionalVerticalCenterLayout class]),
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
