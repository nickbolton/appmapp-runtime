//
//  AMComponent.m
//  AppMapTest
//
//  Created by Nick Bolton on 8/1/14.
//  Copyright (c) 2014 Nick Bolton. All rights reserved.
//

#import "AMComponent.h"
#import "AMImageAsset.h"
#import "AMLayerFactory.h"
#import "AMLayerDescriptor.h"
#import "AMVynthLayerDescriptor.h"

#if TARGET_OS_IPHONE
#import "AMIBuilderView.h"
#else
#import "AMMBuilderView.h"
#import "AMPhotoshopManager.h"
#endif

static NSString * kAMComponentNameKey = @"name";
static NSString * kAMComponentTypeKey = @"type";
static NSString * kAMComponentIdentifierKey = @"identifier";
static NSString * kAMComponentClippedKey = @"clipped";
static NSString * kAMComponentBackgroundColorKey = @"backgroundColor";
static NSString * kAMComponentAlphaKey = @"alpha";
static NSString * kAMComponentBlurRadiusKey = @"blurRadius";
static NSString * kAMComponentBaseCenterKey = @"baseCenter";
static NSString * kAMComponentBaseSizeKey = @"baseSize";
static NSString * kAMComponentCornerRadiusKey = @"cornerRadius";
static NSString * kAMComponentBackingFileEnabledKey = @"backingFileEnabled";
static NSString * kAMComponentBackingFilePrefixKey = @"backingFilePrefix";
static NSString * kAMComponentBackingFileTimestampKey = @"backingFileTimestamp";
static NSString * kAMComponentBackingFileDataKey = @"backingFileData";
static NSString * kAMComponentBackingFileAssetKey = @"backingFileAsset";
static NSString * kAMComponentLayerStylesAboveBaseKey = @"layerStylesAboveBase";
static NSString * kAMComponentLayerStylesBelowBaseKey = @"layerStylesBelowBase";
static NSString * kAMComponentChildComponentsKey = @"childComponents";

@interface AMComponent()

@property (nonatomic, readwrite) NSString *backingFile;
@property (nonatomic, strong) NSMutableArray *primLayerStylesAboveBase;
@property (nonatomic, strong) NSMutableArray *primLayerStylesBelowBase;
@property (nonatomic, strong) NSMutableArray *primChildComponents;
@property (nonatomic, readwrite) NSString *defaultName;
@property (nonatomic, strong) AMLayerDescriptor *baseViewLayerDescriptor;

@end

@implementation AMComponent

- (void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeObject:self.name forKey:kAMComponentNameKey];
    [coder encodeInt32:self.componentType forKey:kAMComponentTypeKey];
    [coder encodeObject:self.identifier forKey:kAMComponentIdentifierKey];
    [coder encodeObject:NSStringFromCGPoint(self.baseCenter) forKey:kAMComponentBaseCenterKey];
    [coder encodeObject:NSStringFromCGSize(self.baseSize) forKey:kAMComponentBaseSizeKey];
    [coder encodeBool:self.isClipped forKey:kAMComponentClippedKey];
    [coder encodeObject:self.backgroundColor forKey:kAMComponentBackgroundColorKey];
    [coder encodeFloat:self.alpha forKey:kAMComponentAlphaKey];
    [coder encodeFloat:self.blurRadius forKey:kAMComponentBlurRadiusKey];
    [coder encodeFloat:self.cornerRadius forKey:kAMComponentCornerRadiusKey];
    [coder encodeBool:self.backingFileEnabled forKey:kAMComponentBackingFileEnabledKey];
    [coder encodeObject:self.backingFilePrefix forKey:kAMComponentBackingFilePrefixKey];
    [coder encodeFloat:self.backingFileTimestamp forKey:kAMComponentBackingFileTimestampKey];
    [coder encodeObject:self.backingFileData forKey:kAMComponentBackingFileDataKey];
    [coder encodeObject:self.backingImage forKey:kAMComponentBackingFileAssetKey];
    [coder encodeObject:self.layerStylesAboveBase forKey:kAMComponentLayerStylesAboveBaseKey];
    [coder encodeObject:self.layerStylesBelowBase forKey:kAMComponentLayerStylesBelowBaseKey];
    [coder encodeObject:self.childComponents forKey:kAMComponentChildComponentsKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    
    if (self != nil) {

        self.name = [decoder decodeObjectForKey:kAMComponentNameKey];
        self.componentType = [decoder decodeInt32ForKey:kAMComponentTypeKey];
        self.identifier = [decoder decodeObjectForKey:kAMComponentIdentifierKey];
        self.baseCenter = CGPointFromString([decoder decodeObjectForKey:kAMComponentBaseCenterKey]);
        self.baseSize = CGSizeFromString([decoder decodeObjectForKey:kAMComponentBaseSizeKey]);
        self.clipped = [decoder decodeBoolForKey:kAMComponentClippedKey];
        self.backgroundColor = [decoder decodeObjectForKey:kAMComponentBackgroundColorKey];
        self.alpha = [decoder decodeFloatForKey:kAMComponentAlphaKey];
        self.blurRadius = [decoder decodeFloatForKey:kAMComponentBlurRadiusKey];
        self.cornerRadius = [decoder decodeFloatForKey:kAMComponentCornerRadiusKey];
        self.backingFileEnabled = [decoder decodeBoolForKey:kAMComponentBackingFileEnabledKey];
        self.backingFilePrefix = [decoder decodeObjectForKey:kAMComponentBackingFilePrefixKey];
        self.backingFileTimestamp = [decoder decodeFloatForKey:kAMComponentBackingFileTimestampKey];
        self.backingFileData = [decoder decodeObjectForKey:kAMComponentBackingFileDataKey];
        self.backingImage = [decoder decodeObjectForKey:kAMComponentBackingFileAssetKey];
        self.layerStylesAboveBase = [decoder decodeObjectForKey:kAMComponentLayerStylesAboveBaseKey];
        self.layerStylesBelowBase = [decoder decodeObjectForKey:kAMComponentLayerStylesBelowBaseKey];
        
        NSArray *childComponents =
        [decoder decodeObjectForKey:kAMComponentChildComponentsKey];
        
        [self addChildComponents:childComponents];
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return [self copy];
}

- (id)copy {
    
    AMComponent *component = [[AMComponent alloc] init];
    component.identifier = self.identifier.copy;
    component.baseCenter = self.baseCenter;
    component.baseSize = self.baseSize;
    component.componentType = self.componentType;
    component.backingFilePrefix = self.backingFilePrefix.copy;
    component.backingImage = self.backingImage.copy;
    component.backingFileData = self.backingFileData.copy;
    component.backingFile = self.backingFile.copy;
    component.primLayerStylesAboveBase = self.primLayerStylesAboveBase.mutableCopy;
    component.primLayerStylesBelowBase = self.primLayerStylesBelowBase.mutableCopy;
    component.baseViewLayerDescriptor = self.baseViewLayerDescriptor.copy;
    component.childComponents = self.primChildComponents.mutableCopy;
    component.clipped = self.isClipped;
    component.backgroundColor = self.backgroundColor;
    component.alpha = self.alpha;
    component.blurRadius = self.blurRadius;
    
    return component;
}

+ (AMComponent *)buildComponent {

    static NSInteger typeIndex = 0;
    
    AMComponent *component = [[AMComponent alloc] init];
    component.identifier = [NSString uuidString];
    component.componentType = AMComponentContainer;
    
    AMVynthLayerDescriptor *descriptor =
    [[AMLayerFactory sharedInstance]
     buildLayerDescriptorOfType:AMLayerTypeVynth];
    
    descriptor.color = [UIColor blackColor];
    descriptor.insets = UIEdgeInsetsMake(10.0f, 10.0f, -10.0f, -10.0f);
    descriptor.alpha = 1.0f;
    descriptor.behind = YES;
    descriptor.clipped = NO;
    descriptor.blurRadius = 10.0f;
    descriptor.type = AMVynthTypeNormal;
    
//    [component addLayerStyle:descriptor];
    
#define ARC4RANDOM_MAX      0x100000000

    double r = ((double)arc4random() / ARC4RANDOM_MAX);
    double g = ((double)arc4random() / ARC4RANDOM_MAX);
    double b = ((double)arc4random() / ARC4RANDOM_MAX);
    
    r = roundf(r * 255.0f) / 255.0f;
    g = roundf(g * 255.0f) / 255.0f;
    b = roundf(b * 255.0f) / 255.0f;
    
    component.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1.0f];
    component.alpha = 1.0f;

//    switch (typeIndex) {
//        case 1:
//            descriptor.behind = NO;
//            descriptor.clipped = YES;
//            break;
//
//        case 2:
//            descriptor.behind = NO;
//            descriptor.clipped = YES;
//            descriptor.type = AMVynthTypeInverted;
//            break;
//
//        case 3:
//            descriptor.insets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
//            descriptor.behind = NO;
//            break;
//
//        case 4:
//            descriptor.behind = NO;
//            break;
//
//        default:
//            break;
//    }

    typeIndex = (typeIndex+1) % 5;
    
//    [component addLayerStyle:descriptor];
    
    return component;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Component: %@, %@, %d", self.name, self.identifier, self.componentType];
}

#pragma mark - Getters and Setters

- (NSString *)name {
    if (_name != nil) {
        return _name;
    }
    return self.defaultName;
}

- (NSString *)defaultName {
    
    if (_defaultName == nil) {
        
        static NSInteger index = 0;
        
        _defaultName = [NSString stringWithFormat:@"Container-%d", index++];
    }
    
    return _defaultName;
}

- (Class)viewClass {
#if TARGET_OS_IPHONE
    return [AMIBuilderView class];
#else
    return [AMMBuilderView class];
#endif
}

- (NSString *)backingFile {
    
    if (self.backingFileEnabled && _backingFile == nil) {
        
        __weak typeof(self) this = self;
        
        [self updateBackingFile:^(NSError *error) {
            
            if (error != nil) {
                PBLog(@"Error updating backing file: %@", error);
                this.backingFile = nil;
            }
        }];
    }
    
    return _backingFile;
}

- (BOOL)backingFileEnabled {
    return NO;
}

- (AMLayerDescriptor *)baseViewLayerDescriptor {
    
    if (_baseViewLayerDescriptor == nil) {
    
        AMVynthLayerDescriptor *descriptor =
        [[AMLayerFactory sharedInstance]
         buildLayerDescriptorOfType:AMLayerTypeVynth];
        
        descriptor.color = self.backgroundColor;
        descriptor.base = YES;
        descriptor.blurRadius = self.blurRadius;
        
        _baseViewLayerDescriptor = descriptor;
    }
    
    return _baseViewLayerDescriptor;
}

- (void)setBlurRadius:(CGFloat)blurRadius {
    _blurRadius = blurRadius;
    self.baseViewLayerDescriptor.blurRadius = blurRadius;
}

- (NSArray *)layerStylesAboveBase {
    return [NSArray arrayWithArray:self.primLayerStylesAboveBase];
}

- (NSArray *)layerStylesBelowBase {
    return [NSArray arrayWithArray:self.primLayerStylesBelowBase];
}

- (void)setLayerStylesAboveBase:(NSArray *)layerStylesAboveBase {

    NSMutableArray *primStyles = self.primLayerStylesAboveBase;
    [primStyles removeAllObjects];
    [primStyles addObjectsFromArray:layerStylesAboveBase];
}

- (void)setLayerStylesBelowBase:(NSArray *)layerStylesBelowBase {
    
    NSMutableArray *primStyles = self.primLayerStylesBelowBase;
    [primStyles removeAllObjects];
    [primStyles addObjectsFromArray:layerStylesBelowBase];
}

- (NSMutableArray *)primLayerStylesAboveBase {
    
    if (_primLayerStylesAboveBase == nil) {
        _primLayerStylesAboveBase = [NSMutableArray array];
    }
    return _primLayerStylesAboveBase;
}

- (NSMutableArray *)primLayerStylesBelowBase {
    
    if (_primLayerStylesBelowBase == nil) {
        _primLayerStylesBelowBase = [NSMutableArray array];
    }
    return _primLayerStylesBelowBase;
}

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

#pragma mark - Public

- (void)addNewLayerStyle {
    
    AMLayerDescriptor *lastDescriptor = self.primLayerStylesBelowBase.lastObject;
    
    if (lastDescriptor == nil) {
        lastDescriptor = self.baseViewLayerDescriptor;
    }
    
    [self insertNewLayerStyleAfterStyle:lastDescriptor];
}

//- (void)insertNewLayerStyleAtIndex:(NSUInteger)index {
//
//    AMVynthLayerDescriptor *descriptor =
//    [[AMLayerFactory sharedInstance]
//     buildLayerDescriptorOfType:AMLayerTypeVynth];
//
//    index = MIN(index, self.layerStyles.count);
//    
//    descriptor.behind = index >= self.layerStylesAboveBase.count;
//    
//    [self.primLayerStyles insertObject:descriptor atIndex:index];
//}

- (void)insertLayerStyle:(AMLayerDescriptor *)descriptor
             beforeStyle:(AMLayerDescriptor *)nextDescriptor {
    
    if (nextDescriptor == self.baseViewLayerDescriptor) {
        
        descriptor.behind = NO;
        [self.primLayerStylesAboveBase addObject:descriptor];
        
    } else {
        
        NSUInteger index =
        [self.primLayerStylesAboveBase indexOfObject:nextDescriptor];
        
        if (index != NSNotFound) {
            
            descriptor.behind = NO;
            [self.primLayerStylesAboveBase insertObject:descriptor atIndex:index];
            
        } else {
            
            index =
            [self.primLayerStylesBelowBase indexOfObject:nextDescriptor];
            
            if (index != NSNotFound) {
                
                descriptor.behind = YES;
                [self.primLayerStylesBelowBase insertObject:descriptor atIndex:index];
                
            } else {
                
                descriptor.behind = YES;
                [self.primLayerStylesBelowBase addObject:descriptor];
            }
        }
    }
}

- (void)insertLayerStyle:(AMLayerDescriptor *)descriptor
              afterStyle:(AMLayerDescriptor *)prevDescriptor {
    
    if (prevDescriptor == self.baseViewLayerDescriptor) {
        
        descriptor.behind = YES;
        [self.primLayerStylesBelowBase insertObject:descriptor atIndex:0];
        
    } else {
        
        NSUInteger index =
        [self.primLayerStylesBelowBase indexOfObject:prevDescriptor];
        
        if (index != NSNotFound) {
            
            descriptor.behind = YES;
            [self.primLayerStylesBelowBase insertObject:descriptor atIndex:index+1];
            
        } else {
            
            index =
            [self.primLayerStylesAboveBase indexOfObject:prevDescriptor];
            
            if (index != NSNotFound) {
                
                descriptor.behind = NO;
                [self.primLayerStylesAboveBase insertObject:descriptor atIndex:index+1];
                
            } else {
                
                descriptor.behind = NO;
                [self.primLayerStylesAboveBase insertObject:descriptor atIndex:0];
            }
        }
    }
}

- (void)insertNewLayerStyleBeforeStyle:(AMLayerDescriptor *)nextDescriptor {

    AMVynthLayerDescriptor *descriptor =
    [[AMLayerFactory sharedInstance]
     buildLayerDescriptorOfType:AMLayerTypeVynth];
    
    descriptor.color = [UIColor blackColor];
    descriptor.insets = UIEdgeInsetsMake(10.0f, 10.0f, -10.0f, -10.0f);

    [self insertLayerStyle:descriptor beforeStyle:nextDescriptor];
}

- (void)insertNewLayerStyleAfterStyle:(AMLayerDescriptor *)prevDescriptor {
    
    AMVynthLayerDescriptor *descriptor =
    [[AMLayerFactory sharedInstance]
     buildLayerDescriptorOfType:AMLayerTypeVynth];
    
    descriptor.color = [UIColor blackColor];
    descriptor.insets = UIEdgeInsetsMake(10.0f, 10.0f, -10.0f, -10.0f);

    [self insertLayerStyle:descriptor afterStyle:prevDescriptor];
}

- (void)moveLayerStyle:(AMLayerDescriptor *)descriptor
           beforeStyle:(AMLayerDescriptor *)nextDescriptor {
    
    [self.primLayerStylesAboveBase removeObject:descriptor];
    [self.primLayerStylesBelowBase removeObject:descriptor];
    [self insertLayerStyle:descriptor beforeStyle:nextDescriptor];
}

- (void)moveLayerStyle:(AMLayerDescriptor *)descriptor
            afterStyle:(AMLayerDescriptor *)prevDescriptor {
    
    [self.primLayerStylesAboveBase removeObject:descriptor];
    [self.primLayerStylesBelowBase removeObject:descriptor];
    [self insertLayerStyle:descriptor afterStyle:prevDescriptor];
}

- (void)addLayerStyle:(AMLayerDescriptor *)descriptor {
    if (descriptor != nil) {
        descriptor.behind = YES;
        [self.primLayerStylesBelowBase addObject:descriptor];
    }
}

- (void)removeLayerStyle:(AMLayerDescriptor *)descriptor {
    if (descriptor != nil) {
        [self.primLayerStylesBelowBase removeObject:descriptor];
        [self.primLayerStylesAboveBase removeObject:descriptor];
    }
}

- (void)addChildComponent:(AMComponent *)component {
    if (component != nil) {
        [self addChildComponents:@[component]];
    }
}

- (void)addChildComponents:(NSArray *)components {

    NSMutableArray *primComponents = self.primChildComponents;

    [components enumerateObjectsUsingBlock:^(AMComponent *component, NSUInteger idx, BOOL *stop) {
        
        if ([primComponents containsObject:component] == NO) {
            [primComponents addObject:component];
        }
        
        component.parentComponent = self;
    }];
}

- (void)insertChildComponent:(AMComponent *)insertedComponent
             beforeComponent:(AMComponent *)siblingComponent {
    
    NSMutableArray *primComponents = self.primChildComponents;

    NSUInteger pos = [primComponents indexOfObject:siblingComponent];
    
    if (pos == NSNotFound) {
        pos = 0;
    }
    
    if ([primComponents containsObject:insertedComponent]) {
        [primComponents removeObject:insertedComponent];
    }
    
    [primComponents insertObject:insertedComponent atIndex:pos];
}

- (void)removeChildComponent:(AMComponent *)component {
    if (component != nil) {
        [self removeChildComponents:@[component]];
    }
}

- (void)removeChildComponents:(NSArray *)components {
    [self.primChildComponents removeObjectsInArray:components];
    
    [components enumerateObjectsUsingBlock:^(AMComponent *component, NSUInteger idx, BOOL *stop) {
        component.parentComponent = nil;
    }];
}

#if TARGET_OS_IPHONE == 0
- (void)importBackingImage {
    
    if (self.backingFileEnabled) {
        
        NSDictionary *errorDict = nil;
        
        UIImage *image =
        [[AMPhotoshopManager sharedInstance]
         exportDocumentAtPath:self.backingFile
         error:&errorDict];
        
        if (errorDict != nil) {
            [self.delegate component:self photoshopError:errorDict];
            return;
        }
        
        self.backingImage =
        [[UIImageAsset alloc]
         initWithName:self.identifier
         image:image
         scale:2.0f];
        
        self.hasBackingFileChanges = NO;
        
        [self.delegate component:self updatedBackingImage:self.backingImage];
    }
}

#endif

- (void)importBackingFile {
    
    if (self.backingFileEnabled && self.backingFile.length > 0) {
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath:self.backingFile]) {
            
            self.backingFileData =
            [NSData dataWithContentsOfFile:self.backingFile];
        }
    }
}

- (void)closeBackingFile {
    
    if (self.backingFileEnabled && self.backingFile.length > 0) {
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath:self.backingFile]) {
            
            NSError *error = nil;
            [fileManager removeItemAtPath:self.backingFile error:&error];
            
            if (error != nil) {
                PBLog(@"Error: %@", error);
            }
        }
    }
}

- (BOOL)isEqualToComponent:(AMComponent *)object {
    return
    [self.identifier isEqualToString:object.identifier];
}

#pragma mark - Private

- (void)updateBackingFile:(void(^)(NSError *error))completion {

    if (self.backingFileEnabled) {
        
        if (self.backingFilePrefix.length > 0 &&
            self.identifier.length > 0) {
            
            self.backingFile =
            [self.backingFilePrefix stringByAppendingString:self.identifier];
            
            self.backingFile =
            [self.backingFile stringByAppendingPathExtension:@"psd"];
            
#if TARGET_OS_IPHONE == 0
            [self setupBackingFile:completion];
#endif
            
        } else {
            
            if (completion != nil) {
                
                NSError *error =
                [[NSError alloc]
                 initWithDomain:@"appmap"
                 code:-1
                 userInfo:@{NSLocalizedDescriptionKey : @"Component not prepared."}];
                
                completion(error);
            }
        }
        
    } else {
        
        if (completion != nil) {
            completion(nil);
        }
    }
}

#if TARGET_OS_IPHONE == 0
- (void)setupBackingFile:(void(^)(NSError *error))completion {
    
    if (self.backingFileEnabled) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSDictionary *errorDict = nil;
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:self.backingFile] == NO) {
                
                [[AMPhotoshopManager sharedInstance]
                 createDocumentAtPath:self.backingFile
                 withSize:self.frame.size
                 error:&errorDict];
            }
            
            if (completion != nil) {
                
                NSError *error = nil;
                
                if (errorDict != nil) {
                    
                    error =
                    [[NSError alloc]
                     initWithDomain:@"appmap"
                     code:-1
                     userInfo:errorDict];
                    
                    PBLog(@"Error: %@", error);
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(error);                
                });
            }
        });
        
    } else {
        
        if (completion != nil) {
            completion(nil);
        }
    }
}
#endif

@end
