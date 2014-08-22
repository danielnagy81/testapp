//
//  NDDownloader.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 19/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDDownloader.h"
#import "NDErrorFactory.h"

int64_t const DownloadTimeout = 10;

@implementation NDDownloader {
    
    BOOL _downloadingFinished;
}

- (void)downloadDataFromURL:(NSURL *)url withCompletion:(NDDownloadCompletion)completion {
    
    if (completion) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, DownloadTimeout * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
            if (!_downloadingFinished) {
                _downloadingFinished = YES;
                NSError *downloadError =  [NDErrorFactory errorWithDetails:@"Try again later, the service is not responding." withCode:993];
                completion(nil, downloadError);
            }
        });
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (data) {
            _downloadingFinished = YES;
            completion(data, nil);
        }
        else {
            if (!_downloadingFinished) {
                _downloadingFinished = YES;
                NSError *downloadError = [NDErrorFactory errorWithDetails:@"The returned data is nil." withCode:994];
                completion(nil, downloadError);
            }
        }
    }
    else {
        NSLog(@"Error: the completion block is nil in %s", __PRETTY_FUNCTION__);
    }
}

@end
