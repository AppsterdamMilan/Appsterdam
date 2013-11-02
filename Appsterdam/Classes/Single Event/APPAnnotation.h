//
//  APPAnnotation.h
//  Appsterdam
//
//  Created by Alessio Roberto on 02/11/13.
//  Copyright (c) 2013 Alessio Roberto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface APPLocation : NSObject {
    CLLocationCoordinate2D _coordinate;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end


@interface APPAnnotation : NSObject <MKAnnotation>

@property (nonatomic,strong) APPLocation *location;
@property (nonatomic,strong) NSString *name;
@property (nonatomic, strong) NSString *address;

@end
