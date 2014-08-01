//
//  NDAuthenticationService.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 01/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDAuthenticationService.h"
#import "FSOAuth.h"
#import "Reachability.h"

NSString *const ClientID = @"FWVVZO3UPNXWXRGL3E3D5FX4XRVBXO2VJHK02Z3CQEHVYLHF";
NSString *const ClientSecret = @"CMC30AIKMH0MZ50COXVBHUSVH5RHUYDUD1ATAORFLI3RDQEN";
NSString *const CallbackURIString = @"ndfoursquare://foursquare";
NSString *const AccessTokenIsAlreadyProvidedUserDefaultsKey = @"AccessToken";

@implementation NDAuthenticationService {
    
    Reachability *_reachability;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _reachability = [[Reachability alloc] init];
    }
    return self;
}

- (NSString *)accessToken {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:AccessTokenIsAlreadyProvidedUserDefaultsKey];
}

- (void)authenticate {
    
    if ([_reachability currentReachabilityStatus] != NotReachable) {
        NSLog(@"There is internet connection!");
        if (![[NSUserDefaults standardUserDefaults] objectForKey:AccessTokenIsAlreadyProvidedUserDefaultsKey]) {
            NSLog(@"Authentication required!");
            NSUInteger authenticationResult = [FSOAuth authorizeUserUsingClientId:ClientID callbackURIString:CallbackURIString allowShowingAppStore:NO];
            [self errorMessage:authenticationResult];
        }
        else {
            NSLog(@"Authentication is not required.");
        }
    }
    else {
        NSLog(@"There is no internet connection right now.");
    }
}

- (void)handleURL:(NSURL *)url {
    
    if ([url.scheme isEqualToString:@"ndfoursquare"]) {
        FSOAuthErrorCode errorCode;
        NSString *accessCode = [FSOAuth accessCodeForFSOAuthURL:url error:&errorCode];
        [self errorMessage:errorCode];
        
        if (errorCode == FSOAuthErrorNone) {
            [self requestAccessTokenWithAccessCode:accessCode];
        }
    }
}

- (void)requestAccessTokenWithAccessCode:(NSString *)accessCode {
    
    [FSOAuth requestAccessTokenForCode:accessCode clientId:ClientID callbackURIString:CallbackURIString clientSecret:ClientSecret completionBlock:^(NSString *authToken, BOOL requestCompleted, FSOAuthErrorCode errorCode) {
        
        if ([NSThread isMainThread]) {
            NSLog(@"We are on the main thread!");
        }
        else {
            NSLog(@"We are on a background thread!");
        }
        
        if (requestCompleted && errorCode == FSOAuthErrorNone) {
            [[NSUserDefaults standardUserDefaults] setObject:authToken forKey:AccessTokenIsAlreadyProvidedUserDefaultsKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"The request is completed!");
        }
        else {
            NSLog(@"There was an error during the access token request process.");
        }
    }];
}

- (void)errorMessage:(FSOAuthErrorCode)errorCode {
    
    if (errorCode == FSOAuthStatusSuccess) {
        NSLog(@"The authentication was successfull!");
    }
    else if (errorCode == FSOAuthStatusErrorInvalidClientID){
        NSLog(@"You did not provide a valid client ID to the method.");
    }
    else if (errorCode == FSOAuthStatusErrorInvalidCallback) {
        NSLog(@"You did not provide a valid callback string that has been registered with the system.");
    }
    else if (errorCode == FSOAuthStatusErrorFoursquareNotInstalled) {
        NSLog(@"Foursquare is not installed on the user's iOS device.");
    }
    else {
        NSLog(@"The version of the Foursquare app installed on the user's iOS device is too old to support native auth.");
    }
}

@end
