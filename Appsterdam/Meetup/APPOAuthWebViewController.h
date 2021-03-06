
/**
 *  A block object to be executed when an APPMeetupAuthWebViewController gets redirected to its redirect uri.
 *
 *  @param url   The url redirected to.
 */
typedef void(^APPMeetupAuthWebViewControllerRedirectUriBlock)(NSURL *url);

@interface APPOAuthWebViewController : UIViewController

/**
 *  The designated initializer to initialize a `APPMeetupAuthWebViewController` object.
 *
 *  @param request     An NSURLRequest.
 *  @param redirectUri A redirect url string.
 *  @param completion  A completion block
 *
 *  @return An initialized `APPMeetupAuthWebViewController` object or nil.
 */
- (instancetype)initWithRequest:(NSURLRequest *)request
                   redirectUri:(NSString *)redirectUri
                    completion:(APPMeetupAuthWebViewControllerRedirectUriBlock)completion;

/**
 *  Loads the OAuth request.
 */
- (void)loadAuthRequest;

@end