//
//  DetailsViewController.m
//  twitter
//
//  Created by Ruben Green on 7/2/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "ComposeViewController.h"
#import "TimelineViewController.h"


@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshData];
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

-(void) refreshData {
    self.displayNameLabel.text = self.tweet.user.displayName;
    self.userNameLabel.text = self.tweet.user.name;
    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.tweet.user.imageURLString]];
    self.tweetLabel.text = self.tweet.text;
    self.dateLabel.text = self.tweet.createdAtString;
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    self.likeButton.selected = self.tweet.favorited;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ComposeView"]){
        UINavigationController* navigationController = [segue destinationViewController];
        ComposeViewController* composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.sourceTweet = self.tweet;
    }
}


@end
