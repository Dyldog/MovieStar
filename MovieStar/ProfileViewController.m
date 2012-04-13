//
//  ProfileViewController.m
//  MovieStar
//
//  Created by Dylan Elliott on 18/03/12.
//  Copyright (c) 2012 Tigerspike. All rights reserved.
//

#import "ProfileViewController.h"

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
            _user = [[DataManager sharedManager] currentUser];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.backgroundImageView.image = [UIImage imageNamed:@"background.png"];
    
    self.nameLabel.text = self.user.name;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[DataManager sharedManager] setDelegate:self];
    [[DataManager sharedManager] getRatingsForUser:self.user];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                      reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%.2f / 10", rating.ratingLevel];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", rating.movieID];
    return cell;
}

@end
