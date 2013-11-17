#import "APPMeetupOperationManager.h"


// FIXME: Contact @spllr for Appsterdam account details

static NSString * const kAPPKeysFileName = @"Appsterdam-Keys";
static NSString * const kAPPMeetupKey = @"APPMeetupKey";

static NSString * const kAPPMeetupRedirectUri = @"APPMeetupRedirectUri";
static NSString * const kAPPMeetupOAuth2Url = @"APPMeetupOAuth2Url";

static NSString * const kAPPMeetupAPIUrl = @"APPMeetupAPIUrl";
static NSString * const kAPPAppsterdamMilanMeetupID = @"APPAppsterdamMilanMeetupID";
static NSString * const kAPPMeetupListPage = @"APPMeetupListPage";

static NSString * const kAPPMeetupErrorDomain = @"APPMeetupErrorDomain";

@implementation APPMeetupOperationManager

#pragma mark - Factories

+ (instancetype)sharedInstance
{
    static APPMeetupOperationManager *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *keysPath = [[NSBundle mainBundle] pathForResource:kAPPKeysFileName ofType:@"plist"];
        NSDictionary *keys = [NSDictionary dictionaryWithContentsOfFile:keysPath];
        NSString *meetupAPIUrl = keys[kAPPMeetupAPIUrl];
        _sharedInstance = [[APPMeetupOperationManager alloc] initWithBaseURL:[NSURL URLWithString:meetupAPIUrl]];
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
    NSString *meetupListPage = keys[kAPPMeetupListPage];
    
    [[self sharedInstance] GET:@"2/events"
                    parameters:@{@"group_id": appsterdamMilanMeetupID, @"page" : meetupListPage}
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
    NSString *meetupKey = keys[kAPPMeetupKey];
    
    NSAssert([meetupKey length] > 0, @"Missing Meetup key");
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
            completion(NO, [NSError errorWithDomain:keys[kAPPMeetupErrorDomain]
                                               code:0
                                           userInfo:@{NSLocalizedDescriptionKey: [parameters[@"errors"] description]}]);
        }
    };
    APPOAuthWebViewController *authController = [[APPOAuthWebViewController alloc] initWithRequest:[self authRequest]
                                                                                                 redirectUri:keys[kAPPMeetupRedirectUri]
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
    
    NSString *urlString = [NSString stringWithFormat:@"%@?client_id=%@&response_type=token&redirect_uri=%@",
                           keys[kAPPMeetupOAuth2Url],
                           keys[kAPPMeetupKey],
                           [keys[kAPPMeetupRedirectUri] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
}


#pragma mark Helpers

+ (NSDictionary *)responseObjectFromRedirectURL:(NSURL *)url
{
    NSString *keysPath = [[NSBundle mainBundle] pathForResource:kAPPKeysFileName ofType:@"plist"];
    NSDictionary *keys = [NSDictionary dictionaryWithContentsOfFile:keysPath];
    
    NSString *form = [[[url absoluteString] lowercaseString] stringByReplacingOccurrencesOfString:[keys[kAPPMeetupRedirectUri] stringByAppendingString:@"?"]
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
