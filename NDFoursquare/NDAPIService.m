//
//  NDAPIService.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 04/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDAPIService.h"
#import "NDJSONParser.h"

@implementation NDAPIService {
    
    NSString *_urlString;
}

- (instancetype)initWithUrlString:(NSString *)urlString {
    self = [super init];
    if (self) {
        _urlString = [[NSString alloc] init];
    }
    return self;
}

- (void)processURL {
    
}

- (NSDictionary *)jsonParserWithUrlStr {
    
    if ([_urlString rangeOfString:@"users"].location != NSNotFound) {
        if ([_urlString rangeOfString:@"leaderboard"].location != NSNotFound) {
            //TODO: returning the corresponding json parser.
            NSLog(@"Leaderboard of users!");
            return nil;
        }
        else {
            NSLog(@"Users!");
            //TODO: returning the corresponding json parser.
            return nil;
        }
    }
    else if ([_urlString rangeOfString:@"venues"].location != NSNotFound) {
        if ([_urlString rangeOfString:@"trending"].location != NSNotFound) {
            NSLog(@"Trending venue places!");
            //TODO: returning the corresponding json parser.
            return nil;
        }
        else {
            NSLog(@"Venue stats!");
            //TODO: returning the corresponding json parser.
            return nil;
        }
    }
    else {
        NSLog(@"Tips!");
        //TODO: returning the corresponding json parser.
        return nil;
    }
}

@end

