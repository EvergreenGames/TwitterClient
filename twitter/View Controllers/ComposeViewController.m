//
//  ComposeViewController.m
//  twitter
//
//  Created by Ruben Green on 6/30/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *mainTextView;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(self.sourceTweet){
        self.mainTextView.text = [@"@" stringByAppendingString:self.sourceTweet.user.name];
        self.title = @"Replying";
    }
}
- (IBAction)closeTabButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)tweetTabButton:(id)sender {
    [[APIManager shared] postStatusWithText:self.mainTextView.text sourceTweet:self.sourceTweet completion:^(Tweet * tweet, NSError * error) {
        if(error){
            NSLog(@"Error composing Tweet: %@", error.localizedDescription);
        }
        else{
            [self.delegate didTweet:tweet];
            NSLog(@"Compose Tweet Success!");
        }
        [self dismissViewControllerAnimated:true completion:nil];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
