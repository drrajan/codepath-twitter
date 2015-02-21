//
//  TweetCell.m
//  codepath-twitter
//
//  Created by David Rajan on 2/19/15.
//  Copyright (c) 2015 David Rajan. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"

@interface TweetCell()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *twitterHandleLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetBodyLabel;


@end

@implementation TweetCell

- (void)awakeFromNib {
    // Initialization code
    self.tweetBodyLabel.preferredMaxLayoutWidth = self.tweetBodyLabel.frame.size.width;
    
    self.profileImageView.layer.cornerRadius = 3;
    self.profileImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    
    [self.profileImageView setImageWithURL:[NSURL URLWithString:tweet.user.profileImageUrl]];
    self.nameLabel.text = tweet.user.name;
    self.twitterHandleLabel.text = tweet.user.screenname;
    self.tweetBodyLabel.text = tweet.text;
    //self.createdAtLabel.text = [NSString stringWithFormat:@"@%", tweet.createdAt];
}

@end