//
//  NDAppDelegate.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 31/07/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDAppDelegate.h"
#import "NDAuthenticationService.h"

@implementation NDAppDelegate {
    
    NDAuthenticationService *_authenticationService;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _authenticationService = [[NDAuthenticationService alloc] init];
    [_authenticationService authenticate];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    [_authenticationService handleURL:url];
    return YES;
}

@end
