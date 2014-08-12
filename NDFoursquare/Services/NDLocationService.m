//
//  NDLocationService.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 07/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDLocationService.h"
#import "NDNetworkStatusService.h"

static NDLocationService *locationService;

@implementation NDLocationService {
    
    BOOL _updating;
    NDNetworkStatusService *_networkService;
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
        _networkService = [NDNetworkStatusService networkStatusServiceIstance];
        _locationManager = [[CLLocationManager alloc] init];
    }
    return self;
}

- (void)setDelegate:(id<CLLocationManagerDelegate>)delegate {
    
    _locationManager.delegate = delegate;
}

- (NSError *)currentLocation {
    
    if ([_networkService isNetworkReachable]) {
        if (!_updating) {
            [_locationManager startUpdatingLocation];
            _updating = YES;
        }
        return nil;
    }
    else {
        NSDictionary *errorDetails = @{NSLocalizedDescriptionKey: @"The network is not reachable at the moment."};
        NSError *error = [NSError errorWithDomain:@"com.ndani.foursquare" code:998 userInfo:errorDetails];
        return error;
    }
}

- (void)stopMonitoring {
    
    if (_updating) {
        [_locationManager stopUpdatingLocation];
        _updating = NO;
    }
}

@end
