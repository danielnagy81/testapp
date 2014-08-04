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
    NetworkStatus _isInternetReachable;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _reachability = [Reachability reachabilityForInternetConnection];
        _isInternetReachable = [_reachability currentReachabilityStatus];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(internetStatusChanged) name:kReachabilityChangedNotification object:nil];
        [_reachability startNotifier];
    }
    return self;
}

- (NSString *)accessToken {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:AccessTokenIsAlreadyProvidedUserDefaultsKey];
}

- (void)authenticate {
    
    if (_isInternetReachable != NotReachable) {
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
        NSLog(@"There is no internet connection at the moment.");
        //TODO: Implement a user flow that redirects from here to one of the view controllers.
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
    
    if (_isInternetReachable != NotReachable) {
        [FSOAuth requestAccessTokenForCode:accessCode clientId:ClientID callbackURIString:CallbackURIString clientSecret:ClientSecret completionBlock:^(NSString *authToken, BOOL requestCompleted, FSOAuthErrorCode errorCode) {
            
            if (requestCompleted && errorCode == FSOAuthErrorNone) {
                [[NSUserDefaults standardUserDefaults] setObject:authToken forKey:AccessTokenIsAlreadyProvidedUserDefaultsKey];
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

- (void)internetStatusChanged {
    
    _isInternetReachable = [_reachability currentReachabilityStatus];
    if (_isInternetReachable == NotReachable) {
        NSLog(@"The internet is not reachable at the moment.");
    }
    else if (_isInternetReachable == ReachableViaWiFi) {
        NSLog(@"There is internet via wifi.");
    }
    else {
        NSLog(@"There is internet via wwan.");
    }
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
