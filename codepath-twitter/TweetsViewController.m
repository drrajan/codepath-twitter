//
//  TweetsViewController.m
//  codepath-twitter
//
//  Created by David Rajan on 2/18/15.
//  Copyright (c) 2015 David Rajan. All rights reserved.
//

#import "BDBSpinKitRefreshControl.h"
#import "TweetsViewController.h"
#import "User.h"
#import "Tweet.h"
#import "TwitterClient.h"
#import "TweetCell.h"
#import "TweetDetailViewController.h"

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) BDBSpinKitRefreshControl *refreshControl;

@property (strong, nonatomic) NSArray *tweets;

@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Home";
    
    self.refreshControl =
    [BDBSpinKitRefreshControl refreshControlWithStyle:RTSpinKitViewStylePulse color:UIColorFromRGB(0X66757F)];
    [self.refreshControl addTarget:self
                            action:@selector(refresh:)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 140;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    
    [self refresh:nil];
}

- (void)refresh:(id)sender {
    NSLog(@"Refreshing");
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        //        for (Tweet *tweet in tweets) {
        //            NSLog(@"text: %@", tweet.text);
        //        }
        self.tweets = tweets;
        [self.tableView reloadData];
        [(BDBSpinKitRefreshControl *)sender endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogout:(id)sender {
    [User logout];
}


#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.tweets.count;
    //return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    cell.preservesSuperviewLayoutMargins = NO;
    [cell setLayoutMargins:UIEdgeInsetsZero];
    
    Tweet *tweet = self.tweets[indexPath.row];
    if (tweet.rtName == nil) {
        cell.rtHeightConstraint.constant = 0.f;
        cell.rtImgHeightConstraint.constant = 0.f;
    } else {
        cell.rtHeightConstraint.constant = 14.5f;
        cell.rtImgHeightConstraint.constant = 16.0f;
    }
    
    cell.tweet = tweet;
    
    
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TweetDetailViewController *vc = [[TweetDetailViewController alloc] init];
    
    vc.tweet = self.tweets[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
}


@end
