//
//  APPEvent.m
//  Appsterdam
//
//  Created by Mouhcine El Amine on 14/11/13.
//  Copyright (c) 2013 Alessio Roberto. All rights reserved.
//

#import "APPEvent.h"

@interface APPEvent ()
@property (nonatomic, strong) NSString *eventStatus;
@end

@implementation APPEvent

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.eventID = dictionary[@"id"];
        self.name = dictionary[@"name"];
        NSTimeInterval created = [dictionary[@"created"] doubleValue] / 1000;
        self.creationDate = [NSDate dateWithTimeIntervalSince1970:created];
        NSTimeInterval updated = [dictionary[@"updated"] doubleValue] / 1000;
        self.updateDate = [NSDate dateWithTimeIntervalSince1970:updated];
        NSTimeInterval time = [dictionary[@"time"] doubleValue] / 1000;
        self.date = [NSDate dateWithTimeIntervalSince1970:time];
        self.eventDescription = dictionary[@"description"];
        self.duration = [dictionary[@"duration"] doubleValue] / 1000;
        self.url = [NSURL URLWithString:dictionary[@"event_url"]];
        self.eventStatus = dictionary[@"status"];
    }
    return self;
}

-(APPEventStatus)status
{
    APPEventStatus result = APPEventStatusUnknown;
    if ([self.eventStatus isEqualToString:@"cancelled"]) {
        result = APPEventStatusCancelled;
    } else if ([self.eventStatus isEqualToString:@"upcoming"]) {
        result = APPEventStatusUpcoming;
    } else if ([self.eventStatus isEqualToString:@"past"]) {
        result = APPEventStatusPast;
    } else if ([self.eventStatus isEqualToString:@"proposed"]) {
        result = APPEventStatusProposed;
    } else if ([self.eventStatus isEqualToString:@"suggested"]) {
        result = APPEventStatusSuggested;
    } else if ([self.eventStatus isEqualToString:@"draft"]) {
        result = APPEventStatusDraft;
    }
    return result;
}

-(APPEventType)type
{
    APPEventType result = APPEventTypeOther;
    if ([self.name isEqualToString:@"Appsterdam Weekly Beer"]) {
        result = APPEventTypeWeeklyBeer;
    } else if ([self.name isEqualToString:@"Appsterdam TalkLab"]) {
        result = APPEventTypeTalkLab;
    }
    return result;
}

-(BOOL)isWeeklyBeerEvent
{
    return [self type] == APPEventTypeWeeklyBeer;
}

-(BOOL)isTalkLabEvent
{
    return [self type] == APPEventTypeTalkLab;
}

@end
