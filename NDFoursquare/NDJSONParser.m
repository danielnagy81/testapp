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

- (NSArray *)parseLeaderboard {
    
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
            NSString *userName = [NSString stringWithFormat:@"%@ %@", [[userDictionary objectForKey:@"user"] objectForKey:@"lastName"], [[userDictionary objectForKey:@"user"] objectForKey:@"firstName"]];
            NSString *userScore = [NSString stringWithFormat:@"%@ %@ %@", [[userDictionary objectForKey:@"scores"] objectForKey:@"max"], [[userDictionary objectForKey:@"scores"] objectForKey:@"checkinsCount"], [[userDictionary objectForKey:@"scores"] objectForKey:@"recent"]];
            NSDictionary *userEntry = @{@"name": [NSString stringWithFormat:@"%lu. %@:", (unsigned long)userRank, userName], @"scores": userScore};
            [resultArray addObject:userEntry];
        }
    }
    return resultArray;
}

- (NSArray *)parseTips {
    
    NSError *error = nil;
    NSDictionary *parsedDictionary = [NSJSONSerialization JSONObjectWithData:_dataFromURL options:NSJSONReadingMutableContainers error:&error];
    //TODO: if the meta code is 200, there is a possible scenario, when there is no data from the url, but creating a new access token might help.
    if (error) {
        NSLog(@"%@", error);
        return nil;
    }
    
    NSArray *tipsArray = [[parsedDictionary objectForKey:@"response"] objectForKey:@"tips"];
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    if (tipsArray.count > 0) {
        NSString *currentVenueName = [[[tipsArray firstObject] objectForKey:@"venue"] objectForKey:@"name"];
        NSMutableArray *currentVenuesTips = [[NSMutableArray alloc] init];
        for (NSDictionary *tipDictionary in tipsArray) {
            
            if ([[[tipDictionary objectForKey:@"venue"] objectForKey:@"name"] isEqualToString:currentVenueName]) {
                [currentVenuesTips addObject:[tipDictionary objectForKey:@"text"]];
            }
            else {
                [resultArray addObject:@{currentVenueName: [currentVenuesTips copy]}];
                currentVenueName = [[tipDictionary objectForKey:@"venue"] objectForKey:@"name"];
                [currentVenuesTips removeAllObjects];
                [currentVenuesTips addObject:[tipDictionary objectForKey:@"text"]];
            }
        }
        if (currentVenuesTips.count > 0) {
            [resultArray addObject:@{currentVenueName: currentVenuesTips}];
        }
    }
    return resultArray;
}

- (NSArray *)parseUser {
    
    NSError *error = nil;
    NSDictionary *parsedDictionary = [NSJSONSerialization JSONObjectWithData:_dataFromURL options:NSJSONReadingMutableContainers error:&error];
    //TODO: if the meta code is 200, there is a possible scenario, when there is no data from the url, but creating a new access token might help.
    if (error) {
        NSLog(@"%@", error);
        return nil;
    }
    
    NSDictionary *userDictionary = [[parsedDictionary objectForKey:@"response"] objectForKey:@"user"];
    NSString *name = [NSString stringWithFormat:@"%@ %@", [userDictionary objectForKey:@"lastName"], [userDictionary objectForKey:@"firstName"]];
    NSString *bio = [NSString stringWithFormat:@"Bio: %@", [userDictionary objectForKey:@"bio"]];
    NSString *homeCity = [NSString stringWithFormat:@"Home city: %@", [userDictionary objectForKey:@"homeCity"]];
    NSString *friendsCount = [NSString stringWithFormat:@"Friends: %@", [[userDictionary objectForKey:@"friends"] objectForKey:@"count"]];
    NSString *tipsCount = [NSString stringWithFormat:@"Tips: %@", [[userDictionary objectForKey:@"tips"] objectForKey:@"count"]];
    NSString *badgesCount = [NSString stringWithFormat:@"Badges: %@", [[userDictionary objectForKey:@"badges"] objectForKey:@"count"]];
    NSString *checkinsCount = [NSString stringWithFormat:@"Checkins: %@", [[userDictionary objectForKey:@"checkins"] objectForKey:@"count"]];
    NSString *mayorshipCount = [NSString stringWithFormat:@"Mayorships: %@", [[userDictionary objectForKey:@"mayorships"] objectForKey:@"count"]];
    NSString *facebookContact = [NSString stringWithFormat:@"Facebook: https://www.facebook.com/%@", [[userDictionary objectForKey:@"contact"] objectForKey:@"facebook"]];
    NSString *emailContact = [NSString stringWithFormat:@"Email: %@", [[userDictionary objectForKey:@"contact"] objectForKey:@"email"]];
    return @[name, homeCity, bio, checkinsCount, friendsCount, tipsCount, badgesCount,mayorshipCount, facebookContact, emailContact];
}

- (NSArray *)parseTrendingPlaces {
    
    NSError *error = nil;
    NSDictionary *parsedDictionary = [NSJSONSerialization JSONObjectWithData:_dataFromURL options:NSJSONReadingMutableContainers error:&error];
    //TODO: if the meta code is 200, there is a possible scenario, when there is no data from the url, but creating a new access token might help.
    if (error) {
        NSLog(@"%@", error);
        return nil;
    }
    
    NSDictionary *venuesDictionary = [[parsedDictionary objectForKey:@"response"] objectForKey:@"venues"];
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:venuesDictionary.count];
    
    if (venuesDictionary.count > 0) {
        for (NSDictionary *venueDictionary in venuesDictionary) {
            [resultArray addObject:@{@"name": [venueDictionary objectForKey:@"name"],
                                     @"address": [NSString stringWithFormat:@"%@. %@, %@", [[venueDictionary objectForKey:@"location"] objectForKey:@"postalCode"], [[venueDictionary objectForKey:@"location"] objectForKey:@"city"], [[venueDictionary objectForKey:@"location"] objectForKey:@"address"]],
                                     @"latitude":
                                         [[venueDictionary objectForKey:@"location"] objectForKey:@"lat"],
                                     @"longitude": [[venueDictionary objectForKey:@"location"] objectForKey:@"lng"]}];
        }
    }
    return resultArray;
}

@end
