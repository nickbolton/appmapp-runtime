//
//  ViewController.m
//  AppMapExample
//
//  Created by Nick Bolton on 5/28/15.
//  Copyright (c) 2015 Pixelbleed. All rights reserved.
//

#import "ViewController.h"
#import "AppMap.h"
#import "PBRootViewViewController.h"
#import "PBRootViewView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    PBRootViewViewController *viewController = [PBRootViewViewController new];
    
    UINavigationController *navigationController =
    [[UINavigationController alloc]
     initWithRootViewController:viewController];
    
    UIView *view = navigationController.view;
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    view.frame = self.view.bounds;
    
    [self addChildViewController:navigationController];
    [self.view addSubview:view];
    [navigationController didMoveToParentViewController:self];
}

//- (void)loadView {
//    PBRootViewView *view = [PBRootViewView new];
//    self.view = view;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
