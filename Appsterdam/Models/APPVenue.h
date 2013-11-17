
#import <MapKit/MapKit.h>

/**
 *  `APPVenue`
 */
@interface APPVenue : NSObject <MKAnnotation>

/**
 *  The venue city.
 */
@property (nonatomic, strong) NSString *city;

/**
 *  The venue country.
 */
@property (nonatomic, strong) NSString *country;

/**
 *  The venue name.
 */
@property (nonatomic, strong) NSString *name;

/**
 *  The venue address.
 */
@property (nonatomic, strong) NSString *address;

/**
 *  The venue ID.
 */
@property (nonatomic, strong) NSString *venueID;

/**
 *  The designated initializer to initialize an `APPVenue` object.
 *
 *  @param dictionary A JSON dictionary from a Meetup API end point.
 *
 *  @return An initiliazed `APPVenue` object or nil.
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
