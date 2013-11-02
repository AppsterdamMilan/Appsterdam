//
//  APPOtherEvents.m
//  Appsterdam
//
//  Created by Alessio Roberto on 02/11/13.
//  Copyright (c) 2013 Alessio Roberto. All rights reserved.
//

#import "APPOtherEvents.h"
#import "APPEventsMangment.h"
#import "APPEventViewController.h"

@interface APPOtherEvents ()

@end

@implementation APPOtherEvents

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    APPEventsMangment *managment = [[APPEventsMangment alloc] init];
    self.events = [managment getOthersEventList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    APPEventViewController *event = [segue destinationViewController];
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    event.eventData = [self.events objectAtIndex:path.row];
    event.veespoToken = [[self.veespoTokens objectAtIndex:0] objectForKey:@"token"];
    //    NSLog(@"%@", event.eventData);
}

@end
