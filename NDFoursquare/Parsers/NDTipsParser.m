//
//  NDTipsParser.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 07/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDTipsParser.h"
#import "NDVenueTips.h"
#import "NDTip.h"

@implementation NDTipsParser {
    
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
    
    NSArray *tipsArray = [[parsedDictionary objectForKey:@"response"] objectForKey:@"tips"];
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    if (tipsArray.count > 0) {
        NDVenueTips *venueTips = [[NDVenueTips alloc] init];
        venueTips.venueName = [[[tipsArray firstObject] objectForKey:@"venue"] objectForKey:@"name"];
        venueTips.venueCoordinate = CLLocationCoordinate2DMake([[[[[tipsArray firstObject] objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"lat"] doubleValue],
                                                          [[[[[tipsArray firstObject] objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"lng"] doubleValue]);
        venueTips.venueAddress = [[[[tipsArray firstObject] objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"address"];
        if (!venueTips.venueName) {
            venueTips.venueName = @"Venue name 0";
        }
        for (NSDictionary *tipDictionary in tipsArray) {
            
            if ([[[tipDictionary objectForKey:@"venue"] objectForKey:@"name"] isEqualToString:venueTips.venueName]) {
                NDTip *aTip = [[NDTip alloc] init];
                aTip.tipContent = [tipDictionary objectForKey:@"text"];
                aTip.tipAuthor = [NSString stringWithFormat:@"%@ %@",
                                  [[tipDictionary objectForKey:@"user"] objectForKey:@"firstName"] ?
                                  [[tipDictionary objectForKey:@"user"] objectForKey:@"firstName"] : @"",
                                  [[tipDictionary objectForKey:@"user"] objectForKey:@"lastName"] ?
                                  [[tipDictionary objectForKey:@"user"] objectForKey:@"lastName"] : @""];
                aTip.timeStamp = [NSDate dateWithTimeIntervalSince1970:[[tipDictionary objectForKey:@"createdAt"] doubleValue]];
                [venueTips.tips addObject:aTip];
            }
            else {
                if (!venueTips.venueName) {
                    venueTips.venueName = [NSString stringWithFormat:@"Venue name %lu", (unsigned long)[tipsArray indexOfObject:tipDictionary]];
                }
                [resultArray addObject:[venueTips copy]];
                venueTips.venueName = [[tipDictionary objectForKey:@"venue"] objectForKey:@"name"];
                venueTips.venueCoordinate = CLLocationCoordinate2DMake([[[[tipDictionary objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"lat"] doubleValue],
                                                                  [[[[tipDictionary objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"lng"] doubleValue]);
                venueTips.venueAddress = [[[tipDictionary objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"address"];
                [venueTips.tips removeAllObjects];
                NDTip *aTip = [[NDTip alloc] init];
                aTip.tipContent = [tipDictionary objectForKey:@"text"];
                [[tipDictionary objectForKey:@"user"] objectForKey:@"firstName"] ? [[tipDictionary objectForKey:@"user"] objectForKey:@"firstName"] : @"";
                aTip.tipAuthor = [NSString stringWithFormat:@"%@ %@",
                                  [[tipDictionary objectForKey:@"user"] objectForKey:@"firstName"] ?
                                  [[tipDictionary objectForKey:@"user"] objectForKey:@"firstName"] : @"",
                                  [[tipDictionary objectForKey:@"user"] objectForKey:@"lastName"] ?
                                  [[tipDictionary objectForKey:@"user"] objectForKey:@"lastName"] : @""];
                aTip.timeStamp = [NSDate dateWithTimeIntervalSince1970:[[tipDictionary objectForKey:@"createdAt"] doubleValue]];
                [venueTips.tips addObject:aTip];
            }
        }
        if (venueTips.tips.count > 0) {
            if (!venueTips.venueName) {
                venueTips.venueName = [NSString stringWithFormat:@"Venue name %lu", (unsigned long)tipsArray.count];
            }
            [resultArray addObject:venueTips];
        }
    }
    return resultArray;
}

@end
