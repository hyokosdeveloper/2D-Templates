//
//  GameKitHelper.m
//  MonkeyJump
//
//  Created by Fahim Farook on 18/8/12.
//
//

#import "GameKitHelper.h"
#import "GameConstants.h"
#import "FriendsPickerViewController.h"

@interface GameKitHelper () {
    BOOL _gameCenterFeaturesEnabled;
}
@end

@implementation GameKitHelper

#pragma mark Singleton stuff

+(id) sharedGameKitHelper {
    static GameKitHelper *sharedGameKitHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGameKitHelper =
		[[GameKitHelper alloc] init];
    });
    return sharedGameKitHelper;
}

#pragma mark Player Authentication

-(void) authenticateLocalPlayer {
	GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
	
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error) {
        
        [self setLastError:error];
        
        if ([CCDirector sharedDirector].isPaused)
            [[CCDirector sharedDirector] resume];
        
        if (localPlayer.authenticated) {
            _gameCenterFeaturesEnabled = YES;
        } else if(viewController) {
            [[CCDirector sharedDirector] pause];
            [self presentViewController:viewController];
        } else {
            _gameCenterFeaturesEnabled = NO;
        }
    };
}

-(void) submitScore:(int64_t)score category:(NSString*)category {
    //1: Check if Game Center features are enabled
    if (!_gameCenterFeaturesEnabled) {
        CCLOG(@"Player not authenticated");
        return;
    }
    
    //2: Create a GKScore object
    GKScore* gkScore = [[GKScore alloc] initWithCategory:category];
    
    //3: Set the score value
    gkScore.value = score;
    
    //4: Send the score to Game Center
    [gkScore reportScoreWithCompletionHandler:^(NSError* error) {
		 
		 [self setLastError:error];
		 
		 BOOL success = (error == nil);
		 
		 if ([_delegate respondsToSelector:@selector(onScoresSubmitted:)]) {
			 
			 [_delegate onScoresSubmitted:success];
		 }
     }];
}

-(void) findScoresOfFriendsToChallenge {
    //1
    GKLeaderboard *leaderboard = [[GKLeaderboard alloc] init];
    
    //2
    leaderboard.category = kHighScoreLeaderboardCategory;
    
    //3
    leaderboard.playerScope = GKLeaderboardPlayerScopeFriendsOnly;
    
    //4
    leaderboard.range = NSMakeRange(1, 100);
    
    //5
    [leaderboard loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
		 
		 [self setLastError:error];
		 
		 BOOL success = (error == nil);
		 
		 if (success) {
			 if (!_includeLocalPlayerScore) {
				 NSMutableArray *friendsScores = [NSMutableArray array];
				 
				 for (GKScore *score in scores) {
					 if (![score.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
						 [friendsScores addObject:score];
					 }
				 }
				 scores = friendsScores;
			 }
			 if ([_delegate
				  respondsToSelector:
				  @selector
				  (onScoresOfFriendsToChallengeListReceived:)]) {
				 
				 [_delegate
				  onScoresOfFriendsToChallengeListReceived:scores];
			 }
		 }
	 }];
}

-(void) getPlayerInfo:(NSArray*)playerList {
    //1
    if (_gameCenterFeaturesEnabled == NO)
        return;
    
    //2
    if ([playerList count] > 0) {
        [GKPlayer
		 loadPlayersForIdentifiers:
		 playerList
		 withCompletionHandler:
		 ^(NSArray* players, NSError* error) {
             
			 [self setLastError:error];
             
			 if ([_delegate
				  respondsToSelector:
				  @selector(onPlayerInfoReceived:)]) {
				 
				 [_delegate onPlayerInfoReceived:players];
			 }
         }];
	}
}

-(void) sendScoreChallengeToPlayers:(NSArray*)players withScore:(int64_t)score message:(NSString*)message {
    //1
    GKScore *gkScore = [[GKScore alloc] initWithCategory:kHighScoreLeaderboardCategory];
    gkScore.value = score;
    
    //2
    [gkScore issueChallengeToPlayers:players message:message];
}

-(void) showFriendsPickerViewControllerForScore:(int64_t)score {
    FriendsPickerViewController
	*friendsPickerViewController =
	[[FriendsPickerViewController alloc]
	 initWithScore:score];
    
    friendsPickerViewController.
	cancelButtonPressedBlock = ^() {
        [self dismissModalViewController];
    };
    
    friendsPickerViewController.
	challengeButtonPressedBlock = ^() {
        [self dismissModalViewController];
    };
    
    UINavigationController *navigationController =
	[[UINavigationController alloc]
	 initWithRootViewController:
	 friendsPickerViewController];
    
    [self presentViewController:navigationController];
}

#pragma mark Property setters
-(void) setLastError:(NSError*)error {
    _lastError = [error copy];
	if (_lastError) {
		NSLog(@"GameKitHelper ERROR: %@", [[_lastError userInfo] description]);
	}
}

#pragma mark UIViewController stuff

-(UIViewController*) getRootViewController {
	return [UIApplication sharedApplication].keyWindow.rootViewController;
}

-(void) presentViewController:(UIViewController*)vc {
	UIViewController* rootVC = [self getRootViewController];
	[rootVC presentViewController:vc animated:YES completion:nil];
}

-(void) dismissModalViewController {
    UIViewController* rootVC = [self getRootViewController];
    [rootVC dismissViewControllerAnimated:YES completion:nil];
}

@end
