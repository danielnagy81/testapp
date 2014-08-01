//
//  NDAppDelegate.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 31/07/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDAppDelegate.h"
#import "NDAuthenticationService.h"
#import "NDJSONParser.h"
#import "NDURLRequestFactory.h"

@implementation NDAppDelegate {
    
    NDAuthenticationService *_authenticationService;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _authenticationService = [[NDAuthenticationService alloc] init];
    [_authenticationService authenticate];
//    NSString *urlString = @"https://api.foursquare.com/v2/users/11703949?oauth_token=1CUVPISLFOWVS0VZUC0VSTZWZ1QC2PWK2FYMICZM1MS4HAQG&v=20140731";
//    [NDJSONParser parseUserInfoWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    _authenticationService = [[NDAuthenticationService alloc] init];
    [_authenticationService handleURL:url];
    return YES;
}

@end
