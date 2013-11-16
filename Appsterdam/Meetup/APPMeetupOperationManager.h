//
//  APPMeetupOperationManager.h
//  Appsterdam
//
//  Created by Mouhcine El Amine on 10/11/13.
//  Copyright (c) 2013 Alessio Roberto. All rights reserved.
//

#import "AFNetworking.h"
#import "APPOAuthWebViewController.h"
#import "APPEvent.h"

/**
 *  A block object to be executed when the request operation finishes.
 *
 *  @param success A boolean value indicating whether the operation was successful or not.
 *  @param error   An error if one occured.
 */
typedef void (^APPMeetupRequestHandler) (BOOL success, NSError *error);

/**
 *  A block object to be executed when an event fetch operation finishes.
 *
 *  @param events  An array of event objects.
 *  @param error   An error if one occured.
 */
typedef void (^APPMeetupEventsHandler) (NSArray *events, NSError *error);

@interface APPMeetupOperationManager : AFHTTPRequestOperationManager

/**
 *  The shared `APPMeetupOperationManager` instance.
 *
 *  @return The shared instance or nil.
 */
+(instancetype)sharedInstance;

#pragma mark - OAuth

/**
 *  Authorizes a user using OAuth2.
 *
 *  @param completion A block to be executed when the authorization finishes.
 *  @discussion This class method present a web view controller. It must not be called before the root view controller is on screen, if so it will raise an exception.
 */
+(void)authorizeWithCompletion:(APPMeetupRequestHandler)completion;

#pragma mark - Events

/**
 *  Makes a request for events scheduled in Appsterdam Milan Meetup group.
 *
 *  @param completion A block to be executed when the request finishes.
 */
+(void)getAppsterdamMilanEventsWithCompletion:(APPMeetupEventsHandler)completion;

/**
 *  Makes a request for events of a certain type scheduled in Appsterdam Milan Meetup group.
 *
 *  @param type       An event type.
 *  @param completion A block to be executed when the request finishes.
 */
+(void)getAppsterdamMilanEventsWithType:(APPEventType)type
                             Completion:(APPMeetupEventsHandler)completion;

@end