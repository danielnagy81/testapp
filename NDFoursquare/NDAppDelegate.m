//
//  NDAppDelegate.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 31/07/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDAppDelegate.h"
#import "NDAuthenticationService.h"
//********TEST*********
#import "NDJSONParser.h"
#import "NDAPIService.h"
//********TEST*********

@implementation NDAppDelegate {
    
    NDAuthenticationService *_authenticationService;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //********TEST*********
    NSData *contentOfURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://api.foursquare.com/v2/users/leaderboard?oauth_token=EXFFYIEEJK0WXP4AYXXP0OB2NPL3XE3O410VZEYBQ5GSY1IB&v=20140804"]];
    NDAPIService *api = [[NDAPIService alloc] init];
    [api jsonParserWithUrlString:@"https://api.foursquare.com/v2/users/leaderboard?oauth_token=1CUVPISLFOWVS0VZUC0VSTZWZ1QC2PWK2FYMICZM1MS4HAQG&v=20140804"];
    NDJSONParser *parser = [[NDJSONParser alloc] initWithData:contentOfURL];
    NSArray *array = [parser leaderboardArray];
    
    NSLog(@"%u", 17<<1);
    
    //********TEST*********
    
    _authenticationService = [[NDAuthenticationService alloc] init];
    [_authenticationService authenticate];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    [_authenticationService handleURL:url];
    return YES;
}

@end
