#import "APPEventsViewController.h"

#import "APPEventViewController.h"
#import "APPMeetupOperationManager.h"
#import "SVProgressHUD.h"
#import <AdSupport/AdSupport.h>

static NSString * const kAPPEventsShowDetailsSegueIdentifier = @"showDetails";
static NSString * const kAPPEventsTalkLabTitle = @"TalkLab";
static NSString * const kAPPEventsWeeklyBeerTitle = @"WeeklyBeer";

@interface APPEventsViewController ()

@property (nonatomic, strong) NSArray *events, *veespoTokens;

@end

@implementation APPEventsViewController

#pragma mark - UIViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    APPEventViewController *eventViewController = [segue destinationViewController];
    eventViewController.event = self.events[[self.tableView indexPathForSelectedRow].row];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reloadEvents];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.veespoTokens == nil) {
        // NOTE: Check soure controll for old code
    }
}


#pragma mark - UITableViewDataSource

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self events] count];
}


#pragma mark - API

- (APPEventType)eventType
{
    APPEventType type = APPEventTypeOther;
    if ([self.title isEqualToString:kAPPEventsWeeklyBeerTitle]) {
        type = APPEventTypeWeeklyBeer;
    } else if ([self.title isEqualToString:kAPPEventsTalkLabTitle]) {
        type = APPEventTypeTalkLab;
    }
    return type;
}

- (void)reloadEvents
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

@end
