//
//  MovieViewController.h
//  MovieStar
//
//  Created by Dylan Elliott on 26/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieStarViewController.h"

@interface MovieViewController : MovieStarViewController <UITableViewDelegate, UITableViewDataSource, MSDataManagerDelegate, UISearchBarDelegate> {
    
    IBOutlet UISearchBar *_searchBar;
    
    NSMutableArray *_searchResults;
    
}

- (void) movieButtonTapped:(UIMovieButton *)mb;
- (void) reload;
- (void) hideLoadingViewIfPossible;

@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *searchResults;

@end
