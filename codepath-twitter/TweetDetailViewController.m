//
//  TweetDetailViewController.m
//  codepath-twitter
//
//  Created by David Rajan on 2/21/15.
//  Copyright (c) 2015 David Rajan. All rights reserved.
//

#import "TwitterClient.h"
#import "TweetDetailViewController.h"
#import "ComposeViewController.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+DateTools.h"

@interface TweetDetailViewController () <ComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *twitterHandleLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetBodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rtHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rtImgHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rtFavHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rtFavBarHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rtFavTxtHeightConstraint;

@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@property (strong, nonatomic) UIColor *retweetColor;
@property (strong, nonatomic) UIColor *favoriteColor;
@end

@implementation TweetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    
    self.profileImageView.layer.cornerRadius = 3;
    self.profileImageView.clipsToBounds = YES;
    
    self.retweetColor = [UIColor colorWithRed:119/255.0f green:178/255.0f blue:85/255.0f alpha:1.0f];
    self.favoriteColor = [UIColor colorWithRed:119/255.0f green:178/255.0f blue:85/255.0f alpha:1.0f];
    
    if (self.tweet.isRetweet) {
        [self.retweetButton setTitleColor:self.retweetColor forState:UIControlStateNormal];
    }
    if (self.tweet.isFavorite) {
        [self.favoriteButton setTitleColor:self.favoriteColor forState:UIControlStateNormal];
    }
    
    if (self.tweet.rtName == nil) {
        self.rtHeightConstraint.constant = 0.f;
        self.rtImgHeightConstraint.constant = 0.f;
    } else {
        self.rtHeightConstraint.constant = 15.0f;
        self.rtImgHeightConstraint.constant = 16.0f;
    }
    if (self.tweet.retweetCount > 0 || self.tweet.favoriteCount > 0) {
        self.rtFavHeightConstraint.constant = 40.0f;
        self.rtFavBarHeightConstraint.constant = 1.0f;
        self.rtFavTxtHeightConstraint.constant = 16.0f;
    } else {
        self.rtFavHeightConstraint.constant = 0.f;
        self.rtFavBarHeightConstraint.constant = 0.f;
        self.rtFavTxtHeightConstraint.constant = 0.f;
    }
    
    [self updateView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateView {
    
    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.tweet.user.profileImageUrl]];
    self.nameLabel.text = self.tweet.user.name;
    self.twitterHandleLabel.text = self.tweet.user.screenname;
    self.tweetBodyLabel.text = self.tweet.text;

    self.createdAtLabel.text = [self.tweet.createdAt formattedDateWithFormat:@"M/dd/yy, hh:mm a"];
    
    if (self.tweet.retweetCount > 0) {
        self.retweetCountLabel.text = [NSString stringWithFormat:@"%ld", self.tweet.retweetCount];
    } else {
        self.retweetCountLabel.text = @"";
    }
    if (self.tweet.favoriteCount > 0) {
        self.favoriteCountLabel.text = [NSString stringWithFormat:@"%ld", self.tweet.favoriteCount];
    } else {
        self.favoriteCountLabel.text = @"";
    }
    
    
    if (self.tweet.rtName != nil) {
        self.retweetLabel.text = [NSString stringWithFormat:@"%@ retweeted", self.tweet.rtName];
    } else {
        self.retweetLabel.text = @"";
    }
}

#pragma mark Compose View methods

-(void)postStatusUpdateWithDictionary:(NSDictionary *)dictionary {
    [[TwitterClient sharedInstance] postStatusWithParams:dictionary completion:^(Tweet *tweet, NSError *error) {
        NSLog(@"posted tweet: %@", tweet.text);
    }];
}

#pragma mark Private methods

- (IBAction)onReply:(id)sender {
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    vc.tweet = self.tweet;
    vc.delegate = self;
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (IBAction)onRetweet:(UIButton *)sender {
    if (self.tweet.isRetweet) {
        [[TwitterClient sharedInstance] deleteRetweetWithID:self.tweet.retweetID completion:^(Tweet *tweet, NSError *error) {
            if (!error) {
                NSLog(@"unretweeted: %@", tweet.text);
                [sender setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            }
        }];
    } else {
        [[TwitterClient sharedInstance] postRetweetWithID:self.tweet.retweetID completion:^(Tweet *tweet, NSError *error) {
            if (!error) {
                NSLog(@"retweeted: %@", tweet.text);
                [sender setTitleColor:self.retweetColor forState:UIControlStateNormal];
            }
        }];
    }
}

- (IBAction)onFavorite:(UIButton *)sender {
    [sender setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
}




@end
