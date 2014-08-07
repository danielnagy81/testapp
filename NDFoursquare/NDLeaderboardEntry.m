//
//  NDLeaderboard.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 07/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDLeaderboardEntry.h"

@implementation NDLeaderboardEntry

- (instancetype)init {
    self = [super init];
    if (self) {
        _userName = [[NSString alloc] init];
        _userScore = [[NSString alloc] init];
    }
    return self;
}

@end
