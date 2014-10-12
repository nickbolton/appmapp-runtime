//
//  AMDataSource.m
//  Prototype
//
//  Created by Nick Bolton on 7/6/13.
//  Copyright (c) 2013 Pixelbleed. All rights reserved.
//

#import "AMDataSource.h"
#import "AMComponent.h"
#import "AMComponentFactory.h"
#import "AMVynthLayerDescriptor.h"

static NSString * kAMDataSourceVersionKey = @"version";
static NSString * kAMDataSourceBackgroundColorRedKey = @"backgroundColorRed";
static NSString * kAMDataSourceBackgroundColorGreenKey = @"backgroundColorGreen";
static NSString * kAMDataSourceBackgroundColorBlueKey = @"backgroundColorBlue";
static NSString * kAMDataSourceBackgroundColorAlphaKey = @"backgroundColorAlpha";
static NSString * kAMDataSourceCanvasScaleKey = @"canvasScale";
static NSString * kAMDataSourceWindowFrameKey = @"windowFrame";
static NSString * kAMDataSourceComponentsKey = @"components";

static NSInteger const kAMDataSourceVersion = 1;

NSString * kAMDocumentExtension = @"am";

@interface AMDataSource()

@property (nonatomic, strong) NSMutableDictionary *componentDictionary;

@end

@implementation AMDataSource

- (void)encodeWithCoder:(NSCoder *)coder {
    
    UIColor *backgroundColor = self.canvasBackgroundColor;

    [coder encodeInt32:(int32_t)self.version forKey:kAMDataSourceVersionKey];
    [coder encodeFloat:[backgroundColor redComponent] forKey:kAMDataSourceBackgroundColorRedKey];
    [coder encodeFloat:[backgroundColor greenComponent] forKey:kAMDataSourceBackgroundColorGreenKey];
    [coder encodeFloat:[backgroundColor blueComponent] forKey:kAMDataSourceBackgroundColorBlueKey];
    [coder encodeFloat:[backgroundColor alphaComponent] forKey:kAMDataSourceBackgroundColorAlphaKey];
    [coder encodeFloat:self.canvasScale forKey:kAMDataSourceCanvasScaleKey];
    [coder encodeObject:NSStringFromCGRect(self.windowFrame) forKey:kAMDataSourceWindowFrameKey];
    [coder encodeObject:self.components forKey:kAMDataSourceComponentsKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    
    if (self != nil) {

        self.version = [decoder decodeInt32ForKey:kAMDataSourceVersionKey];
        
        CGFloat canvasBackgroundColorRed = [decoder decodeFloatForKey:kAMDataSourceBackgroundColorRedKey];
        CGFloat canvasBackgroundColorGreen = [decoder decodeFloatForKey:kAMDataSourceBackgroundColorGreenKey];
        CGFloat canvasBackgroundColorBlue = [decoder decodeFloatForKey:kAMDataSourceBackgroundColorBlueKey];
        CGFloat canvasBackgroundColorAlpha = [decoder decodeFloatForKey:kAMDataSourceBackgroundColorAlphaKey];
        
        
        CGFloat canvasScale = [decoder decodeFloatForKey:kAMDataSourceCanvasScaleKey];
        CGRect windowFrame = CGRectFromString([decoder decodeObjectForKey:kAMDataSourceWindowFrameKey]);
        
        NSArray *components = [decoder decodeObjectForKey:kAMDataSourceComponentsKey];
        
        UIColor *color =
        [UIColor
         colorWithRed:canvasBackgroundColorRed
         green:canvasBackgroundColorGreen
         blue:canvasBackgroundColorBlue
         alpha:canvasBackgroundColorAlpha];
        
        self.components = components;
        self.canvasBackgroundColor = color;
        self.canvasScale = canvasScale;
        self.windowFrame = windowFrame;
    }
    
    return self;
}

- (id)init {
    self = [super init];
    
    if (self != nil) {
        self.canvasScale = 1.0f;
        self.canvasBackgroundColor = [AMDesign sharedInstance].backgroundColor;
        self.version = kAMDataSourceVersion;
        self.componentDictionary = [NSMutableDictionary dictionary];
//        [self setupTestData];
    }
    
    return self;
}

- (void)setupTestData {
    
    static CGFloat const offset = 10.0f;
    static CGFloat const padding = 5.0f;
    static CGFloat const xPos = 50.0f;
    static CGSize const size = {100.0f, 100.0f};
    
    CGFloat yPos = 0.0f;
    
    NSMutableArray *components = [NSMutableArray array];
    
    for (AMVynthType type = AMVynthTypeNormal; type <= AMVynthTypeInverted; type++) {
        
        BOOL behind = NO;
        for (NSInteger i = 0; i < 2; i++, behind = !behind) {
            
            BOOL clipped = NO;
            for (NSInteger i = 0; i < 2; i++, clipped = !clipped) {
                
                for (NSInteger top=-1; top<=1; top++) {
                    
                    for (NSInteger left=-1; left<=1; left++) {
                        
                        for (NSInteger bottom=-1; bottom<=1; bottom++) {
                            
                            for (NSInteger right=-1; right<=1; right++) {
                                
                                UIEdgeInsets insets = UIEdgeInsetsMake(top*offset, left*offset, bottom*offset, right*offset);
                                
                                AMComponent *component = [[AMComponentFactory sharedInstance] buildComponentWithComponentType:AMComponentContainer];
                                
                                CGPoint center = CGPointMake(xPos - (size.width/2.0f), yPos - (size.height/2.0f));
                                component.baseCenter = center;
                                component.baseSize = size;
                                
                                AMVynthLayerDescriptor *descriptor =
                                [[AMVynthLayerDescriptor alloc] init];
                                descriptor.color = [UIColor colorWithRGBHex:0x517BA8];
                                descriptor.insets = insets;
                                descriptor.alpha = .5f;
                                descriptor.behind = behind;
                                descriptor.clipped = clipped;
                                descriptor.type = type;
                                
                                [component addLayerStyle:descriptor];
                                
                                yPos += size.height + padding;
                                
                                [components addObject:component];
                            }
                        }
                    }
                }
            }
        }
    }
    
    self.components = components;
}

- (id)copy {

    AMDataSource *dataSource = [[AMDataSource alloc] init];
    dataSource.canvasBackgroundColor = self.canvasBackgroundColor.copy;
    dataSource.windowFrame = self.windowFrame;
    dataSource.canvasScale = self.canvasScale;
    
    NSMutableArray *components = [NSMutableArray array];
    
    [self.components enumerateObjectsUsingBlock:^(AMComponent *component, NSUInteger idx, BOOL *stop) {
        [components addObject:component.copy];
    }];
    
    dataSource.components = components;
    
    return dataSource;
}

- (BOOL)isEqualToDataSource:(AMDataSource *)object {
    
    __block BOOL componentsEqual =
    self.components.count == object.components.count;

    if (componentsEqual) {
        
        NSMutableDictionary *selfComponentsByIdentifier = [NSMutableDictionary dictionary];
        NSMutableDictionary *objectComponentsByIdentifier = [NSMutableDictionary dictionary];
        
        [self.components enumerateObjectsUsingBlock:^(AMComponent *component, NSUInteger idx, BOOL *stop) {
            selfComponentsByIdentifier[component.identifier] = component;
        }];
        
        [object.components enumerateObjectsUsingBlock:^(AMComponent *component, NSUInteger idx, BOOL *stop) {
            objectComponentsByIdentifier[component.identifier] = component;
        }];
        
        NSSortDescriptor *identifierSorter =
        [NSSortDescriptor
         sortDescriptorWithKey:@"self"
         ascending:YES
         selector:@selector(compare:)];
        
        NSArray *selfSortedComponentIdentifiers =
        [selfComponentsByIdentifier.allKeys
         sortedArrayUsingDescriptors:@[identifierSorter]];
        
        NSArray *objectSortedComponentIdentifiers =
        [objectComponentsByIdentifier.allKeys
         sortedArrayUsingDescriptors:@[identifierSorter]];
        
        componentsEqual =
        [selfSortedComponentIdentifiers
         isEqualToArray:objectSortedComponentIdentifiers];
        
        if (componentsEqual) {
            
            [self.components enumerateObjectsUsingBlock:^(AMComponent *selfComponent, NSUInteger idx, BOOL *stop) {
                
                AMComponent *objectComponent = objectComponentsByIdentifier[selfComponent.identifier];
                
                if ([selfComponent isEqualToComponent:objectComponent] == NO) {
                    componentsEqual = NO;
                    *stop = YES;
                }
            }];
        }
    }
    
    return
    [self.canvasBackgroundColor isEqual:object.canvasBackgroundColor] &&
    self.canvasScale == object.canvasScale &&
    componentsEqual;
}

#pragma mark - Component Management

- (NSMutableArray *)mutableComponents {
    
    if (_components == nil) {
        _components = [NSMutableArray array];
    }
    
    return (id)_components;
}

- (void)addComponent:(AMComponent *)component {
    NSAssert([component isKindOfClass:[AMComponent class]],
             @"component not a %@ type", NSStringFromClass([AMComponent class]));
    
    if ([self.mutableComponents containsObject:component] == NO) {
        [self.mutableComponents addObject:component];
        self.componentDictionary[component.identifier] = component;
    }
}

- (void)addComponents:(NSArray *)components {

    [components enumerateObjectsUsingBlock:^(AMComponent *component, NSUInteger idx, BOOL *stop) {
        [self addComponent:component];
    }];
}

- (void)insertChildComponent:(AMComponent *)insertedComponent
             beforeComponent:(AMComponent *)siblingComponent {

    NSUInteger pos = [self.mutableComponents indexOfObject:siblingComponent];
    
    if (pos == NSNotFound) {
        pos = 0;
    }
    
    if ([self.mutableComponents containsObject:insertedComponent]) {
        [self.mutableComponents removeObject:insertedComponent];
    }
    
    [self.mutableComponents insertObject:insertedComponent atIndex:pos];
    self.componentDictionary[insertedComponent.identifier] = insertedComponent;
}

- (AMComponent *)componentAtIndex:(NSUInteger)index {
    
    AMComponent *result = nil;
    
    if (index < self.components.count) {
        result = self.components[index];
    }
    
    return result;
}

- (AMComponent *)componentWithIdentifier:(NSString *)identifier {
 
    if (identifier == nil) {
        return nil;
    }
    
    return self.componentDictionary[identifier];
}

- (NSUInteger)indexOfComponent:(AMComponent *)component {
    NSAssert([component isKindOfClass:[AMComponent class]],
             @"component not a %@ type", NSStringFromClass([AMComponent class]));
    return [self.components indexOfObject:component];
}

- (void)removeComponent:(AMComponent *)component {
    NSAssert([component isKindOfClass:[AMComponent class]],
             @"component not a %@ type", NSStringFromClass([AMComponent class]));
    [self.mutableComponents removeObject:component];
    [self.componentDictionary removeObjectForKey:component.identifier];
}

- (void)removeAllComponents {
    [self.mutableComponents removeAllObjects];
    [self.componentDictionary removeAllObjects];
}

- (void)addChildComponent:(AMComponent *)component toComponent:(AMComponent *)targetComponent {
    [targetComponent addChildComponent:component];
    self.componentDictionary[component.identifier] = component;
}

- (void)addChildComponents:(NSArray *)components toComponent:(AMComponent *)targetComponent {
    [targetComponent addChildComponents:components];
    [components enumerateObjectsUsingBlock:^(AMComponent *component, NSUInteger idx, BOOL *stop) {
        self.componentDictionary[component.identifier] = component;
    }];
}

- (void)removeChildComponent:(AMComponent *)component fromComponent:(AMComponent *)targetComponent {
    [targetComponent removeChildComponent:component];
    [self.componentDictionary removeObjectForKey:component.identifier];
}

- (void)removeChildComponents:(NSArray *)components fromComponent:(AMComponent *)targetComponent {
    [targetComponent removeChildComponents:components];
    [components enumerateObjectsUsingBlock:^(AMComponent *component, NSUInteger idx, BOOL *stop) {
        [self.componentDictionary removeObjectForKey:component.identifier];
    }];
}

- (void)insertChildComponent:(AMComponent *)insertedComponent
             beforeComponent:(AMComponent *)siblingComponent
                 toComponent:(AMComponent *)targetComponent {
    [targetComponent insertChildComponent:insertedComponent beforeComponent:siblingComponent];
    self.componentDictionary[insertedComponent.identifier] = insertedComponent;
}

- (void)updateComponentBackingData {
    
    [self.components enumerateObjectsUsingBlock:^(AMComponent *component, NSUInteger idx, BOOL *stop) {
        [component importBackingFile];
        [component closeBackingFile];
    }];
}

- (NSString *)description {

    NSMutableString *result = [NSMutableString string];
    
    [result appendString:@"DataSource: "];
    
    [self.components enumerateObjectsUsingBlock:^(AMComponent *component, NSUInteger idx, BOOL *stop) {
        [self appendComponent:component toDescription:result level:0];
    }];
    
    return result;
}

- (void)appendComponent:(AMComponent *)component toDescription:(NSMutableString *)string level:(NSUInteger)level {
    
    [string appendString:@"\n"];
    
    for (NSInteger i = 0; i < level; i++) {
        [string appendString:@"    "];
    }
    [string appendString:[component description]];
}

@end
