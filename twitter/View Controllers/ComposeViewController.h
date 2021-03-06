//
//  ComposeViewController.h
//  twitter
//
//  Created by Ruben Green on 6/30/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ComposeViewControllerDelegate

- (void)didTweet:(Tweet*)tweet;

@end

@interface ComposeViewController : UIViewController

@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;
@property (nullable, nonatomic, strong) Tweet* sourceTweet;

@end

NS_ASSUME_NONNULL_END
