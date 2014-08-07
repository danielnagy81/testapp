//
//  NDLeaderboardParser.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 07/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDLeaderboardParser.h"
#import "NDLeaderboardEntry.h"

@implementation NDLeaderboardParser {
    
    NSData *_dataFromURL;
}

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        _dataFromURL = data;
    }
    return self;
}

- (NSArray *)parse {
    
    if (!_dataFromURL) {
        NSLog(@"Error: the data is nil that should be parsed!");
        return nil;
    }
    NSError *error = nil;
    NSDictionary *parsedDictionary = [NSJSONSerialization JSONObjectWithData:_dataFromURL options:NSJSONReadingMutableContainers error:&error];
    //TODO: if the meta code is 200, there is a possible scenario, when there is no data from the url, but creating a new access token might help.
    if (error) {
        NSLog(@"%@", error);
        return nil;
    }
    
    NSDictionary *leaderboardDictionary = [[[parsedDictionary objectForKey:@"response"] objectForKey:@"leaderboard"] objectForKey:@"items"];
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:leaderboardDictionary.count];
    
    if (leaderboardDictionary) {
        NSUInteger userRank = 0;
        for (NSDictionary *userDictionary in leaderboardDictionary) {
            ++userRank;
            NDLeaderboardEntry *leaderboardEntry = [[NDLeaderboardEntry alloc] init];
            leaderboardEntry.userName = [NSString stringWithFormat:@"%@ %@", [[userDictionary objectForKey:@"user"] objectForKey:@"lastName"], [[userDictionary objectForKey:@"user"] objectForKey:@"firstName"]];
            leaderboardEntry.userScore = [NSString stringWithFormat:@"%@ %@ %@", [[userDictionary objectForKey:@"scores"] objectForKey:@"max"], [[userDictionary objectForKey:@"scores"] objectForKey:@"checkinsCount"], [[userDictionary objectForKey:@"scores"] objectForKey:@"recent"]];
            [resultArray addObject:leaderboardEntry];
        }
    }
    return resultArray;
}

@end
