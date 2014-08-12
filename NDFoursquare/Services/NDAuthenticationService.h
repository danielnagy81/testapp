//
//  NDAuthenticationService.h
//  NDFoursquare
//
//  Created by Daniel_Nagy on 01/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NDAuthenticationService;

extern NSString *const UserAccessTokenUserDefaultsKey;
extern NSString *const AuthenticationDidFinishedNotificationName;
@interface NDAuthenticationService : NSObject

- (void)authenticate;
- (NSError *)forcedAuthenticate;
- (NSString *)accessToken;
- (void)handleURL:(NSURL *)url;

@end
