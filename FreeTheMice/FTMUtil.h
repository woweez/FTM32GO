//
//  FTMUtil.h
//  FreeTheMice
//
//  Created by Muhammad Kamran on 9/23/13.
//
//

#import <Foundation/Foundation.h>

@interface FTMUtil : NSObject
{
}

@property (readwrite) int mouseClicked;
@property (readwrite) int offsetY;
@property (readwrite) BOOL isFirstTutorial;
@property (readwrite) BOOL isSecondTutorial;
@property (readwrite) BOOL isIphone5;
@property (readwrite) BOOL isSlowDownTimer;
@property (readwrite) BOOL isRespawnMice;
@property (readwrite) BOOL isBoostPowerUpEnabled;
@property (readwrite) BOOL isGameSoundOn;
@property (readwrite) BOOL isIphone4;
@property (readwrite) BOOL isRetinaDisplay;
@property (readwrite) BOOL isInvincibilityOn;

+ (FTMUtil*) sharedInstance;
- (NSString *)getModel;
@end
