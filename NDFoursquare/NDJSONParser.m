//
//  NDJSONParser.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 31/07/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDJSONParser.h"

@implementation NDJSONParser

+ (void)parseUserInfoWithData:(NSData *)data {
    
    NSError *error = nil;
    NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if (error) {
        NSLog(@"%@", error);
    }
}

@end
