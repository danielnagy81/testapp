//
//  NDGeocoder.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 06/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDGeocoder.h"
#import <CoreLocation/CoreLocation.h>

@implementation NDGeocoder

- (void)convertLocationStringWithAddress:(NSString *)address {
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        [_delegate geocoder:self didFinishGeocodingWithLocationArray:placemarks withError:error];
    }];
}

@end
