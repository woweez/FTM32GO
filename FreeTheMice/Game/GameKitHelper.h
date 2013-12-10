//
//  GameKitHelper.h
//  FreeTheMice
//
//  Created by Muhammad Kamran on 07/12/2013.
//
//
//   Include the GameKit framework
#import <GameKit/GameKit.h>

//   Protocol to notify external
//   objects when Game Center events occur or
//   when Game Center async tasks are completed
@protocol GameKitHelperProtocol<NSObject>
-(void) onScoresSubmitted:(bool)success;
@end

@interface MyInGameAchiementController : UINavigationController{
    
}
-(void) showAchievementBoard;
@end

@interface GameKitHelper : NSObject

@property (nonatomic, assign)
id<GameKitHelperProtocol> delegate;

// This property holds the last known error
// that occured while using the Game Center API's
@property (nonatomic, readonly) NSError* lastError;
@property(nonatomic, retain) NSMutableDictionary *achievementsDictionary;
@property(nonatomic, retain) NSMutableDictionary *userPreferencesDictionary;
+ (id) sharedGameKitHelper;

// Player authentication, info
-(void) authenticateLocalPlayer;
// Scores
-(void) submitScore:(int64_t)score
           category:(NSString*)category;
- (void) reportAchievementIdentifier: (NSString*) identifier
                                                percentComplete: (float) percent maxValue:(float) max checkPercent:(BOOL) checkPercent;
- (void) showLeaderboard: (NSString*) leaderboardID;
-(void) loadSharePrefernceDicForAchievements;
@end