//
//  NDAppDelegate.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 31/07/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDAppDelegate.h"
#import "FSOAuth.h"
#import "NDJSONParser.h"

@implementation NDAppDelegate

NSString *const ClientID = @"FWVVZO3UPNXWXRGL3E3D5FX4XRVBXO2VJHK02Z3CQEHVYLHF";
NSString *const ClientSecret = @"CMC30AIKMH0MZ50COXVBHUSVH5RHUYDUD1ATAORFLI3RDQEN";
NSString *const URIString = @"ndfoursquare://foursquare";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSString *urlString = @"https://api.foursquare.com/v2/users/11703949?oauth_token=1CUVPISLFOWVS0VZUC0VSTZWZ1QC2PWK2FYMICZM1MS4HAQG&v=20140731";
    [NDJSONParser parseUserInfoWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
    return YES;
}

@end
