#import "APPMapViewController.h"

#import <CoreLocation/CoreLocation.h>

@interface APPMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MKMapView *mapView;

- (void)setUpMap;

@end

@implementation APPMapViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.locationManager startUpdatingLocation];
    [self.view addSubview:self.mapView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [_locationManager stopUpdatingLocation];
    _locationManager = nil;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [self setUpMap];
}


#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation{
    if (annotation == map.userLocation)
        return nil;
    
    static NSString *s = @"ann";
    MKAnnotationView *pin = [map dequeueReusableAnnotationViewWithIdentifier:s];
    if (!pin) {
        pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:s];
        pin.canShowCallout = YES;
        pin.calloutOffset = CGPointZero;
    }
    return pin;
}


#pragma mark - API

#pragma mark Properties

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 200;
    }
    return _locationManager;
}

- (MKMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
        _mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [_mapView setShowsUserLocation:YES];
        [_mapView setZoomEnabled:YES];
        [_mapView setScrollEnabled:YES];
        [_mapView setRotateEnabled:YES];
        _mapView.delegate = self;
        _mapView.tintColor = [UIColor redColor];
        [_mapView addAnnotation:self.annotation];
    }
    return _mapView;
}


#pragma mark Methods

- (void)setUpMap
{
    MKMapPoint annotationPoint = MKMapPointForCoordinate(self.mapView.userLocation.coordinate);
    MKMapRect zoomRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 5.0, 5.0);
    for (id <MKAnnotation> annotation in self.mapView.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 5.0, 5.0);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    [self.mapView setVisibleMapRect:zoomRect animated:YES];
}

@end
