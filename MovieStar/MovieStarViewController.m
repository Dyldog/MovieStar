//
//  MovieStarViewController.m
//  MovieStar
//
//  Created by Dylan Elliott on 26/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovieStarViewController.h"
#import "MSImageCell.h"
#import "MSRatingCell.h"

@implementation UINavigationBar (BackgroundImage)
//This overridden implementation will patch up the NavBar with a custom Image instead of the title
- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed: @""];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end

@implementation MovieStarViewController

@synthesize backgroundImageView = _backgroundImageView;
@synthesize loadingView = _loadingView;
@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
        self.backgroundImageView.contentMode = UIViewContentModeTop;
        [[self view] insertSubview:self.backgroundImageView 
                           atIndex:0];
        
        [self.navigationItem.backBarButtonItem setTintColor:[UIColor clearColor]];

        
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
    self.loadingView = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.loadingView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                      reuseIdentifier:@"Cell"];
    }
	cell.textLabel.text = [NSString stringWithFormat:@"Cell %d", indexPath.row];
    return cell;
}

- (UITableViewCell *) tableView:(UITableView *)tableView imageCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MSImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell"];
    
    if (cell == nil) 
    {
        cell = [[MSImageCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                      reuseIdentifier:@"ImageCell"];
    }
    cell.cellLabel.backgroundColor = [UIColor clearColor];
	cell.cellLabel.text = [NSString stringWithFormat:@"Cell %d", indexPath.row];
        
    return cell;
}

- (MSRatingCell *) tableView:(UITableView *)tableView ratingCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MSRatingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RatingCell"];
    
    if (cell == nil) 
    {
        cell = [[MSRatingCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                  reuseIdentifier:@"RatingCell"];
    }
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comments_bar.png"]];
    
    headerImageView.tag = 11;
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headerImageView.frame.size.width, headerImageView.frame.size.height)];
    headerLabel.tag = 22;
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.shadowColor = [UIColor darkGrayColor];
    headerLabel.shadowOffset = CGSizeMake(0, -1);
    headerLabel.textAlignment = UITextAlignmentCenter;
    headerLabel.text = [NSString stringWithFormat:@"Section %d", section];
    [headerImageView addSubview:headerLabel];
     
    return headerImageView;
}

@end
