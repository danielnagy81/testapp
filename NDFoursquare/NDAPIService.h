//
//  NDAPIService.h
//  NDFoursquare
//
//  Created by Daniel_Nagy on 04/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NDAPIService : NSObject

typedef void (^NDCompletionBlock) (NSArray *resultArray, NSError *error);

- (instancetype)initWithURL:(NSURL *)url;
- (void)processURLWithCompletion:(NDCompletionBlock)completion;

@end
