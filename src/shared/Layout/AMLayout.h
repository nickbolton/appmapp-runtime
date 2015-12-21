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
#import "AMComponentAware.h"

@class AMComponent;

@protocol AMLayoutProvider <NSObject>

- (AMView<AMComponentAware> *)viewWithComponentIdentifier:(NSString *)componentIdentifier;
- (AMComponent *)componentWithComponentIdentifier:(NSString *)componentIdentifier;

@end

@interface AMLayout : NSObject<NSCoding>

@property (nonatomic) NSLayoutAttribute attribute;
@property (nonatomic) NSLayoutRelation relation;
@property (nonatomic) CGFloat multiplier;
@property (nonatomic, copy) NSString *componentIdentifier;
@property (nonatomic, copy) NSString *relatedComponentIdentifier;
@property (nonatomic, copy) NSString *commonAncestorComponentIdentifier;
@property (nonatomic) NSLayoutAttribute relatedAttribute;
@property (nonatomic) CGFloat offset;
@property (nonatomic) AMLayoutPriority priority;
@property (nonatomic) CGRect referenceFrame;

@property (nonatomic, strong) NSLayoutConstraint *constraint;
@property (nonatomic, readonly) BOOL isHorizontal;
@property (nonatomic, readonly) BOOL isVertical;
@property (nonatomic, readonly) BOOL isSizing;
@property (nonatomic, copy) NSString *viewIdentifier;

@property (nonatomic, weak) id <AMLayoutProvider> layoutProvider;

@property (nonatomic, weak, readonly) AMView<AMComponentAware> *view;
@property (nonatomic, weak, readonly) AMView<AMComponentAware> *relatedView;
@property (nonatomic, weak, readonly) AMView *commonAncestorView;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)layoutWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)exportLayout;
- (NSDictionary *)debuggingDictionary;

+ (BOOL)isHorizontalLayoutType:(NSLayoutAttribute)layoutType;
+ (BOOL)isVerticalLayoutType:(NSLayoutAttribute)layoutType;

- (void)updateLayoutInAnimation:(BOOL)inAnimation;
- (void)clearLayout;
- (void)addLayout;

@end
