//
//  NDTipsViewController.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 06/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDTipsViewController.h"
#import "NDTipContentViewController.h"
#import "NDGeocoder.h"
#import "NDAPIService.h"
#import "NDVenueTips.h"
#import "NDLocationService.h"

NSString *const TipTableViewCellIdentifier = @"TipCellIdentifier";
NSString *const TipContentViewControllerIdentifier = @"TipContentViewController";

@interface NDTipsViewController () {
    
    NDLocationService *_locationService;
    __weak IBOutlet UIButton *_nearbyButton;
    IBOutlet UITableView *_tableView;
    NSMutableArray *_tips;
    NDGeocoder *_geocoder;
    __weak IBOutlet UITextField *_searchTextField;
    __weak IBOutlet NSLayoutConstraint *_searchTextFieldWidthConstraint;
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
    _locationService = [NDLocationService locationService];
    [_locationService setDelegate:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NDVenueTips *venueTips = [_tips objectAtIndex:section];
    return venueTips.tips.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _tips.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:TipTableViewCellIdentifier];
    NDVenueTips *placeTips = [_tips objectAtIndex:indexPath.section];
    cell.textLabel.text = [placeTips.tips objectAtIndex:indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NDVenueTips *venueTips = [_tips objectAtIndex:section];
    return venueTips.venueName;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    NSString *contentOfCell = cell.textLabel.text;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NDTipContentViewController *tipContentViewController = [storyboard instantiateViewControllerWithIdentifier:TipContentViewControllerIdentifier];
    [tipContentViewController tipContentWithText:contentOfCell];
    [self presentViewController:tipContentViewController animated:YES completion:nil];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:.2f animations:^{
        _nearbyButton.alpha = .0f;;
        _searchTextFieldWidthConstraint.constant = 280.0f;
        [self.view layoutIfNeeded];
    }];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:.2f animations:^{
        _nearbyButton.alpha = 1.0f;
        _searchTextFieldWidthConstraint.constant = 230.0f;
        [self.view layoutIfNeeded];
    }];
    return YES;
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
        [apiService processURLWithCompletion:^(id result, NSError *error) {
            if (error) {
                NSLog(@"%@", error);
            }
            else {
                if ([result isKindOfClass:[NSArray class]]) {
                    _tips = [NSMutableArray arrayWithArray:result];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_tableView reloadData];
                    });
                }
                else {
                    NSLog(@"Error: the returned object wasn't an array in %s.", __PRETTY_FUNCTION__);
                }
            }
        }];
    }
}

- (IBAction)nearbyButtonPressed:(id)sender {
    
    [_locationService currentLocation];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *lastLocation = locations.lastObject;
    NSString *locationString = [NSString stringWithFormat:@"%f,%f", lastLocation.coordinate.latitude, lastLocation.coordinate.longitude];
    NDAPIService *apiService = [[NDAPIService alloc] initWithServiceType:NDServiceTypeTipsSearch withOptionalParameter:locationString];
    [apiService processURLWithCompletion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }
        else {
            if ([result isKindOfClass:[NSArray class]]) {
                _tips = [NSMutableArray arrayWithArray:result];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadData];
                });
            }
            else {
                NSLog(@"Error: the returned object wasn't an array in %s.", __PRETTY_FUNCTION__);
            }
        }
    }];
    [_locationService stopMonitoring];
}

@end
