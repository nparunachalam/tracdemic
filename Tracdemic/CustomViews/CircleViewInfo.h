//
//  CircleViewInfo.h
//  Tracdemic
//
//  Created by Oruvan on 3/30/20.
//  Copyright © 2020 Oruvan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CircleViewInfo : NSObject

@property (nonatomic, assign) CLLocationDistance distanceInMeters;
@property (nonatomic, assign) CLLocationCoordinate2D locationCoord;

+(instancetype)initWithDistance:(CGFloat)distance coord:(CLLocationCoordinate2D)location xOffset:(double)xOffset yOffset:(double)yOffset;

@end

NS_ASSUME_NONNULL_END
