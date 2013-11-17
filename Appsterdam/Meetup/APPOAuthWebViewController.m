#import "APPOAuthWebViewController.h"

#import <SVProgressHUD/SVProgressHUD.h>

@interface APPOAuthWebViewController () <UIWebViewDelegate>

@property (nonatomic, copy) APPMeetupAuthWebViewControllerRedirectUriBlock redirectBlock;
@property (nonatomic, strong) NSString *redirectUri;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) UIWebView *webView;

- (BOOL)isTargetRedirectURL:(NSURL *)url;
- (void)loadAuthRequest;

@end

@implementation APPOAuthWebViewController

#pragma mark - Initializers

- (instancetype)initWithRequest:(NSURLRequest *)request redirectUri:(NSString *)redirectUri completion:(APPMeetupAuthWebViewControllerRedirectUriBlock)completion
{
    self = [super init];
    if (self) {
        self.redirectBlock = [completion copy];
        self.request = request;
        self.redirectUri = redirectUri;
    }
    return self;
}


#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Meetup", nil);
    self.view.backgroundColor = [UIColor colorWithRed:218.0f/255.0f green:54.0f/256.0f blue:75.0f/256.0f alpha:1.0f];
    [self.view addSubview:self.webView];
}


#pragma mark - UIWebViewDelegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    [self loadAuthRequest];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)type
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


#pragma mark - API

#pragma mark Properties

- (UIWebView *)webView
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


#pragma mark Methods

- (BOOL)isTargetRedirectURL:(NSURL *)url
{
    return [[[url absoluteString] lowercaseString] hasPrefix:[self.redirectUri lowercaseString]];
}

- (void)loadAuthRequest
{
    [self.webView stopLoading];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [self.webView loadRequest:self.request];
}

@end