//
//  AMCompositeTextDescriptor.m
//  AppMap
//
//  Created by Nick Bolton on 1/3/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMCompositeTextDescriptor.h"

static NSString * const kAMBaseTextDescriptorTextDescriptorsKey = @"textDescriptors";

@interface AMCompositeTextDescriptor()

@property (nonatomic, strong) NSMutableArray *textDescriptors;
@property (nonatomic, strong) NSAttributedString *compositeAttributedString;

@end

@implementation AMCompositeTextDescriptor

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        self.textDescriptors = [decoder decodeObjectForKey:kAMBaseTextDescriptorTextDescriptorsKey];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    
    self = [super initWithDictionary:dict];
    
    if (self != nil) {

        NSMutableArray *textDescriptors = [NSMutableArray array];
        NSArray *descriptors = dict[kAMBaseTextDescriptorTextDescriptorsKey];
        [descriptors enumerateObjectsUsingBlock:^(NSDictionary *descriptorDict, NSUInteger idx, BOOL *stop) {
            
            NSString *className = descriptorDict[kAMBaseTextDescriptorClassNameKey];
            
            AMTextDescriptor *textDescriptor =
            [[NSClassFromString(className) alloc] initWithDictionary:descriptorDict];
            
            [textDescriptors addObject:textDescriptor];
        }];
        
        self.textDescriptors = textDescriptors;
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    [coder encodeObject:self.textDescriptors forKey:kAMBaseTextDescriptorTextDescriptorsKey];
}

- (instancetype)copy {
    
    AMCompositeTextDescriptor *result = [AMCompositeTextDescriptor new];
    result.textDescriptors = self.textDescriptors.mutableCopy;
    
    return result;
}

- (NSDictionary *)exportTextDescriptor {
    
    NSMutableDictionary *dict = [[super exportTextDescriptor] mutableCopy];
    NSMutableArray *descriptors = [NSMutableArray array];
    
    [self.textDescriptors enumerateObjectsUsingBlock:^(AMTextDescriptor *descriptor, NSUInteger idx, BOOL *stop) {
        [descriptors addObject:[descriptor exportTextDescriptor]];
    }];
    
    return dict;
}

#pragma mark - Getters and Setters

- (NSMutableArray *)textDescriptors {
    
    if (_textDescriptors == nil) {
        _textDescriptors = [NSMutableArray array];
    }
    
    return _textDescriptors;
}

- (void)setKerning:(CGFloat)kerning {
    [super setKerning:kerning];
    
    [self.textDescriptors enumerateObjectsUsingBlock:^(AMTextDescriptor *textDescriptor, NSUInteger idx, BOOL *stop) {
        textDescriptor.kerning = kerning;
    }];
    
    self.compositeAttributedString = nil;
}

- (void)setFont:(id)font {
    [super setFont:font];
    
    [self.textDescriptors enumerateObjectsUsingBlock:^(AMTextDescriptor *textDescriptor, NSUInteger idx, BOOL *stop) {
        textDescriptor.font = font;
    }];
    
    self.compositeAttributedString = nil;
}

- (void)setLeading:(CGFloat)leading {
    [super setLeading:leading];
    
    [self.textDescriptors enumerateObjectsUsingBlock:^(AMTextDescriptor *textDescriptor, NSUInteger idx, BOOL *stop) {
        textDescriptor.leading = leading;
    }];
    
    self.compositeAttributedString = nil;
}

- (void)setTextColor:(id)textColor {
    [super setTextColor:textColor];
    
    [self.textDescriptors enumerateObjectsUsingBlock:^(AMTextDescriptor *textDescriptor, NSUInteger idx, BOOL *stop) {
        textDescriptor.textColor = textColor;
    }];
    
    self.compositeAttributedString = nil;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    
    [self.textDescriptors enumerateObjectsUsingBlock:^(AMTextDescriptor *textDescriptor, NSUInteger idx, BOOL *stop) {
        textDescriptor.textAlignment = textAlignment;
    }];
    
    self.compositeAttributedString = nil;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    
    [self.textDescriptors enumerateObjectsUsingBlock:^(AMTextDescriptor *textDescriptor, NSUInteger idx, BOOL *stop) {
        textDescriptor.text = text;
    }];
    
    self.compositeAttributedString = nil;
}

- (void)setBaselineAdjustment:(CGFloat)baselineAdjustment {
    [super setBaselineAdjustment:baselineAdjustment];
    
    [self.textDescriptors enumerateObjectsUsingBlock:^(AMTextDescriptor *textDescriptor, NSUInteger idx, BOOL *stop) {
        textDescriptor.baselineAdjustment = baselineAdjustment;
    }];
    
    self.compositeAttributedString = nil;
}

- (void)setUnderline:(BOOL)underline {
    [super setUnderline:underline];
    
    [self.textDescriptors enumerateObjectsUsingBlock:^(AMTextDescriptor *textDescriptor, NSUInteger idx, BOOL *stop) {
        textDescriptor.underline = underline;
    }];
    
    self.compositeAttributedString = nil;
}

- (NSAttributedString *)attributedString {

    if (self.textDescriptors.count > 0) {
        
        if (_compositeAttributedString == nil) {
            
            NSMutableAttributedString *attributedString =
            [NSMutableAttributedString new];
            
            [self.textDescriptors enumerateObjectsUsingBlock:^(AMTextDescriptor *textDescriptor, NSUInteger idx, BOOL *stop) {                
                [attributedString appendAttributedString:textDescriptor.attributedString];
            }];
            
            _compositeAttributedString = attributedString;
        }
        
        return _compositeAttributedString;
    }
    
    return super.attributedString;
}

#pragma mark - Public

- (void)clearCache {
    [super clearCache];
    self.compositeAttributedString = nil;
}

- (void)addTextDescriptor:(AMTextDescriptor *)textDescriptor {
    [self.textDescriptors addObject:textDescriptor];
    [self clearCache];
}
- (void)removeTextDescriptor:(AMTextDescriptor *)textDescriptor {
    [self.textDescriptors removeObject:textDescriptor];
    [self clearCache];
}

@end
