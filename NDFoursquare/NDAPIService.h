//
//  NDAPIService.h
//  NDFoursquare
//
//  Created by Daniel_Nagy on 04/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NDAPIService : NSObject

typedef NS_ENUM(NSInteger, NDServiceType) {
    NDServiceTypeUsersLeaderboard = 0,
    NDServiceTypeUsers,
    NDServiceTypeTipsSearch,
    NDServiceTypeVenuesTrending
};

typedef void (^NDCompletionBlock) (NSArray *resultArray, NSError *error);

- (instancetype)initWithServiceType:(NDServiceType)serviceType withOptionalParameter:(NSString *)optionalParameter;
- (void)processURLWithCompletion:(NDCompletionBlock)completion;

@end
