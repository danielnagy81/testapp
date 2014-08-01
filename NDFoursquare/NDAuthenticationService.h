//
//  NDAuthenticationService.h
//  NDFoursquare
//
//  Created by Daniel_Nagy on 01/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NDAuthenticationService : NSObject

- (NSString *)accessToken;
- (void)authenticate;
- (void)handleURL:(NSURL *)url;

@end
