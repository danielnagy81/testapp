//
//  NDUserInformationParser.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 07/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDUserInformationParser.h"

@implementation NDUserInformationParser {
    
    NSData *_dataFromURL;
}

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        _dataFromURL = data;
    }
    return self;
}

- (NDUser *)parse {
    
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
    
    NSDictionary *userDictionary = [[parsedDictionary objectForKey:@"response"] objectForKey:@"user"];
    NDUser *user = [[NDUser alloc] init];
    user.name = [NSString stringWithFormat:@"%@ %@", [userDictionary objectForKey:@"lastName"], [userDictionary objectForKey:@"firstName"]];
    user.bio = [NSString stringWithFormat:@"Bio: %@", [userDictionary objectForKey:@"bio"]];
    user.homeCity = [NSString stringWithFormat:@"Home city: %@", [userDictionary objectForKey:@"homeCity"]];
    user.friendsCount = [NSString stringWithFormat:@"Friends: %@", [[userDictionary objectForKey:@"friends"] objectForKey:@"count"]];
    user.tipsCount = [NSString stringWithFormat:@"Tips: %@", [[userDictionary objectForKey:@"tips"] objectForKey:@"count"]];
    user.badgesCount = [NSString stringWithFormat:@"Badges: %@", [[userDictionary objectForKey:@"badges"] objectForKey:@"count"]];
    user.checkinsCount = [NSString stringWithFormat:@"Checkins: %@", [[userDictionary objectForKey:@"checkins"] objectForKey:@"count"]];
    user.mayorshipCount = [NSString stringWithFormat:@"Mayorships: %@", [[userDictionary objectForKey:@"mayorships"] objectForKey:@"count"]];
    user.facebookContact = [NSString stringWithFormat:@"Facebook: https://www.facebook.com/%@", [[userDictionary objectForKey:@"contact"] objectForKey:@"facebook"]];
    user.email = [NSString stringWithFormat:@"Email: %@", [[userDictionary objectForKey:@"contact"] objectForKey:@"email"]];
    return user;
}

@end
