//
//  DetailsViewController.h
//  twitter
//
//  Created by Ruben Green on 7/2/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

@property (nonatomic, strong) Tweet* tweet;

-(void) refreshData;

@end

NS_ASSUME_NONNULL_END
