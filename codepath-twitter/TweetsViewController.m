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
#import "ComposeViewController.h"

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) BDBSpinKitRefreshControl *refreshControl;
@property (strong, nonatomic) UIColor *retweetColor;
@property (strong, nonatomic) UIColor *favoriteColor;

@property (strong, nonatomic) NSArray *tweets;

@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Home";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onNewButton)];
    
    self.retweetColor = [UIColor colorWithRed:119/255.0f green:178/255.0f blue:85/255.0f alpha:1.0f];
    self.favoriteColor = [UIColor colorWithRed:255/255.0f green:172/255.0f blue:51/255.0f alpha:1.0f];
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)refresh:(id)sender {
    NSLog(@"Refreshing");
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
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
    
    if (tweet.isRetweet) {
        [cell.retweetButton setTitleColor:self.retweetColor forState:UIControlStateNormal];
    } else {
        [cell.retweetButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    if (tweet.isFavorite) {
        [cell.favoriteButton setTitleColor:self.favoriteColor forState:UIControlStateNormal];
    } else {
        [cell.favoriteButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
    cell.replyButton.tag = indexPath.row;
    cell.retweetButton.tag = indexPath.row;
    cell.favoriteButton.tag = indexPath.row;
    [cell.replyButton addTarget:self action:@selector(onReply:) forControlEvents:UIControlEventTouchUpInside];
    [cell.retweetButton addTarget:self action:@selector(onRetweet:) forControlEvents:UIControlEventTouchUpInside];
    [cell.favoriteButton addTarget:self action:@selector(onFavorite:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TweetDetailViewController *vc = [[TweetDetailViewController alloc] init];
    
    vc.tweet = self.tweets[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark Compose View methods

- (void)postStatusUpdateWithDictionary:(NSDictionary *)dictionary {
    [[TwitterClient sharedInstance] postStatusWithParams:dictionary completion:^(Tweet *tweet, NSError *error) {
        NSLog(@"posted tweet: %@", tweet.text);
        NSMutableArray *tmpArray = [NSMutableArray arrayWithObject:tweet];
        [tmpArray addObjectsFromArray:self.tweets];
        self.tweets = tmpArray;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }];
}

#pragma mark Private methods

- (void)composeTweetWithReply:(Tweet *)reply {
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    vc.tweet = reply;
    vc.delegate = self;
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)onNewButton {
    [self composeTweetWithReply:nil];
}

- (void)onReply:(UIButton*)sender {
    [self composeTweetWithReply:self.tweets[sender.tag]];
}

- (void)onRetweet:(UIButton*)sender {
    Tweet *currTweet = self.tweets[sender.tag];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
    
    if (currTweet.isRetweet) {
        [[TwitterClient sharedInstance] deleteRetweetWithID:currTweet.retweetID completion:^(Tweet *tweet, NSError *error) {
            if (!error) {
                NSLog(@"unretweeted: %@", tweet.text);
                --currTweet.retweetCount;
                currTweet.isRetweet = NO;
                [self updateCellAtIndexPath:indexPath];
            }
        }];
    } else {
        [[TwitterClient sharedInstance] postRetweetWithID:currTweet.retweetID completion:^(Tweet *tweet, NSError *error) {
            if (!error) {
                NSLog(@"retweeted: %@", tweet.text);
                currTweet.retweetCount++;
                currTweet.isRetweet = YES;
                [self updateCellAtIndexPath:indexPath];
            }
        }];
    }
}

- (void)onFavorite:(UIButton*)sender {
    Tweet *currTweet = self.tweets[sender.tag];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
    
    if (currTweet.isFavorite) {
        [[TwitterClient sharedInstance] postFavoriteWithID:currTweet.retweetID withAction:@"destroy" completion:^(Tweet *tweet, NSError *error) {
            if (!error) {
                NSLog(@"unfavorited: %@", tweet.text);
                currTweet.isFavorite = NO;
                --currTweet.favoriteCount;
                [self updateCellAtIndexPath:indexPath];
            }
        }];
    } else {
        [[TwitterClient sharedInstance] postFavoriteWithID:currTweet.retweetID withAction:@"create" completion:^(Tweet *tweet, NSError *error) {
            if (!error) {
                NSLog(@"favorited: %@", tweet.text);
                currTweet.isFavorite = YES;
                currTweet.favoriteCount++;
                [self updateCellAtIndexPath:indexPath];
            }
        }];
    }
}

- (void)updateCellAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


@end
