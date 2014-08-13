//
//  NDTip.h
//  NDFoursquare
//
//  Created by Daniel_Nagy on 07/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface NDVenueTips : NSObject

@property (nonatomic) NSString *venueName;
@property (nonatomic) NSMutableArray *tips;
@property (nonatomic) CLLocationCoordinate2D venueCoordinate;
@property (nonatomic) NSString *venueAddress;

@end
