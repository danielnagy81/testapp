//
//  NDAuthenticationViewViewController.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 11/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDAuthenticationViewViewController.h"
#import "NDAuthenticationService.h"

@interface NDAuthenticationViewViewController () {
    
    NDAuthenticationService *_authenticationService;
}

@end

@implementation NDAuthenticationViewViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authenticationServiceDidFinishedAuthenticationWitNotification:) name:AuthenticationDidFinishedNotificationName object:nil];
    _authenticationService = [[NDAuthenticationService alloc] init];
}

- (IBAction)authenticate:(UIButton *)sender {
    
    [_authenticationService forcedAuthenticate];
}

- (void)authenticationServiceDidFinishedAuthenticationWitNotification:(NSNotification *)notification {
    
    if (notification.userInfo) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[notification.userInfo objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"The authentication process was successful!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
