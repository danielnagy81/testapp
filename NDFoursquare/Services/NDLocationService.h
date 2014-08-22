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

typedef void (^NDLocationServiceErrorHandler) (NSError *error);

+ (NDLocationService *)sharedInstance;
- (NSError *)currentLocationWithErrorHandler:(NDLocationServiceErrorHandler)errorHandler;
- (void)stopMonitoring;
- (void)setDelegate:(id<CLLocationManagerDelegate>)delegate;

@end
