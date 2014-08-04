//
//  NDJSONParser.h
//  NDFoursquare
//
//  Created by Daniel_Nagy on 31/07/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NDJSONParser : NSObject

- (instancetype)initWithData:(NSData *)data;
- (NSArray *)leaderboardArray;

@end
