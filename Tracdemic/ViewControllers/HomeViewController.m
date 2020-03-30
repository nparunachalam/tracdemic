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
#import "StatusUpdateViewController.h"
#import "CircleViewInfo.h"

#define kPageTitle @"Tracdemic"

@interface HomeViewController () <CLLocationManagerDelegate, MKMapViewDelegate, MapSearchSelectionDelegate, UISearchBarDelegate>

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
    [self updateTitle];
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

- (IBAction)statusUpdateButtonAction:(id)sender {
    
    StatusUpdateViewController *statusUpdateViewController = [[StatusUpdateViewController alloc] init];
    [self.navigationController pushViewController:statusUpdateViewController animated:YES];
    
}
- (IBAction)recordMeButtonAction:(id)sender {
    
    UIAlertController * disabledContactsAlert = [UIAlertController alertControllerWithTitle:@"Thank you"
                message:@"Your location/route will be anonymous recorded"
                preferredStyle:UIAlertControllerStyleAlert];


    [disabledContactsAlert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                              style:UIAlertActionStyleDefault
                                                            handler:nil]];
    [self presentViewController:disabledContactsAlert animated:YES completion:nil];
    
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
    [searchBar setDelegate:self];
    
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
    [self.resultsearchController.searchBar resignFirstResponder];
    [self updateTitle];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark -

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self updateTitle];
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
    
//    MKPointAnnotation *myLocation = [[MKPointAnnotation alloc] init];
//    [myLocation setCoordinate:coord];
//    [myLocation setTitle:@"My Location"];
//    [self.mapView addAnnotation:myLocation];
    
    [self createRandomCircles];
    [self stopTracingUserLocation];
}

-(MKAnnotationView *)mapView:(MKMapView *)map
        viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *AnnotationViewID = @"annotationViewId";

    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;  // use default user location view
    }

    MKPinAnnotationView *annotationView =
        (MKPinAnnotationView*) [self.mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];

    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];

//        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [rightButton setImage:[UIImage imageNamed:@"addButton"] forState:UIControlStateNormal];
//        [rightButton sizeToFit];
//        [rightButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        annotationView.rightCalloutAccessoryView = rightButton;
    }

    annotationView.annotation = annotation;
    annotationView.canShowCallout = YES;
    annotationView.animatesDrop   = NO;

    return annotationView;
}

-(void)addButtonAction:(id)sender {
    UIViewController *recordMeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddDetails"];
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
    [self.mapView setSelectedAnnotations:@[annotation]];
    
    [self updateTitle];
    
}

#pragma mark -

-(void)updateTitle {
    [self.navigationItem setTitleView:nil];
    [self setTitle:kPageTitle];
}

-(void) addCircle {
    CLLocationDistance fenceDistance = 300;
    CLLocationCoordinate2D circleMiddlePoint = CLLocationCoordinate2DMake(self.userCurrentLocation.latitude, self.userCurrentLocation.longitude);
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:circleMiddlePoint radius:fenceDistance];
    [self.mapView addOverlay: circle];
    
}


-(MKOverlayRenderer*)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    if([overlay isKindOfClass:[MKCircle class]]) {
        
        MKCircleRenderer *circle = [[MKCircleRenderer alloc] initWithOverlay:overlay];
        [circle setStrokeColor:[UIColor redColor]];
        [circle setFillColor:[UIColor colorWithRed:255/255 green:0 blue:0 alpha:0.1]];
        [circle setLineWidth:1.0];
        return circle;
    }
    else {
        return nil;
    }
    
}

-(void) createRandomCircles {
    
    NSMutableArray *circleDetailsArray = [NSMutableArray array];
    [circleDetailsArray addObject:[CircleViewInfo initWithDistance:250 coord:self.userCurrentLocation xOffset:10000 yOffset:4000]];
    [circleDetailsArray addObject:[CircleViewInfo initWithDistance:1000 coord:self.userCurrentLocation xOffset:5000 yOffset:3000]];
    [circleDetailsArray addObject:[CircleViewInfo initWithDistance:800 coord:self.userCurrentLocation xOffset:2000 yOffset:500]];
 
    [circleDetailsArray enumerateObjectsUsingBlock:^(CircleViewInfo *circleInfo, NSUInteger idx, BOOL * _Nonnull stop) {
        CLLocationCoordinate2D circleMiddlePoint = CLLocationCoordinate2DMake(circleInfo.locationCoord.latitude, circleInfo.locationCoord.longitude);
        MKCircle *circle = [MKCircle circleWithCenterCoordinate:circleMiddlePoint radius:circleInfo.distanceInMeters];
        [self.mapView addOverlay: circle];
        
    }];
}

@end
