//
//  NDGeocoder.h
//  NDFoursquare
//
//  Created by Daniel_Nagy on 06/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NDGeocoder;

@protocol NDGeocoderDelegate <NSObject>

- (void)geocoder:(NDGeocoder *)geocoder didFinishGeocodingLocationString:(NSString *)locationString withError:(NSError *)error;

@end

@interface NDGeocoder : NSObject

@property (weak, nonatomic) id<NDGeocoderDelegate>delegate;

- (void)convertLocationStringWithAddress:(NSString *)address;

@end
