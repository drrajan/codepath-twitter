//
//  TweetCell.h
//  codepath-twitter
//
//  Created by David Rajan on 2/19/15.
//  Copyright (c) 2015 David Rajan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetCell : UITableViewCell

@property (nonatomic, strong) Tweet *tweet;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rtHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rtImgHeightConstraint;

@end
