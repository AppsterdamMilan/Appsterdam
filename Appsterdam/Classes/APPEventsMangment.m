//
//  APPEventsMangment.m
//  Appsterdam
//
//  Created by Alessio Roberto on 17/10/13.
//  Copyright (c) 2013 Alessio Roberto. All rights reserved.
//

#import "APPEventsMangment.h"

@implementation APPEventsMangment

- (void)setTalkLabList:(NSArray *)list
{
    [[NSUserDefaults standardUserDefaults] setObject:list forKey:@"talklab"];
}

- (void)setWeeklyBeerList:(NSArray *)list
{
    [[NSUserDefaults standardUserDefaults] setObject:list forKey:@"weeklybeer"];
}

- (void)setWorkShopList:(NSArray *)list
{
    [[NSUserDefaults standardUserDefaults] setObject:list forKey:@"workshop"];
}

- (void)setOthersEventList:(NSArray *)list
{
    [[NSUserDefaults standardUserDefaults] setObject:list forKey:@"other"];
}

- (NSArray *)getTalkLabList
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"talklab"];
}

- (NSArray *)getWeeklyBeerList
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"weeklybeer"];
}

- (NSArray *)getWorkShopList
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"workshop"];
}

@end
