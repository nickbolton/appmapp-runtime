// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SecondViewView.m instead.

#import "_SecondViewView.h"
#import "AMAppMap.h"


@interface _SecondViewView ()


@end

@implementation _SecondViewView

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
        @"frame" : @"{{1410.5, 1024}, {288, 352}}",
        @"class-name" : @"AMComponent",
        @"type" : @(0),
        @"identifier" : @"E4E7099D-0BD7-42C4-AAD1-B9A536F5F4A2",
        @"clipped" : @(0),
        @"borderWidth" : @(1),
        @"alpha" : @(1),
        @"layoutObjects" : @[@{@"className" : @"AMExpandingLayout",@"proportionalValue" : @(0),},],
        @"layoutPreset" : @(0),
        @"name" : @"SECOND VIEw",
        @"cornerRadius" : @(2),
        @"childComponents" : @[],
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
