//
//  AMLayout.h
//  AppMap
//
//  Created by Nick Bolton on 12/28/14.
//  Copyright (c) 2014 Pixelbleed LLC. All rights reserved.
//
#import "AppMap.h"
#import "NSLayoutConstraint+Utilities.h"
#import "AppMapTypes.h"

@class AMComponent;

@interface AMLayout : NSObject

@property (nonatomic, strong) NSLayoutConstraint *constraint;
@property (nonatomic, copy) NSString *viewIdentifier;

@property (nonatomic) NSLayoutAttribute attribute;
@property (nonatomic) NSLayoutRelation relation;
@property (nonatomic) CGFloat multiplier;
@property (nonatomic, copy) NSString *relatedComponentIdentifier;
@property (nonatomic) NSLayoutAttribute relatedAttribute;
@property (nonatomic) CGFloat offset;
@property (nonatomic) AMLayoutPriority priority;
@property (nonatomic, readonly) BOOL isHorizontal;

@property (nonatomic, weak) AMView *view;
@property (nonatomic, weak) AMView *relatedView;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)layoutWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)exportLayout;

- (void)clearLayout;

- (void)applyConstraintIfNecessary;
- (void)createConstraintIfNecessary;
- (NSLayoutConstraint *)buildConstraint;

@end
