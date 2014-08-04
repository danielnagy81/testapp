//
//  NDAPIService.h
//  NDFoursquare
//
//  Created by Daniel_Nagy on 04/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NDAPIService : NSObject

- (NSDictionary *)jsonParserWithUrlString:(NSString *)urlString;

@end
