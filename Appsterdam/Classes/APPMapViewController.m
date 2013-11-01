//
//  APPMapViewController.m
//  Appsterdam
//
//  Created by Alessio Roberto on 20/10/13.
//  Copyright (c) 2013 Alessio Roberto. All rights reserved.
//

#import "APPMapViewController.h"

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
    // LocationManager
	_locationManager = [[CLLocationManager alloc]init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    
    [self.view addSubview:mapView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Location and Map

-(void)setupMapForLocatoion:(CLLocation*)newLocation{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.003;
    span.longitudeDelta = 0.003;
    CLLocationCoordinate2D location;
    location.latitude = newLocation.coordinate.latitude;
    location.longitude = newLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [mapView setRegion:region animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
        _locationManager.distanceFilter = 200;
    [self setupMapForLocatoion:newLocation];
}
@end
