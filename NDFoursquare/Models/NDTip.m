//
//  NDTip.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 08/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDTip.h"

@implementation NDTip

- (instancetype)init {
    self = [super init];
    if (self) {
        _tipContent = [[NSString alloc] init];
        _tipAuthor = [[NSString alloc] init];
        _timeStamp = [[NSDate alloc] init];
    }
    return self;
}

@end
