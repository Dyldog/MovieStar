//
//  MSUser.m
//  MovieStar
//
//  Created by Dylan Elliott on 27/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSUser.h"

@implementation MSUser 

@synthesize fbDict;
@synthesize wsDict;

@synthesize facebookID;
@synthesize userID;
@synthesize name;
@synthesize password;
@synthesize twitterID;

@synthesize facebookFriends;
@synthesize appFriends;

@synthesize ratings;
@synthesize totalNumRatings;

@synthesize relationshipType;

- (MSUser *) init {
    if (self = [super init]) {
        fbDict = nil;
        wsDict = nil;
        facebookID = nil;
        userID = nil;
        name = nil;
        password = nil;
        twitterID = nil;
        facebookFriends = nil;
        appFriends = nil;
        ratings = nil;
        totalNumRatings = 0;
        relationshipType = USER_UNDEFINED;
    }
    
    return self;
}

- (void) updateWithWebserviceDict:(NSDictionary *)dict {
    self.userID = [dict objectForKey:@"Id"];
    self.facebookID = [dict objectForKey:@"FaceBookId"];
    self.name = [dict objectForKey:@"Name"];
    self.totalNumRatings = [[dict objectForKey:@"NoOfMoviesRated"] intValue];
    
}
- (void) updateWithFacebookDict:(NSDictionary *)dict {
    self.facebookID = [dict objectForKey:@"id"];
    
    if ([dict objectForKey:@"first_name"] != nil) {
        self.name = [NSString stringWithFormat:@"%@ %@", [dict objectForKey:@"first_name"], [dict objectForKey:@"last_name"]];
    } else {
        self.name = [dict objectForKey:@"name"];
    }
}

- (void) updateFacebookFriendsWithArray:(NSArray *)ff {
    self.facebookFriends = [[NSMutableArray alloc] init];
    
    for (NSDictionary *friend in ff) {
        MSUser *f = [[MSUser alloc] init];
        [f updateWithFacebookDict:friend];
        [self.facebookFriends addObject:f];
    }
}

@end
