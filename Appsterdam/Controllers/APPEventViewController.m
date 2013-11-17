#import "APPEventViewController.h"

#import "APPEvent.h"
#import "APPMapViewController.h"
#import "APPVenue.h"

@interface APPEventViewController () <UIWebViewDelegate>
{
    BOOL webFlag;
}

@property (nonatomic, weak) IBOutlet UIButton *directionButton;
@property (nonatomic, weak) IBOutlet UIWebView *descriptionWebView;

- (IBAction)openMapViewController:(id)sender;
- (IBAction)openVeespo:(id)sender;

@end

@implementation APPEventViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    webFlag = YES;
    [self.descriptionWebView loadHTMLString:self.event.eventDescription baseURL:nil];
}


#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return webFlag;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    webFlag = NO;
}


#pragma mark - API

#pragma mark Actions

- (IBAction)openMapViewController:(id)sender
{
    APPMapViewController *mapViewController = [[APPMapViewController alloc] init];
    mapViewController.annotation = self.event.venue;
    [self.navigationController pushViewController:mapViewController animated:YES];
}

- (IBAction)openVeespo:(id)sender
{
    if (self.veespoToken) {
        // NOTE: See source controll for commented out code
    }
}

@end
