//
// CommonEngine.mm
//  FreeTheMice
//
//  Created by Muhammad Kamran on 9/23/13.
//
//


#import <GameKit/GameKit.h>


#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "AppDelegate.h"
#import "HudLayer.h"
#import "CatObject.h"
#import "sound.h"
@interface CommonEngine : CCLayer {
    
    CCSprite *heroRunSprite;
    CCSprite *heroSprite;
    CCSprite *flamesSprite;
    CCSprite *heroPushSprite;
    CCSprite *catSprite;
    sound *soundManager;
    CCSpriteBatchNode *spriteSheet;
    //boots power up feature..
    CCSpriteBatchNode *bootsSpriteSheet;
    CCSprite *bootsRunSprite;
    CCSprite *bootsJumpSprite;
    CCSprite *bootsStandSprite;
    CCAnimation *heroRunningAnimation;
    CCAnimation *heroBootsRunningAnimation;
    
    CCSprite *trappingAnimationSprite;
    BOOL forwardChe;
    BOOL mouseWinChe;
    BOOL isScheduledTime;
    BOOL heroTrappedChe;
    BOOL landingChe;
    BOOL runningChe;
    BOOL heroJumpLocationChe;
    BOOL firstRunningChe;
    BOOL safetyJumpChe;
    BOOL heroJumpRunningChe;
    BOOL jumpingChe;
    BOOL isLandingAnimationAdded;
    BOOL isLevelCompleted;
    int miceTrapAnimationType;
    int currentAnim;
    CCSpriteFrameCache *cache;
    HudLayer *hudLayer;
    CGFloat platformX,platformY;
    int elapsedSeconds;
    int clockIntervalCounter;
    
    }
@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *background;

-(void)addAnimation:(NSString *) plistName noOfFrames:(int) frames startingFrameName:(NSString *) startFrame;
-(void)updateAnimationOnCurrentType:(int)frameToLoad animationType:(NSString *)type;
-(void)showAnimationWithMiceIdAndIndex:(int)miceId andAnimationIndex:(int) animIndex;
-(CCSprite *) getTrappingAnimatedSprite;
-(CCSprite *) getFireAnimatedSprite;
-(void) applyBoostPowerUpFeature;
-(CCSprite *) addFireFlamesAnimation:(CGPoint) position;
-(void) switchAnimationsForBootsPowerUp;
-(void) addStrongMouseRunningSprite;
-(void) addStrongMousePushingSprite;
-(void)progressBarFunc;
-(void) startClockTimer;
-(void) levelCompleted : (int) tag;
-(void) showLevelFailedUI : (int) tag;
-(void) mouseTrapped;
-(void) playIceCubeApprearSound;
-(void) scheduleFridgeMotorFallSound;
-(void) scheduleHotPotSmokeSound;
-(void) unScheduleHotPotSmokeSound;
-(void) mamaAnimationWithType:(int)fValue animationType:(NSString *)type;
-(void) girlAnimationWithType:(int)fValue animationType:(NSString *)type;
//-(void)playMamaKniveHitAnimation;
//-(void)playStrongKniveHitAnimation;
//-(void)playGirlKniveHitAnimation;
//
//-(void)playMamaWaterHitAnimation;
//-(void)playStrongWaterHitAnimation;
//-(void)playGirlWaterHitAnimation;
//
//-(void)playMamaShockHitAnimation;
//-(void)playStrongShockHitAnimation;
//-(void)playGirlShockHitAnimation;
//
//-(void)playMamaMistHitAnimation;
//-(void)playStrongMistHitAnimation;
//-(void)playGirlMistHitAnimation;

@end
