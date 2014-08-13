//
//  NDTrendingPlace.h
//  NDFoursquare
//
//  Created by Daniel_Nagy on 07/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface NDTrendingPlace : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *address;
@property (nonatomic) CLLocationCoordinate2D coordinate;

@end
