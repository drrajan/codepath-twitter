//
//  TweetDetailViewController.m
//  codepath-twitter
//
//  Created by David Rajan on 2/21/15.
//  Copyright (c) 2015 David Rajan. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+DateTools.h"

@interface TweetDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *twitterHandleLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetBodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;

@end

@implementation TweetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    
    self.profileImageView.layer.cornerRadius = 3;
    self.profileImageView.clipsToBounds = YES;
    
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

    self.createdAtLabel.text = [self.tweet.createdAt formattedDateWithFormat:@"MM/dd/yy, hh:mm a"];
    
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


@end
