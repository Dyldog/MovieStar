//
//  AddFriendsViewController.h
//  MovieStar
//
//  Created by Dylan Elliott on 26/02/12.
//  Copyright (c) 2012 Tigerspike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieStarViewController.h"
@interface AddFriendsViewController : MovieStarViewController {
    
    NSMutableArray *_appFriends;
    NSMutableArray *_facebookFriends;
    NSMutableArray *_friendsWhoArentFriends;
    NSMutableArray *_allFriends;
    
}

//- (id) initWithFriends:(NSMutableArray *)f;
- (void) reload;

- (void) addFriendButtonTapped:(UIButton *)sender;
- (void) inviteFriendButtonTapped:(UIButton *)sender;

@property (nonatomic, strong) NSMutableArray *appFriends;
@property (nonatomic, strong) NSMutableArray *facebookFriends;
@property (nonatomic, strong) NSMutableArray *allFriends;
@property (nonatomic, strong) NSMutableArray *friendsWhoArentFriends;

@end
