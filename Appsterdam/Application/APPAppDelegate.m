#import "APPAppDelegate.h"

#import "AFNetworkActivityIndicatorManager.h"
#import "TestFlight.h"
#import <HockeySDK/HockeySDK.h>

static NSString * const kAPPHockeyAppIdentifierKey = @"HockeyApp Identifier";
static NSString * const kAPPTestFlightKey = @"TestFlightKey";
static NSString * const kAPPKeysFileName = @"Appsterdam-Keys";

@interface APPAppDelegate () <BITHockeyManagerDelegate>
- (void)setUpHockeyApp;
@end

@implementation APPAppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setUpHockeyApp];
    [self takeOffTestFlight];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    return YES;
}


#pragma mark - API


- (void)setUpHockeyApp;
{
#ifndef DEBUG
    NSString *keysPath = [[NSBundle mainBundle] pathForResource:kAPPKeysFileName ofType:@"plist"];
    if (!keysPath) {
        NSLog(@"To use HockeyApp make sure you have a Appsterdam-Keys.plist with the Identifier in your project");
        return;
    }
    
    NSDictionary *keys = [NSDictionary dictionaryWithContentsOfFile:keysPath];
    NSString *appIdentifier = keys[kAPPHockeyAppIdentifierKey];
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:appIdentifier delegate:self];
    [[BITHockeyManager sharedHockeyManager] startManager];
#endif
}

- (void)takeOffTestFlight
{
    NSString *keysPath = [[NSBundle mainBundle] pathForResource:kAPPKeysFileName ofType:@"plist"];
    if (!keysPath) {
        NSLog(@"To use TestFlight make sure you have a Appsterdam-Keys.plist with the Identifier in your project");
        return;
    }
    
    NSDictionary *keys = [NSDictionary dictionaryWithContentsOfFile:keysPath];
    [TestFlight takeOff:keys[kAPPTestFlightKey]];
}

@end
