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

@implementation NDAPIService {
    
    NSURL *_url;
    NDNetworkStatusService *_networkStatusService;
}

- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        _url = url;
        _networkStatusService = [NDNetworkStatusService networkStatusServiceIstance];
    }
    return self;
}

- (void)processURLWithCompletion:(NDCompletionBlock)completion {
    
    if ([_networkStatusService isNetworkReachable]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *dataWithURL = [NSData dataWithContentsOfURL:_url];
            NSArray *resultArray = [self jsonParserWithData:dataWithURL];
            
            if (resultArray.count > 0) {
                completion(resultArray, nil);
            }
            else {
                NSDictionary *errorDetails = @{NSLocalizedDescriptionKey: @"The returned array was empty."};
                NSError *error = [NSError errorWithDomain:@"com.ndani.foursquare" code:999 userInfo:errorDetails];
                completion(resultArray, error);
            }
        });
    }
    else {
        NSLog(@"The network is not reachable at the moment.");
    }
}

- (NSArray *)jsonParserWithData:(NSData *)data {
    
    NDJSONParser *jsonParser = [[NDJSONParser alloc] initWithData:data];
    NSString *urlString = [_url absoluteString];
    if ([urlString rangeOfString:@"users"].location != NSNotFound) {
        if ([urlString rangeOfString:@"leaderboard"].location != NSNotFound) {
            return [jsonParser parseLeaderboard];
        }
        else {
            return [jsonParser parseUser];
        }
    }
    else if ([urlString rangeOfString:@"venues"].location != NSNotFound) {
        return [jsonParser parseTrendingPlaces];
    }
    else {
        return [jsonParser parseTips];
    }
}

@end

