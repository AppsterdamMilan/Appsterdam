//
//  APPEventsViewController.m
//  Appsterdam
//
//  Created by Alessio Roberto on 17/10/13.
//  Copyright (c) 2013 Alessio Roberto. All rights reserved.
//

#import "APPEventsViewController.h"
#import "APPEventViewController.h"

@interface APPEventsViewController ()

@end

@implementation APPEventsViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Conversione del timestamp passato da meetup
    NSDate *eventDate = [NSDate dateWithTimeIntervalSince1970:([[_events objectAtIndex:indexPath.row][@"time"] doubleValue]) / 1000];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"dd/MM/yyyy HH:mm"]; // 2009-02-01 19:50
    NSString *dateString = [dateFormat stringFromDate:eventDate];
    
    cell.textLabel.text = [_events objectAtIndex:indexPath.row][@"name"];
    cell.detailTextLabel.text = dateString;
    
    return cell;
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    APPEventViewController *event = [segue destinationViewController];
     NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    event.eventData = [_events objectAtIndex:path.row];
    NSLog(@"%@", event.eventData);
}



@end
