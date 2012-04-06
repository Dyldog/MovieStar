//
//  FriendsViewController.m
//  MovieStar
//
//  Created by Dylan Elliott on 19/02/12.
//  Copyright (c) 2012 Tigerspike. All rights reserved.
//

#import "FriendsViewController.h"
#import "MSImageCell.h"
#import "AddFriendsViewController.h"
#import "EGOImageView.h"
#import "ProfileViewController.h"

@implementation FriendsViewController
@synthesize friends = _friends;
@synthesize addFriendsButton = _addFriendsButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Friends";
        
        self.tabBarItem.image = [UIImage imageNamed:@"tab_friends.png"];
        self.addFriendsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
                                                                             target:self 
                                                                             action:@selector(addFriendsButtonPressed:)];
        self.navigationItem.rightBarButtonItem = self.addFriendsButton;
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

- (void) friendsReceived {
    [self.loadingView hide:YES];
    [self.tableView reloadData];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[DataManager sharedManager] currentUser].appFriends.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MSUser *friend = [[[DataManager sharedManager] currentUser].appFriends objectAtIndex:indexPath.row];
    MSImageCell *cell = [super tableView:tableView imageCellForRowAtIndexPath:indexPath];
    [cell.egoImageView setFrame:CGRectMake(0, 0, 44, 44)];
    
    CGRect labelFrame = cell.cellLabel.frame;
    labelFrame.origin.x = cell.egoImageView.frame.origin.x + cell.egoImageView.frame.size.width + 10;
    cell.cellLabel.frame = labelFrame;
    cell.cellLabel.text = friend.name;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithUser:[[[DataManager sharedManager] currentUser].appFriends objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:profileViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (float) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (void) addFriendsButtonPressed:(UIBarButtonItem *)sender {
    AddFriendsViewController *addFriendsViewController = [[AddFriendsViewController alloc] init];
    [self.navigationController pushViewController:addFriendsViewController animated:YES];
}

- (void) reload {
    [[DataManager sharedManager] setDelegate:self];
    [[DataManager sharedManager] getFriendsForCurrentUser];
    
    self.loadingView.labelText = @"Loading...";
    [self.loadingView show:YES];
}

@end
