//
//  CircleViewInfo.m
//  Tracdemic
//
//  Created by Oruvan on 3/30/20.
//  Copyright © 2020 Oruvan. All rights reserved.
//

#import "CircleViewInfo.h"

@implementation CircleViewInfo

+(instancetype)initWithDistance:(CGFloat)distance coord:(CLLocationCoordinate2D)location xOffset:(double)xOffset yOffset:(double)yOffset {
    return [[CircleViewInfo alloc] initWithDistance:distance coord:location xOffset:xOffset yOffset:yOffset];
}

-(instancetype)initWithDistance:(CGFloat)distance coord:(CLLocationCoordinate2D)location xOffset:(double)xOffset yOffset:(double)yOffset {
    
    if(self = [super init]) {        
        self.locationCoord = [self calculateCoordinateFrom:location onBearing:xOffset atDistance:yOffset];//[self convertLocationWith:location xOffset:xOffset yOffset:yOffset];
        self.distanceInMeters = distance;
    }
    return self;
}

- (CLLocationCoordinate2D)calculateCoordinateFrom:(CLLocationCoordinate2D)coordinate  onBearing:(double)bearingInRadians atDistance:(double)distanceInMetres {

       double coordinateLatitudeInRadians = coordinate.latitude * M_PI / 180;
       double coordinateLongitudeInRadians = coordinate.longitude * M_PI / 180;

       double distanceComparedToEarth = distanceInMetres / 6378100;

       double resultLatitudeInRadians = asin(sin(coordinateLatitudeInRadians) * cos(distanceComparedToEarth) + cos(coordinateLatitudeInRadians) * sin(distanceComparedToEarth) * cos(bearingInRadians));
       double resultLongitudeInRadians = coordinateLongitudeInRadians + atan2(sin(bearingInRadians) * sin(distanceComparedToEarth) * cos(coordinateLatitudeInRadians), cos(distanceComparedToEarth) - sin(coordinateLatitudeInRadians) * sin(resultLatitudeInRadians));

       CLLocationCoordinate2D result;
       result.latitude = resultLatitudeInRadians * 180 / M_PI;
       result.longitude = resultLongitudeInRadians * 180 / M_PI;
       return result;
   }



@end
