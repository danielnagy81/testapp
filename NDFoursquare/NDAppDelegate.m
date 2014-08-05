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
#import "NDAPIService.h"
//********TEST*********

@implementation NDAppDelegate {
    
    NDAuthenticationService *_authenticationService;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _authenticationService = [[NDAuthenticationService alloc] init];
    [_authenticationService authenticate];
    //********TEST*********
    NSURL *requestURL = [NDURLRequestFactory trendingPlacesURLWithLocationString:@"47.497453,19.076745" authToken:[_authenticationService accessToken]];
    NDAPIService *apiService = [[NDAPIService alloc] initWithURL:requestURL];
    [apiService processURLWithCompletion:^(NSArray *resultArray, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }
        else {
            NSLog(@"%@", resultArray);
        }
    }];
    
    NSLog(@"%u", 17<<1);
    
    //********TEST*********

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    [_authenticationService handleURL:url];
    return YES;
}

@end
