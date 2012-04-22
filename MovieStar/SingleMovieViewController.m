//
//  SingleMovieViewController.m
//  MovieStar
//
//  Created by Dylan Elliott on 4/02/12.
//  Copyright (c) 2012 Tigerspike. All rights reserved.
//

#import "SingleMovieViewController.h"
#import <QuartzCore/QuartzCore.h>

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
    [coverImageView setPlaceholderImage:[UIImage imageNamed:@"DefaultPosterImage.png"]];
    
	ratingControl = [[JSFavStarControl alloc] initWithLocation:CGPointMake(130, 96) 
                                                                 dotImage:[UIImage imageNamed:@"star_title_hole.png"] 
                                                                starImage:[UIImage imageNamed:@"star_title.png"] spacing:7];
    [ratingControl setUserInteractionEnabled:NO];
	//[rating addTarget:self action:@selector(updateRating:) forControlEvents:UIControlEventValueChanged];
    [scrollView addSubview:ratingControl];
    
    taggerControl = [[JSFavStarControl alloc] initWithLocation:CGPointMake(20, 18) 
                                                      dotImage:[UIImage imageNamed:@"star_hole.png"] 
                                                     starImage:[UIImage imageNamed:@"star.png"] spacing:12];
	//[taggerControl addTarget:self action:@selector(updateRating:) forControlEvents:UIControlEventValueChanged];
    UIImage *backgroundImage = [UIImage imageNamed:@"cutout.png"];
    taggerBackgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];

    [taggerControlHolder addSubview:taggerBackgroundImageView];
    
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
                             taggerViewFrame.size.height = 150;
                             taggerControlHolder.frame = taggerViewFrame;
                             
                             CGRect bottomViewFrame = bottomView.frame;
                             bottomViewFrame.origin.y = taggerControlHolder.frame.origin.y + 150;
                             bottomView.frame = bottomViewFrame;
                             
                             scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, 
                                                                 bottomViewFrame.origin.y + bottomViewFrame.size. height);
                             
                         }];
    } else {
        [scrollView bringSubviewToFront:taggerControlHolder];
        [taggerControl setUserInteractionEnabled:NO];
        
        [taggerControl removeFromSuperview];
        [taggerBackgroundImageView removeFromSuperview];
        
        CGRect taggerFrame = taggerControl.frame;
        taggerFrame.origin.x = 20.0;
        taggerFrame.origin.y = taggerControlHolder.frame.origin.y + 18.0;
        taggerControl.frame = taggerFrame;
        
        CGRect taggerBackgroundFrame = taggerBackgroundImageView.frame;
        taggerBackgroundFrame.origin.x = 0.0;
        taggerBackgroundFrame.origin.y = taggerControlHolder.frame.origin.y;
        taggerBackgroundImageView.frame = taggerBackgroundFrame;
        
        [scrollView addSubview:taggerBackgroundImageView];
        [scrollView addSubview:taggerControl];
        
        [UIView animateWithDuration:0.5 
                         animations:^{
                             
                             CGRect bottomViewFrame = bottomView.frame;
                             bottomViewFrame.origin.y = taggerBackgroundImageView.frame.origin.y + taggerBackgroundImageView.frame.size.height + 10;
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
        rating.movie = movie;
        rating.comment = commentTextView.text;
        if (rating.comment == nil) {
            rating.comment = @"";
        }
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

- (IBAction)imdbButtonTapped:(id)sender {
    NSURL *imdbURL = [NSURL URLWithString:movie.imdbURL];
    if( imdbURL ) {
        [[UIApplication sharedApplication] openURL:imdbURL];
    }
}

- (void) updateMovieInfo {
    if ([self view] != nil) {
        titleLabel.text = movie.title;
        [coverImageView setImageURL:[NSURL URLWithString:movie.imageURL]];
        yearLabel.text = [NSString stringWithFormat:@"(%@)", movie.releaseYear];
        [ratingControl setRating:(movie.averageRating/2)];
    }
}
@end
