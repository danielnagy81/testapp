//
//  NDAuthenticationService.h
//  NDFoursquare
//
//  Created by Daniel_Nagy on 01/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const UserAccessTokenUserDefaultsKey;

@interface NDAuthenticationService : NSObject

- (void)authenticate;
- (void)forcedAuthenticate;
- (NSString *)accessToken;
- (void)handleURL:(NSURL *)url;

@end
