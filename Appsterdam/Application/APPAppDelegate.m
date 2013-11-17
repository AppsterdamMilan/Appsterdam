#import "APPAppDelegate.h"

#import "AFNetworkActivityIndicatorManager.h"

@implementation APPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    return YES;
}

@end
