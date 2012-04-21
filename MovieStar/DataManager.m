//
//  DataManager.m
//  MovieStar
//
//  Created by Dylan Elliott on 10/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DataManager.h"

#define WS_URL_AUTH @"http://veritaswebsystems.com/MovieStar/MovieStar/AuthenticateUserByFaceBookId"
#define WS_URL_GETTOPMOVIES @"http://veritaswebsystems.com/MovieStar/MovieStar/GetTopMovies"
#define WS_URL_GETLATESTMOVIES @"http://veritaswebsystems.com/MovieStar/MovieStar/GetRecentlyRatedMovies"
#define WS_URL_GETMOVIE @"http://veritaswebsystems.com/MovieStar/MovieStar/GetMovie"
#define WS_URL_GETRATINGSFORMOVIE @"http://veritaswebsystems.com/MovieStar/MovieStar/GetRatingsForMovie"
#define WS_URL_ADDMOVIE @"http://veritaswebsystems.com/MovieStar/MovieStar/AddMovie"
#define WS_URL_ADDRATING @"http://veritaswebsystems.com/MovieStar/MovieStar/AddRatingForMovie"
#define WS_URL_GETFRIENDS @"http://veritaswebsystems.com/MovieStar/MovieStar/GetFriendsForUser"
#define WS_URL_GETUSERSFORFBFRIENDS @"http://veritaswebsystems.com/MovieStar/MovieStar/GetUsersForFriendsOnFaceBook"
#define WS_URL_ADDFRIEND @"http://veritaswebsystems.com/MovieStar/MovieStar/AddFriendForUser"
#define WS_URL_GETRATINGSFORUSER @"http://veritaswebsystems.com/MovieStar/MovieStar/GetRatingsByUser"

#define TBDB_API_KEY @"cfb81c79f91f313fd87d4f457b114ec9"
#define TMDB_URL_SEARCH [NSString stringWithFormat:@"http://api.themoviedb.org/2.1/Movie.search/en/json/%@/", TBDB_API_KEY]


static DataManager *sharedDataManager = nil;

@implementation DataManager

@synthesize facebook;
@synthesize appDelegate;
@synthesize currentUser;
@synthesize topMovies;
@synthesize latestMovies;
@synthesize delegate;

#pragma mark Singleton Methods
+ (id)sharedManager {
    @synchronized(self) {
        if (sharedDataManager == nil)
            sharedDataManager = [[self alloc] init];
    }
    return sharedDataManager;
}
- (id)init {
    if (self = [super init]) {
        facebook = [[Facebook alloc] initWithAppId:@"156245317813645" 
                                       andDelegate:self];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"FBAccessTokenKey"] 
            && [defaults objectForKey:@"FBExpirationDateKey"]) {
            facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
            facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        }
        
        currentUser = [[MSUser alloc] init];
        
    }
    return self;
}

#pragma mark Facebook Methods

- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    [facebook requestWithGraphPath:@"me" andDelegate:self];
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    if ([request.url isEqualToString:@"https://graph.facebook.com/me"]) {
        //Get Current User
        [self.currentUser updateWithFacebookDict:result];
        [self loginWithCurrentFacebookUser];
    } else if ([request.url isEqualToString:[NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@", facebook.accessToken]]) {
        
        //Get Friends
        [self.currentUser updateFacebookFriendsWithArray:[result objectForKey:@"data"]];
         if ([self.delegate respondsToSelector:@selector(facebookFriendsReceived)]) {
             [self.delegate facebookFriendsReceived];
         }
    }
}

#pragma mark - WS Methods

- (id) requestWithURL:(NSString *)url andDict:(NSDictionary *)dict {
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
    if (dict != nil) {
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request setPostBody:[[[dict JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding] mutableCopy]];
    }    
    
    [request setDidFailSelector:@selector(requestDidFail:)];
    
    return request;
}

- (void) requestDidFail:(ASIHTTPRequest *)request {
    NSLog(@"RequestDidFail: %@", request.error);
}

- (BOOL) autoLoginIfPossible {
    if ([facebook isSessionValid]) {
        [facebook requestWithGraphPath:@"me" andDelegate:self];
    } else {
        return NO;
    }
    
    return YES;
}

- (void) loginWithCurrentFacebookUser {
    if (self.currentUser.facebookID != nil) {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                              currentUser.facebookID, 
                              @"FaceBookId", 
                              currentUser.name , 
                              @"Name", nil];
        ASIHTTPRequest *request = [self requestWithURL:WS_URL_AUTH andDict:dict];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(webServiceURLAuthDidReceiveResponse:)];
        [request startAsynchronous];
        
    }
}

- (void) webServiceURLAuthDidReceiveResponse:(ASIHTTPRequest *)request {
    
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", responseString);
    NSDictionary *responseDict = [responseString JSONValue];
    [self.currentUser updateWithWebserviceDict:responseDict];
    if ([self.delegate respondsToSelector:@selector(userDidLogin)]) {
        [self.delegate userDidLogin];
    }
    
}

- (void) getTopMovies {
    self.topMovies = nil;
    if (self.currentUser.userID != nil) {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                              currentUser.userID, 
                              @"AuthId", 
                              @"20", 
                              @"TopNumber", nil];
        ASIHTTPRequest *request = [self requestWithURL:WS_URL_GETTOPMOVIES andDict:dict];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(getTopMoviesDidReceiveResponse:)];
        [request startAsynchronous];
    }
}

- (void) getTopMoviesDidReceiveResponse:(ASIHTTPRequest *)request {
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSArray *responseDict = [responseString JSONValue];
    
    self.topMovies = [[NSMutableArray alloc] init];
    
    for (NSDictionary *topMovieDict in responseDict) {
       // for (int i = 0; i < 10; i++) {
            MSMovie *topMovie = [self movieFromDict:topMovieDict];
            [self.topMovies addObject:topMovie];
       // }
    }
    
    if ([self.delegate respondsToSelector:@selector(topMoviesReceived)]) {
        [self.delegate topMoviesReceived];
    }
}

- (void) getLatestMovies {
    self.latestMovies = nil;
    if (self.currentUser.userID != nil) {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                              currentUser.userID, 
                              @"AuthId", 
                              @"20", 
                              @"TopNumber", nil];
        ASIHTTPRequest *request = [self requestWithURL:WS_URL_GETLATESTMOVIES andDict:dict];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(getLatestMoviesDidReceiveResponse:)];
        [request startAsynchronous];
    }
}

- (void) getLatestMoviesDidReceiveResponse:(ASIHTTPRequest *)request {
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSArray *responseDict = [responseString JSONValue];
    
    self.latestMovies = [[NSMutableArray alloc] init];
    
    for (NSDictionary *latestMovieDict in responseDict) {
       // for (int i = 0; i < 10; i++) {
            MSMovie *latestMovie = [self movieFromDict:latestMovieDict];            
            [self.latestMovies addObject:latestMovie];
        // }
    }
    
    if ([self.delegate respondsToSelector:@selector(latestMoviesReceived)]) {
        [self.delegate latestMoviesReceived];
    }
}

- (void) getMovie:(NSString *)imdbID {
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          currentUser.userID, 
                          @"AuthId", 
                          imdbID, 
                          @"ImdbId", nil];
    ASIHTTPRequest *request = [self requestWithURL:WS_URL_GETMOVIE andDict:dict];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(getMovieDidReceiveResponse:)];
    [request startAsynchronous];

}

- (void) getMovieDidReceiveResponse:(ASIHTTPRequest *)request {
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSLog(@"%@", responseString);
    NSDictionary *responseDict = [responseString JSONValue];
    
    MSMovie *movie;
    if (responseDict != nil) {
       movie = [self movieFromDict:responseDict];
    } else {
        movie = [[MSMovie alloc] init];
    }
    
    if ([self.delegate respondsToSelector:@selector(movieReceived:)]) {
        [self.delegate movieReceived:movie];
    }
}

- (void) getRatingsWithImdbID:(NSString *)mid {
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          currentUser.userID, 
                          @"AuthId", 
                          mid, 
                          @"ImdbId", nil];
    ASIHTTPRequest *request = [self requestWithURL:WS_URL_GETRATINGSFORMOVIE andDict:dict];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(getRatingsDidReceiveResponse:)];
    [request startAsynchronous];
}

- (void) getRatingsDidReceiveResponse:(ASIHTTPRequest *)request {
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSLog(@"%@", responseString);
    NSArray *responseDict = [responseString JSONValue];
    
    NSMutableArray *ratings = [[NSMutableArray alloc] init];
    for (NSDictionary *ratingDict in responseDict) {
        MSRating *rating = [self ratingFromDict:ratingDict];
        [ratings addObject:rating];
    }
    
    if ([self.delegate respondsToSelector:@selector(ratingsForMovieReceived:)]) {
        [self.delegate ratingsForMovieReceived:ratings];
    }
}

- (void) addMovie:(MSMovie *)movie {
    NSDictionary *movieDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                movie.imageURL,
                                @"Image",
                                movie.imdbID,
                                @"ImdbId",
                                movie.title,
                                @"Name",
                                @"0",
                                @"AvgRating",
                                @"0",
                                @"NoOfRating",
                                [NSString stringWithFormat:@"/Date(%qi+1000)/", ([movie.releaseDate timeIntervalSince1970] * 1000)],
                                @"Year",
                                nil];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          currentUser.userID, 
                          @"AuthId",
                          movieDict,
                          @"Movie",
                          nil];
    ASIHTTPRequest *request = [self requestWithURL:WS_URL_ADDMOVIE andDict:dict];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(addMovieDidReceiveResponse:)];
    [request startAsynchronous];
}

- (void) addMovieDidReceiveResponse:(ASIHTTPRequest *)request {
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSDictionary *responseDict = [responseString JSONValue];
    
    MSMovie *movie = [self movieFromDict:responseDict];
    
    if ([self.delegate respondsToSelector:@selector(addMovieReceived:)]) {
        [self.delegate addMovieReceived:movie];
    }

}

- (void) addRatingForMovie:(MSRating *)rating {
    NSDictionary *ratingDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                rating.comment,
                                @"Comment",
                                [[NSNumber numberWithFloat:rating.ratingLevel] stringValue],
                                @"RatingLevel",
                                rating.movie.wsID,
                                @"MovieId",
                                currentUser.userID,
                                @"UserId", nil];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          currentUser.userID, 
                          @"AuthId",
                          ratingDict,
                          @"Rating",
                          nil];
    ASIHTTPRequest *request = [self requestWithURL:WS_URL_ADDRATING andDict:dict];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(addRatingDidReceiveResponse:)];
    [request startAsynchronous];
}

- (void) addRatingDidReceiveResponse:(ASIHTTPRequest *)request {
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSDictionary *responseDict = [responseString JSONValue];
    
    MSRating *rating = [self ratingFromDict:responseDict];
    
    if ([self.delegate respondsToSelector:@selector(addRatingReceived:)]) {
        [self.delegate addRatingReceived:rating];
    }
}

- (void) searchTMDBWithText:(NSString *)text {
    ASIHTTPRequest *request = [self requestWithURL:[NSString stringWithFormat:@"%@%@", TMDB_URL_SEARCH, text]
                                           andDict:nil];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(searchTMDBWithTextDidReceiveResponse:)];
    [request startAsynchronous];
}

- (void) searchTMDBWithTextDidReceiveResponse:(ASIHTTPRequest *)request {
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    if (([responseString rangeOfString:@"<html>"].length == 0) && (responseString != nil)) {
        NSArray *responseArray = [responseString JSONValue];
        NSMutableArray *moviesArray = [[NSMutableArray alloc] init];
        if (responseArray != nil) {
            for (NSDictionary *movieDict in responseArray) {
                MSMovie *movie = [self movieFromTMDBDict:movieDict];
                [moviesArray addObject:movie];
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(searchResultsReceived:)]) {
            [self.delegate searchResultsReceived:moviesArray];
        }
    }
}

- (void) getFriendsForCurrentUser {
    self.topMovies = nil;
    if (self.currentUser.userID != nil) {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                              currentUser.userID, 
                              @"AuthId", 
                              currentUser.facebookID, 
                              @"FaceBookId", nil];
        ASIHTTPRequest *request = [self requestWithURL:WS_URL_GETFRIENDS andDict:dict];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(getFriendsForCurrentUserDidReceiveResponse:)];
        [request startAsynchronous];
    }
}

- (void) getFriendsForCurrentUserDidReceiveResponse:(ASIHTTPRequest *)request {
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    if (([responseString rangeOfString:@"<html>"].length == 0) && (responseString != nil)) {
        NSArray *responseArray = [responseString JSONValue];
        NSMutableArray *friendsArray = [[NSMutableArray alloc] init];
        if (friendsArray != nil) {
            for (NSDictionary *friendDict in responseArray) {
                MSUser *friend = [[MSUser alloc] init];
                [friend updateWithWebserviceDict:friendDict];
                [friendsArray addObject:friend];
            }
        }
        
        currentUser.appFriends = friendsArray;
        
        if ([self.delegate respondsToSelector:@selector(friendsReceived)]) {
            [self.delegate friendsReceived];
        }
    }
}

- (void) getFacebookFriendsForCurrentUser {
    [facebook requestWithGraphPath:[NSString stringWithFormat:@"me/friends?access_token=%@", facebook.accessToken] 
                       andDelegate:self];
}

- (void) getAppUsersForFacebookFriends {
    NSMutableArray *fbFriends = [[NSMutableArray alloc] init];
    
    for (MSUser *facebookFriend in currentUser.facebookFriends) {
        [fbFriends addObject:facebookFriend.facebookID];
    }
        
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          currentUser.userID, 
                          @"AuthId", 
                          fbFriends, 
                          @"FaceBookIds", nil];
    
    ASIHTTPRequest *request = [self requestWithURL:WS_URL_GETUSERSFORFBFRIENDS andDict:dict];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(getAppUsersForFacebookFriendsDidReceiveResponse:)];
    [request startAsynchronous];
}
- (void) getAppUsersForFacebookFriendsDidReceiveResponse:(ASIHTTPRequest *)request {
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSArray *responseArray = [responseString JSONValue];
    
    NSMutableArray *appUsers = [[NSMutableArray alloc] init];
    
    for (NSDictionary *user in responseArray) {
        MSUser *appUser = [[MSUser alloc] init];
        [appUser updateWithWebserviceDict:user];
        [appUsers addObject:appUser];
    }
    
    if ([self.delegate respondsToSelector:@selector(appUsersReceived:)]) {
        [self.delegate appUsersReceived:appUsers];
    }
}

- (void) addFriendWithFacebookID:(NSString *)fbID {
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          currentUser.userID, 
                          @"AuthId", 
                          fbID, 
                          @"FriendFaceBookId",
                          currentUser.facebookID,
                          @"UserFaceBookId", nil];
    
    ASIHTTPRequest *request = [self requestWithURL:WS_URL_ADDFRIEND andDict:dict];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(addFriendWithFacebookIdDidReceiveResponse:)];
    [request startAsynchronous];
}
- (void) addFriendWithFacebookIdDidReceiveResponse:(ASIHTTPRequest *)request {
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    
    MSUser *appUser = [[MSUser alloc] init];
    [appUser updateWithWebserviceDict:[responseString JSONValue]];
    [currentUser.appFriends addObject:appUser];
    
    if ([self.delegate respondsToSelector:@selector(friendAdded:)]) {
        [self.delegate friendAdded:appUser.facebookID];
    }
}

- (void) getRatingsForUser:(MSUser *)user {
    if ((user != nil) && (currentUser != nil)) {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                              currentUser.userID, 
                              @"AuthId", 
                              user.userID, 
                              @"UserId", nil];
        ASIHTTPRequest *request = [self requestWithURL:WS_URL_GETRATINGSFORUSER andDict:dict];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(getRatingsForUserDidReceiveResponse:)];
        [request startAsynchronous];
    }
}

- (void) getRatingsForUserDidReceiveResponse:(ASIHTTPRequest *)request {
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSArray *responseArray = [responseString JSONValue];
    
    NSMutableArray *userRatings = [[NSMutableArray alloc] init];
    
    for (NSDictionary *rating in responseArray) {
        MSRating *userRating = [self ratingFromDict:rating];
        [userRatings addObject:userRating];
    }
    
    if ([self.delegate respondsToSelector:@selector(userRatingsReceived:)]) {
        [self.delegate userRatingsReceived:userRatings];
    }
}

- (MSRating *) ratingFromDict:(NSDictionary *)dict {
    MSRating *rating = [[MSRating alloc] init];
    rating.ratingID = [dict objectForKey:@"Id"];
    rating.ratingLevel = [[dict objectForKey:@"RatingLevel"] floatValue];
    rating.userID = [dict objectForKey:@"UserId"];
    rating.comment = [dict objectForKey:@"Comment"];
    
    rating.movie = [self movieFromDict:[dict objectForKey:@"Movie"]];
    
    return rating;
}

- (MSMovie *) movieFromDict: (NSDictionary *)dict {
    MSMovie *movie = [[MSMovie alloc] init];
    movie.wsID = [dict objectForKey:@"Id"];
    movie.imdbID = [dict objectForKey:@"ImdbId"];
    movie.imageURL = [dict objectForKey:@"Image"];
    movie.title = [dict objectForKey:@"Name"];
    movie.numRatings = [[dict objectForKey:@"NoOfRating"] intValue];
    movie.releaseDate = [self mfDateFromDotNetJSONString:[dict objectForKey:@"Year"]];
    movie.averageRating = [[dict objectForKey:@"AvgRating"] floatValue];
    
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setDateFormat:@"yyyy"];
    }
    
    movie.releaseYear = [dateFormatter stringFromDate:movie.releaseDate];
    
    return movie;
}

- (MSMovie *) movieFromTMDBDict: (NSDictionary *)dict {
    MSMovie *movie = [[MSMovie alloc] init];
    movie.title = [dict objectForKey:@"name"];
    movie.imdbID = [[dict objectForKey:@"url"] stringByReplacingOccurrencesOfString:@"http://www.themoviedb.org/movie/" withString:@""];
   
    NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setDateFormat:@"yyyy-mm-dd"];
    } movie.releaseDate = [dateFormatter dateFromString:[dict objectForKey:@"released"]]; 
    
    dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setDateFormat:@"yyyy"];
    } movie.releaseYear = [dateFormatter stringFromDate:movie.releaseDate];
    
    movie.imageURL = [[[[dict objectForKey:@"posters"] objectAtIndex:0] objectForKey:@"image"] objectForKey:@"url"];
    
    return movie;
}

- (NSDate *) dateFromJSON:(NSString *)date {
    NSInteger offset = [[NSTimeZone defaultTimeZone] secondsFromGMT];
    
    NSDate *dateDate = [[NSDate dateWithTimeIntervalSince1970:
                     [[date substringWithRange:NSMakeRange(6, 10)] intValue]]
                    dateByAddingTimeInterval:offset];
    
    return dateDate;
}

- (NSDate *)mfDateFromDotNetJSONString:(NSString *)string {
    if (string != nil) {
        static NSRegularExpression *dateRegEx = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            dateRegEx = [[NSRegularExpression alloc] initWithPattern:@"^\\/date\\((-?\\d++)(?:([+-])(\\d{2})(\\d{2}))?\\)\\/$" options:NSRegularExpressionCaseInsensitive error:nil];
        });
        NSTextCheckingResult *regexResult = [dateRegEx firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
        
        if (regexResult) {
            // milliseconds
            NSTimeInterval seconds = [[string substringWithRange:[regexResult rangeAtIndex:1]] doubleValue] / 1000.0;
            // timezone offset
            if ([regexResult rangeAtIndex:2].location != NSNotFound) {
                NSString *sign = [string substringWithRange:[regexResult rangeAtIndex:2]];
                // hours
                seconds += [[NSString stringWithFormat:@"%@%@", sign, [string substringWithRange:[regexResult rangeAtIndex:3]]] doubleValue] * 60.0 * 60.0;
                // minutes
                seconds += [[NSString stringWithFormat:@"%@%@", sign, [string substringWithRange:[regexResult rangeAtIndex:4]]] doubleValue] * 60.0;
            }
            
            return [NSDate dateWithTimeIntervalSince1970:seconds];
        }
    }
    return nil;
}

@end
