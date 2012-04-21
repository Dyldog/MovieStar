//
//  MovieViewController.h
//  MovieStar
//
//  Created by Dylan Elliott on 26/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieStarViewController.h"
#import "EGORefreshTableHeaderView.h"

@interface MovieViewController : MovieStarViewController <UITableViewDelegate, UITableViewDataSource, MSDataManagerDelegate, UISearchBarDelegate, EGORefreshTableHeaderDelegate> {
    
    IBOutlet UISearchBar *_searchBar;
    
    NSMutableArray *_searchResults;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    NSDate *updatedDate;
    
    BOOL _topMoviesReceived;
    BOOL _latestMoviesReceived;
    
}

- (void) movieButtonTapped:(UIMovieButton *)mb;
- (void) reload;
- (void) hideLoadingViewIfPossible;

@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *searchResults;

@end
