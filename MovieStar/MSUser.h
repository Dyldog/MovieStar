//
//  MSUser.h
//  MovieStar
//
//  Created by Dylan Elliott on 27/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum UserRelationshipType {
    USER_YOU = 0,
    USER_FRIEND = 1,
    USER_UNDEFINED
} kUserReleationshipType;


@interface MSUser : NSObject {
    
    NSDictionary *fbDict;
    NSDictionary *wsDict;
    
    NSString *facebookID;
    NSString *userID;
    NSString *name;
    NSString *password;
    NSString *twitterID;
    
    NSMutableArray *appFriends;
    NSMutableArray *facebookFriends;
    
    NSMutableArray *ratings;
    
    kUserReleationshipType relationshipType;
}

- (void) updateWithWebserviceDict:(NSDictionary *)dict;
- (void) updateWithFacebookDict:(NSDictionary *)dict;


- (void) updateFacebookFriendsWithArray:(NSArray *)ff;
- (void) updateAppFriendsWithArray:(NSArray *)af;

@property (nonatomic, strong) NSDictionary *fbDict;
@property (nonatomic, strong) NSDictionary *wsDict;

@property (nonatomic, strong) NSString *facebookID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *twitterID;

@property (nonatomic, strong) NSMutableArray *appFriends;
@property (nonatomic, strong) NSMutableArray *facebookFriends;

@property (nonatomic, strong) NSMutableArray *ratings;

@property (assign) kUserReleationshipType relationshipType;

@end
