//
//  NDLocationService.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 07/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDLocationService.h"

static NDLocationService *locationService;

@implementation NDLocationService {
    
    BOOL _updating;
    CLLocationManager *_locationManager;
}

+ (NDLocationService *)locationService {
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        if (!locationService) {
            locationService = [[NDLocationService alloc] init];
        }
    });
    return locationService;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return self;
}

- (void)setDelegate:(id<CLLocationManagerDelegate>)delegate {
    
    _locationManager.delegate = delegate;
}

- (void)currentLocation {
    
    if (!_updating) {
        [_locationManager startUpdatingLocation];
        _updating = YES;
    }
}

- (void)stopMonitoring {
    
    if (_updating) {
        [_locationManager stopUpdatingLocation];
        _updating = NO;
    }
}

@end
