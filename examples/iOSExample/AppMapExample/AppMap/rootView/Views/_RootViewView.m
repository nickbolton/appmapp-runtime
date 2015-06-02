// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RootViewView.m instead.

#import "_RootViewView.h"
#import "AMAppMap.h"
#import "AMRuntimeButton.h"


@interface _RootViewView ()

@property (nonatomic, readwrite) AMRuntimeButton *buttonView;

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
        @"useCustomViewClass" : @(1),
        @"borderColor" : @"0.403922,0.458824,0.513726,1.000000",
        @"tlc" : @(1),
        @"backgroundColor" : @"0.874510,0.894118,0.913725,0.700000",
        @"frame" : @"{{1024, 1024}, {266, 362}}",
        @"class-name" : @"AMComponent",
        @"type" : @(0),
        @"identifier" : @"53104E62-C773-4F9D-8A81-8374C62E0C4D",
        @"clipped" : @(0),
        @"borderWidth" : @(1),
        @"alpha" : @(1),
        @"layoutObjects" : @[@{@"className" : @"AMExpandingLayout",@"proportionalValue" : @(0),},],
        @"layoutPreset" : @(0),
        @"name" : @"ROOT VIEW",
        @"cornerRadius" : @(2),
        @"childComponents" : @[
            @{
            @"layoutPreset" : @(1),
            @"borderColor" : @"0.403922,0.458824,0.513726,1.000000",
            @"tlc" : @(0),
            @"backgroundColor" : @"0.874510,0.894118,0.913725,0.700000",
            @"frame" : @"{{163, 45.5}, {72, 76}}",
            @"linkedComponent" : @"E4E7099D-0BD7-42C4-AAD1-B9A536F5F4A2",
            @"class-name" : @"AMComponent",
            @"behavior" : @{@"class" : @"AMNavigatingButtonBehavior",@"navigationType" : @(2),},
            @"type" : @(1),
            @"identifier" : @"149764D6-CF4E-47FB-AEB2-2BF65DD78BD7",
            @"clipped" : @(0),
            @"borderWidth" : @(1),
            @"alpha" : @(1),
            @"layoutObjects" : @[@{@"className" : @"AMFixedWidthLayout",@"proportionalValue" : @(0),},@{@"className" : @"AMProportionalRightLayout",@"proportionalValue" : @(0.1165413558483124),},@{@"className" : @"AMFixedHeightLayout",@"proportionalValue" : @(0),},@{@"className" : @"AMProportionalTopLayout",@"proportionalValue" : @(0.1256906092166901),},],
            @"cornerRadius" : @(2),
            @"useCustomViewClass" : @(0),
            @"name" : @"BUTTOn",
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
