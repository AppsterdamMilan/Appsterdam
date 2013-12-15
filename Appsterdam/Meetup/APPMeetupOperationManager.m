#import "APPMeetupOperationManager.h"


// FIXME: Contact @spllr for Appsterdam account details

// All the key are in key.plist file (in gitignore). For info contac
// @darthpelo or @spllr

static NSString * const kAPPKeysFileName = @"Appsterdam-Keys";
static NSString * const kAPPMeetupKey = @"APPMeetupKey";

static NSString * const APPMeetupRedirectUri = @"appsterdam://oauth";
static NSString * const APPMeetupOAuth2Url = @"https://secure.meetup.com/oauth2/authorize";

static NSString * const APPMeetupAPIUrl = @"https://api.meetup.com";
static NSString * const kAPPAppsterdamMilanMeetupID = @"APPAppsterdamMilanMeetupID";
static NSString * const APPMeetupListPage = @"20";

static NSString * const APPMeetupErrorDomain = @"APPMeetupErrorDomain";

@implementation APPMeetupOperationManager

#pragma mark - Factories

+ (instancetype)sharedInstance
{
    static APPMeetupOperationManager *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[APPMeetupOperationManager alloc] initWithBaseURL:[NSURL URLWithString:APPMeetupAPIUrl]];
    });
    return _sharedInstance;
}

#pragma mark - Class API

#pragma mark Events

+ (void)getAppsterdamMilanEventsWithCompletion:(APPMeetupEventsHandler)completion
{
    NSString *keysPath = [[NSBundle mainBundle] pathForResource:kAPPKeysFileName ofType:@"plist"];
    NSDictionary *keys = [NSDictionary dictionaryWithContentsOfFile:keysPath];
    NSString *appsterdamMilanMeetupID = keys[kAPPAppsterdamMilanMeetupID];
    
    NSAssert([appsterdamMilanMeetupID length] > 0, @"Missing Meetup group ID");
    
    [[self sharedInstance] GET:@"2/events"
                    parameters:@{@"group_id": appsterdamMilanMeetupID, @"page" : APPMeetupListPage}
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           if (completion) {
                               NSArray *results = responseObject[@"results"];
                               NSMutableArray *array = [NSMutableArray array];
                               for (NSDictionary *dictionary in results) {
                                   [array addObject:[[APPEvent alloc] initWithDictionary:dictionary]];
                               }
                               completion(array, nil);
                           }
                       }
                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           if (completion) {
                               completion(nil, error);
                           }
                       }];
}

+ (void)getAppsterdamMilanEventsWithType:(APPEventType)type completion:(APPMeetupEventsHandler)completion
{
    [self getAppsterdamMilanEventsWithCompletion:^(NSArray *events, NSError *error) {
        if (completion) {
            NSPredicate *eventTypePredicate = [NSPredicate predicateWithFormat:@"%K == %i", @"type", type];
            completion([events filteredArrayUsingPredicate:eventTypePredicate], error);
        }
    }];
}


#pragma mark Authorization

+ (void)authorizeWithCompletion:(APPMeetupRequestHandler)completion
{
    NSString *keysPath = [[NSBundle mainBundle] pathForResource:kAPPKeysFileName ofType:@"plist"];
    NSDictionary *keys = [NSDictionary dictionaryWithContentsOfFile:keysPath];
    
    NSAssert([keys[kAPPMeetupKey] length] > 0, @"Missing Meetup key");
    UIViewController *rootViewController = [[UIApplication sharedApplication] delegate].window.rootViewController;
    NSAssert(rootViewController.view.window, @"Authorization can be started only after the root view controller is on screen");
    
    APPMeetupAuthWebViewControllerRedirectUriBlock redirectBlock = ^(NSURL *url) {
        NSDictionary *parameters = [self responseObjectFromRedirectURL:url];
        NSString *token = parameters[@"access_token"];
        if (token) {
            [[[self sharedInstance] requestSerializer] setValue:[NSString stringWithFormat:@"bearer %@", token]
                                             forHTTPHeaderField:@"Authorization"];
            if (completion) {
                completion(YES, nil);
            }
            [rootViewController dismissViewControllerAnimated:YES
                                                   completion:nil];
        } else if (completion) {
            completion(NO, [NSError errorWithDomain:APPMeetupErrorDomain
                                               code:0
                                           userInfo:@{NSLocalizedDescriptionKey: [parameters[@"errors"] description]}]);
        }
    };
    APPOAuthWebViewController *authController = [[APPOAuthWebViewController alloc] initWithRequest:[self authRequest]
                                                                                                 redirectUri:APPMeetupRedirectUri
                                                                                                  completion:redirectBlock];    
    [rootViewController presentViewController:authController
                                     animated:YES
                                   completion:^{
                                       [authController loadAuthRequest];
                                   }];
}

+ (NSURLRequest *)authRequest
{
    NSString *keysPath = [[NSBundle mainBundle] pathForResource:kAPPKeysFileName ofType:@"plist"];
    NSDictionary *keys = [NSDictionary dictionaryWithContentsOfFile:keysPath];
    
    NSAssert([keys[kAPPMeetupKey] length] > 0, @"Missing Meetup key");
    NSString *urlString = [NSString stringWithFormat:@"%@?client_id=%@&response_type=token&redirect_uri=%@",
                           APPMeetupOAuth2Url,
                           keys[kAPPMeetupKey],
                           [APPMeetupRedirectUri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
}


#pragma mark Helpers

+ (NSDictionary *)responseObjectFromRedirectURL:(NSURL *)url
{
    NSString *form = [[[url absoluteString] lowercaseString] stringByReplacingOccurrencesOfString:[APPMeetupRedirectUri stringByAppendingString:@"?"]
                                                                                       withString:@""];
    NSArray *pairs = [form componentsSeparatedByString:@"&"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    for (NSString *pair in pairs) {
        NSArray *keyAndValue = [pair componentsSeparatedByString:@"="];
        [parameters setObject:[[keyAndValue lastObject] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                       forKey:[keyAndValue firstObject]];
    }
    return parameters;
}

@end
