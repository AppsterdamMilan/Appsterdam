//
//  APPMeeUpCommunicator.h
//  Appsterdam
//
//  Created by Alessio Roberto on 17/10/13.
//  Copyright (c) 2013 Alessio Roberto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPMeeUpCommunicator : NSObject

+ (void)getEvents:(void (^)(NSArray *events))result;

@end
