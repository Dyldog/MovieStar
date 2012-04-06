//
//  LoginViewController.m
//  MovieStar
//
//  Created by Dylan Elliott on 10/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

@implementation LoginViewController

@synthesize bannerImageView = _bannerImageView;
@synthesize facebookButton = _facebookButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[self bannerImageView] setImage:[UIImage imageNamed:@"banner_ms.png"]];
        
        [[self facebookButton] setImage:[UIImage imageNamed:@"btn_login.png"] 
                               forState:UIControlStateNormal];
        
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
    [[DataManager sharedManager] setDelegate:self];
    if ([[DataManager sharedManager] autoLoginIfPossible]) {
        [self userWillLogin];
    }
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

- (IBAction)facebookButtonTapped:(id)sender {
    [self userWillLogin];
    [[[DataManager sharedManager] facebook] authorize:nil];
}

- (void) userWillLogin {
    self.loadingView.labelText = @"Logging In...";
    [self.loadingView show:YES];
}

- (void) userDidLogin {
    [self.loadingView show:NO];
    [[[DataManager sharedManager] appDelegate] userDidLogin];

}
@end
