// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ThirdViewViewController.m instead.

#import "_ThirdViewViewController.h"
#import "AMAppMap.h"
#import "AMLayouts.h"
#import "AMComponentManager.h"
#import "AMRuntimeView.h"

@interface _ThirdViewViewController ()<AMRuntimeDelegate>

@property (nonatomic, readwrite) ThirdViewView *thirdViewView;
@end

@implementation _ThirdViewViewController

#pragma mark - Setup

#pragma mark - View Controller Lifecycle

- (void)loadView {
    self.thirdViewView = [ThirdViewView new];
    self.thirdViewView.runtimeDelegate = self;
    self.view = self.thirdViewView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - AMRuntimeDelegate Conformance

- (void)navigateToComponentWithIdentifier:(NSString *)componentIdentifier
navigationType:(AMNavigationType)navigationType {

}
@end
