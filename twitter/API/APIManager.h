//
//  APIManager.h
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "BDBOAuth1SessionManager.h"
#import "BDBOAuth1SessionManager+SFAuthenticationSession.h"
#import "Tweet.h"

@interface APIManager : BDBOAuth1SessionManager

+ (instancetype)shared;

- (void)getHomeTimelineWithCompletion:(void(^)(NSArray<Tweet*> *tweets, NSError *error))completion;

- (void)postStatusWithText:(NSString*) text sourceTweet:(Tweet*) sourceTweet completion:(void (^)(Tweet*, NSError*)) completion;

- (void)favorite:(Tweet*)tweet status:(BOOL)status completion:(void (^)(Tweet*, NSError*)) completion;
- (void)retweet:(Tweet*)tweet status:(BOOL)status completion:(void (^)(Tweet*, NSError*)) completion;

@end
