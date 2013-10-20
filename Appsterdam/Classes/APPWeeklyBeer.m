//
//  APPWeeklyBeer.m
//  Appsterdam
//
//  Created by Alessio Roberto on 17/10/13.
//  Copyright (c) 2013 Alessio Roberto. All rights reserved.
//

#import "APPWeeklyBeer.h"
#import "APPEventsMangment.h"

@interface APPWeeklyBeer ()

@end

@implementation APPWeeklyBeer

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    APPEventsMangment *managment = [[APPEventsMangment alloc] init];
    self.events = [managment getWeeklyBeerList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


@end
