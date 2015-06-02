// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SecondViewViewController.m instead.

#import "_SecondViewViewController.h"
#import "AMAppMap.h"
#import "AMLayouts.h"
#import "AMComponentManager.h"
#import "AMRuntimeView.h"
#import "SecondViewView.h"


@interface _SecondViewViewController ()<AMRuntimeDelegate>

@property (nonatomic, readwrite) SecondViewView *secondViewView;
@end

@implementation _SecondViewViewController

#pragma mark - Setup

#pragma mark - View Controller Lifecycle

- (void)loadView {
    self.secondViewView = [SecondViewView new];
    self.secondViewView.runtimeDelegate = self;
    self.view = self.secondViewView;
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
