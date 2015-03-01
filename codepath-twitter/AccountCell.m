//
//  AccountCell.m
//  codepath-twitter
//
//  Created by David Rajan on 2/28/15.
//  Copyright (c) 2015 David Rajan. All rights reserved.
//

#import "AccountCell.h"
#import "UIImageView+AFNetworking.h"

@interface AccountCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@end

@implementation AccountCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUser:(User *)user {
    _user = user;
    
    [self.profileImageView setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    self.nameLabel.text = user.name;
    self.screenNameLabel.text = user.screenname;
    
    self.profileImageView.layer.cornerRadius = 3;
    self.profileImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.profileImageView.layer.borderWidth = 3;
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.clipsToBounds = YES;
}

@end
