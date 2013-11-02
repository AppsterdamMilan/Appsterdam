//
//  APPAnnotation.m
//  Appsterdam
//
//  Created by Alessio Roberto on 02/11/13.
//  Copyright (c) 2013 Alessio Roberto. All rights reserved.
//

#import "APPAnnotation.h"

@implementation APPLocation

@end

@implementation APPAnnotation

- (id)init
{
    self = [super init];
    if (self) {
        self.location = [[APPLocation alloc]init];
    }
    return self;
}

-(CLLocationCoordinate2D)coordinate
{
    return self.location.coordinate;
}

-(NSString*)title
{
    return self.name;
}

- (NSString*)subtitle
{
    return self.address;
}

@end
