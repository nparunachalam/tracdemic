//
//  LocationSearchTableViewController.m
//  Tracdemic
//
//  Created by Oruvan on 3/29/20.
//  Copyright © 2020 Oruvan. All rights reserved.
//

#import "LocationSearchTableViewController.h"
#import <MapKit/MapKit.h>

@interface LocationSearchTableViewController ()

@property (nonatomic, strong) NSArray *matchingItems;

@end

@implementation LocationSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchBarText = [searchController.searchBar text];
    
    if([searchBarText length]) {
        MKMapView *mapView = [[MKMapView alloc] init];
        MKLocalSearchRequest *searchRequest = [[MKLocalSearchRequest alloc] init];
        [searchRequest setNaturalLanguageQuery:searchBarText];
        
        searchRequest.region = mapView.region;
        MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:searchRequest];
        [search startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
            
            if(response) {
                self.matchingItems = [response mapItems];
                [self.tableView reloadData];
            }
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.matchingItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    MKMapItem *mapItem = [self.matchingItems objectAtIndex:indexPath.row];
    MKPlacemark *placemark = [mapItem placemark];

    [cell.textLabel setText:[placemark name]];
    [cell.detailTextLabel setText:[self parseAddress:placemark]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MKMapItem *mapItem = [self.matchingItems objectAtIndex:indexPath.row];
    MKPlacemark *placemark = [mapItem placemark];

    if(self.selectionDelegate) {
        [self.selectionDelegate zoomInSelection:placemark];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -

-(NSString*)parseAddress:(MKPlacemark*)selectedItem {
    
    NSString *firstSpace = (selectedItem.subThoroughfare && selectedItem.thoroughfare) ? @" " : @"";
    NSString *comma = ((selectedItem.subThoroughfare || selectedItem.thoroughfare) && (selectedItem.administrativeArea || selectedItem.subAdministrativeArea) ) ? @", " : @"";
    NSString *secondSpace = (selectedItem.subAdministrativeArea && selectedItem.administrativeArea) ? @" " : @"";
    
    NSString *addressLine = [NSString stringWithFormat:@"%@%@%@%@%@%@%@", selectedItem.subThoroughfare, firstSpace, selectedItem.thoroughfare, comma, selectedItem.locality, secondSpace, selectedItem.administrativeArea];
    
    return addressLine;
}

@end
