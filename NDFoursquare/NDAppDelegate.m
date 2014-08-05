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
#import "NDURLRequestFactory.h"
#import "NDAPIService.h"
//********TEST*********

@implementation NDAppDelegate {
    
    NDAuthenticationService *_authenticationService;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _authenticationService = [[NDAuthenticationService alloc] init];
    [_authenticationService authenticate];
    //********TEST*********
    NSURL *url = [NDURLRequestFactory trendingPlacesURLWithLocationString:@"47.507658,19.079491" authToken:[_authenticationService accessToken]];
    NSData *dataWithURL = [NSData dataWithContentsOfURL:url];
    
    NDJSONParser *parser = [[NDJSONParser alloc] initWithData:dataWithURL];
    NSArray *array = [parser parseTrendingPlaces];
    
    NSLog(@"%u", 17<<1);
    
    //********TEST*********

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    [_authenticationService handleURL:url];
    return YES;
}

@end
