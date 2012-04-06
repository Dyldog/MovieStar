//
//  FriendsViewController.h
//  MovieStar
//
//  Created by Dylan Elliott on 19/02/12.
//  Copyright (c) 2012 Tigerspike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieStarViewController.h"

@interface FriendsViewController : MovieStarViewController {
    
    NSMutableArray *_friends;
    UIBarButtonItem *_addFriendsButton;
    
}

@property (nonatomic) NSMutableArray *friends;
@property (nonatomic) UIBarButtonItem *addFriendsButton;

- (void) addFriendsButtonPressed:(UIBarButtonItem *)sender;
- (void) reload;

@end
