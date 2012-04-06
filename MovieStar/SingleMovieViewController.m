//
//  SingleMovieViewController.m
//  MovieStar
//
//  Created by Dylan Elliott on 4/02/12.
//  Copyright (c) 2012 Tigerspike. All rights reserved.
//

#import "SingleMovieViewController.h"

@implementation SingleMovieViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    coverImageView.backgroundColor = [UIColor greenColor];
    
	ratingControl = [[JSFavStarControl alloc] initWithLocation:CGPointMake(130, 96) 
                                                                 dotImage:[UIImage imageNamed:@"star_title_hole.png"] 
                                                                starImage:[UIImage imageNamed:@"star_title.png"]];
    [ratingControl setUserInteractionEnabled:NO];
	//[rating addTarget:self action:@selector(updateRating:) forControlEvents:UIControlEventValueChanged];
    [scrollView addSubview:ratingControl];
    
    taggerControl = [[JSFavStarControl alloc] initWithLocation:CGPointMake(60, 20) 
                                                      dotImage:[UIImage imageNamed:@"star_title_hole.png"] 
                                                     starImage:[UIImage imageNamed:@"star_title.png"]];
	//[taggerControl addTarget:self action:@selector(updateRating:) forControlEvents:UIControlEventValueChanged];
    [taggerControlHolder addSubview:taggerControl];
    [tagButton setBackgroundImage:[UIImage imageNamed:@"btn_tag.png"] 
                         forState:UIControlStateNormal];
    
    [commentsHeaderBGImageView setImage:[UIImage imageNamed:@"comments_bar.png"]];
    
    commentTextView = nil;

}

- (void) viewDidAppear:(BOOL)animated {
    [self reload];
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

- (void) setMovie:(MSMovie *)m {
    movie = m;
    [self updateMovieInfo];
}

- (IBAction)tagButtonPressed:(id)sender {
    if (taggerControlHolder.frame.size.height == 0) {
        [UIView animateWithDuration:0.5 
                         animations:^{
                             CGRect taggerViewFrame = taggerControlHolder.frame;
                             taggerViewFrame.size.height = 127;
                             taggerControlHolder.frame = taggerViewFrame;
                             
                             CGRect bottomViewFrame = bottomView.frame;
                             bottomViewFrame.origin.y = taggerControlHolder.frame.origin.y + 127;
                             bottomView.frame = bottomViewFrame;
                             
                             scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, 
                                                                 bottomViewFrame.origin.y + bottomViewFrame.size. height);
                             
                         }];
    } else {
        [scrollView bringSubviewToFront:taggerControlHolder];
        [taggerControl setUserInteractionEnabled:NO];
        
        [taggerControl removeFromSuperview];
        
        CGRect taggerFrame = taggerControl.frame;
        taggerFrame.origin.y = coverImageView.frame.origin.y + coverImageView.frame.size.height + 10;
        taggerFrame.origin.x = 160 - (taggerFrame.size.width / 2);
        taggerControl.frame = taggerFrame;
        
        [scrollView addSubview:taggerControl];
        
        [UIView animateWithDuration:0.5 
                         animations:^{
                             
                             CGRect bottomViewFrame = bottomView.frame;
                             bottomViewFrame.origin.y = taggerControl.frame.origin.y + taggerControl.frame.size.height + 10;
                             bottomView.frame = bottomViewFrame;
                             
                             scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, 
                                                                 bottomViewFrame.origin.y + bottomViewFrame.size. height);
                             CGRect taggerViewFrame = taggerControlHolder.frame;
                             taggerViewFrame.size.height = 0;
                             taggerControlHolder.frame = taggerViewFrame;
                         }];
        
        MSRating *rating = [MSRating new];
        rating.ratingLevel = [taggerControl rating] * 2;
        rating.userID = [[DataManager sharedManager] currentUser].userID;
        rating.movieID = movie.wsID;
        [[DataManager sharedManager] addRatingForMovie:rating];
        
        commentTextView = nil;
    }
}

- (IBAction)commentButtonTapped:(UIButton *)sender {
    if (commentTextView == nil) {
        
        commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(sender.frame.origin.x, sender.frame.origin.y + sender.frame.size.height + 20, sender.frame.size.width, 0)];
        
        [taggerControlHolder addSubview:commentTextView];
        
        [UIView beginAnimations:nil context:nil];

        commentTextView.frame = CGRectMake(sender.frame.origin.x, sender.frame.origin.y + sender.frame.size.height + 20, sender.frame.size.width, 100);
        
        CGRect taggerViewFrame = taggerControlHolder.frame;
        taggerViewFrame.size.height = 247;
        taggerControlHolder.frame = taggerViewFrame;
        
        CGRect bottomViewFrame = bottomView.frame;
        bottomViewFrame.origin.y = taggerControlHolder.frame.origin.y + 247;
        bottomView.frame = bottomViewFrame;
        
        scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, 
                                            bottomViewFrame.origin.y + bottomViewFrame.size. height);
        
        [UIView commitAnimations];
    } else {
        [UIView beginAnimations:nil context:nil];
        
        commentTextView.frame = CGRectMake(sender.frame.origin.x, sender.frame.origin.y + sender.frame.size.height + 20, sender.frame.size.width, 0);
        
        CGRect taggerViewFrame = taggerControlHolder.frame;
        taggerViewFrame.size.height = 127;
        taggerControlHolder.frame = taggerViewFrame;
        
        CGRect bottomViewFrame = bottomView.frame;
        bottomViewFrame.origin.y = taggerControlHolder.frame.origin.y + 127;
        bottomView.frame = bottomViewFrame;
        
        scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, 
                                            bottomViewFrame.origin.y + bottomViewFrame.size. height);

        [UIView commitAnimations];

        [commentTextView removeFromSuperview];
        commentTextView = nil;
        
    } 
}

- (void) ratingsForMovieReceived:(NSMutableArray *)ratings {
    movie.ratings = ratings;
    NSLog(@"%@", ratings);
    [self.loadingView hide:YES];
}

- (void) movieReceived:(MSMovie *)m {
    if (m.title != nil) {
        movie.wsID = m.wsID;
        movie.averageRating = m.averageRating;
        movie.numRatings = m.numRatings;
        movie.ratings = m.ratings;
        
        [[DataManager sharedManager] getRatingsWithImdbID:m.imdbID];
    } else {
        [[DataManager sharedManager] addMovie:movie];
    }
}

- (void) addMovieReceived:(MSMovie *)m {
    movie.wsID = m.wsID;
    [self updateMovieInfo];
    [self.loadingView hide:YES];
}

- (void) addRatingReceived:(MSRating *)rating {
    NSLog(@"AddRatingReceived");
}

- (void) reload {
    [[DataManager sharedManager] setDelegate:self];
    
    if (movie.wsID == nil) {
        [[DataManager sharedManager] getMovie:movie.imdbID];
    } else {
        [[DataManager sharedManager] getRatingsWithImdbID:movie.imdbID];
    }
    
    self.loadingView.labelText = @"Loading...";
    [self.loadingView show:YES];
}

- (void) updateMovieInfo {
    if ([self view] != nil) {
        titleLabel.text = movie.title;
        [coverImageView setImageURL:[NSURL URLWithString:movie.imageURL]];
        yearLabel.text = [NSString stringWithFormat:@"%@", movie.releaseYear];
        [ratingControl setRating:(int)(movie.averageRating/2)];
    }
}
@end
