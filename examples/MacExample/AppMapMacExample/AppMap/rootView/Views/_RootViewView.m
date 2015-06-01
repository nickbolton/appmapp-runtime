// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RootViewView.m instead.

#import "_RootViewView.h"
#import "AMAppMap.h"

@interface _RootViewView ()

@property (nonatomic, readwrite) Container155View *container155View;

@end

@implementation _RootViewView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self _setupComponent];
    }
    return self;
}

#pragma mark - Setup
- (void)_setupComponent {

    NSDictionary *componentDict =
    @{
        @"borderColor" : @"0.403922,0.458824,0.513726,1.000000",
        @"tlc" : @(1),
        @"backgroundColor" : @"0.874510,0.894118,0.913725,0.700000",
        @"frame" : @"{{2443, 1224}, {263, 481}}",
        @"class-name" : @"AMComponent",
        @"type" : @(0),
        @"identifier" : @"944E8B5D-D3D9-4CC2-9D88-F9FE4AB84AC7",
        @"clipped" : @(0),
        @"borderWidth" : @(1),
        @"alpha" : @(1),
        @"layoutObjects" : @[@{@"className" : @"AMExpandingLayout",@"proportionalValue" : @(0),},],
        @"cornerRadius" : @(2),
        @"name" : @"ROOT VIEw",
        @"layoutPreset" : @(4),
        @"childComponents" : @[
            @{
            @"borderColor" : @"0.403922,0.458824,0.513726,1.000000",
            @"tlc" : @(0),
            @"backgroundColor" : @"0.874510,0.894118,0.913725,0.700000",
            @"frame" : @"{{176, 108}, {56, 52}}",
            @"linkedComponent" : @"323839F4-E33A-48CA-A298-7958DCEBE130",
            @"class-name" : @"AMComponent",
            @"behavior" : @{@"class" : @"AMNavigatingButtonBehavior",@"navigationType" : @(2),},
            @"type" : @(1),
            @"identifier" : @"0545EC26-31C9-4EC5-951B-422194012933",
            @"clipped" : @(0),
            @"borderWidth" : @(1),
            @"alpha" : @(1),
            @"layoutObjects" : @[@{@"className" : @"AMFixedWidthLayout",@"proportionalValue" : @(0),},@{@"className" : @"AMProportionalRightLayout",@"proportionalValue" : @(0.1184738948941231),},@{@"className" : @"AMFixedHeightLayout",@"proportionalValue" : @(0),},@{@"className" : @"AMProportionalTopLayout",@"proportionalValue" : @(0.2245322316884995),},],
            @"cornerRadius" : @(2),
            @"name" : @"Container-155",
            @"layoutPreset" : @(1),
            @"childComponents" : @[],
            },
        ],
        };

    self.component = [AMComponent componentWithDictionary:componentDict];

    for (AMComponent *childComponent in self.component.childComponents) {

        [[AMAppMap sharedInstance]
         buildViewFromComponent:childComponent
         inContainer:self
         bindingObject:self];
    }

}

#pragma mark - View Controller Lifecycle

@end
