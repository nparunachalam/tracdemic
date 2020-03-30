//
//  LocationSearchTableViewController.h
//  Tracdemic
//
//  Created by Oruvan on 3/29/20.
//  Copyright © 2020 Oruvan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol MapSearchSelectionDelegate <NSObject>

-(void) zoomInSelection:(MKPlacemark*_Nonnull)placemark;

@end

NS_ASSUME_NONNULL_BEGIN

@interface LocationSearchTableViewController : UITableViewController <UISearchResultsUpdating>

@property (nonatomic, weak) id<MapSearchSelectionDelegate> selectionDelegate;

@end

NS_ASSUME_NONNULL_END
