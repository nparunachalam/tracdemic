//
//  HomeViewController.m
//  Tracdemic
//
//  Created by Oruvan on 3/29/20.
//  Copyright © 2020 Oruvan. All rights reserved.
//

#import "HomeViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"

#import <MapKit/MapKit.h>
#import "LocationSearchTableViewController.h"
#import "PinAnnotationView.h"

@interface HomeViewController () <CLLocationManagerDelegate, MKMapViewDelegate, MapSearchSelectionDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *loactionManager;
@property (nonatomic, assign) CLLocationCoordinate2D userCurrentLocation;

@property (nonatomic, strong) UISearchController *resultsearchController;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLeftMenuButton];
    
    [self.mapView registerClass:[PinAnnotationView class] forAnnotationViewWithReuseIdentifier:@"SelectedLocation"];
    
    UIBarButtonItem *searchIcon = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBarButtonIconAction:)];
    [self.navigationItem setRightBarButtonItem:searchIcon];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startTracingUserLocation];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopTracingUserLocation];
}

#pragma mark -

-(void)searchBarButtonIconAction:(id)sender {
    [self setupSearchTableController];
}

-(void)setupSearchTableController {
    LocationSearchTableViewController *searchTableController = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationSearchTable"];
    self.resultsearchController = [[UISearchController alloc] initWithSearchResultsController:searchTableController];
    [self.resultsearchController setSearchResultsUpdater:searchTableController];
    [searchTableController setSelectionDelegate:self];
    
    UISearchBar *searchBar = [self.resultsearchController searchBar];
    [searchBar sizeToFit];
    [searchBar setPlaceholder:@"Check Address"];
    
    [self.navigationItem setTitleView:searchBar];
    
    [self.resultsearchController setHidesNavigationBarDuringPresentation:NO];
    [self.resultsearchController setObscuresBackgroundDuringPresentation:YES];
    [self setDefinesPresentationContext:YES];
    
    [searchBar becomeFirstResponder];
}

-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)leftDrawerButtonPress:(id)sender{
    [self.searchBar resignFirstResponder];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark - Location related

-(void)startTracingUserLocation {
    
    if(!self.loactionManager) {
        self.loactionManager = [[CLLocationManager alloc] init];
        [self.loactionManager setDelegate:self];
        [self.loactionManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [self.loactionManager requestWhenInUseAuthorization];
    }
    [self.loactionManager startUpdatingLocation];
    
    
}

-(void)stopTracingUserLocation {
    
    [self.loactionManager stopUpdatingLocation];
    [self.loactionManager setDelegate:nil];
    self.loactionManager = nil;
    
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    NSLog(@"locations: %@", locations);
    
    CLLocationCoordinate2D coord = manager.location.coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(coord, span);
    [self.mapView setRegion:region];
    
    self.userCurrentLocation = coord;
    
    MKPointAnnotation *myLocation = [[MKPointAnnotation alloc] init];
    [myLocation setCoordinate:coord];
    [myLocation setTitle:@"My Location"];
    [self.mapView addAnnotation:myLocation];
    
    [self stopTracingUserLocation];
}



//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
//
//    if(annotation.class == [MKPinAnnotationView class]) {
//
////        PinAnnotationView *pinView = (PinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"SelectedLocation" forAnnotation:annotation];
////        pinView.canShowCallout = YES;
////        [pinView setTintColor:[UIColor purpleColor]];
////
////        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
////        pinView.leftCalloutAccessoryView = button;
//
//        MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pin" forAnnotation:annotation];
//        [pinView setCanShowCallout:YES];
//        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//        [button setImage:[UIImage imageNamed:@"addButton.png"] forState:UIControlStateNormal];
//        [button sizeToFit];
//        pinView.leftCalloutAccessoryView = button;
//
//        return pinView;
//    }
//    else {
//        return nil;
//    }
//}

-(MKAnnotationView *)mapView:(MKMapView *)map
        viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *AnnotationViewID = @"stationViewId";

    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;  // use default user location view
    }

    MKPinAnnotationView *annotationView =
        (MKPinAnnotationView*) [self.mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];

    if (annotationView == nil) {
        // if an existing pin view was not available, create one
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];

        // add rightAccessoryView
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setImage:[UIImage imageNamed:@"addButton"] forState:UIControlStateNormal];
        [rightButton sizeToFit];
        [rightButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        annotationView.rightCalloutAccessoryView = rightButton;
    }

    annotationView.annotation = annotation;
    annotationView.canShowCallout = YES;
    annotationView.animatesDrop   = NO;

    return annotationView;
}

-(void)addButtonAction:(id)sender {
    UIViewController *recordMeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RecordMe"];
    [self.navigationController showViewController:recordMeViewController sender:self];
}

#pragma mark -

-(void) zoomInSelection:(MKPlacemark*_Nonnull)placemark {
    
    [self.mapView removeAnnotations:[self.mapView annotations]];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:[placemark coordinate]];
    [annotation setTitle:[placemark name]];
    
    if([placemark administrativeArea]) {
        [annotation setSubtitle:[NSString stringWithFormat:@"%@ %@", placemark.locality, placemark.administrativeArea]];
    }
    
    [self.mapView addAnnotation:annotation];
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake([placemark coordinate], span);
    [self.mapView setRegion:region];
    
}

@end
