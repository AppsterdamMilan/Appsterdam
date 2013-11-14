//
//  APPVenue.h
//  Appsterdam
//
//  Created by Mouhcine El Amine on 14/11/13.
//  Copyright (c) 2013 Alessio Roberto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

/**
 *  `APPVenue`
 */
@interface APPVenue : NSObject <MKAnnotation>

/**
 *  The venue ID.
 */
@property (nonatomic, strong) NSString *venueID;

/**
 *  The venue name.
 */
@property (nonatomic, strong) NSString *name;

/**
 *  The venue address.
 */
@property (nonatomic, strong) NSString *address;

/**
 *  The venue city.
 */
@property (nonatomic, strong) NSString *city;

/**
 *  The venue country.
 */
@property (nonatomic, strong) NSString *country;

/**
 *  The designated initializer to initialize an `APPVenue` object.
 *
 *  @param dictionary A JSON dictionary from a Meetup API end point.
 *
 *  @return An initiliazed `APPVenue` object or nil.
 */
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
