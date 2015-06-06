//
//  AMDataSource.h
//  Prototype
//
//  Created by Nick Bolton on 7/6/13.
//  Copyright (c) 2013 Pixelbleed. All rights reserved.
//

#import "AMDataSource.h"
#import "AppMapTypes.h"

extern NSString * kAMDocumentExtension;

@class AMComponent;

@interface AMDataSource : NSObject <NSCoding>

@property (nonatomic) NSInteger version;
@property (nonatomic, strong) AMColor *canvasBackgroundColor;
@property (nonatomic) CGFloat canvasScale;
@property (nonatomic) CGRect windowFrame;
@property (nonatomic, strong) NSArray *components;
@property (nonatomic, readonly) NSDictionary *nameRegistry;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)exportDataSource;

- (BOOL)isEqualToDataSource:(AMDataSource *)object;
- (AMComponent *)componentWithIdentifier:(NSString *)identifier;
- (void)addComponent:(AMComponent *)component;
- (void)addComponents:(NSArray *)components;
- (void)insertComponent:(AMComponent *)insertedComponent
        beforeComponent:(AMComponent *)siblingComponent;
- (void)insertComponent:(AMComponent *)insertedComponent
         afterComponent:(AMComponent *)siblingComponent;

- (AMComponent *)componentAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfComponent:(AMComponent *)component;
- (void)removeComponent:(AMComponent *)component;
- (void)removeAllComponents;

- (void)addComponent:(AMComponent *)component toComponent:(AMComponent *)targetComponent;
- (void)addComponents:(NSArray *)components toComponent:(AMComponent *)targetComponent;

- (void)registerName:(NSString *)name;
- (NSArray *)nameCompletions:(NSString *)token;

- (void)updateComponentLinks;
- (NSArray *)linkSourcesForTargetComponent:(AMComponent *)component;

@end
