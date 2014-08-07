//
//  NDTrendingPlacesParser.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 07/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDTrendingPlacesParser.h"
#import "NDTrendingPlace.h"

@implementation NDTrendingPlacesParser {
    
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
    
    NSDictionary *venuesDictionary = [[parsedDictionary objectForKey:@"response"] objectForKey:@"venues"];
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:venuesDictionary.count];
    
    if (venuesDictionary.count > 0) {
        for (NSDictionary *venueDictionary in venuesDictionary) {
            NDTrendingPlace *trendingPlace = [[NDTrendingPlace alloc] init];
            trendingPlace.name = [venueDictionary objectForKey:@"name"];
            trendingPlace.address = [NSString stringWithFormat:@"%@. %@, %@", [[venueDictionary objectForKey:@"location"] objectForKey:@"postalCode"], [[venueDictionary objectForKey:@"location"] objectForKey:@"city"], [[venueDictionary objectForKey:@"location"] objectForKey:@"address"]];
            trendingPlace.latitudeString = [[venueDictionary objectForKey:@"location"] objectForKey:@"lat"];
            trendingPlace.longitudeString = [[venueDictionary objectForKey:@"location"] objectForKey:@"lng"];
            [resultArray addObject:trendingPlace];
        }
    }
    return resultArray;
}

@end
