//
//  AMDataSource.h
//  Prototype
//
//  Created by Nick Bolton on 7/6/13.
//  Copyright (c) 2013 Pixelbleed. All rights reserved.
//

#import "AMDataSource.h"
#import "AMComponentFactory.h"
#import "AMTool.h"

extern NSString * kAMDocumentExtension;

@interface AMDataSource : NSObject <NSCoding>

@property (nonatomic) NSInteger version;
@property (nonatomic, strong) UIColor *canvasBackgroundColor;
@property (nonatomic) CGFloat canvasScale;
@property (nonatomic) CGRect windowFrame;
@property (nonatomic, strong) NSArray *components;

- (BOOL)isEqualToDataSource:(AMDataSource *)object;
- (AMComponent *)componentWithIdentifier:(NSString *)identifier;
- (void)addComponent:(AMComponent *)component;
- (void)addComponents:(NSArray *)components;
- (void)insertChildComponent:(AMComponent *)insertedComponent
             beforeComponent:(AMComponent *)siblingComponent;
- (AMComponent *)componentAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfComponent:(AMComponent *)component;
- (void)removeComponent:(AMComponent *)component;
- (void)removeAllComponents;
- (void)updateComponentBackingData;

- (void)addChildComponent:(AMComponent *)component toComponent:(AMComponent *)targetComponent;
- (void)addChildComponents:(NSArray *)components toComponent:(AMComponent *)targetComponent;
- (void)removeChildComponent:(AMComponent *)component fromComponent:(AMComponent *)targetComponent;
- (void)removeChildComponents:(NSArray *)components fromComponent:(AMComponent *)targetComponent;
- (void)insertChildComponent:(AMComponent *)insertedComponent
             beforeComponent:(AMComponent *)siblingComponent
                 toComponent:(AMComponent *)targetComponent;

@end
