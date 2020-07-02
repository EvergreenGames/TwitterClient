//
//  APIManager.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "APIManager.h"
#import "Tweet.h"

static NSString * const baseURLString = @"https://api.twitter.com";
static NSString * const consumerKey = @"mMmc6YfFjRl5zY3Fxf6Va5U5m";// Enter your consumer key here
static NSString * const consumerSecret = @"beaWaIDw62sR1ITIL94Vl4VLMLL1E9kaMZYq8JU2Ji7IxG0Bbt";// Enter your consumer secret here

@interface APIManager()

@end

@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSString *key = consumerKey;
    NSString *secret = consumerSecret;
    // Check for launch arguments override
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"]) {
        key = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"];
    }
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"]) {
        secret = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"];
    }
    
    self = [super initWithBaseURL:baseURL consumerKey:key consumerSecret:secret];
    if (self) {
        
    }
    return self;
}

- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion {
    
    [self GET:@"1.1/statuses/home_timeline.json?tweet_mode=extended"
   parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
       
       // Manually cache the tweets. If the request fails, restore from cache if possible.
        NSMutableArray* tweets = [Tweet tweetsWithArray:tweetDictionaries];

       completion(tweets, nil);
       
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       completion(nil, error);
   }];
}

- (void)postStatusWithText:(NSString *)text sourceTweet:(Tweet*) sourceTweet completion:(void (^)(Tweet *, NSError *))completion{
    NSString *urlString = @"1.1/statuses/update.json";
    NSMutableDictionary* parameters = [NSMutableDictionary new];
    [parameters addEntriesFromDictionary:@{@"status": text, @"tweet_mode": @"extended"}];
    if(sourceTweet) {
        [parameters addEntriesFromDictionary:@{@"in_reply_to_status_id": sourceTweet.idStr}];
    }
    
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        Tweet* tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)favorite:(Tweet *)tweet status:(BOOL)status completion:(void (^)(Tweet *, NSError *))completion{
    NSString* urlString = status ? @"1.1/favorites/create.json" : @"1.1/favorites/destroy.json";
    NSDictionary* parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        Tweet* tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)retweet:(Tweet *)tweet status:(BOOL)status completion:(void (^)(Tweet *, NSError *))completion{
    NSString* urlString = status ? @"1.1/statuses/retweet/" : @"1.1/statuses/unretweet/";
    urlString = [[urlString stringByAppendingString:tweet.idStr] stringByAppendingString:@".json"];
    NSDictionary* parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        Tweet* tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}
@end
