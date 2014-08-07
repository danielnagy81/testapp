//
//  NDUser.h
//  NDFoursquare
//
//  Created by Daniel_Nagy on 07/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NDUser : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *bio;
@property (nonatomic) NSString *homeCity;
@property (nonatomic) NSString *friendsCount;
@property (nonatomic) NSString *tipsCount;
@property (nonatomic) NSString *badgesCount;
@property (nonatomic) NSString *checkinsCount;
@property (nonatomic) NSString *mayorshipCount;
@property (nonatomic) NSString *facebookContact;
@property (nonatomic) NSString *email;

@end
