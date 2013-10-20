//
//  APPFirstViewController.m
//  Appsterdam
//
//  Created by Alessio Roberto on 17/10/13.
//  Copyright (c) 2013 Alessio Roberto. All rights reserved.
//

#import "APPFirstViewController.h"
#import "APPMeeUpCommunicator.h"
#import "APPEventsMangment.h"

static NSString *weeklybeer = @"Appsterdam Weekly Beer";
static NSString *talklab = @"Appsterdam TalkLab";

@interface APPFirstViewController () {
    NSMutableArray *talkLabLists;
    NSMutableArray *weeklyBeerLists;
    NSMutableArray *othersEventLists;
}

@end

@implementation APPFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [APPMeeUpCommunicator getEvents:^(NSArray *events) {
        for (NSDictionary *event in events) {
            if ([event[@"name"] isEqualToString:talklab]) {
                if (talkLabLists == nil) {
                    talkLabLists = [[NSMutableArray alloc] init];
                }
                [talkLabLists addObject:event];
            } else if ([event[@"name"] isEqualToString:weeklybeer]) {
                if (weeklyBeerLists == nil) {
                    weeklyBeerLists = [[NSMutableArray alloc] init];
                }
                [weeklyBeerLists addObject:event];
            } else {
                if (othersEventLists == nil) {
                    othersEventLists = [[NSMutableArray alloc] init];
                }
                [othersEventLists addObject:event];
            }
        }
        APPEventsMangment *mangment = [[APPEventsMangment alloc] init];
        [mangment setTalkLabList:talkLabLists];
        [mangment setWeeklyBeerList:weeklyBeerLists];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
