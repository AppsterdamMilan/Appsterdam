//
//  APPOAuthWebViewController.m
//  Appsterdam
//
//  Created by Mouhcine El Amine on 11/11/13.
//  Copyright (c) 2013 Alessio Roberto. All rights reserved.
//

#import "APPOAuthWebViewController.h"
#import "SVProgressHUD.h"

@interface APPOAuthWebViewController () <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSString *redirectUri;
@property (nonatomic, copy) APPMeetupAuthWebViewControllerRedirectUriBlock redirectBlock;
@end

@implementation APPOAuthWebViewController

-(instancetype)initWithRequest:(NSURLRequest *)request
                   redirectUri:(NSString *)redirectUri
                    completion:(APPMeetupAuthWebViewControllerRedirectUriBlock)completion
{
    self = [super init];
    if (self) {
        self.redirectBlock = [completion copy];
        self.request = request;
        self.redirectUri = redirectUri;
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"Meetup", nil);
    self.view.backgroundColor = [UIColor colorWithRed:218.0f/255.0f
                                                green:54.0f/256.0f
                                                 blue:75.0f/256.0f
                                                alpha:1.0f];
    [self.view addSubview:self.webView];
}

#pragma mark - Web View

-(UIWebView *)webView
{
    if (!_webView) {
        CGRect frame = self.view.bounds;
        frame.origin.y = [UIApplication sharedApplication].statusBarFrame.size.height;
        frame.size.height -= frame.origin.y;
        _webView = [[UIWebView alloc] initWithFrame:frame];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _webView.delegate = self;
    }
    return _webView;
}

-(void)loadAuthRequest
{
    [self.webView stopLoading];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [self.webView loadRequest:self.request];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    [self loadAuthRequest];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)type
{
    NSURL *url = [request URL];
    if ([self isTargetRedirectURL:url]) {
        webView.delegate = nil;
        if (self.redirectBlock) {
            self.redirectBlock(url);
        }
        [SVProgressHUD dismiss];
        return NO;
    }
    return YES;
}

-(BOOL)isTargetRedirectURL:(NSURL *)url
{
    return [[[url absoluteString] lowercaseString] hasPrefix:[self.redirectUri lowercaseString]];
}

@end