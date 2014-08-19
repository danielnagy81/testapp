//
//  NDAugmentedRealityViewController.h
//  NDFoursquare
//
//  Created by Daniel_Nagy on 18/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PRARManager.h>
#import <CoreLocation/CoreLocation.h>

@interface NDAugmentedRealityViewController : UIViewController <PRARManagerDelegate, CLLocationManagerDelegate>

@property (nonatomic) NSMutableArray *locations;

@end

