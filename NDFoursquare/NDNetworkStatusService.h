//
//  NDNetworkStatusService.h
//  NDFoursquare
//
//  Created by Daniel_Nagy on 04/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NDNetworkStatusService : NSObject

+ (NDNetworkStatusService *)networkStatusServiceIstance;
- (BOOL)isNetworkReachable;

@end
