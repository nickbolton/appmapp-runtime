// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PBContainer0ViewController.m instead.

#import "_PBContainer0ViewController.h"
#import "AMAppMap.h"

@interface _PBContainer0ViewController ()

@property (nonatomic, strong) AMComponent *component;
@property (nonatomic, readwrite) PBContainer0View *container0View;
@end

@implementation _PBContainer0ViewController

#pragma mark - Setup

- (void)_setupComponent {
    
    NSDictionary *componentDict =
    @{
        @"borderColor" : @"0.403922,0.458824,0.513726,1.000000",
        @"frame" : @"{{122.56640625, 61.79296875}, {440, 445}}",
        @"backgroundColor" : @"0.874510,0.894118,0.913725,0.700000",
        @"class-name" : @"AMComponent",
        @"layoutType" : @(0),
        @"identifier" : @"A0856F2F-8FE0-473D-9B12-80A5EBF82C23",
        @"clipped" : @(0),
        @"borderWidth" : @(1),
        @"alpha" : @(1),
        @"cornerRadius" : @(2),
        @"name" : @"Container-0",
@"classPrefix" : @"PB",
        @"childComponents" : @[
            @{
            @"borderColor" : @"0.403922,0.458824,0.513726,1.000000",
            @"frame" : @"{{30, 242.79296875}, {153.43359375, 170}}",
            @"backgroundColor" : @"0.874510,0.894118,0.913725,0.700000",
            @"class-name" : @"AMComponent",
            @"layoutType" : @(0),
            @"identifier" : @"633775D4-2F49-47F0-8555-72856A13F1E5",
            @"clipped" : @(0),
            @"borderWidth" : @(1),
            @"alpha" : @(1),
            @"cornerRadius" : @(2),
            @"name" : @"Container-2",
@"classPrefix" : @"PB",
            @"childComponents" : @[],
            },
            @{
            @"borderColor" : @"0.403922,0.458824,0.513726,1.000000",
            @"frame" : @"{{29.56640625, 33.79296875}, {156, 178}}",
            @"backgroundColor" : @"0.874510,0.894118,0.913725,0.700000",
            @"class-name" : @"AMComponent",
            @"layoutType" : @(0),
            @"identifier" : @"B0EA305D-5E9A-480D-AD41-16C5E2A00FFC",
            @"clipped" : @(0),
            @"borderWidth" : @(1),
            @"alpha" : @(1),
            @"cornerRadius" : @(2),
            @"name" : @"Container-1",
@"classPrefix" : @"PB",
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
