//
//  APPMapViewController.m
//  Appsterdam
//
//  Created by Alessio Roberto on 20/10/13.
//  Copyright (c) 2013 Alessio Roberto. All rights reserved.
//

#import "APPMapViewController.h"
#import "APPAnnotation.h"

@interface APPMapViewController () {
    CLLocationManager *_locationManager;
    MKMapView* mapView;
}

@end

@implementation APPMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // MAKMapView
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, (screenBounds.size.height == 568)?568:480)];
    [mapView setShowsUserLocation:YES];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    [mapView setRotateEnabled:YES];
    mapView.delegate = self;
    mapView.tintColor = [UIColor redColor];
    
    APPAnnotation *annotation = [[APPAnnotation alloc] init];
    [annotation.location setCoordinate:self.venueLocation.coordinate];
    annotation.name = self.nameLocation;
    annotation.address = self.addressLocation;
    [mapView addAnnotation:annotation];
    
    // LocationManager
	_locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    _locationManager.delegate = self;
    _locationManager.distanceFilter = 200;
    [_locationManager startUpdatingLocation];
    
    [self.view addSubview:mapView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [_locationManager stopUpdatingLocation];
    _locationManager = nil;
}

#pragma mark - Location and Map

-(void)setupMap
{
    MKMapPoint annotationPoint = MKMapPointForCoordinate(mapView.userLocation.coordinate);
    MKMapRect zoomRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 3.5, 3.5);
    for (id <MKAnnotation> annotation in mapView.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 4.0, 4.0);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    [mapView setVisibleMapRect:zoomRect animated:YES];
    [_locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [self setupMap];
}

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation{
    if (annotation == map.userLocation)
        return nil;
    
    static NSString *s = @"ann";
    MKAnnotationView *pin = [map dequeueReusableAnnotationViewWithIdentifier:s];
    if (!pin) {
        pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:s];
        pin.canShowCallout = YES;
        pin.calloutOffset = CGPointMake(0, 0);
    }
    return pin;
}

@end
