//
//  APPTabBarController.m
//  Appsterdam
//
//  Created by Mouhcine El Amine on 14/11/13.
//  Copyright (c) 2013 Alessio Roberto. All rights reserved.
//

#import "APPTabBarController.h"
#import "APPMeetupOperationManager.h"

@implementation APPTabBarController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    static BOOL didLogin = NO;
    if (!didLogin) {
        [APPMeetupOperationManager authorizeWithCompletion:^(BOOL success, NSError *error) {
            didLogin = success;
        }];
    }
}

@end