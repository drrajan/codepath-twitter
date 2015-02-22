//
//  ComposeViewController.m
//  codepath-twitter
//
//  Created by David Rajan on 2/21/15.
//  Copyright (c) 2015 David Rajan. All rights reserved.
//

#import "ComposeViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ComposeViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *screenname;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView.delegate = self;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"X" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweetButton)];
    
    User *user = [User currentUser];
    self.name.text = user.name;
    self.screenname.text = user.screenname;
    [self.profileImageView setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    
    [self updateTextViewForReply];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onTweetButton {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:self.textView.text forKey:@"status"];
    
    if (self.tweet != nil) {
        [dictionary setValue:self.tweet.tweetID forKey:@"in_reply_to_status_id"];
        NSLog(@"reply to: %@", [dictionary valueForKey:@"in_reply_to_status_id"]);
    }
    
    [self.delegate postStatusUpdateWithDictionary:dictionary];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateTextViewForReply {
    if (self.tweet != nil) {
        NSString *text = [NSString stringWithFormat:@"%@ ", self.tweet.user.screenname];
        if (self.tweet.rtScreenName != nil) {
            text = [text stringByAppendingString:[NSString stringWithFormat:@"@%@ ", self.tweet.rtScreenName]];
        }
        self.textView.text = text;
        self.textView.textColor = [UIColor blackColor];
        [self.textView becomeFirstResponder];
    }
}

#pragma mark Text View methods

static NSString * const placeholder = @"What's happening?";

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:placeholder]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = placeholder;
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}

@end
