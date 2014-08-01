//
//  NDURLRequestFactory.h
//  NDFoursquare
//
//  Created by Daniel_Nagy on 01/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NDURLRequestFactory : NSObject

+ (NSURL *)leaderboardURLWithAuthToken:(NSString *)authToken;
+ (NSURL *)tipsURLWithLocationString:(NSString *)locationString authToken:(NSString *)authToken;
+ (NSURL *)userInformationURLWithUserID:(NSString *)userID authToken:(NSString *)authToken;
+ (NSURL *)trendingPlacesURLWithLocationString:(NSString *)locationString authToken:(NSString *)authToken;
+ (NSURL *)venuesURLWithLocationString:(NSString *)locationString authToken:(NSString *)authToken;

@end
