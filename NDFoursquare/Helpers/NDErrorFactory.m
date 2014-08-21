//
//  NDErrorFactory.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 21/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDErrorFactory.h"

NSString *const ErrorDomain = @"com.ndani.foursquare";

@implementation NDErrorFactory

+ (NSError *)errorWithDetails:(NSString *)details withCode:(NSInteger)code {
    
    NSDictionary *errorDetails = @{NSLocalizedDescriptionKey: details};
    NSError *error = [NSError errorWithDomain:ErrorDomain code:code userInfo:errorDetails];
    return error;
}

@end
