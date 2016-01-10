//
//  AMExpandingLayout.m
//  AppMap
//
//  Created by Nick Bolton on 1/1/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "AMExpandingLayout.h"

@interface AMExpandingLayout()

@property (nonatomic, strong) NSArray *constraints;

@end

@implementation AMExpandingLayout

- (void)clearLayout {
    [super clearLayout];
    
    if (self.constraints.count > 0) {
        [self.view.superview removeConstraints:self.constraints];
    }
    self.constraints = nil;
}

- (void)createConstraintsIfNecessaryWithMultiplier:(CGFloat)multiplier
                                          priority:(AMLayoutPriority)priority {
    
    if (self.constraints == nil && self.view.superview != nil) {
        
        NSArray *hConstraints =
        [NSLayoutConstraint
         constraintsWithVisualFormat:@"H:|-(0)-[v]-(0)-|"
         options:NSLayoutFormatAlignAllCenterX
         metrics:nil
         views:@{@"v" : self.view}];
        [NSLayoutConstraint activateConstraints:hConstraints];

        NSArray *vConstraints =
        [NSLayoutConstraint
         constraintsWithVisualFormat:@"V:|-(0)-[v]-(0)-|"
         options:NSLayoutFormatAlignAllCenterY
         metrics:nil
         views:@{@"v" : self.view}];
        [NSLayoutConstraint activateConstraints:hConstraints];

        NSMutableArray *constraints = [NSMutableArray arrayWithArray:hConstraints];
        [constraints addObjectsFromArray:vConstraints];
        
        self.constraints = constraints;
    }
}

@end
