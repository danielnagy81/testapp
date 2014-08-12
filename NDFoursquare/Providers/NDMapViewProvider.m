//
//  NDMapViewProvider.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 12/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDMapViewProvider.h"

static MKMapView *mapView;

@implementation NDMapViewProvider

+ (MKMapView *)mapView {
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        if (!mapView) {
            mapView = [[MKMapView alloc] init];
        }
    });
    return mapView;
}

@end
