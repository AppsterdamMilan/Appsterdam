//
//  APPEventViewController.m
//  Appsterdam
//
//  Created by Alessio Roberto on 19/10/13.
//  Copyright (c) 2013 Alessio Roberto. All rights reserved.
//

#import "APPEventViewController.h"
#import "APPMapViewController.h"

@interface APPEventViewController () {
    BOOL webFlag;
}

@end

@implementation APPEventViewController

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
    webFlag = YES;
    [self.descriptionWV loadHTMLString:self.eventData[@"description"] baseURL:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openMapViewController:(id)sender
{
    APPMapViewController *mapViewController = [[APPMapViewController alloc] init];
    NSString *lat = _eventData[@"venue"][@"lat"];
    NSString *lon = _eventData[@"venue"][@"lon"];
    mapViewController.venueLocation = [[CLLocation alloc] initWithLatitude:[lat floatValue] longitude:[lon floatValue]];
    [self.navigationController pushViewController:mapViewController animated:YES];
}

#pragma mark - UIWebVew

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return webFlag;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    webFlag = NO;
}

@end
