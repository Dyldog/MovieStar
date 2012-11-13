//
//  MovieViewController.m
//  MovieStar
//
//  Created by Dylan Elliott on 26/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovieViewController.h"
#import "SingleMovieViewController.h"
#import "MSImageCell.h"
#import "DataManager.h"

@implementation MovieViewController

@synthesize searchBar = _searchBar;
@synthesize searchResults = _searchResults;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"MovieStar";
        
        self.tabBarItem.image = [UIImage imageNamed:@"tab_movies.png"];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.tableView.scrollEnabled = YES;   
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.searchDisplayController.searchResultsTableView setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:1.0]];
    
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewDidAppear:(BOOL)animated {
    if( updatedDate == nil ) {
        [self reload];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDelegate/Datasource Methods

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableView) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return 1;
    } else {
        return self.searchResults.count;
    }
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tableView) {
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        
        cell.contentView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
        
        UIScrollView *scrollView = [UIScrollView new];
        scrollView.delegate = self;
        [scrollView setBackgroundColor:[UIColor blueColor]];
        scrollView.frame = CGRectMake(0, 0, 320, CELL_HEIGHT);
        scrollView.backgroundColor = [UIColor darkGrayColor];
        
        NSArray *movies;
                    
        if (indexPath.section == 0) {
            //TopMovies
            movies = [[DataManager sharedManager] topMovies];
            scrollView.tag = 987;
        } else {
            //LatestMovies
            movies = [[DataManager sharedManager] latestMovies];
            scrollView.tag = 789;
        }
        
        for (int i = 0; i < [movies count]; i++) {
            MSMovie *movie = [movies objectAtIndex:i];
            UIMovieButton *movieButton = [[UIMovieButton alloc] init];
            movieButton.movie = movie;
            [movieButton addTarget:self action:@selector(movieButtonTapped:) 
                  forControlEvents:UIControlEventTouchUpInside];
            movieButton.frame = CGRectMake(((COVER_WIDTH + 1) * i), 0, COVER_WIDTH, COVER_HEIGHT);
            
//            EGOImageView *movieImageView = [[EGOImageView alloc] initWithFrame:movieButton.bounds];
            EGOImageView *movieImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"default_poster.png"]];
            movieImageView.delegate = movieButton;
            [movieImageView performSelectorOnMainThread:@selector(setImageURL:) withObject:[NSURL URLWithString:movie.imageURL] waitUntilDone:NO];
            [movieButton addSubview:movieImageView];
            
            if ([movie.imageURL isEqualToString:@""]) {
                movieButton.backgroundColor = [UIColor redColor];
                
                UILabel *movieTitleLabel = [UILabel new];
                movieTitleLabel.backgroundColor = [UIColor clearColor];
                CGRect labelRect = CGRectMake(0, movieButton.frame.size.height - 50, movieButton.frame.size.width, 50);
                movieTitleLabel.frame = labelRect;
                movieTitleLabel.numberOfLines = 0;
                movieTitleLabel.textAlignment = UITextAlignmentCenter;
                movieTitleLabel.font = [UIFont systemFontOfSize:13];
                movieTitleLabel.text = [NSString stringWithFormat:@"%@ (%@)", movie.title, movie.releaseYear];
                [movieButton addSubview:movieTitleLabel];

            }
            
            [scrollView addSubview:movieButton];
            [scrollView setContentSize:CGSizeMake(((COVER_WIDTH + 1) * (i + 1)) - 1, CELL_HEIGHT)];
        }
        
        [cell.contentView addSubview:scrollView];
        
        return cell;
    } else {
        MSImageCell *cell = [super tableView:tableView imageCellForRowAtIndexPath:indexPath];
        cell.cellLabel.text = [[self.searchResults objectAtIndex:indexPath.row] title];
        [cell setCoverPhoto:[[self.searchResults objectAtIndex:indexPath.row] imageURL]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return [super tableView:tableView heightForHeaderInSection:section];
    } else {
        return 0;
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [super tableView:tableView viewForHeaderInSection:section];
    if (tableView == self.tableView) {
        UILabel *headerLabel = (UILabel *)[header viewWithTag:22];
        
        if (section == 0) {
            headerLabel.text = @"Top Movies";
        } else {
            headerLabel.text = @"Latest Movies";
        }
    }
    
    return header;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        SingleMovieViewController *singleMovieController = [[SingleMovieViewController alloc] init];
        [singleMovieController setMovie:[self.searchResults objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:singleMovieController animated:YES];
    }
}

- (void) topMoviesReceived {
    _topMoviesReceived = YES;
    [self.tableView reloadData];
    [self hideLoadingViewIfPossible];
    updatedDate = [NSDate date];

    if( _topMoviesReceived && _latestMoviesReceived ) {
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5];
    }
}

- (void) latestMoviesReceived {
    _latestMoviesReceived = YES;
    [self.tableView reloadData];
    [self hideLoadingViewIfPossible];
    updatedDate = [NSDate date];
    if( _topMoviesReceived && _latestMoviesReceived ) {
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5];
    }
}

- (void) homeScreenReceived {
    _latestMoviesReceived = YES;
    _topMoviesReceived = YES;
    [self.tableView reloadData];
    [self hideLoadingViewIfPossible];
    updatedDate = [NSDate date];
    if( _topMoviesReceived && _latestMoviesReceived ) {
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5];
    }
}

- (void) searchResultsReceived:(NSMutableArray *)results {
    static int numUpdates = 1;
    NSLog(@"Number search results received calls: %d", numUpdates);
    self.searchResults = results;
    NSLog(@"%@", results);
    [self.searchDisplayController.searchResultsTableView reloadData];
    numUpdates++;
}

- (void) movieButtonTapped:(UIMovieButton *)mb {
    SingleMovieViewController *singleMovieController = [[SingleMovieViewController alloc] init];
    [singleMovieController setMovie:mb.movie];
    [self.navigationController pushViewController:singleMovieController animated:YES];
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.searchDisplayController.searchResultsTableView setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:1.0]];
    
//    NSString *newSearchString = [searchText stringByReplacingOccurrencesOfString:@" " withString:@"+"];
//        NSLog(@"SearchText: %@", newSearchString);
//    [[DataManager sharedManager] setDelegate:self];
//    [[DataManager sharedManager] searchTMDBWithText:newSearchString];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *newSearchString = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSLog(@"SearchText: %@", newSearchString);
    [[DataManager sharedManager] setDelegate:self];
    [[DataManager sharedManager] searchTMDBWithText:newSearchString];
}

- (void) reload {
    _topMoviesReceived = NO;
    _latestMoviesReceived = NO;
    
    [[DataManager sharedManager] setDelegate:self];
    [[DataManager sharedManager] getHomeScreen];
    
    self.loadingView.labelText = @"Loading...";
    [self.loadingView show:YES];
}

- (void) hideLoadingViewIfPossible {
    if ([[DataManager sharedManager] topMovies] != nil && [[DataManager sharedManager] latestMovies] != nil) {
        [self.loadingView hide:YES];
    }
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	[self reload];
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	if( scrollView == self.tableView) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    } else {
        
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if( scrollView == self.tableView)
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}
@end
