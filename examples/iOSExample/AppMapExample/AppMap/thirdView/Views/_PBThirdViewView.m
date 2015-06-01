// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PBThirdViewView.m instead.

#import "_PBThirdViewView.h"
#import "AMAppMap.h"

@interface _PBThirdViewView ()


@end

@implementation _PBThirdViewView

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
        @"frame" : @"{{2820.5, 1236.5}, {306, 480}}",
        @"class-name" : @"AMComponent",
        @"type" : @(0),
        @"identifier" : @"323839F4-E33A-48CA-A298-7958DCEBE130",
        @"clipped" : @(0),
        @"borderWidth" : @(1),
        @"alpha" : @(1),
        @"layoutObjects" : @[@{@"className" : @"AMExpandingLayout",@"proportionalValue" : @(0),},],
        @"cornerRadius" : @(0),
        @"name" : @"THIRD VIEw",
        @"layoutPreset" : @(4),
@"classPrefix" : @"PB",
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
