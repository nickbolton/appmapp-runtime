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

- (AMLayoutType)layoutType {
    return AMLayoutTypeExpanding;
}

- (void)clearLayout {
    [super clearLayout];
    
    [self.view.superview removeConstraints:self.constraints];
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
        [self.view.superview addConstraints:hConstraints];

        NSArray *vConstraints =
        [NSLayoutConstraint
         constraintsWithVisualFormat:@"V:|-(0)-[v]-(0)-|"
         options:NSLayoutFormatAlignAllCenterY
         metrics:nil
         views:@{@"v" : self.view}];
        [self.view.superview addConstraints:vConstraints];

        NSMutableArray *constraints = [NSMutableArray arrayWithArray:hConstraints];
        [constraints addObjectsFromArray:vConstraints];
        
        self.constraints = constraints;
    }
}

- (void)updateLayoutWithFrame:(CGRect)frame
                   multiplier:(CGFloat)multiplier
                     priority:(AMLayoutPriority)priority
                  parentFrame:(CGRect)parentFrame
             allLayoutObjects:(NSArray *)allLayoutObjects
                       inView:(AMView *)view {
    [super
     updateLayoutWithFrame:frame
     multiplier:multiplier
     priority:priority
     parentFrame:parentFrame
     allLayoutObjects:allLayoutObjects
     inView:view];

    [self applyConstraintIfNecessary];
}

@end
