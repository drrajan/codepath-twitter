//
//  Tweet.m
//  codepath-twitter
//
//  Created by David Rajan on 2/17/15.
//  Copyright (c) 2015 David Rajan. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        
        self.tweetID = dictionary[@"id_str"];
        
        if ([[dictionary valueForKeyPath:@"retweeted_status"] count] > 0) {
            self.rtName = [dictionary valueForKeyPath:@"user.name"];
            self.rtScreenName = [dictionary valueForKeyPath:@"user.screen_name"];
            dictionary = [dictionary valueForKeyPath:@"retweeted_status"];
            self.rtTweetID = dictionary[@"id_str"];
        } else {
            self.rtName = nil;
            self.rtScreenName = nil;
        }
        
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.text = dictionary[@"text"];
        self.retweetCount = [dictionary[@"retweet_count"] integerValue];
        self.favoriteCount = [dictionary[@"favorite_count"] integerValue];
        
        NSString *createdAtString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        
        self.createdAt = [formatter dateFromString:createdAtString];
    }
    return self;
}

+ (NSArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    
    return tweets;
}

@end
