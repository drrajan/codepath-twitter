//
//  ProfileHeaderCell.m
//  codepath-twitter
//
//  Created by David Rajan on 2/26/15.
//  Copyright (c) 2015 David Rajan. All rights reserved.
//

#import "ProfileHeaderCell.h"

@interface ProfileHeaderCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *followLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;

@end

@implementation ProfileHeaderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setUser:(User *)user {
    _user = user;
    
    self.nameLabel.text = user.name;
    self.screenNameLabel.text = user.screenname;
    self.locationLabel.text = user.location;
    self.descriptionLabel.text = user.tagline;
    self.tweetsLabel.text = user.tweetCount;
    self.followLabel.text = user.followingCount;
    self.followersLabel.text = user.followersCount;
    
    self.descriptionLabel.preferredMaxLayoutWidth = self.descriptionLabel.bounds.size.width;

}

@end
