//
//  NDViewController.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 31/07/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDLeaderboardViewController.h"
#import "NDAPIService.h"
#import "NDLeaderboardEntry.h"

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
    [_apiService processURLWithCompletion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }
        else {
            if ([result isKindOfClass:[NSArray class]]) {
                _leaderboard = [NSMutableArray arrayWithArray:result];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
            else {
                NSLog(@"Error: the returned object wasn't an array in %s.", __PRETTY_FUNCTION__);
            }
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _leaderboard.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NDLeaderboardEntry *leaderboardEntry = [_leaderboard objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", leaderboardEntry.userName, leaderboardEntry.userScore];
    return cell;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
