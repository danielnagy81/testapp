//
//  NDAPIService.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 04/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDAPIService.h"
#import "NDJSONParser.h"
#import "NDNetworkStatusService.h"
#import "NDURLRequestFactory.h"
#import "NDAuthenticationService.h"

@implementation NDAPIService {
    
    NDServiceType _serviceType;
    /**
     *  _optinalInputParameter can be nil, a location or a UserID depending on the request.
     */
    NSString *_optinalInputParameter;
    NDNetworkStatusService *_networkStatusService;
}

- (instancetype)initWithServiceType:(NDServiceType)serviceType withOptionalParameter:(NSString *)optionalParameter {
    self = [super init];
    if (self) {
        _serviceType = serviceType;
        _optinalInputParameter = optionalParameter;
        _networkStatusService = [NDNetworkStatusService networkStatusServiceIstance];
    }
    return self;
}

- (void)processURLWithCompletion:(NDCompletionBlock)completion {
    
    if ([_networkStatusService isNetworkReachable]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:UserAccessTokenUserDefaultsKey];
            if (authToken) {
                NSURL *requestURL = [self urlWithAuthToken:authToken];
                NSData *dataFromURL = [NSData dataWithContentsOfURL:requestURL];
                NSArray *resultArray = [self jsonParserWithData:dataFromURL];
                if (resultArray.count > 0) {
                    completion(resultArray, nil);
                }
                else {
                    NSDictionary *errorDetails = @{NSLocalizedDescriptionKey: @"The returned array was empty."};
                    NSError *error = [NSError errorWithDomain:@"com.ndani.foursquare" code:999 userInfo:errorDetails];
                    completion(resultArray, error);
                }
            }
            else {
                NSLog(@"Error: There was no auth token in the user defaults.");
            }
        });
    }
    else {
        NSLog(@"The network is not reachable at the moment.");
    }
}

- (NSURL *)urlWithAuthToken:(NSString *)authToken {
    
    switch (_serviceType) {
        case NDServiceTypeUsersLeaderboard:
            return [NDURLRequestFactory leaderboardURLWithAuthToken:authToken];
        case NDServiceTypeUsers:
            return [NDURLRequestFactory userInformationURLWithUserID:_optinalInputParameter authToken:authToken];
        case NDServiceTypeTipsSearch:
            return [NDURLRequestFactory tipsURLWithLocationString:_optinalInputParameter authToken:authToken];
        case NDServiceTypeVenuesTrending:
            return [NDURLRequestFactory venuesURLWithLocationString:_optinalInputParameter authToken:authToken];
        default:
            NSLog(@"Error, service type is incorrect in %s", __PRETTY_FUNCTION__);
            return nil;
    }
}

- (NSArray *)jsonParserWithData:(NSData *)data {
    
    if (!data) {
        NSLog(@"Error, the data you pass in was nil in %s.", __PRETTY_FUNCTION__);
    }
    NDJSONParser *jsonParser = [[NDJSONParser alloc] initWithData:data];
    switch (_serviceType) {
        case NDServiceTypeUsersLeaderboard:
            return [jsonParser parseLeaderboard];
        case NDServiceTypeUsers:
            return [jsonParser parseUser];
        case NDServiceTypeTipsSearch:
            return [jsonParser parseTips];
        case NDServiceTypeVenuesTrending:
            return [jsonParser parseTrendingPlaces];
        default:
            NSLog(@"Error, service type is incorrect in %s", __PRETTY_FUNCTION__);
            return nil;
    }
}

@end

