#import "APPTabBarController.h"

#import "APPMeetupOperationManager.h"

@implementation APPTabBarController

#pragma mark - UIViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    static BOOL didLogin = NO;
    if (!didLogin) {
        [APPMeetupOperationManager authorizeWithCompletion:^(BOOL success, NSError *error) {
            didLogin = success;
        }];
    }
}

@end