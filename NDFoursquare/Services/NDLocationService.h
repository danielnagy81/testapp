//
//  NDLocationService.h
//  NDFoursquare
//
//  Created by Daniel_Nagy on 07/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface NDLocationService : NSObject

+ (NDLocationService *)locationService;
- (void)currentLocation;
- (void)stopMonitoring;
- (void)setDelegate:(id<CLLocationManagerDelegate>)delegate;

@end
