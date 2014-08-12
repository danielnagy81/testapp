//
//  NDAPIService.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 04/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDAPIService.h"
#import "NDTrendingPlacesParser.h"
#import "NDTipsParser.h"
#import "NDLeaderboardParser.h"
#import "NDUserInformationParser.h"
#import "NDNetworkStatusService.h"
#import "NDURLRequestFactory.h"
#import "NDAuthenticationService.h"

@implementation NDAPIService {
    
    NDServiceType _requestType;
    /**
     *  _optinalInputParameter can be nil, a location or a UserID depending on the request.
     */
    NSString *_optinalInputParameter;
    NDNetworkStatusService *_networkStatusService;
}

- (instancetype)initWithServiceType:(NDServiceType)serviceType withOptionalParameter:(NSString *)optionalParameter {
    self = [super init];
    if (self) {
        _requestType = serviceType;
        _optinalInputParameter = optionalParameter;
        _networkStatusService = [NDNetworkStatusService networkStatusServiceIstance];
    }
    return self;
}

- (void)processURLWithCompletion:(NDProcessCompletionBlock)completion {
    
    if ([_networkStatusService isNetworkReachable]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:UserAccessTokenUserDefaultsKey];
            if (authToken) {
                NSURL *requestURL = [self urlWithAuthToken:authToken];
                NSData *dataFromURL = [NSData dataWithContentsOfURL:requestURL];
                NSArray *resultArray = [self jsonParserWithData:dataFromURL];
                if (resultArray.count > 0) {
                    if (completion) {
                        completion(resultArray, nil);
                    }
                    else {
                        NSLog(@"Error: The block is nil in %s.", __PRETTY_FUNCTION__);
                    }
                }
                else {
                    if (completion) {
                        NSDictionary *errorDetails = @{NSLocalizedDescriptionKey: @"The returned array was empty."};
                        NSError *error = [NSError errorWithDomain:@"com.ndani.foursquare" code:999 userInfo:errorDetails];
                        completion(resultArray, error);
                    }
                    else {
                        NSLog(@"Error: The block is nil in %s.", __PRETTY_FUNCTION__);
                    }
                }
            }
            else {
                NSLog(@"Error: There was no auth token in the user defaults.");
            }
        });
    }
    else {
        NSLog(@"The network is not reachable at the moment.");
        if (completion) {
            NSDictionary *errorDetails = @{NSLocalizedDescriptionKey: @"The network is not reachable at the moment."};
            NSError *error = [NSError errorWithDomain:@"com.ndani.foursquare" code:998 userInfo:errorDetails];
            completion(nil, error);
        }
    }
}

- (NSURL *)urlWithAuthToken:(NSString *)authToken {
    
    switch (_requestType) {
        case NDServiceTypeUsersLeaderboard:
            return [NDURLRequestFactory leaderboardURLWithAuthToken:authToken];
        case NDServiceTypeUsers:
            return [NDURLRequestFactory userInformationURLWithUserID:_optinalInputParameter authToken:authToken];
        case NDServiceTypeTipsSearch:
            return [NDURLRequestFactory tipsURLWithLocationString:_optinalInputParameter authToken:authToken];
        case NDServiceTypeVenuesTrending:
            return [NDURLRequestFactory trendingPlacesURLWithLocationString:_optinalInputParameter authToken:authToken];
        default:
            NSLog(@"Error, service type is incorrect in %s", __PRETTY_FUNCTION__);
            return nil;
    }
}

- (id)jsonParserWithData:(NSData *)data {
    
    if (!data) {
        NSLog(@"Error, the data you pass in was nil in %s.", __PRETTY_FUNCTION__);
    }
    switch (_requestType) {
        case NDServiceTypeUsersLeaderboard: {
            NDLeaderboardParser *leaderboardParser = [[NDLeaderboardParser alloc] initWithData:data];
            return [leaderboardParser parse];
        }
        case NDServiceTypeUsers: {
            NDUserInformationParser *userInformationParser = [[NDUserInformationParser alloc] initWithData:data];
            return [userInformationParser parse];
        }
        case NDServiceTypeTipsSearch: {
            NDTipsParser *tipParser = [[NDTipsParser alloc] initWithData:data];
            return [tipParser parse];
        }
        case NDServiceTypeVenuesTrending: {
            NDTrendingPlacesParser *trendingPlacesParser = [[NDTrendingPlacesParser alloc] initWithData:data];
            return [trendingPlacesParser parse];
        }
        default:
            NSLog(@"Error, service type is incorrect in %s", __PRETTY_FUNCTION__);
            return nil;
    }
}

@end

