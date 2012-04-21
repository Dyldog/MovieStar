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
    self.tableView.scrollEnabled = NO;   
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewDidAppear:(BOOL)animated {
    [self reload];
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
        
        cell.contentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        
        UIScrollView *scrollView = [UIScrollView new];
        [scrollView setBackgroundColor:[UIColor blueColor]];
        scrollView.frame = CGRectMake(0, 0, 320, CELL_HEIGHT);
        scrollView.backgroundColor = [UIColor darkGrayColor];
        
        NSArray *movies;
                    
        if (indexPath.section == 0) {
            movies = [[DataManager sharedManager] topMovies];
        } else {
            movies = [[DataManager sharedManager] latestMovies];
        }
        
        for (int i = 0; i < [movies count]; i++) {
            MSMovie *movie = [movies objectAtIndex:i];
            UIMovieButton *movieButton = [[UIMovieButton alloc] init];
            movieButton.movie = movie;
            [movieButton addTarget:self action:@selector(movieButtonTapped:) 
                  forControlEvents:UIControlEventTouchUpInside];
            movieButton.frame = CGRectMake(((COVER_WIDTH + 1) * i), 0, COVER_WIDTH, COVER_HEIGHT);
            
            EGOImageView *movieImageView = [[EGOImageView alloc] initWithFrame:movieButton.bounds];
            movieImageView.delegate = movieButton;
            [movieImageView performSelectorOnMainThread:@selector(setImageURL:) withObject:[NSURL URLWithString:movie.imageURL] waitUntilDone:NO];
            [movieButton addSubview:movieImageView];
            
            if ([movie.imageURL isEqualToString:@""]) {
                movieButton.backgroundColor = [UIColor redColor];
                
                UILabel *movieTitleLabel = [UILabel new];
                movieTitleLabel.backgroundColor = [UIColor clearColor];
                movieTitleLabel.frame = movieButton.bounds;
                movieTitleLabel.numberOfLines = 0;
                movieTitleLabel.textAlignment = UITextAlignmentCenter;
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
    [self.tableView reloadData];
    [self hideLoadingViewIfPossible];
}

- (void) latestMoviesReceived {
    [self.tableView reloadData];
    [self hideLoadingViewIfPossible];
}

- (void) searchResultsReceived:(NSMutableArray *)results {
    self.searchResults = results;
    NSLog(@"%@", results);
    [self.searchDisplayController.searchResultsTableView reloadData];
}

- (void) movieButtonTapped:(UIMovieButton *)mb {
    SingleMovieViewController *singleMovieController = [[SingleMovieViewController alloc] init];
    [singleMovieController setMovie:mb.movie];
    [self.navigationController pushViewController:singleMovieController animated:YES];
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [[DataManager sharedManager] searchTMDBWithText:searchText];
}

- (void) reload {
    [[DataManager sharedManager] setDelegate:self];
    [[DataManager sharedManager] getTopMovies];
    [[DataManager sharedManager] getLatestMovies];
    
    self.loadingView.labelText = @"Loading...";
    [self.loadingView show:YES];
}

- (void) hideLoadingViewIfPossible {
    if ([[DataManager sharedManager] topMovies] != nil && [[DataManager sharedManager] latestMovies] != nil) {
        [self.loadingView hide:YES];
    }
}
@end
