//
//  ProfileViewController.m
//  MovieStar
//
//  Created by Dylan Elliott on 18/03/12.
//  Copyright (c) 2012 Tigerspike. All rights reserved.
//

#import "ProfileViewController.h"
#import "SingleMovieViewController.h"
#import "MSMovie.h"
#import "MSRatingCell.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

@synthesize user = _user;
@synthesize profilePictureImageView = _profilePictureImageView;
@synthesize nameLabel = _nameLabel;
@synthesize numMoviesRatedLabel = _numMoviesRatedLabel;
@synthesize tagModeSegmentedControl = _tagModeSegmentedControl;
@synthesize tagTableView = _tagTableView;

- (id) initWithUser:(MSUser *)user
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        _user = user;
        if (_user == nil) {
        }
        
        NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", _user.facebookID]; 
        [_profilePictureImageView setImageURL:[NSURL URLWithString:urlString]];
        [_profilePictureImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_profilePictureImageView setClipsToBounds:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.backgroundImageView.image = [UIImage imageNamed:@"background.png"];
}

- (void) reload {
    if (self.user == nil) {
        self.user = [[DataManager sharedManager] currentUser];
    }
    
    if (self.user != nil) {
        self.nameLabel.text = self.user.name;
        
        [[DataManager sharedManager] setDelegate:self];
        [[DataManager sharedManager] getRatingsForUser:self.user];
    } else {
        NSLog(@"Why you give me no user?");
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self reload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) userRatingsReceived:(NSMutableArray *)ratings {
    self.user.ratings = ratings;
    [self.tagTableView reloadData];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.user.ratings.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MSRating *rating = [self.user.ratings objectAtIndex:indexPath.row];
    MSRatingCell *cell = (MSRatingCell *)[super tableView:tableView ratingCellForRowAtIndexPath:indexPath];
	[cell setRating:rating];
    return cell;
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SingleMovieViewController *singleMovieController = [[SingleMovieViewController alloc] init];
    [singleMovieController setMovie:[(MSRating *)[self.user.ratings objectAtIndex:indexPath.row] movie]];
    [self.navigationController pushViewController:singleMovieController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
