//
//  NDNetworkStatusService.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 04/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDNetworkStatusService.h"
#import "Reachability.h"

static NDNetworkStatusService *networkStatusService;

@implementation NDNetworkStatusService {
    
    Reachability *_reachability;
}

+ (NDNetworkStatusService *)networkStatusServiceIstance {
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        networkStatusService = [[NDNetworkStatusService alloc] init];
    });
    return networkStatusService;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _reachability = [Reachability reachabilityForInternetConnection];
    }
    return self;
}

- (BOOL)isNetworkReachable {
    
    if ([_reachability currentReachabilityStatus] == NotReachable) {
        return NO;
    }
    return YES;
}

@end
