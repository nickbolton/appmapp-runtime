// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PBThirdViewViewController.m instead.

#import "_PBThirdViewViewController.h"
#import "AMAppMap.h"
#import "AMLayouts.h"
#import "AMComponentManager.h"
#import "AMRuntimeView.h"

@interface _PBThirdViewViewController ()<AMRuntimeDelegate>

@property (nonatomic, readwrite) PBThirdViewView *thirdViewView;
@end

@implementation _PBThirdViewViewController

#pragma mark - Setup

#pragma mark - View Controller Lifecycle

- (void)loadView {
    self.thirdViewView = [PBThirdViewView new];
    self.thirdViewView.runtimeDelegate = self;
    self.view = self.thirdViewView;
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
