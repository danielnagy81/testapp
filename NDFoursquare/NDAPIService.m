//
//  NDAPIService.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 04/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDAPIService.h"

@implementation NDAPIService

- (void)initWithUrlString:(NSString *)urlString {
    
    
}

- (NSDictionary *)jsonParserWithUrlString:(NSString *)urlString {
    
    if ([urlString rangeOfString:@"users"].location != NSNotFound) {
        if ([urlString rangeOfString:@"leaderboard"].location != NSNotFound) {
            NSLog(@"Leaderboard of users!");
        }
        else {
            NSLog(@"Users!");
        }
    }
    else if ([urlString rangeOfString:@"venues"].location != NSNotFound) {
        if ([urlString rangeOfString:@"trending"].location != NSNotFound) {
            NSLog(@"Trending venue places!");
        }
        else {
            NSLog(@"Venue stats!");
        }
    }
    else {
        NSLog(@"Tips!");
    }
    return nil;
}

@end

