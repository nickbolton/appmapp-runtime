//
//  ViewController.m
//  AppMapExample
//
//  Created by Nick Bolton on 1/9/15.
//  Copyright (c) 2015 Pixelbleed LLC. All rights reserved.
//

#import "ViewController.h"
#import "AMAppMap.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [[AMAppMap sharedInstance]
     buildViewFromResourceName:@"rootView"
     componentName:@"container0"
     inContainer:self.view];
    
    [[AMAppMap sharedInstance]
     buildViewFromResourceName:@"rootView"
     componentName:@"container1"
     inContainer:self.view];
}

@end
