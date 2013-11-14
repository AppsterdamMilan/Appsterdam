//
//  APPEventsViewController.m
//  Appsterdam
//
//  Created by Alessio Roberto on 17/10/13.
//  Copyright (c) 2013 Alessio Roberto. All rights reserved.
//

// Contact roberto@veespo.com to download VeespoFramework
//#import <VeespoFramework/Veespo.h>
#import <AdSupport/AdSupport.h>
#import "APPEventsViewController.h"
#import "APPEventViewController.h"
#import "APPMeetupOperationManager.h"
#import "SVProgressHUD.h"

@interface APPEventsViewController ()
@property (nonatomic, strong) NSArray *events;
@property (nonatomic, strong) NSArray *veespoTokens;
@end

@implementation APPEventsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reloadEvents];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.veespoTokens == nil) {
//        NSString *userid = [NSString stringWithFormat:@"AppsterdamMilan-%@", [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]];
//        NSArray *languageArray = [NSLocale preferredLanguages];
        
        // Contact roberto@veespo.com to download VeespoFramework
        /*
        [Veespo initVeespo:@"apk-189a5479-ee70-4dbe-9acf-16ed04947fad"
                    userId:userid
                  userName:nil
                  language:[languageArray objectAtIndex:0]
                categories:@{
                             @"categories":@[
                                     @{@"cat": @"eventi"}
                                     ]
                             }
                   testUrl:YES
                    tokens:^(id responseData, BOOL error) {
                        self.veespoTokens = [[NSArray alloc] initWithArray:[responseData objectForKey:@"tokens"]];
                    }];
         */
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self events] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    APPEvent *event = self.events[indexPath.row];
    cell.textLabel.text = event.name;
    cell.detailTextLabel.text = [NSDateFormatter localizedStringFromDate:event.date
                                                               dateStyle:NSDateFormatterShortStyle
                                                               timeStyle:NSDateFormatterShortStyle];
    return cell;
}

#pragma mark - Events

// Could be done better if not using storyboard.
-(APPEventType)eventType
{
    APPEventType type = APPEventTypeOther;
    if ([self.title isEqualToString:@"WeeklyBeer"]) {
        type = APPEventTypeWeeklyBeer;
    } else if ([self.title isEqualToString:@"TalkLab"]) {
        type = APPEventTypeTalkLab;
    }
    return type;
}

-(void)reloadEvents
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [APPMeetupOperationManager getAppsterdamMilanEventsWithType:[self eventType]
                                                     Completion:^(NSArray *events, NSError *error) {
                                                         if (!error) {
                                                             self.events = events;
                                                             [self.tableView reloadData];
                                                             [SVProgressHUD showSuccessWithStatus:nil];
                                                         } else {
                                                             [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                                                         }
                                                     }];
}
     

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    APPEventViewController *eventViewController = [segue destinationViewController];
    eventViewController.event = self.events[[self.tableView indexPathForSelectedRow].row];
}



@end
