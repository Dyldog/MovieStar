//
//  DataManager.h
//  MovieStar
//
//  Created by Dylan Elliott on 10/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Facebook.h"
#import "MSUser.h"
#import "MSMovie.h"
#import "MSRating.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"

@protocol MSDataManagerDelegate <NSObject>
@optional

- (void) userWillLogin;
- (void) userDidLogin;
- (void) topMoviesReceived;
- (void) latestMoviesReceived;
- (void) homeScreenReceived;
- (void) movieReceived:(MSMovie *)m;
- (void) ratingsForMovieReceived:(NSMutableArray *)ratings;
- (void) addMovieReceived:(MSMovie *)m;
- (void) addRatingReceived:(MSRating *)rating;
- (void) searchResultsReceived:(NSMutableArray *)results;
- (void) friendsReceived;
- (void) facebookFriendsReceived;
- (void) appUsersReceived:(NSMutableArray *)users;
- (void) friendAdded:(NSString *)fbID;
- (void) userRatingsReceived:(NSMutableArray *)ratings;

@end

@class AppDelegate;
@interface DataManager : NSObject <FBSessionDelegate, FBRequestDelegate> {
    
    Facebook *facebook;
    AppDelegate *appDelegate;
    
    MSUser *currentUser;
    
    NSMutableArray *topMovies;
    NSMutableArray *latestMovies;
    
    ASIHTTPRequest *searchRequest;

    NSObject <MSDataManagerDelegate> *delegate;
    
}

+ (id)sharedManager;
- (id) requestWithURL:(NSString *)url andDict:(NSDictionary *)dict;
- (void) requestDidFail:(ASIHTTPRequest *)request;

- (BOOL) autoLoginIfPossible;
- (void) loginWithCurrentFacebookUser;
- (void) getTopMoviesFrom:(int)start;
- (void) getLatestMoviesFrom:(int)start;
- (void) getHomeScreen;
- (void) getMovie:(NSString *)imdbID;
- (void) getRatingsWithImdbID:(NSString *)imdbID;
- (void) addMovie:(MSMovie *)movie;
- (void) addRatingForMovie:(MSRating *)rating;

- (void) webServiceURLAuthDidReceiveResponse:(ASIHTTPRequest *)request;
- (void) getTopMoviesDidReceiveResponse:(ASIHTTPRequest *)request;
- (void) getLatestMoviesDidReceiveResponse:(ASIHTTPRequest *)request;
- (void) getHomeScreenDidReceiveResponse:(ASIHTTPRequest *)request;
- (void) getMovieDidReceiveResponse:(ASIHTTPRequest *)request;
- (void) getRatingsDidReceiveResponse:(ASIHTTPRequest *)request;
- (void) addMovieDidReceiveResponse:(ASIHTTPRequest *)request;
- (void) addRatingDidReceiveResponse:(ASIHTTPRequest *)request;

- (void) searchTMDBWithText:(NSString *)text;
- (void) searchTMDBWithTextDidReceiveResponse:(ASIHTTPRequest *)request;

- (void) getFriendsForCurrentUser;
- (void) getFriendsForCurrentUserDidReceiveResponse:(ASIHTTPRequest *)request;

- (void) getFacebookFriendsForCurrentUser;
- (void) getFacebookFriendsForCurrentUserDidReceiveResponse:(ASIHTTPRequest *)request;

- (void) getAppUsersForFacebookFriends;
- (void) getAppUsersForFacebookFriendsDidReceiveResponse:(ASIHTTPRequest *)request;

- (void) addFriendWithFacebookID:(NSString *)fbID;
- (void) addFriendWithFacebookIdDidReceiveResponse:(ASIHTTPRequest *)request;

- (void) getRatingsForUser:(MSUser *)user;
- (void) getRatingsForUserDidReceiveResponse:(ASIHTTPRequest *)request;

- (void) getRatingsForUser:(MSUser *)user From:(int)from Amound:(int)num SortedBy:(NSString *)latestOrHighest;

- (MSRating *) ratingFromDict:(NSDictionary *)dict;
- (MSMovie *) movieFromDict: (NSDictionary *)dict;
- (MSMovie *) movieFromTMDBDict: (NSDictionary *)dict;


- (NSDate *) dateFromJSON:(NSString *)date;
- (NSDate *)mfDateFromDotNetJSONString:(NSString *)string;

@property (nonatomic, strong) Facebook *facebook;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) MSUser *currentUser;
@property (nonatomic, strong) NSMutableArray *topMovies;
@property (nonatomic, strong) NSMutableArray *latestMovies;
@property (nonatomic, strong) NSObject <MSDataManagerDelegate> *delegate;

@end
