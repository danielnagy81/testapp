//
//  NDGeocoder.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 06/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDGeocoder.h"
#import "NDNetworkStatusService.h"
#import "NDErrorFactory.h"
#import <CoreLocation/CoreLocation.h>

@implementation NDGeocoder {
    
    NDNetworkStatusService *_networkService;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _networkService = [NDNetworkStatusService networkStatusServiceIstance];
    }
    return self;
}

- (NSError *)convertLocationStringWithAddress:(NSString *)address {
    
    NSError *geocoderError = nil;
    if ([_networkService isNetworkReachable]) {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
            [_delegate geocoder:self didFinishGeocodingWithLocationArray:placemarks withError:error];
        }];
    }
    else {
        geocoderError = [NDErrorFactory errorWithDetails:@"The network is not reachable at the moment." withCode:998];
    }
    return geocoderError;
}

@end
