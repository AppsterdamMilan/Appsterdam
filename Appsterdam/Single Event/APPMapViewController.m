//
//  APPMapViewController.m
//  Appsterdam
//
//  Created by Alessio Roberto on 20/10/13.
//  Copyright (c) 2013 Alessio Roberto. All rights reserved.
//

#import "APPMapViewController.h"

@interface APPMapViewController ()
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MKMapView *mapView;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [_locationManager stopUpdatingLocation];
    _locationManager = nil;
}

#pragma mark - Getters And Setters

-(MKMapView *)mapView
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

-(CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 200;
    }
    return _locationManager;
}

#pragma mark - Location and Map

-(void)setupMap
{
    MKMapPoint annotationPoint = MKMapPointForCoordinate(self.mapView.userLocation.coordinate);
    MKMapRect zoomRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 3.5, 3.5);
    for (id <MKAnnotation> annotation in self.mapView.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 4.0, 4.0);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    [self.mapView setVisibleMapRect:zoomRect animated:YES];
    [self.locationManager stopUpdatingLocation];
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
        pin.calloutOffset = CGPointZero;
    }
    return pin;
}

@end
