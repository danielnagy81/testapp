//
//  NDViewController.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 31/07/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDLeaderboardViewController.h"
#import "NDAPIService.h"

NSString *const TableViewCellIdentifier = @"LeaderboardCellIdentifier";

@interface NDLeaderboardViewController () {
    
    NSMutableArray *_leaderboard;
    NDAPIService *_apiService;
}

@end

@implementation NDLeaderboardViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:TableViewCellIdentifier];
    _leaderboard = [[NSMutableArray alloc] init];
    _apiService = [[NDAPIService alloc] initWithServiceType:NDServiceTypeUsersLeaderboard withOptionalParameter:nil];
    [_apiService processURLWithCompletion:^(NSArray *resultArray, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }
        else {
            _leaderboard = [NSMutableArray arrayWithArray:resultArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _leaderboard.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", [[_leaderboard objectAtIndex:indexPath.row] objectForKey:@"name"], [[_leaderboard objectAtIndex:indexPath.row] objectForKey:@"scores"]];
    return cell;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
