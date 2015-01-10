// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PBcontainer0ViewController.m instead.

#import "_PBcontainer0ViewController.h"
#import "AMAppMap.h"

@interface _PBcontainer0ViewController ()

@property (nonatomic, strong) AMComponent *component;
@property (nonatomic, readwrite) UIView *container0;
@property (nonatomic, readwrite) UIView *container1;

@end

@implementation _PBcontainer0ViewController

#pragma mark - Setup

- (void)_setupComponent {
    
    NSDictionary *componentDict =
    @{
        @"borderColor" : @"0.403922,0.458824,0.513726,1.000000",
        @"frame" : @"{{134, 121}, {371, 402}}",
        @"backgroundColor" : @"0.874510,0.894118,0.913725,0.700000",
        @"class-name" : @"AMComponent",
        @"layoutType" : @(0),
        @"identifier" : @"D11CB32E-6FC9-4CFF-B860-5DE288B06879",
        @"clipped" : @(0),
        @"borderWidth" : @(1),
        @"alpha" : @(1),
        @"cornerRadius" : @(2),
        @"name" : @"Container-0",
        @"childComponents" : @[
            @{
            @"borderColor" : @"0.403922,0.458824,0.513726,1.000000",
            @"frame" : @"{{41.15625, 292.99609375}, {81.84375, 78}}",
            @"backgroundColor" : @"0.874510,0.894118,0.913725,0.700000",
            @"class-name" : @"AMComponent",
            @"layoutType" : @(0),
            @"identifier" : @"CA14459F-C53D-47AC-92E8-6423FA5BA7A8",
            @"clipped" : @(0),
            @"borderWidth" : @(1),
            @"alpha" : @(1),
            @"cornerRadius" : @(2),
            @"name" : @"Container-0",
            @"childComponents" : @[],
        },
@{
            @"borderColor" : @"0.403922,0.458824,0.513726,1.000000",
            @"frame" : @"{{123, 125}, {123, 127}}",
            @"backgroundColor" : @"0.874510,0.894118,0.913725,0.700000",
            @"class-name" : @"AMComponent",
            @"layoutType" : @(0),
            @"identifier" : @"C21EEDEE-33DA-4779-8E03-EA9E0935B743",
            @"clipped" : @(0),
            @"borderWidth" : @(1),
            @"alpha" : @(1),
            @"cornerRadius" : @(2),
            @"name" : @"Container-1",
            @"childComponents" : @[],
        },
        ],
    };
    
    self.component =
    [[AMAppMap sharedInstance]
     loadComponentWithDictionary:componentDict];
}

- (void)_setupRootView {
    
    [[AMAppMap sharedInstance]
     buildViewFromComponent:self.component
     inContainer:self.view
     bindingObject:self];
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupComponent];
    [self _setupRootView];
}

@end
