// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PBRootViewViewController.m instead.

#import "_PBRootViewViewController.h"
#import "AMAppMap.h"
#import "AMLayouts.h"
#import "AMComponentManager.h"
#import "AMRuntimeView.h"

@interface _PBRootViewViewController ()<AMRuntimeDelegate>

@property (nonatomic, readwrite) PBRootViewView *rootViewView;
@end

@implementation _PBRootViewViewController

#pragma mark - Setup

#pragma mark - View Controller Lifecycle

- (void)loadView {
    self.rootViewView = [PBRootViewView new];
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
