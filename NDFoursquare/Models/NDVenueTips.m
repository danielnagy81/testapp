//
//  NDTip.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 07/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDVenueTips.h"

@implementation NDVenueTips

- (instancetype)init {
    self = [super init];
    if (self) {
        _venueName = [[NSString alloc] init];
        _tips = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)copy {
    
    NDVenueTips *copy = [[NDVenueTips alloc] init];
    if (copy) {
        copy.venueName = self.venueName;
        copy.tips = [self.tips copy];
    }
    return copy;
}

@end
