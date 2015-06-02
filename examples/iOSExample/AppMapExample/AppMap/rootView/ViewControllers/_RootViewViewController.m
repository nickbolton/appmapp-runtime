// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RootViewViewController.m instead.

#import "_RootViewViewController.h"
#import "AMAppMap.h"
#import "AMLayouts.h"
#import "AMComponentManager.h"
#import "AMRuntimeView.h"
#import "RootViewView.h"


@interface _RootViewViewController ()<AMRuntimeDelegate>

@property (nonatomic, readwrite) RootViewView *rootViewView;
@end

@implementation _RootViewViewController

#pragma mark - Setup

#pragma mark - View Controller Lifecycle

- (void)loadView {
    self.rootViewView = [RootViewView new];
    self.rootViewView.runtimeDelegate = self;
    self.view = self.rootViewView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - AMRuntimeDelegate Conformance

- (void)navigateToComponentWithIdentifier:(NSString *)componentIdentifier
                           navigationType:(AMNavigationType)navigationType {

    Class viewControllerClass =
    [[AMComponentManager sharedInstance]
     viewControllerClassForComponentIdentifier:componentIdentifier];

    if (viewControllerClass != Nil) {

        UIViewController *viewController = [viewControllerClass new];

        switch (navigationType) {

            case AMNavigationTypePush:

                [self.navigationController
                 pushViewController:viewController
                 animated:YES];

                break;

            case AMNavigationTypePresent:

                [self presentViewController:viewController animated:YES completion:nil];

                break;

            default:
                break;
        }
    }
}
@end
