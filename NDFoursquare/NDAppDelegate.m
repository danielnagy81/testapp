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
    NDAPIService *apiService = [[NDAPIService alloc] initWithServiceType:NDServiceTypeVenuesTrending withOptionalParameter:@"47.495090,19.059048"];
    [apiService processURLWithCompletion:^(NSArray *resultArray, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }
        else {
            NSLog(@"%@", resultArray);
        }
    }];
    //********TEST*********

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    [_authenticationService handleURL:url];
    return YES;
}

@end
