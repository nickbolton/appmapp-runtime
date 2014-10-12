//
//  AMComponent.h
//  AppMapTest
//
//  Created by Nick Bolton on 8/1/14.
//  Copyright (c) 2014 Nick Bolton. All rights reserved.
//

#import "AMComponentFactory.h"

@class AMComponent;
@class AMImageAsset;
@class AMLayerDescriptor;

@protocol AMComponentDelegate <NSObject>

- (void)component:(AMComponent *)component updatedBackingImage:(AMImageAsset *)imageAsset;
- (void)component:(AMComponent *)component photoshopError:(NSDictionary *)errorDict;
- (void)componentEstablishedBackingFile:(AMComponent *)component;

@end

@interface AMComponent : NSObject <NSCoding, NSCopying>

@property (nonatomic, weak) id <AMComponentDelegate> delegate;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, readonly) NSString *defaultName;
@property (nonatomic) AMComponentType componentType;
@property (nonatomic, strong) NSArray *childComponents;
@property (nonatomic, weak) AMComponent *parentComponent;
@property (nonatomic, weak) AMComponent *lastParentComponent;
@property (nonatomic, strong) NSString *backingFilePrefix;
@property (nonatomic, readonly) NSString *backingFile;
@property (nonatomic) NSTimeInterval backingFileTimestamp;
@property (nonatomic, strong) AMImageAsset *backingImage;
@property (nonatomic, strong) NSData *backingFileData;
@property (nonatomic) BOOL hasBackingFileChanges;
@property (nonatomic) BOOL backingFileEnabled;
@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic, readonly) Class viewClass;
@property (nonatomic, readonly) NSArray *layerStylesBelowBase;
@property (nonatomic, readonly) NSArray *layerStylesAboveBase;

@property (nonatomic, getter=isClipped) BOOL clipped;
@property (nonatomic) CGFloat alpha;
@property (nonatomic) UIColor *backgroundColor;
@property (nonatomic) CGFloat blurRadius;
@property (nonatomic) CGPoint baseCenter;
@property (nonatomic) CGSize baseSize;


#if TARGET_OS_IPHONE == 0
- (void)importBackingImage;
#endif

- (void)importBackingFile;
- (void)closeBackingFile;
- (BOOL)isEqualToComponent:(AMComponent *)object;
- (void)updateBackingFile:(void(^)(NSError *error))completion;

- (void)addNewLayerStyle;
- (void)insertNewLayerStyleBeforeStyle:(AMLayerDescriptor *)nextDescriptor;
- (void)insertNewLayerStyleAfterStyle:(AMLayerDescriptor *)prevDescriptor;

- (void)moveLayerStyle:(AMLayerDescriptor *)descriptor
           beforeStyle:(AMLayerDescriptor *)nextDescriptor;
- (void)moveLayerStyle:(AMLayerDescriptor *)descriptor
            afterStyle:(AMLayerDescriptor *)prevDescriptor;

- (void)addLayerStyle:(AMLayerDescriptor *)descriptor;
- (void)removeLayerStyle:(AMLayerDescriptor *)descriptor;
- (AMLayerDescriptor *)baseViewLayerDescriptor;

- (void)addChildComponent:(AMComponent *)component;
- (void)addChildComponents:(NSArray *)components;
- (void)removeChildComponent:(AMComponent *)component;
- (void)removeChildComponents:(NSArray *)components;
- (void)insertChildComponent:(AMComponent *)insertedComponent
             beforeComponent:(AMComponent *)siblingComponent;

+ (instancetype)buildComponent;

@end
