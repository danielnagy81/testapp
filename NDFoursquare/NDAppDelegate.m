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
//    [_authenticationService authenticate];
    
    
    //******************TEST******************
    [[NSUserDefaults standardUserDefaults] setObject:@"EXFFYIEEJK0WXP4AYXXP0OB2NPL3XE3O410VZEYBQ5GSY1IB" forKey:@"AccessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //******************TEST******************
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setFont:[UIFont boldSystemFontOfSize:19.0f]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:13.0f]} forState:UIControlStateNormal];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    [_authenticationService handleURL:url];
    return YES;
}

@end
