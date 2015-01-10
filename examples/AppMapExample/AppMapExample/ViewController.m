//
//  ViewController.m
//  AppMapExample
//
//  Created by Nick Bolton on 1/9/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "ViewController.h"
#import "AMAppMap.h"
#import "PBcontainer0ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =
    [UIColor
     colorWithRed:0.6352941176f
     green:0.6784313725f
     blue:0.7215686275f
     alpha:1.0f];
    
//    [[AMAppMap sharedInstance]
//     buildViewFromResourceName:@"rootView"
//     componentName:@"container0"
//     inContainer:self.view];
//    
//    [[AMAppMap sharedInstance]
//     buildViewFromResourceName:@"rootView"
//     componentName:@"container1"
//     inContainer:self.view];
    
    PBContainer0ViewController *viewController =
    [PBContainer0ViewController new];
    
    UIView *view = viewController.view;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addChildViewController:viewController];
    [self.view addSubview:view];
    [viewController didMoveToParentViewController:self];
    
    NSArray *hConstraints =
    [NSLayoutConstraint
     constraintsWithVisualFormat:@"H:|-(0)-[v]-(0)-|"
     options:NSLayoutFormatAlignAllCenterX
     metrics:nil
     views:@{@"v" : view}];
    [view.superview addConstraints:hConstraints];
    
    NSArray *vConstraints =
    [NSLayoutConstraint
     constraintsWithVisualFormat:@"V:|-(0)-[v]-(0)-|"
     options:NSLayoutFormatAlignAllCenterY
     metrics:nil
     views:@{@"v" : view}];
    [view.superview addConstraints:vConstraints];
    
    viewController.container0View.backgroundColor = [UIColor redColor];
    viewController.container0View.container1View.backgroundColor = [UIColor greenColor];
}

@end
