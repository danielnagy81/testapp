//
//  NDDownloader.h
//  NDFoursquare
//
//  Created by Daniel_Nagy on 19/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^NDDownloadCompletion)(NSData *data, NSError *error);

@interface NDDownloader : NSObject

- (void)downloadDataFromURL:(NSURL *)url withCompletion:(NDDownloadCompletion)completion;

@end