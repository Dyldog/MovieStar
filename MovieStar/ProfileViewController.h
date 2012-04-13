//
//  ProfileViewController.h
//  MovieStar
//
//  Created by Dylan Elliott on 18/03/12.
//  Copyright (c) 2012 Tigerspike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieStarViewController.h"

@interface ProfileViewController : MovieStarViewController <MSDataManagerDelegate, UITableViewDataSource, UITableViewDelegate> {
    
    MSUser *_user;
    
    IBOutlet UIImageView *_profilePictureImageView;
    IBOutlet UILabel *_nameLabel;
    IBOutlet UILabel *_numMoviesRatedLabel;
    IBOutlet UISegmentedControl *_tagModeSegmentedControl;
    IBOutlet UITableView *_tagTableView;
    
}

- (id) initWithUser:(MSUser *)user;

@property (nonatomic, strong) MSUser *user;

@property (nonatomic, strong) UIImageView *profilePictureImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numMoviesRatedLabel;
@property (nonatomic, strong) UISegmentedControl *tagModeSegmentedControl;
@property (nonatomic, strong) UITableView *tagTableView;

@end
