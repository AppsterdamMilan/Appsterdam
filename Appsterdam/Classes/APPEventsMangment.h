//
//  APPEventsMangment.h
//  Appsterdam
//
//  Created by Alessio Roberto on 17/10/13.
//  Copyright (c) 2013 Alessio Roberto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPEventsMangment : NSObject

@property (nonatomic, strong) NSArray *talkLabList;
@property (nonatomic, strong) NSArray *weeklyBeerList;
@property (nonatomic, strong) NSArray *othersEventList;
@property (nonatomic, strong) NSArray *workShopList;

- (NSArray *)getTalkLabList;
- (NSArray *)getWeeklyBeerList;
- (NSArray *)getWorkShopList;
- (NSArray *)getOthersEventList;

@end
