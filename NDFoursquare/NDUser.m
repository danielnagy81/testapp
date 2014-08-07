//
//  NDUser.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 07/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDUser.h"

@implementation NDUser

- (instancetype)init {
    self = [super init];
    if (self) {
        _name = [[NSString alloc] init];
        _bio = [[NSString alloc] init];
        _homeCity = [[NSString alloc] init];
        _friendsCount = [[NSString alloc] init];
        _tipsCount = [[NSString alloc] init];
        _badgesCount = [[NSString alloc] init];
        _checkinsCount = [[NSString alloc] init];
        _mayorshipCount = [[NSString alloc] init];
        _facebookContact = [[NSString alloc] init];
        _email = [[NSString alloc] init];
    }
    return self;
}

@end
