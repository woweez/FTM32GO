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
@property (readwrite) BOOL isFirstTutorial;
@property (readwrite) BOOL isSecondTutorial;
@property (readwrite) BOOL isIphone5;
@property (readwrite) BOOL isSlowDownTimer;
@property (readwrite) BOOL isRespawnMice;
@property (readwrite) BOOL isBoostPowerUpEnabled;
@property (readwrite) BOOL isGameSoundOn;

+ (FTMUtil*) sharedInstance;
- (NSString *)getModel;
@end
