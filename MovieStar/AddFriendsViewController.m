//
//  AddFriendsViewController.m
//  MovieStar
//
//  Created by Dylan Elliott on 26/02/12.
//  Copyright (c) 2012 Tigerspike. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "ProfileViewController.h"
@implementation AddFriendsViewController

@synthesize appFriends = _appFriends;
@synthesize facebookFriends = _facebookFriends;
@synthesize allFriends = _allFriends;
@synthesize friendsWhoArentFriends = _friendsWhoArentFriends;

- (id) initWithFriends:(NSMutableArray *)f {
    if (self = [super init]) {
        self.appFriends = f;
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
    [self reload];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[DataManager sharedManager] setDelegate:self];
    [[DataManager sharedManager] getFacebookFriendsForCurrentUser];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
      return self.appFriends.count;  
    } else if (section == 1) {
        return self.friendsWhoArentFriends.count;
    } else {
        return self.facebookFriends.count;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.text = [[self.appFriends objectAtIndex:indexPath.row] name];
        
        return cell;
    } else if (indexPath.section == 1) {
        UITableViewCell *addCell = [tableView dequeueReusableCellWithIdentifier:@"AddCell"];
        
        if (addCell == nil) {
            addCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                             reuseIdentifier:@"AddCell"];
        }
        
        addCell.textLabel.text = [[self.friendsWhoArentFriends objectAtIndex:indexPath.row] name];
        addCell.textLabel.backgroundColor = [UIColor clearColor];
        
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        addButton.tag = indexPath.row;
        [addButton setFrame:CGRectMake(230, 5, 70, 35)];
        [addButton setTitle:@"Add" forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addFriendButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [addCell.contentView addSubview:addButton];
        
        return addCell;
    } else {
        UITableViewCell *inviteCell = [tableView dequeueReusableCellWithIdentifier:@"InviteCell"];
        
        if (inviteCell == nil) {
            inviteCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                             reuseIdentifier:@"InviteCell"];
        }
        
        inviteCell.textLabel.text = [[self.facebookFriends objectAtIndex:indexPath.row] name];
        inviteCell.textLabel.backgroundColor = [UIColor clearColor];
        
        UIButton *inviteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        inviteButton.tag = indexPath.row;
        [inviteButton setFrame:CGRectMake(230, 5, 70, 35)];
        [inviteButton setTitle:@"Invite" forState:UIControlStateNormal];
        [inviteButton addTarget:self action:@selector(inviteFriendButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [inviteCell.contentView addSubview:inviteButton];
        
        return inviteCell;
    }        
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 2) {
        ProfileViewController *profileViewController = [ProfileViewController new];
        [self.navigationController pushViewController:profileViewController animated:YES];
    } [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [super tableView:tableView viewForHeaderInSection:section];
    
    UILabel *headerLabel = (UILabel *)[header viewWithTag:22];
    
    if (section == 0) {
        headerLabel.text = @"App Friends";
    } else if (section == 1) {
        headerLabel.text = @"Facebook Friends on MovieStar";
    } else {
        headerLabel.text = @"Facebbok Friend not on MovieStar";
    } return header;
}

- (void) facebookFriendsReceived {
    [self reload];
    
    [[DataManager sharedManager] getAppUsersForFacebookFriends];
}

- (void) appUsersReceived:(NSMutableArray *)users {
    self.friendsWhoArentFriends = users;
    self.appFriends = [[DataManager sharedManager] currentUser].appFriends;
    
    NSMutableArray *friendsToRemove = [NSMutableArray new];
    
    for (MSUser *appFriend in self.appFriends) {
        for (MSUser *fbFriend in self.friendsWhoArentFriends) {
            if ([appFriend.facebookID isEqualToString:fbFriend.facebookID]) {
                [friendsToRemove addObject:fbFriend];
            }
        }
    }
    [self.friendsWhoArentFriends removeObjectsInArray:friendsToRemove];
    [self reload];
}

- (void) reload {
    
    self.appFriends = [[DataManager sharedManager] currentUser].appFriends;
    self.facebookFriends = [[DataManager sharedManager] currentUser].facebookFriends;    
    [self.tableView reloadData];
}

- (void) addFriendButtonTapped:(UIButton *)sender {
    [[DataManager sharedManager] addFriendWithFacebookID:[(MSUser *)[self.friendsWhoArentFriends objectAtIndex:sender.tag] facebookID]];
}

- (void) friendAdded:(NSString *)fbID {
    MSUser *friendToRemove;
    
    for (MSUser *friend in self.friendsWhoArentFriends) {
        if ([friend.facebookID isEqualToString:fbID]) {
            friendToRemove = friend;
        }
    }
    
    if (friendToRemove != nil)
        [self.friendsWhoArentFriends removeObject:friendToRemove];
    
    [self reload];
}

- (void) inviteFriendButtonTapped:(UIButton *)sender {
    UIButton *inviteButton = (UIButton*)sender;
}

@end
