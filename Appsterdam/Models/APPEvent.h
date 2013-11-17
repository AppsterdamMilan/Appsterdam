//
//  APPEvent.h
//  Appsterdam
//
//  Created by Mouhcine El Amine on 14/11/13.
//  Copyright (c) 2013 Alessio Roberto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APPVenue.h"

/**
 *  The possible statuses of an event.
 */
typedef NS_ENUM(NSUInteger, APPEventStatus) {
    /**
     *  Unknown status.
     */
    APPEventStatusUnknown,
    /**
     *  Upcoming event.
     */
    APPEventStatusUpcoming,
    /**
     *  Past event.
     */
    APPEventStatusPast,
    /**
     *  Cancelled event.
     */
    APPEventStatusCancelled,
    /**
     *  Proposed event.
     */
    APPEventStatusProposed,
    /**
     *  Suggested event.
     */
    APPEventStatusSuggested,
    /**
     *  Draft event.
     */
    APPEventStatusDraft,
};

/**
 *  The different event types organized by Appsterdam Milan.
 */
typedef NS_ENUM(NSUInteger, APPEventType) {
    /**
     *  Undefined event type.
     */
    APPEventTypeOther,
    /**
     *  Weekly beer event.
     */
    APPEventTypeWeeklyBeer,
    /**
     *  Talk lab event.
     */
    APPEventTypeTalkLab,
};


/**
 *  `APPEvent`
 */
@interface APPEvent : NSObject

/**
 *  The event id.
 */
@property (nonatomic) NSString *eventID;

/**
 *  The name of the event
 */
@property (nonatomic, strong) NSString *name;

/**
 *  The event venue.
 */
@property (nonatomic, strong) APPVenue *venue;

/**
 *  The creation date of the event.
 */
@property (nonatomic, strong) NSDate *creationDate;

/**
 *  The last modification date of the event.
 */
@property (nonatomic, strong) NSDate *updateDate;

/**
 *  The date of the event
 */
@property (nonatomic, strong) NSDate *date;

/**
 *  The description of the event.
 */
@property (nonatomic, strong) NSString *eventDescription;

/**
 *  The event duration.
 */
@property (nonatomic) NSTimeInterval duration;

/**
 *  The url of the event's page on Meetup.
 */
@property (nonatomic, strong) NSURL *url;

/**
 *  The designated initializer to initialize an `APPEvent` object.
 *
 *  @param dictionary A JSON dictionary from a Meetup API end point.
 *
 *  @return An initiliazed `APPEvent` object or nil.
 */
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

/**
 *  Returns the status of the event.
 *
 *  @return The status of the event.
 */
-(APPEventStatus)status;

#pragma mark - Appsterdam Milan

/**
 *  Returns the type of the event.
 *
 *  @return The type of the event.
 */
-(APPEventType)type;

/**
 *  Checks if the event is of type `APPEventTypeWeeklyBeer`.
 *
 *  @return YES if the event is of type `APPEventTypeWeeklyBeer`, NO otherwise.
 */
-(BOOL)isWeeklyBeerEvent;

/**
 *  Checks if the event is of type `APPEventTypeTalkLab`.
 *
 *  @return YES if the event is of type `APPEventTypeTalkLab`, NO otherwise.
 */
-(BOOL)isTalkLabEvent;

@end
