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
    _authenticationService = [[NDAuthenticationService alloc] init];
}

- (IBAction)authenticate:(UIButton *)sender {
    
    [_authenticationService forcedAuthenticate];
}

@end
