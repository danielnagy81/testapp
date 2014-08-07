//
//  NDUserInformationParser.h
//  NDFoursquare
//
//  Created by Daniel_Nagy on 07/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NDUser.h"

@interface NDUserInformationParser : NSObject

- (instancetype)initWithData:(NSData *)data;
- (NDUser *)parse;

@end
