//
//  Tweet.m
//  twitter
//
//  Created by Ruben Green on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "Tweet.h"
#import "DateTools.h"

@implementation Tweet

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        NSDictionary* originalTweet = dictionary[@"retweeted_status"];
        if(originalTweet != nil){
            NSDictionary* userDictionary = dictionary[@"user"];
            self.retweetedByUser = [[User alloc] initWithDictionary:userDictionary];
            
            dictionary = originalTweet;
        }
        self.idStr = dictionary[@"id_str"];
        self.text = dictionary[@"full_text"];
        self.favoriteCount = [dictionary[@"favorite_count"] intValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.retweetCount = [dictionary[@"retweet_count"] intValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        
        NSDictionary* user = dictionary[@"user"];
        self.user = [[User alloc] initWithDictionary:user];
        
        NSString* createdAtOriginalString = dictionary[@"created_at"];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
        NSDate* date = [formatter dateFromString:createdAtOriginalString];
        self.timeAgoString = date.shortTimeAgoSinceNow;
        self.createdAtString = [date formattedDateWithStyle:NSDateFormatterShortStyle];
    }
    
    return self;
}

+ (NSMutableArray *)tweetsWithArray:(NSArray<NSDictionary*>*)dictionaryArray{
    NSMutableArray* tweets = [NSMutableArray array];
    for(NSDictionary* dictionary in dictionaryArray){
        Tweet* tweet = [[Tweet alloc] initWithDictionary:dictionary];
        [tweets addObject:tweet];
    }
    return tweets;
}

@end
