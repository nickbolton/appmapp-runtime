//
//  AMDataSource.m
//  Prototype
//
//  Created by Nick Bolton on 7/6/13.
//  Copyright (c) 2013 Pixelbleed. All rights reserved.
//

#import "AMDataSource.h"
#import "AMComponent.h"
#import "AMNameEntity.h"
#import "AMColor+AMColor.h"
#import "AMDesign.h"

static NSString * kAMDataSourceVersionKey = @"appmapp-version";
static NSString * kAMDataSourceBackgroundColorKey = @"backgroundColorRed";
static NSString * kAMDataSourceCanvasScaleKey = @"canvasScale";
static NSString * kAMDataSourceWindowFrameKey = @"windowFrame";
static NSString * kAMDataSourceComponentsKey = @"components";
static NSString * kAMDataSourceNameDictionaryKey = @"nameDictionary";

static NSInteger const kAMDataSourceVersion = 1;

NSString * kAMDocumentExtension = @"am";

@interface AMDataSource()

@property (nonatomic, strong) NSMutableDictionary *componentDictionary;
@property (nonatomic, strong) NSMutableDictionary *linkSourceDictionary;
@property (nonatomic, strong) NSMutableDictionary *nameDictionary;
@property (nonatomic, strong) NSMutableDictionary *nameSearchResults;

@end

@implementation AMDataSource

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    
    self = [super init];
    if (self) {
        
        self.version = [dict[kAMDataSourceVersionKey] integerValue];
        
        if (self.version < 0 || self.version > kAMDataSourceVersion) {
            return nil;
        }

        NSString *canvasBackgroundColorString = dict[kAMDataSourceBackgroundColorKey];
        
        self.canvasBackgroundColor = [AMColor colorWithHexcodePlusAlpha:canvasBackgroundColorString];
        self.canvasScale = [dict[kAMDataSourceCanvasScaleKey] floatValue];
        self.windowFrame = CGRectFromString([NSString safeString:dict[kAMDataSourceWindowFrameKey]]);
        
        // components
        NSMutableArray *components = [NSMutableArray array];
        NSArray *componentsArray = dict[kAMDataSourceComponentsKey];
        
        if ([componentsArray isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *componentDict in componentsArray) {
                
                AMComponent *component =
                [[AMComponent alloc] initWithDictionary:componentDict];
                
                if (component != nil) {
                    [components addObject:component];
                }
            }
        }
        
        self.components = components;
        [self revertComponentsDictionary];
        [self establishLinksForComponents];
        
        // name registry
        
        NSMutableDictionary *nameDictionary = [NSMutableDictionary dictionary];
        NSArray *nameArray = dict[kAMDataSourceNameDictionaryKey];
        
        if ([nameArray isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *nameEntityDict in nameArray) {
                
                AMNameEntity *nameEntity =
                [[AMNameEntity alloc] initWithDictionary:nameEntityDict];
                
                if (nameEntity.name != nil) {
                    nameDictionary[nameEntity.name] = nameEntity;
                }
            }
        }
        
        self.nameDictionary = nameDictionary;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {

    [coder encodeInt32:(int32_t)self.version forKey:kAMDataSourceVersionKey];
    [coder encodeObject:[self.canvasBackgroundColor hexcodePlusAlpha]];
    [coder encodeFloat:self.canvasScale forKey:kAMDataSourceCanvasScaleKey];
    [coder encodeObject:NSStringFromCGRect(self.windowFrame) forKey:kAMDataSourceWindowFrameKey];
    [coder encodeObject:self.components forKey:kAMDataSourceComponentsKey];
    [coder encodeObject:self.nameDictionary forKey:kAMDataSourceNameDictionaryKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    
    if (self != nil) {

        self.version = [decoder decodeInt32ForKey:kAMDataSourceVersionKey];
        
        NSString *canvasBackgroundColorString = [decoder decodeObjectForKey:kAMDataSourceBackgroundColorKey];
        
        CGFloat canvasScale = [decoder decodeFloatForKey:kAMDataSourceCanvasScaleKey];
        CGRect windowFrame = CGRectFromString([decoder decodeObjectForKey:kAMDataSourceWindowFrameKey]);
        
        NSArray *components = [decoder decodeObjectForKey:kAMDataSourceComponentsKey];
        
        self.components = components;
        self.canvasBackgroundColor = [AMColor colorWithHexcodePlusAlpha:canvasBackgroundColorString];
        self.canvasScale = canvasScale;
        self.windowFrame = windowFrame;
        self.nameDictionary = [decoder decodeObjectForKey:kAMDataSourceNameDictionaryKey];
        
        if (self.nameDictionary == nil) {
            self.nameDictionary = [NSMutableDictionary dictionary];
        }
        
        [self revertComponentsDictionary];
        [self establishLinksForComponents];
    }
    
    return self;
}

- (id)init {
    self = [super init];
    
    if (self != nil) {
        self.canvasScale = 1.0f;
        self.canvasBackgroundColor = [AMDesign sharedInstance].canvasColor;
        self.version = kAMDataSourceVersion;
        self.componentDictionary = [NSMutableDictionary dictionary];
        self.linkSourceDictionary = [NSMutableDictionary dictionary];
        self.nameDictionary = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (id)copy {

    AMDataSource *dataSource = [[AMDataSource alloc] init];
    dataSource.canvasBackgroundColor = self.canvasBackgroundColor.copy;
    dataSource.windowFrame = self.windowFrame;
    dataSource.canvasScale = self.canvasScale;
    dataSource.nameDictionary = self.nameDictionary.mutableCopy;
    
    NSMutableArray *components = [NSMutableArray array];
    
    for (AMComponent *component in self.components) {
        [components addObject:component.copy];
    }
    
    dataSource.components = components;
    [dataSource revertComponentsDictionary];
    [dataSource establishLinksForComponents];
    
    return dataSource;
}

- (NSDictionary *)exportDataSource {
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    result[kAMDataSourceVersionKey] = @(kAMDataSourceVersion);
    result[kAMDataSourceBackgroundColorKey] = [self.canvasBackgroundColor hexcodePlusAlpha];
    result[kAMDataSourceCanvasScaleKey] = @(self.canvasScale);
    result[kAMDataSourceWindowFrameKey] = NSStringFromCGRect(self.windowFrame);
    
    // components
    NSMutableArray *components = [NSMutableArray array];
    
    for (AMComponent *component in self.components) {
        
        NSDictionary *componentDict = [component exportComponent];
        
        if (componentDict != nil) {
            [components addObject:componentDict];
        }
    }
    
    result[kAMDataSourceComponentsKey] = components;
    
    // name registry
    
    NSMutableArray *nameArray = [NSMutableArray array];
    
    [self.nameDictionary enumerateKeysAndObjectsUsingBlock:^(id key, AMNameEntity *nameEntity, BOOL *stop) {
       
        NSDictionary *dict = [nameEntity exportNameEntity];
        
        if (dict != nil) {
            [nameArray addObject:dict];
        }
    }];
    
    result[kAMDataSourceNameDictionaryKey] = nameArray;
    
    return result;
}

- (BOOL)isEqualToDataSource:(AMDataSource *)object {
    
    __block BOOL componentsEqual =
    self.components.count == object.components.count;

    if (componentsEqual) {
        
        NSMutableDictionary *selfComponentsByIdentifier = [NSMutableDictionary dictionary];
        NSMutableDictionary *objectComponentsByIdentifier = [NSMutableDictionary dictionary];
        
        for (AMComponent *component in self.components) {
            selfComponentsByIdentifier[component.identifier] = component;
        }
        
        for (AMComponent *component in object.components) {
            objectComponentsByIdentifier[component.identifier] = component;
        }
        
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
    [self.nameDictionary isEqualToDictionary:object.nameDictionary] &&
    componentsEqual;
}

#pragma mark - Getters and Setters

- (NSDictionary *)nameRegistry {
    return self.nameDictionary.copy;
}

- (void)setCanvasScale:(CGFloat)canvasScale {
    _canvasScale = canvasScale;
    
    for (AMComponent *component in self.components) {
        component.scale = canvasScale;
    }
}

- (NSMutableDictionary *)linkSourceDictionary {
    
    if (_linkSourceDictionary == nil) {
        _linkSourceDictionary = [NSMutableDictionary dictionary];
    }
    
    return _linkSourceDictionary;
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
        component.scale = self.canvasScale;
        [self.mutableComponents addObject:component];
        self.componentDictionary[component.identifier] = component;
        [self addComponents:component.childComponents toComponent:component];
    }
}

- (void)addComponents:(NSArray *)components {

    for (AMComponent *component in components) {
        [self addComponent:component];
    }
}

- (void)revertComponentsDictionary {
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    for (AMComponent *component in self.components) {
        [self addToComponentsDictionary:dictionary fromComponent:component];
    }
    
    self.componentDictionary = dictionary;
}

- (void)updateComponentLinks {
    [self establishLinksForComponents];
}

- (void)establishLinksForComponents {
    
    [self.linkSourceDictionary removeAllObjects];
    [self establishLinksForComponents:self.components];
}

- (void)establishLinksForComponents:(NSArray *)components {
    
    for (AMComponent *component in components) {
        
        if (component.linkedComponentIdentifier.length > 0) {
            
            component.linkedComponent =
            self.componentDictionary[component.linkedComponentIdentifier];
            
            if (component.linkedComponent != nil) {
                
                NSMutableArray *linkSources =
                self.linkSourceDictionary[component.linkedComponent.identifier];
                
                if (linkSources == nil) {
                    linkSources = [NSMutableArray array];
                    self.linkSourceDictionary[component.linkedComponent.identifier] = linkSources;
                }
                
                [linkSources addObject:component];
            }
        }
        
        [self establishLinksForComponents:component.childComponents];
    }
}

- (NSArray *)linkSourcesForTargetComponent:(AMComponent *)component {
    return [self.linkSourceDictionary[component.identifier] copy];
}

- (void)addToComponentsDictionary:(NSMutableDictionary *)dictionary fromComponent:(AMComponent *)component {
    
    dictionary[component.identifier] = component;
    
    [component.childComponents enumerateObjectsUsingBlock:^(AMComponent *childComponent, NSUInteger idx, BOOL *stop) {
        [self addToComponentsDictionary:dictionary fromComponent:childComponent];
    }];
}

- (void)insertComponent:(AMComponent *)insertedComponent
        beforeComponent:(AMComponent *)siblingComponent {
    
    insertedComponent.scale = self.canvasScale;
    
    if (siblingComponent.parentComponent != nil) {
        
        [siblingComponent.parentComponent
         insertChildComponent:insertedComponent
         beforeComponent:siblingComponent];
        
        self.componentDictionary[insertedComponent.identifier] = insertedComponent;
        [self addComponents:insertedComponent.childComponents toComponent:insertedComponent];
        
        return;
    }

    NSUInteger pos = [self.mutableComponents indexOfObject:siblingComponent];
    
    if (pos == NSNotFound) {
        pos = 0;
    }
    
    if ([self.mutableComponents containsObject:insertedComponent]) {
        [self.mutableComponents removeObject:insertedComponent];
    }
    
    [self.mutableComponents insertObject:insertedComponent atIndex:pos];
    self.componentDictionary[insertedComponent.identifier] = insertedComponent;
    [self addComponents:insertedComponent.childComponents toComponent:insertedComponent];
}

- (void)insertComponent:(AMComponent *)insertedComponent
         afterComponent:(AMComponent *)siblingComponent {
    
    if (siblingComponent.parentComponent != nil) {
        
        [siblingComponent.parentComponent
         insertChildComponent:insertedComponent
         afterComponent:siblingComponent];
        
        self.componentDictionary[insertedComponent.identifier] = insertedComponent;
        [self addComponents:insertedComponent.childComponents toComponent:insertedComponent];
                
        return;
    }

    NSArray *components = self.mutableComponents;
    
    NSUInteger pos = [components indexOfObject:siblingComponent];
    
    if (pos == NSNotFound) {
        pos = components.count-1;
    }
    
    pos++;
    pos = MIN(pos, components.count-1);
    
    if ([self.mutableComponents containsObject:insertedComponent]) {
        [self.mutableComponents removeObject:insertedComponent];
    }
    
    [self.mutableComponents insertObject:insertedComponent atIndex:pos];
    self.componentDictionary[insertedComponent.identifier] = insertedComponent;
    [self addComponents:insertedComponent.childComponents toComponent:insertedComponent];
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
    
    if (component.parentComponent != nil) {
        [component.parentComponent removeChildComponent:component];
    } else {
        [self.mutableComponents removeObject:component];
    }
    
    [self removeChildComponentFromComponentDictionary:component];
}

- (void)removeComponents:(NSArray *)components {
    
    for (AMComponent *component in components) {
        [self removeComponent:component];
    }
}

- (void)removeAllComponents {
    [self.mutableComponents removeAllObjects];
    [self.componentDictionary removeAllObjects];
}

- (void)addComponent:(AMComponent *)component toComponent:(AMComponent *)targetComponent {
    [targetComponent addChildComponent:component];
    self.componentDictionary[component.identifier] = component;
    [self addComponents:component.childComponents toComponent:component];
}

- (void)addComponents:(NSArray *)components toComponent:(AMComponent *)targetComponent {

    [targetComponent addChildComponents:components];
    for (AMComponent *component in components) {
        self.componentDictionary[component.identifier] = component;
        [self addComponents:component.childComponents toComponent:component];
    }
}

- (void)removeChildComponentFromComponentDictionary:(AMComponent *)component {

    [self.componentDictionary removeObjectForKey:component.identifier];
    [self removeChildComponentsFromComponentDictionary:component.childComponents];
}

- (void)removeChildComponentsFromComponentDictionary:(NSArray *)components {
    
    for (AMComponent *component in components) {

        [self.componentDictionary removeObjectForKey:component.identifier];
        [self removeChildComponentsFromComponentDictionary:component.childComponents];
    }
}

- (NSString *)description {

    NSMutableString *result = [NSMutableString string];
    
    [result appendFormat:@"DataSource: %p", self];
    
    for (AMComponent *component in self.components) {
        [self appendComponent:component toDescription:result level:0];
    }
    
    return result;
}

- (void)appendComponent:(AMComponent *)component toDescription:(NSMutableString *)string level:(NSUInteger)level {
    
    [string appendString:@"\n"];
    
    for (NSInteger i = 0; i < level; i++) {
        [string appendString:@"    "];
    }
    [string appendString:[component description]];
}

#pragma mark - Name Registry

- (void)registerName:(NSString *)name {

    NSDate *now = [NSDate date];
    
    AMNameEntity *nameEntity =
    [[AMNameEntity alloc] initWithName:name lastUsed:now];
    
    self.nameDictionary[name] = nameEntity;
    [self updateSearchResults];
}

- (NSArray *)nameCompletions:(NSString *)token {
    
    NSArray *result = self.nameSearchResults[token];
    
    if (result == nil) {
        result = [self searchNameRegistry:token];
    }
    
    return result;
}

- (void)updateSearchResults {
    
    for (NSString *token in self.nameSearchResults.allKeys.copy) {
        [self updateSearchResult:token];
    }
}

- (void)updateSearchResult:(NSString *)token {
    
    NSArray *result = [self searchNameRegistry:token];
    
    if (result.count > 0) {
        self.nameSearchResults[token] = result;
    } else {
        [self.nameSearchResults removeObjectForKey:token];
    }
}

- (NSArray *)searchNameRegistry:(NSString *)token {
    
    NSMutableArray *result = [NSMutableArray array];
    NSString *lowerCaseToken = token.lowercaseString;
    
    for (AMNameEntity *nameEntity in self.nameDictionary.allValues.copy) {
        
        if ([nameEntity.name.lowercaseString hasPrefix:lowerCaseToken]) {
            [result addObject:nameEntity];
        }
    }
    
    NSSortDescriptor *sorter =
    [NSSortDescriptor sortDescriptorWithKey:@"lastUsed" ascending:NO];
    
    [result sortUsingDescriptors:@[sorter]];
    
    NSArray *nameResult = [result valueForKey:@"name"];
    
    return nameResult;
}

@end
