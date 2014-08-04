//
//  NDJSONParser.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 31/07/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDJSONParser.h"

@implementation NDJSONParser {
    
    NSData *_dataFromURL;
}

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        _dataFromURL = data;
    }
    return self;
}

- (NSArray *)leaderboardArray {
    
    NSError *error = nil;
    NSDictionary *parsedDictionary = [NSJSONSerialization JSONObjectWithData:_dataFromURL options:NSJSONReadingMutableContainers error:&error];
    NSDictionary *leaderboardDictionary = [[[parsedDictionary objectForKey:@"response"] objectForKey:@"leaderboard"] objectForKey:@"items"];
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:leaderboardDictionary.count];
    
    if (error) {
        NSLog(@"%@", error);
        return nil;
    }
    if (leaderboardDictionary) {
        NSUInteger userRank = 0;
        for (NSDictionary *userDictionary in leaderboardDictionary) {
            ++userRank;
            NSString *userName = [NSString stringWithFormat:@"%@ %@", [[userDictionary objectForKey:@"user"] objectForKey:@"lastName"], [[userDictionary objectForKey:@"user"] objectForKey:@"firstName"]];
            NSString *userScore = [NSString stringWithFormat:@"%@ %@ %@", [[userDictionary objectForKey:@"scores"] objectForKey:@"max"], [[userDictionary objectForKey:@"scores"] objectForKey:@"checkinsCount"], [[userDictionary objectForKey:@"scores"] objectForKey:@"recent"]];
            NSDictionary *userEntry = @{@"name": [NSString stringWithFormat:@"%lu. %@:", (unsigned long)userRank, userName], @"scores": userScore};
            [resultArray addObject:userEntry];
        }
    }
    return resultArray;
}

@end
