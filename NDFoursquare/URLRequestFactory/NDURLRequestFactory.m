//
//  NDURLRequestFactory.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 01/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDURLRequestFactory.h"

NSString *const BaseURLString = @"https://api.foursquare.com/v2/";

@implementation NDURLRequestFactory

+ (NSURL *)leaderboardURLWithAuthToken:(NSString *)authToken {
    
    if (!authToken) {
        NSLog(@"Error: there was not enough input parameters in %s.", __PRETTY_FUNCTION__);
        return nil;
    }
    NSString *urlString = [BaseURLString stringByAppendingString:[NSString stringWithFormat:@"users/leaderboard?oauth_token=%@&v=%@", authToken, [self requestVersion]]];
    return [NSURL URLWithString:urlString];
}

+ (NSURL *)tipsURLWithLocationString:(NSString *)locationString authToken:(NSString *)authToken {
    
    if (!locationString || !authToken) {
        NSLog(@"Error: there was not enough input parameters in %s.", __PRETTY_FUNCTION__);
        return nil;
    }
    NSString *urlString = [BaseURLString stringByAppendingString:[NSString stringWithFormat:@"tips/search?ll=%@&oauth_token=%@&v=%@", locationString, authToken, [self requestVersion]]];
    return [NSURL URLWithString:urlString];
}

+ (NSURL *)userInformationURLWithUserID:(NSString *)userID authToken:(NSString *)authToken {
    
    if (!userID || !authToken) {
        NSLog(@"Error: there was not enough input parameters in %s.", __PRETTY_FUNCTION__);
        return nil;
    }
    NSString *urlString = [BaseURLString stringByAppendingString:[NSString stringWithFormat:@"users/%@?oauth_token=%@&v=%@", userID, authToken, [self requestVersion]]];
    return [NSURL URLWithString:urlString];
}

+ (NSURL *)trendingPlacesURLWithLocationString:(NSString *)locationString authToken:(NSString *)authToken {
    
    if (!locationString || !authToken) {
        NSLog(@"Error: there was not enough input parameters in %s.", __PRETTY_FUNCTION__);
        return nil;
    }
    NSString *urlString = [BaseURLString stringByAppendingString:[NSString stringWithFormat:@"venues/trending?ll=%@&oauth_token=%@&v=%@", locationString, authToken, [self requestVersion]]];
    return [NSURL URLWithString:urlString];
}

+ (NSString *)requestVersion {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMdd";
    NSDate *currentDate = [NSDate date];
    return [dateFormatter stringFromDate:currentDate];
}

@end
