//
//  TweetCell.m
//  twitter
//
//  Created by Ruben Green on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)didTapLike:(id)sender {
    if(!self.tweet.favorited){
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        [[APIManager shared] favorite:self.tweet status:YES completion:^(Tweet *tweet, NSError *error) {
            if(error){
                self.tweet.favorited = NO;
                self.tweet.favoriteCount -= 1;
                NSLog(@"Error processing favorite: %@", error.localizedDescription);
            }
        }];
    }
    else{
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        [[APIManager shared] favorite:self.tweet status:NO completion:^(Tweet *tweet, NSError *error) {
            if(error){
                self.tweet.favorited = YES;
                self.tweet.favoriteCount += 1;
                NSLog(@"Error processing unfavorite: %@", error.localizedDescription);
            }
        }];
    }
    
    [self refreshData];
}
- (IBAction)didTapRetweet:(id)sender {
    if(!self.tweet.retweeted){
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        [[APIManager shared] retweet:self.tweet status:YES completion:^(Tweet *tweet, NSError *error) {
            if(error){
                self.tweet.retweeted = NO;
                self.tweet.retweetCount -= 1;
                NSLog(@"Error processing retweet: %@", error.localizedDescription);
            }
        }];
    }
    else{
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        [[APIManager shared] retweet:self.tweet status:NO completion:^(Tweet *tweet, NSError *error) {
            if(error){
                self.tweet.retweeted = YES;
                self.tweet.retweetCount += 1;
                NSLog(@"Error processing unretweet: %@", error.localizedDescription);
            }
        }];
    }
    
    [self refreshData];
}

- (void)refreshData {
    [self.retweetButton setTitle:[NSString stringWithFormat:@"%d", self.tweet.retweetCount] forState:UIControlStateNormal];
    self.retweetButton.selected = self.tweet.retweeted;
    [self.likeButton setTitle:[NSString stringWithFormat:@"%d", self.tweet.favoriteCount] forState:UIControlStateNormal];
    self.likeButton.selected = self.tweet.favorited;
    
    self.dateLabel.text = self.tweet.timeAgoString;
    self.displayNameLabel.text = self.tweet.user.displayName;
    self.usernameLabel.text = self.tweet.user.name;
    self.mainTextLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.mainTextLabel.text = self.tweet.text;
    NSURL* pfpURL = [NSURL URLWithString:self.tweet.user.imageURLString];
    [self.profileImageView setImageWithURL:pfpURL];
}

- (void)setTweet:(Tweet *)tweet{
    _tweet = tweet;
    
    [self refreshData];
}
@end
