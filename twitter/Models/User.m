//
//  User.m
//  twitter
//
//  Created by Ruben Green on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        self.name = dictionary[@"name"];
        self.displayName = dictionary[@"screen_name"];
    }
    return self;
}

@end