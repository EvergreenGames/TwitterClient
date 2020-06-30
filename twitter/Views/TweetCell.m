//
//  TweetCell.m
//  twitter
//
//  Created by Ruben Green on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"

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
}
@end
