//
//  NDErrorFactory.h
//  NDFoursquare
//
//  Created by Daniel_Nagy on 21/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NDErrorFactory : NSObject

+ (NSError *)errorWithDetails:(NSString *)details withCode:(NSInteger)code;

@end
