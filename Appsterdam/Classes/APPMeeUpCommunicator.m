//
//  APPMeeUpCommunicator.m
//  Appsterdam
//
//  Created by Alessio Roberto on 17/10/13.
//  Copyright (c) 2013 Alessio Roberto. All rights reserved.
//

#import "APPMeeUpCommunicator.h"
#import "AFNetworking.h"

#define GROUP_ID (@"3242342")
#define PAGE (@"20")
#define MEETUP_APIK @""

static NSString *kResults = @"results";

@implementation APPMeeUpCommunicator

+ (void)getEvents:(void (^)(NSArray *))result
{
    NSString *urlStr = [NSString stringWithFormat:@"https://api.meetup.com/2/events?&sign=true&status=upcoming&group_id=%@&page=%@&key=%@", GROUP_ID, PAGE, MEETUP_APIK];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        result(JSON[kResults]);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attenzione" message:@"Errore di connessione, riprovare più tardi" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        result(nil);
    }];
    [operation start];
}

@end
