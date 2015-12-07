//
//  AMComponentElement.m
//  AppMapTest
//
//  Created by Nick Bolton on 8/1/14.
//  Copyright (c) 2014 Nick Bolton. All rights reserved.
//

#import "AMComponentElement.h"
#import "AppMap.h"
#import "AMView+Geometry.h"
#import "AMLayoutPresetHelper.h"
#import "AMLayoutFactory.h"

NSString * const kAMComponentClassNameKey = @"class-name";
NSString * const kAMComponentsKey = @"components";
NSString * kAMComponentChildComponentsKey = @"childComponents";
NSString * kAMComponentFrameKey = @"frame";
NSString * kAMComponentLayoutObjectsKey = @"layoutObjects";
NSString * kAMComponentLayoutPresetKey = @"layoutPreset";
NSString * kAMComponentTopLevelComponentKey = @"tlc";

NSString * kAMComponentIdentifierKey = @"identifier";

@interface AMComponentElement()

@property (nonatomic, strong) NSMutableArray *primChildComponents;
@property (nonatomic, readwrite) BOOL hasProportionalLayout;

@end

@implementation AMComponentElement

- (void)encodeWithCoder:(NSCoder *)coder {    
    [coder encodeObject:self.identifier forKey:kAMComponentIdentifierKey];
    [coder encodeObject:self.childComponents forKey:kAMComponentChildComponentsKey];
    
    [coder encodeInteger:self.layoutPreset forKey:kAMComponentLayoutPresetKey];
    [coder encodeObject:self.layoutObjects forKey:kAMComponentLayoutObjectsKey];
    
#if TARGET_OS_IPHONE
    [coder encodeObject:NSStringFromCGRect(self.frame) forKey:kAMComponentFrameKey];
#else
    [coder encodeObject:NSStringFromRect(self.frame) forKey:kAMComponentFrameKey];
#endif
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    
    if (self != nil) {
        self.identifier = [decoder decodeObjectForKey:kAMComponentIdentifierKey];
        
        self.layoutPreset = [decoder decodeIntegerForKey:kAMComponentLayoutPresetKey];
        self.layoutObjects = [decoder decodeObjectForKey:kAMComponentLayoutObjectsKey];
        
#if TARGET_OS_IPHONE
        self.frame = CGRectFromString([decoder decodeObjectForKey:kAMComponentFrameKey]);
#else
        self.frame = NSRectFromString([decoder decodeObjectForKey:kAMComponentFrameKey]);
#endif
        
        NSArray *childComponents =
        [decoder decodeObjectForKey:kAMComponentChildComponentsKey];
        
        [self addChildComponents:childComponents];
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    
    self = [super init];
    
    if (self != nil) {
        self.identifier = dict[kAMComponentIdentifierKey];
        
        self.layoutPreset = [dict[kAMComponentLayoutPresetKey] integerValue];
        
#if TARGET_OS_IPHONE
        self.frame = CGRectFromString(dict[kAMComponentFrameKey]);
#else
        self.frame = NSRectFromString(dict[kAMComponentFrameKey]);
#endif
        
        // layout objects
        
        NSMutableArray *layoutObjects = [NSMutableArray array];
        NSArray *layoutObjectDicts = dict[kAMComponentLayoutObjectsKey];
        
        for (NSDictionary *dict in layoutObjectDicts) {
            
            AMLayout *layout = [AMLayout layoutWithDictionary:dict];
            [layoutObjects addObject:layout];
        }
        
        self.layoutObjects = layoutObjects;
        
        // children
        
        NSMutableArray *childComponents = [NSMutableArray array];
        id children = dict[kAMComponentChildComponentsKey];
        NSArray *childrenArray = nil;
        
        if ([children isKindOfClass:[NSArray class]]) {
            childrenArray = children;
        } else if ([children isKindOfClass:[NSDictionary class]]) {
            childrenArray = ((NSDictionary *)children).allValues;
        }
        
        for (NSDictionary *childDict in childrenArray) {
            
            AMComponentElement *childComponent = [self.class componentWithDictionary:childDict];
            [childComponents addObject:childComponent];
        }
        
        [self addChildComponents:childComponents];
    }
    
    return self;
}

+ (instancetype)componentWithDictionary:(NSDictionary *)dict {
    
    NSString *className = dict[kAMComponentClassNameKey];
    AMComponentElement *component =
    [[NSClassFromString(className) alloc] initWithDictionary:dict];
    
    return component;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return [self copy];
}

- (instancetype)copy {
    
    AMComponentElement *component = [[self.class alloc] init];
    [self copyToComponent:component];
    return component;
}

- (void)copyToComponent:(AMComponentElement *)component {
    component.identifier = self.identifier.copy;
    component.layoutPreset = self.layoutPreset;
    component.layoutObjects = self.layoutObjects.copy;
    component.frame = self.frame;

    // only used to refer back to original parent
    // children will have this reset with the next loop
    component.parentComponent = self.parentComponent;
    
    for (AMComponentElement *childComponent in component.childComponents) {
        childComponent.parentComponent = component;
    }
    
    NSMutableArray *children = [NSMutableArray array];
    
    for (AMComponentElement *component in self.childComponents) {
        [children addObject:component.copy];
    }
    component.childComponents = children;
}

+ (NSDictionary *)exportComponents:(NSArray *)components {
    
    NSMutableDictionary *componentDictionaries = [NSMutableDictionary dictionary];
    
    [components enumerateObjectsUsingBlock:^(AMComponentElement *component, NSUInteger idx, BOOL *stop) {
        
        NSDictionary *componentDict = [component exportComponent];
        componentDictionaries[component.identifier] = componentDict;
    }];
    
    NSDictionary *dict =
    @{
      kAMComponentsKey : componentDictionaries,
      };
    
    return dict;
}

- (NSDictionary *)exportComponent {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[kAMComponentIdentifierKey] = self.identifier;
    dict[kAMComponentClassNameKey] = NSStringFromClass(self.class);
    
#if TARGET_OS_IPHONE
    dict[kAMComponentFrameKey] = NSStringFromCGRect(self.frame);
#else
    dict[kAMComponentFrameKey] = NSStringFromRect(self.frame);
#endif
    
    dict[kAMComponentLayoutPresetKey] = @(self.layoutPreset);
    
    NSMutableArray *layoutObjectDicts = [NSMutableArray array];
    
    for (AMLayout *layout in self.layoutObjects) {
        NSDictionary *dict = [layout exportLayout];
        [layoutObjectDicts addObject:dict];
    }
    
    dict[kAMComponentLayoutObjectsKey] = layoutObjectDicts;

    NSMutableDictionary *children = [NSMutableDictionary dictionary];
    
    for (AMComponentElement *childComponent in self.childComponents) {
        children[childComponent.identifier] = [childComponent exportComponent];
    }
    
    dict[kAMComponentChildComponentsKey] = children;

    return dict;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"ComponentElement(%d): %p %@",
    (int)self.componentType, self, self.identifier];
}

#pragma mark - Getters and Setters

- (BOOL)isEqualToComponent:(AMComponentElement *)object {
    return
    [self.identifier isEqualToString:object.identifier];
}

- (void)setFrame:(CGRect)frame {
    
    BOOL sizeChanged = (CGSizeEqualToSize(frame.size, self.frame.size) == NO);
    _frame = frame;
    if (sizeChanged) {
        [self updateChildFrames];
    }
}

- (void)setScale:(CGFloat)scale {
    _scale = scale;
    
    for (AMComponentElement *component in self.childComponents) {
        component.scale = scale;
    }
}

- (void)resetLayout {
    if (self.layoutPreset < AMLayoutPresetCustom) {
        
        AMLayoutPresetHelper *helper = [AMLayoutPresetHelper new];
        
        NSArray *layoutTypes = [helper layoutTypesForComponent:self layoutPreset:_layoutPreset];
        NSMutableArray *layoutObjects = [NSMutableArray array];
        
        for (NSNumber *layoutType in layoutTypes) {
            
            AMLayout *layoutObject =
            [[AMLayoutFactory sharedInstance]
             buildLayoutOfType:layoutType.integerValue];
            
            [layoutObjects addObject:layoutObject];
        }
        
        self.layoutObjects = layoutObjects;
    }
}

- (void)setLayoutPreset:(AMLayoutPreset)layoutPreset {
    _layoutPreset = layoutPreset;
    
    _layoutPreset = MAX(0, _layoutPreset);
    _layoutPreset = MIN(AMLayoutPresetCustom, _layoutPreset);
    [self resetLayout];
}

#pragma mark - Parent/Child

- (NSArray *)childComponents {
    return
    [NSArray arrayWithArray:self.primChildComponents];
}

- (void)setChildComponents:(NSArray *)childComponents {
    
    NSMutableArray *primComponents = self.primChildComponents;
    [primComponents removeAllObjects];
    [primComponents addObjectsFromArray:childComponents];
}

- (NSMutableArray *)primChildComponents {
    
    if (_primChildComponents == nil) {
        _primChildComponents = [NSMutableArray array];
    }
    return _primChildComponents;
}

- (NSInteger)depth {
    
    if (self.parentComponent != nil) {
        return [self.parentComponent depth] + 1;
    }
    
    return 1;
}

- (NSInteger)childIndex {
    
    NSInteger result = NSNotFound;
    
    if (self.parentComponent != nil) {
        result = [self.parentComponent.childComponents indexOfObject:self];
    }
    
    return result;
}

- (BOOL)isTopLevelComponent {
    return self.topLevelComponent == self;
}

- (AMComponentElement *)topLevelComponent {
    
    if (self.parentComponent != nil) {
        return self.parentComponent.topLevelComponent;
    }
    
    return self;
}

+ (BOOL)doesHaveCommonTopLevelComponent:(NSArray *)components {
    
    NSMutableSet *topLevelComponents = [NSMutableSet set];
    BOOL allAreTopLevelComponents = components.count > 0;
    
    for (AMComponentElement *component in components) {
        
        [topLevelComponents addObject:component.topLevelComponent];
        if (component.parentComponent != nil) {
            allAreTopLevelComponents = NO;
        }
    }
    
    return allAreTopLevelComponents || topLevelComponents.count == 1;
}

+ (BOOL)doesHaveCommonTopLevelComponent:(NSArray *)components
                          withComponent:(AMComponentElement *)component {
    
    NSMutableArray *allComponents = [NSMutableArray array];
    [allComponents addObjectsFromArray:components];
    
    if (component != nil) {
        [allComponents addObject:component];
    }
    
    return [self doesHaveCommonTopLevelComponent:allComponents];
}

- (AMComponentElement *)ancestorBefore:(AMComponentElement *)component {
    
    AMComponentElement *parentComponent = self.parentComponent;
    AMComponentElement *result = self;
    
    while (parentComponent != nil) {
        
        if ([parentComponent.identifier isEqualToString:component.identifier]) {
            return result;
        }
        
        result = parentComponent;
        parentComponent = parentComponent.parentComponent;
    }
    
    return nil;
}

- (BOOL)isDescendent:(AMComponentElement *)component {
    
    AMComponentElement *parentComponent = component.parentComponent;
    
    while (parentComponent != nil) {
        
        if ([parentComponent.identifier isEqualToString:self.identifier]) {
            return YES;
        }
        
        parentComponent = parentComponent.parentComponent;
    }
    
    return NO;
}

- (void)addChildComponent:(AMComponentElement *)component {
    if (component != nil) {
        [self addChildComponents:@[component]];
    }
}

- (void)addChildComponents:(NSArray *)components {
    
    NSMutableArray *primComponents = self.primChildComponents;
    
    for (AMComponentElement *component in components) {
        
        if ([primComponents containsObject:component] == NO) {
            [primComponents addObject:component];
        }
        
        component.parentComponent = self;
    }
}

- (void)insertChildComponent:(AMComponentElement *)insertedComponent
             beforeComponent:(AMComponentElement *)siblingComponent {
    
    NSMutableArray *primComponents = self.primChildComponents;
    
    NSUInteger pos = [primComponents indexOfObject:siblingComponent];
    
    if (pos == NSNotFound) {
        pos = 0;
    }
    
    if ([primComponents containsObject:insertedComponent]) {
        [primComponents removeObject:insertedComponent];
    }
    
    [primComponents insertObject:insertedComponent atIndex:pos];
    
    insertedComponent.parentComponent = self;
}

- (void)insertChildComponent:(AMComponentElement *)insertedComponent
              afterComponent:(AMComponentElement *)siblingComponent {
    
    NSMutableArray *primComponents = self.primChildComponents;
    
    NSUInteger pos = [primComponents indexOfObject:siblingComponent];
    
    if (pos == NSNotFound) {
        pos = primComponents.count-1;
    }
    
    pos++;
    pos = MIN(pos, primComponents.count);
    
    if ([primComponents containsObject:insertedComponent]) {
        [primComponents removeObject:insertedComponent];
    }
    
    if (pos < primComponents.count) {
        [primComponents insertObject:insertedComponent atIndex:pos];
    } else {
        [primComponents addObject:insertedComponent];
    }
    
    insertedComponent.parentComponent = self;
}

- (void)removeChildComponent:(AMComponentElement *)component {
    if (component != nil) {
        [self removeChildComponents:@[component]];
    }
}

- (void)removeChildComponents:(NSArray *)components {
    [self.primChildComponents removeObjectsInArray:components];
    
    [components enumerateObjectsUsingBlock:^(AMComponentElement *component, NSUInteger idx, BOOL *stop) {
        component.parentComponent = nil;
    }];
}

#pragma mark - Helpers

- (void)updateProportionalLayouts {
    
    for (AMLayout *layout in self.layoutObjects) {
        
        if (self.parentComponent != nil) {
            [layout
             updateProportionalValueFromFrame:self.frame
             parentFrame:self.parentComponent.frame];
            
            for (AMComponentElement *childComponent in self.childComponents) {
                
                [childComponent updateProportionalLayouts];
            }
        }
    }
}

- (void)updateChildFrames {
    
    for (AMComponentElement *childComponent in self.childComponents) {
        [childComponent updateFrame];
    }
}

- (void)updateFrame {
    
    //    NSLog(@"startingFrame: %@", NSStringFromCGRect(self.frame));
    //    NSLog(@"parentFrame: %@", NSStringFromCGRect(self.parentInstance.frame));
    
    CGRect updatedFrame = self.frame;
    
    for (AMLayout *layout in self.layoutObjects) {
        
        updatedFrame =
        [layout
         adjustedFrame:updatedFrame
         forComponent:self
         scale:self.scale];
        
        //        NSLog(@"%@ - %@", NSStringFromClass(layout.class), NSStringFromCGRect(updatedFrame));
    }
    
    updatedFrame = AMPixelAlignedCGRect(updatedFrame);
    //    NSLog(@"endingFrame: %@", NSStringFromCGRect(updatedFrame));
    
    self.frame = updatedFrame;
    
    
    for (AMComponentElement *childComponent in self.childComponents) {
        [childComponent updateFrame];
    }
}

@end
