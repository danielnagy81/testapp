//
//  NDTrendingPlace.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 07/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDTrendingPlace.h"

@implementation NDTrendingPlace

- (instancetype)init {
    self = [super init];
    if (self) {
        _name = [[NSString alloc] init];
        _address = [[NSString alloc] init];
        _latitudeString = [[NSString alloc] init];
        _longitudeString = [[NSString alloc] init];
    }
    return self;
}

@end
