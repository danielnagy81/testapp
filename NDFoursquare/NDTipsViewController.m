//
//  NDTipsViewController.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 06/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDTipsViewController.h"
#import "NDGeocoder.h"
#import "NDAPIService.h"

NSString *const TipTableViewCellIdentifier = @"TipCellIdentifier";

@interface NDTipsViewController () {
    
    IBOutlet UITableView *_tableView;
    NSMutableArray *_tips;
    NDGeocoder *_geocoder;
    __weak IBOutlet UITextField *_searchTextField;
}

@end

@implementation NDTipsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:TipTableViewCellIdentifier];
    _geocoder = [[NDGeocoder alloc] init];
    _geocoder.delegate = self;
    _tips = [[NSMutableArray alloc] init];
    _searchTextField.delegate = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[_tips objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _tips.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:TipTableViewCellIdentifier];
    NSDictionary *placeTips = [_tips objectAtIndex:indexPath.section];
    for (NSString *key in placeTips) {
        NSArray *tips = [placeTips objectForKey:key];
        cell.textLabel.text = [tips objectAtIndex:indexPath.row];
        break;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *titleString = nil;
    NSDictionary *venueTips = [_tips objectAtIndex:section];
    for (NSString *key in venueTips) {
        titleString = key;
        break;
    }
    return titleString;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [_geocoder convertLocationStringWithAddress:textField.text];
    [textField resignFirstResponder];
    return YES;
}

- (void)geocoder:(NDGeocoder *)geocoder didFinishGeocodingLocationString:(NSString *)locationString withError:(NSError *)error {
    
    if (error) {
        NSLog(@"%@", error);
    }
    else {
        NDAPIService *apiService = [[NDAPIService alloc] initWithServiceType:NDServiceTypeTipsSearch withOptionalParameter:locationString];
        [apiService processURLWithCompletion:^(NSArray *resultArray, NSError *error) {
            if (error) {
                NSLog(@"%@", error);
            }
            else {
                _tips = [NSMutableArray arrayWithArray:resultArray];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadData];
                });
            }
        }];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
