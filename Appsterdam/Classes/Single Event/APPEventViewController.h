//
//  APPEventViewController.h
//  Appsterdam
//
//  Created by Alessio Roberto on 19/10/13.
//  Copyright (c) 2013 Alessio Roberto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APPEvent.h"

@interface APPEventViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) APPEvent *event;
@property (nonatomic, weak) IBOutlet UIWebView *descriptionWV;
@property (nonatomic, weak) IBOutlet UIButton *directionBtn;
@property (nonatomic, strong) NSString *veespoToken;

- (IBAction)openMapViewController:(id)sender;
- (IBAction)openVeespo:(id)sender;

@end
