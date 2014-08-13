//
//  NDTipContentViewController.h
//  NDFoursquare
//
//  Created by Daniel_Nagy on 07/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "NDTip.h"

@interface NDTipContentViewController : UIViewController

@property (nonatomic) NDTip *tip;
@property (nonatomic) CLLocationCoordinate2D tipCoordinate;
@property (nonatomic) NSString *tipAddress;

@end
