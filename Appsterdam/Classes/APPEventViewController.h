//
//  APPEventViewController.h
//  Appsterdam
//
//  Created by Alessio Roberto on 19/10/13.
//  Copyright (c) 2013 Alessio Roberto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APPEventViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) NSDictionary *eventData;
@property (nonatomic, weak) IBOutlet UIWebView *descriptionWV;
@property (nonatomic, weak) IBOutlet UIButton *directionBtn;

- (IBAction)openMapViewController:(id)sender;

@end
