//
//  APPMeetupOperationManager.m
//  Appsterdam
//
//  Created by Mouhcine El Amine on 10/11/13.
//  Copyright (c) 2013 Alessio Roberto. All rights reserved.
//

#import "APPMeetupOperationManager.h"

// Created with Mouhcine's account (We need to dig and see if we can have one for Appsterdam)
static NSString * const APPMeetupKey = @"ihjgomeoh5hu7rqcuplge9ik9";

static NSString * const APPMeetupRedirectUri = @"appsterdam://oauth";
static NSString * const APPMeetupOAuth2Url = @"https://secure.meetup.com/oauth2/authorize";

static NSString * const APPMeetupAPIUrl = @"https://api.meetup.com";
static NSString * const APPAppsterdamMilanMeetupID = @"3242342";
static NSString * const APPMeetupListPage = @"20";

static NSString * const APPMeetupErrorDomain = @"APPMeetupErrorDomain";

@implementation APPMeetupOperationManager

+(instancetype)sharedInstance
{
    static APPMeetupOperationManager *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[APPMeetupOperationManager alloc] initWithBaseURL:[NSURL URLWithString:APPMeetupAPIUrl]];
    });
    return _sharedInstance;
}

#pragma mark - Events

+(void)getAppsterdamMilanEventsWithCompletion:(APPMeetupEventsHandler)completion
{
    [[self sharedInstance] GET:@"2/events"
                    parameters:@{@"group_id": APPAppsterdamMilanMeetupID, @"page" : APPMeetupListPage}
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

+(void)getAppsterdamMilanEventsWithType:(APPEventType)type
                             Completion:(APPMeetupEventsHandler)completion
{
    [self getAppsterdamMilanEventsWithCompletion:^(NSArray *events, NSError *error) {
        if (completion) {
            NSPredicate *eventTypePredicate = [NSPredicate predicateWithFormat:@"%K == %i", @"type", type];
            completion([events filteredArrayUsingPredicate:eventTypePredicate], error);
        }
    }];
}

#pragma mark - OAuth2

+(void)authorizeWithCompletion:(APPMeetupRequestHandler)completion
{
    NSAssert([APPMeetupKey length] > 0, @"Missing Meetup key");
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

+(NSURLRequest *)authRequest
{
    NSString *urlString = [NSString stringWithFormat:@"%@?client_id=%@&response_type=token&redirect_uri=%@",
                           APPMeetupOAuth2Url,
                           APPMeetupKey,
                           [APPMeetupRedirectUri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
}

#pragma mark - Helper methods

+(NSDictionary *)responseObjectFromRedirectURL:(NSURL *)url
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
