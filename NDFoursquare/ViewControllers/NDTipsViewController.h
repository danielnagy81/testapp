//
//  NDTipsViewController.h
//  NDFoursquare
//
//  Created by Daniel_Nagy on 06/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NDGeocoder.h"
#import <CoreLocation/CoreLocation.h>

@interface NDTipsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NDGeocoderDelegate, CLLocationManagerDelegate, UISearchDisplayDelegate, UISearchBarDelegate>

@end
