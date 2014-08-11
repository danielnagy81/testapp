//
//  NDAuthenticationService.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 01/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDAuthenticationService.h"
#import "FSOAuth.h"
#import "NDNetworkStatusService.h"

NSString *const ClientID = @"FWVVZO3UPNXWXRGL3E3D5FX4XRVBXO2VJHK02Z3CQEHVYLHF";
NSString *const ClientSecret = @"CMC30AIKMH0MZ50COXVBHUSVH5RHUYDUD1ATAORFLI3RDQEN";
NSString *const CallbackURIString = @"ndfoursquare://foursquare";
NSString *const UserAccessTokenUserDefaultsKey = @"AccessToken";
NSString *const URLScheme = @"ndfoursquare";

@implementation NDAuthenticationService {
    
    NDNetworkStatusService *_networkStatusService;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _networkStatusService = [NDNetworkStatusService networkStatusServiceIstance];
    }
    return self;
}

- (NSString *)accessToken {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:UserAccessTokenUserDefaultsKey];
}

- (void)authenticate {
    
    if ([_networkStatusService isNetworkReachable]) {
        if (![[NSUserDefaults standardUserDefaults] objectForKey:UserAccessTokenUserDefaultsKey]) {
            NSLog(@"Authentication required!");
            NSUInteger authenticationResult = [FSOAuth authorizeUserUsingClientId:ClientID callbackURIString:CallbackURIString allowShowingAppStore:NO];
            NSLog(@"%@", [NDAuthenticationService errorMessage:authenticationResult]);
        }
        else {
            NSLog(@"Authentication is not required.");
        }
    }
    else {
        NSLog(@"There is no internet connection at the moment.");
        //TODO: Implement a user flow that redirects from here to one of the view controllers.
    }
}

- (void)forcedAuthenticate {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserAccessTokenUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self authenticate];
}

- (void)handleURL:(NSURL *)url {
    
    if ([url.scheme isEqualToString:URLScheme]) {
        FSOAuthErrorCode errorCode;
        NSString *accessCode = [FSOAuth accessCodeForFSOAuthURL:url error:&errorCode];
        NSLog(@"%@", [NDAuthenticationService errorMessage:errorCode]);
        
        if (errorCode == FSOAuthErrorNone) {
            [self requestAccessTokenWithAccessCode:accessCode];
        }
    }
}

- (void)requestAccessTokenWithAccessCode:(NSString *)accessCode {
    
    if ([_networkStatusService isNetworkReachable]) {
        [FSOAuth requestAccessTokenForCode:accessCode clientId:ClientID callbackURIString:CallbackURIString clientSecret:ClientSecret completionBlock:^(NSString *authToken, BOOL requestCompleted, FSOAuthErrorCode errorCode) {
            
            if (requestCompleted && errorCode == FSOAuthErrorNone) {
                [[NSUserDefaults standardUserDefaults] setObject:authToken forKey:UserAccessTokenUserDefaultsKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSLog(@"The request is completed!");
                NSLog(@"The authentication code is: %@", authToken);
            }
            else {
                NSLog(@"There was an error during the access token request process.");
            }
        }];
    }
    else {
        NSLog(@"There is no internet connection at the moment.");
        //TODO: Implement a user flow that redirects from here to one of the view controllers.
    }
}

+ (NSString *)errorMessage:(FSOAuthErrorCode)errorCode {
    
    if (errorCode == FSOAuthStatusSuccess) {
        return @"The authentication was successfull!";
    }
    else if (errorCode == FSOAuthStatusErrorInvalidClientID) {
        return @"You did not provide a valid client ID to the method.";
    }
    else if (errorCode == FSOAuthStatusErrorInvalidCallback) {
        return @"You did not provide a valid callback string that has been registered with the system.";
    }
    else if (errorCode == FSOAuthStatusErrorFoursquareNotInstalled) {
        return @"Foursquare is not installed on the user's iOS device.";
    }
    else {
        return @"The version of the Foursquare app installed on the user's iOS device is too old to support native auth.";
    }
}

@end
