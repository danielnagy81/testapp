//
//  NDAPIService.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 04/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDAPIService.h"
#import "NDDownloader.h"
#import "NDTrendingPlacesParser.h"
#import "NDTipsParser.h"
#import "NDLeaderboardParser.h"
#import "NDUserInformationParser.h"
#import "NDNetworkStatusService.h"
#import "NDURLRequestFactory.h"
#import "NDAuthenticationService.h"
#import "NDErrorFactory.h"

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

- (void)processRequestWithCompletion:(NDProcessCompletion)completion withFailureHandler:(NDProcessFailureHandler)failureHandler {
    
    NSError *processError = nil;
    if ([_networkStatusService isNetworkReachable]) {
        NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:UserAccessTokenUserDefaultsKey];
        if (authToken) {
            NSURL *requestURL = [self urlWithAuthToken:authToken];
            if (requestURL) {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self downloadDataFromURL:requestURL withCompletion:^(NSData *data, NSError *error) {
                        if (!error) {
                            NSArray *results = [self jsonParserWithData:data];
                            if (results.count > 0) {
                                if (completion) {
                                    completion(results);
                                }
                            }
                            else {
                                if (failureHandler) {
                                    NSError *error = [NDErrorFactory errorWithDetails:@"The returned array is empty." withCode:995];
                                    failureHandler(error);
                                }
                            }
                        }
                        else {
                            if (failureHandler) {
                                failureHandler(error);
                            }
                        }
                    }];
                    
                });
            }
            else {
                processError = [NDErrorFactory errorWithDetails:@"The generated URL was nil." withCode:990];
            }
        }
        else {
            processError = [NDErrorFactory errorWithDetails:@"There is no auth token." withCode:991];
        }
    }
    else {
        processError = [NDErrorFactory errorWithDetails:@"The network is not reachable at the moment." withCode:998];
    }
    if (processError) {
        if (failureHandler) {
            failureHandler(processError);
        }
        else {
            NSLog(@"Error: the failure handler block is nil in %s", __PRETTY_FUNCTION__);
        }
    }
}

- (void)downloadDataFromURL:(NSURL *)url withCompletion:(NDDownloadCompletion)completion {
    
    if (completion) {
        NDDownloader *downloader = [[NDDownloader alloc] init];
        [downloader downloadDataFromURL:url withCompletion:^(NSData *data, NSError *error) {
            if (!error) {
                completion(data, nil);
            }
            else {
                completion(nil, error);
            }
        }];
    }
    else {
        NSLog(@"Error: the completion block is nil in %s", __PRETTY_FUNCTION__);
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
        return nil;
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

