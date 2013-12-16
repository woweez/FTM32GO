//
//  GameKitHelper.m
//  FreeTheMice
//
//  Created by Muhammad Kamran on 07/12/2013.
//
//
#import "GameKitHelper.h"
#import "cocos2d.h"
#import "FTMConstants.h"

@interface GameKitHelper ()
<GKGameCenterControllerDelegate> {
    BOOL _gameCenterFeaturesEnabled;
}
@end

@implementation GameKitHelper
#pragma mark Singleton stuff
@synthesize achievementsDictionary;
@synthesize userPreferencesDictionary;
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
    
    GKLocalPlayer* localPlayer =
    [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler =
    ^(UIViewController *viewController,
      NSError *error) {
        if (viewController != nil) {
        }
        [self setLastError:error];
        
        if ([CCDirector sharedDirector].isPaused)
            [[CCDirector sharedDirector] resume];
        
        if (localPlayer.authenticated) {
            _gameCenterFeaturesEnabled = YES;
            achievementsDictionary = [[NSMutableDictionary alloc] init];
            [self loadAchievements];
        } else if(viewController) {
            [[CCDirector sharedDirector] pause];
            [self presentViewController:viewController];
        } else {
            _gameCenterFeaturesEnabled = NO;
        }
    };
}

#pragma mark Property setters

-(void) setLastError:(NSError*)error {
    _lastError = [error copy];
    if (_lastError) {
        NSLog(@"GameKitHelper ERROR: %@", [[_lastError userInfo]
                                           description]);
    }
}

#pragma mark UIViewController stuff

-(UIViewController*) getRootViewController {
    return [UIApplication
            sharedApplication].keyWindow.rootViewController;
}

-(void)presentViewController:(UIViewController*)vc {
    UIViewController* rootVC = [self getRootViewController];
    [rootVC presentViewController:vc animated:NO
                       completion:nil];
}

-(void) submitScore:(int64_t)score
           category:(NSString*)category {
    //1: Check if Game Center
    //   features are enabled
    if (!_gameCenterFeaturesEnabled) {
        CCLOG(@"Player not authenticated");
        return;
    }
    
    //2: Create a GKScore object
    GKScore* gkScore =
    [[GKScore alloc]
     initWithCategory:category];
    
    //3: Set the score value
    gkScore.value = score;
    
    //4: Send the score to Game Center
    [gkScore reportScoreWithCompletionHandler:
     ^(NSError* error) {
         
         [self setLastError:error];
         
         BOOL success = (error == nil);
         
         if ([_delegate
              respondsToSelector:
              @selector(onScoresSubmitted:)]) {
             
             [_delegate onScoresSubmitted:success];
         }
     }];
}

- (void) reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent maxValue:(float) max checkPercent:(BOOL) checkPercent
{
   // No need to make the call to game center. Its already completed.
   GKAchievement *tempAchievement = [achievementsDictionary objectForKey:identifier];
    id object = [userPreferencesDictionary objectForKey:identifier];
    
    if (object != nil || tempAchievement != nil) {
        if (object != nil) {
            if ([object floatValue] >= 100) {
                return;
            }else if (tempAchievement != nil && tempAchievement.percentComplete >= 100){
                return;
            }
        }
    }
    // end already complete check.
    
    float percentage = [self calculateAchievementPercentage: identifier currentValue:percent maxValue:max];
    GKAchievement *achievement = [self getAchievementForIdentifier:identifier percentage:percentage];
    
    if (achievement)
    {
        [achievement reportAchievementWithCompletionHandler:^(NSError *error)
         {
             if (error != nil)
             {
                 NSLog(@"Error in reporting achievements: %@", error);
             }
         }];
    }
}

-(float) calculateAchievementPercentage :(NSString *) identifier currentValue:(float) cValue maxValue:(float) maxValue{
    GKAchievement *achievement = [achievementsDictionary objectForKey:identifier];
    float percentage = (cValue/maxValue)*100;
    if (achievement == nil && [userPreferencesDictionary objectForKey:identifier] != nil) {
        
        float percent = [[userPreferencesDictionary valueForKey:identifier] floatValue] + percentage;
        return percent;
    }else if (achievement != nil){
        float percent = achievement.percentComplete + percentage;
        return percent;
    }
    
    if (achievement == nil)
    {
        return percentage;
    }
    return 100;
}
- (void) completeMultipleAchievements:(NSMutableArray *)achievementsToComplete
{
    [GKAchievement reportAchievements: achievementsToComplete withCompletionHandler:^(NSError *error)
     {
         if (error != nil)
         {
             NSLog(@"Error in reporting achievements: %@", error);
         }
     }];
}

- (void) loadAchievements
{
    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error) {
        if (error != nil)
        {
        // Handle the error.
        }
        if (achievements != nil)
        {
        // Process the array of achievements.
            NSMutableArray *achievementsToComplete = [[NSMutableArray alloc] init];
            for (GKAchievement* achievement in achievements){
                if ([userPreferencesDictionary objectForKey:achievement.identifier] == nil) {
                    [userPreferencesDictionary setValue:[NSNumber numberWithFloat:achievement.percentComplete] forKey:achievement.identifier];
                    [[NSUserDefaults standardUserDefaults] setObject:userPreferencesDictionary forKey:@"FTM_Achievements"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                [achievementsDictionary setObject: achievement forKey: achievement.identifier];
            }
            
            for (id key in userPreferencesDictionary){
                if ([achievementsDictionary objectForKey:key] == nil) {
                    GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier:key];
                    achievement.percentComplete = [[userPreferencesDictionary valueForKey:key] floatValue];
                    achievement.showsCompletionBanner = YES;
                    [achievementsDictionary setObject: achievement forKey: achievement.identifier];
                    [achievementsToComplete addObject:achievement];
                }else{
                    GKAchievement *achievement = [achievementsDictionary objectForKey:key];
                    if (achievement.percentComplete < [[userPreferencesDictionary valueForKey:key] floatValue]) {
                        achievement.percentComplete = [[userPreferencesDictionary valueForKey:key] floatValue];
                        achievement.showsCompletionBanner = YES;
                        [achievementsDictionary setObject: achievement forKey: achievement.identifier];
                        [achievementsToComplete addObject:achievement];
                    }
                }
            }
            
            if ([achievementsToComplete count] > 0) {
                [self completeMultipleAchievements:achievementsToComplete];
            }
        }
    }];
}

- (GKAchievement*) getAchievementForIdentifier: (NSString*) identifier percentage:(float) percent
{
    GKAchievement *achievement = [achievementsDictionary objectForKey:identifier];
    if (achievement == nil && [userPreferencesDictionary objectForKey:identifier] != nil) {
        
        achievement = [[GKAchievement alloc] initWithIdentifier:identifier];
        [achievementsDictionary setObject:achievement forKey:achievement.identifier];
        [userPreferencesDictionary setValue:[NSNumber numberWithFloat:percent] forKey:identifier];
        [[NSUserDefaults standardUserDefaults] setObject:userPreferencesDictionary forKey:@"FTM_Achievements"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return achievement;
    }
    if (achievement == nil)
    {
        achievement = [[GKAchievement alloc] initWithIdentifier:identifier];
        [achievementsDictionary setObject:achievement forKey:achievement.identifier];
        [userPreferencesDictionary setValue:[NSNumber numberWithFloat:percent] forKey:identifier];
        [[NSUserDefaults standardUserDefaults] setObject:userPreferencesDictionary forKey:@"FTM_Achievements"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    achievement.percentComplete = percent;
    achievement.showsCompletionBanner = YES;
    return achievement;
}

- (void) showLeaderboard: (NSString*) leaderboardID
{
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil)
    {
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateAchievements;
        [[CCDirector sharedDirector] presentViewController: gameCenterController animated: YES completion:nil];
    }
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [[CCDirector sharedDirector] dismissViewControllerAnimated:YES completion:nil];
}

-(void) loadSharePrefernceDicForAchievements{
    userPreferencesDictionary = [[[NSUserDefaults standardUserDefaults] objectForKey:@"FTM_Achievements"] mutableCopy];
    if (userPreferencesDictionary == nil) {
        userPreferencesDictionary = [[NSMutableDictionary alloc] init];
        [[NSUserDefaults standardUserDefaults] setObject:userPreferencesDictionary forKey:@"FTM_Achievements"];
        [[NSUserDefaults standardUserDefaults] registerDefaults:userPreferencesDictionary];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end