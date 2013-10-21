//
//  HelloWorldLayer.h
//  Tap
//
//  Created by karthik g on 27/09/12.
//  Copyright karthik g 2012. All rights reserved.
//


#import <GameKit/GameKit.h>


#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "AppDelegate.h"
#import "MyContactListener.h"
#import "StrongGameFunc.h"
#import "sound.h"
#import "Trigo.h"
#import "HudLayer.h"
#import "LevelCompleteScreen.h"
#import "CommonEngine.h"
#import "StrongLevel13Cat.h"
#define PTM_RATIO 32

@interface StrongMouseEngineMenu13 : CCLayer {
    
    
}

@end
@interface StrongMouseEngine13 : CommonEngine {
	StrongGameFunc *gameFunc;
    sound *soundEffect;
    Trigo *trigo;
    b2World* world;
//    HudLayer *hudLayer;
    CGSize winSize;
	GLESDebugDraw *m_debugDraw;
	MyContactListener *_contactListener;
    b2Body *heroBody;
    b2Vec2 activeVect, startVect;
    float32 jumpPower,jumpAngle;
    CCSprite *heroPimpleSprite[20];
    BOOL heroReleaseChe;
    BOOL isNotScheduled;
    StrongLevel13Cat *catObj;
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_background;
    
    CCMenu *menu;
    CCMenu *menu2;
    
    
//    BOOL jumpingChe;
    int saveDottedPathCount;
    
    CCParticleSystem	*cheeseEmitter;
//    CCSprite *heroSprite;
//    CCSprite *heroRunSprite;
    CCSprite *heroWinSprite;
    CCSprite *heroTrappedSprite;
    CCSprite *mouseTrappedBackground;
    CCSprite *mouseDragSprite;
    CCSprite *progressBarBackSprite;
    CCSprite *cheeseCollectedSprite;
    CCSprite *timeCheeseSprite;
    CCSprite *cheeseSprite[5];
    CCSprite *cheeseSprite2[5];
//    CCSprite *starSprite[6];
    CCSprite *clockBackgroundSprite;
    CCSprite *clockArrowSprite;
//    CCSprite *catJumpingSprite;
    CCSprite *milkSprite;
    CCSprite *waterDropsSprite[20];
    CCSprite *movePlatformSprite;
//    CCSprite *catTurnSprite;
//    CCSprite *catRunSprite;
    CCSprite *fridgeSprite;
    CCSprite *iceSmokingSprite[5][2];
    CCSprite *hoenyPotSprite;
    CCSprite *iceQubeSprite[4];

    CCSprite *catStopWoodSprite;
    CCSprite *pulbSprite;
    
    CCSprite *dotSprite;
    
    BOOL heroStandChe;
    int heroStandAnimationCount;
    BOOL dragChe;
//    BOOL forwardChe;
    int heroJumpingAnimationCount;
    int heroJumpingAnimationArrValue;
//    CCSpriteFrameCache *cache;
//    CCSpriteBatchNode *spriteSheet;
//    CCSpriteFrameCache *catCache;
//    CCSpriteBatchNode *catSpriteSheet;
    
    NSArray * heroJumpIntervalValue;
    NSArray * cheeseSetValue;
    NSArray *cheeseArrX;
    NSArray *cheeseArrY;
    NSArray *heroRunningStopArr;
    CGFloat backHeroJumpingY;
    
//    CGFloat platformX,platformY;
//    BOOL landingChe;
//    BOOL runningChe;
//    BOOL heroJumpLocationChe;
//    BOOL firstRunningChe;
////    BOOL mouseWinChe;
//    BOOL safetyJumpChe;
//    BOOL heroJumpRunningChe;
//    BOOL heroTrappedChe;
    
    
    CGFloat screenHeroPosX;
    CGFloat screenHeroPosY;
    CGFloat heroForwardX;
    
    int heroRunningCount,heroRunningCount2;
    int heroWinCount;
//    int gameMinutes;
    
    CCSprite *numbersSprite[15];
    CCLabelAtlas *lifeMinutesAtlas;
    CCLabelAtlas *cheeseCollectedAtlas;
    CCLabelAtlas *iceBlastAtlas;
    int cheeseX2;
    int cheeseY2;
    int cheeseCollectedScore;
    BOOL cheeseCollectedChe[10];
    int cheeseCount;
    int motherLevel;
    int jumpRunDiff;
    int jumpRunDiff2;
    int topHittingCount;
    int cheeseAnimationCount;
    CGFloat smokingCount[6];
    int smokingCount2;
    int smokingCount3;
    CGFloat smokingX,smokingY;
    int heroTrappedCount;
    int cheeseStarAnimatedCount[5];
    int autoJumpValue2;
    
    CGFloat screenShowX;
    CGFloat screenShowY;
    CGFloat screenShowX2;
    CGFloat screenShowY2;
    BOOL screenMoveChe;
    int screenMovementFindValue;
    int screenMovementFindValue2;
    int screenMovementFindValue3;
    int trappedTypeValue;
    int heroTrappedMove;
    CGFloat waterDropsCount[20];
    int waterDropsReleaseCount;
    
    int testAngle;
    BOOL milkStopChe;
    BOOL successChe;
    CGFloat catMovementValue;
    CGFloat catForwardChe;
    int turnAnimationCount;
    CGFloat catJumpingCount;
    CGFloat catX,catY;
    int catJumpingAnimationCount;
    BOOL catJumpChe;
    BOOL catPatrolChe;
    int catSpillTimeCount;
    int catSpillTimeCount2;
    CGFloat iceSmokingCount[5][2];
    int iceSmokingReleaseCount;
    int waterIntervalTimeCount;
    int fridgeVisibleCount;
    CGFloat iceQubePos[4][2];
    CGFloat iceQubeCount[4];
    int iceBlastAnimationCount;
    int iceQubeReleaseCount;
    int iceQubeDelayCount;
    CGFloat catMovementCount;
    BOOL catBackChe;
    int catAnimationCount;
    BOOL catReleaseChe;
    CGFloat pulbCount;
    
}
+(CCScene *) scene;

@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *background;

-(void)heroRunFunc;
@end
