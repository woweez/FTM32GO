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
#import "GirlGameFunc.h"
#import "sound.h"
#import "Trigo.h"
#import "HudLayer.h"
#import "LevelCompleteScreen.h"
#import "CommonEngine.h"

#define PTM_RATIO 32

@interface GirlMouseEngineMenu10 : CCLayer {
    

}

@end
@interface GirlMouseEngine10 : CommonEngine {
	GirlGameFunc *gameFunc;
    sound *soundEffect;
    b2World* world;
    Trigo *trigo;
//    HudLayer *hudLayer;
    CGSize winSize;
	GLESDebugDraw *m_debugDraw;
	MyContactListener *_contactListener;
    b2Body *heroBody;
    b2Vec2 activeVect, startVect;
    float32 jumpPower,jumpAngle;
    CCSprite *heroPimpleSprite[25];
    BOOL heroReleaseChe;
    
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_background;
    
    CCMenu *menu;
    CCMenu *menu2;
    
    
//    BOOL jumpingChe;
    int saveDottedPathCount;
    
    CCParticleSystem	*cheeseEmitter;
//    CCSprite *heroSprite;
    CCSprite *heroStandSprite;
//    CCSprite *heroRunSprite;
    CCSprite *heroWinSprite;
    CCSprite *heroTrappedSprite;
    CCSprite *mouseDragSprite;
    CCSprite *progressBarBackSprite;
    CCSprite *cheeseCollectedSprite;
    CCSprite *mouseTrappedBackground;
    CCSprite *timeCheeseSprite;
    CCSprite *catSprite2;
    CCSprite *catSprite3;
    CCSprite *cheeseSprite[5];
    CCSprite *cheeseSprite2[5];
    CCSprite *starSprite[6];
    CCSprite *hotSprite[5];
    CCSprite *iceQubeSprite[6];
    CCSprite *iceSmokingSprite[10][2];
    CCSprite *iceSmokingSprite2[10][2];
    CCSprite *pieSprite;
    CCSprite *combinationFreezeSprite[2][2];
    CCSprite *clockBackgroundSprite;
    CCSprite *clockArrowSprite;
    
    CCSprite *dotSprite;
    
    BOOL heroStandChe;
    int heroStandAnimationCount;
    BOOL dragChe;
//    BOOL forwardChe;
    int heroJumpingAnimationCount;
    int heroJumpingAnimationArrValue;
//    CCSpriteFrameCache *cache;
//    CCSpriteBatchNode *spriteSheet;
    CCSpriteFrameCache *catCache;
    CCSpriteBatchNode *catSpriteSheet;
    
    NSArray * heroJumpIntervalValue;
    NSArray * cheeseSetValue;
    NSArray *cheeseArrX;
    NSArray *cheeseArrY;
    NSArray *heroRunningStopArr;
    NSArray *freezeArr;
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
    CCLabelAtlas *switchAtlas;
    CCLabelAtlas *switchAtlas2;
    CCLabelAtlas *switchAtlas3;
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
    int trappedTypeValue;
    int heroTrappedMove;
    int cheeseStarAnimatedCount[5];
    int autoJumpValue2;
    
    CGFloat gateCount;
    CGFloat lightRotateCount;
    CGFloat cheeseFallCount;
    CGFloat screenShowX;
    CGFloat screenShowY;
    CGFloat screenShowX2;
    CGFloat screenShowY2;
    BOOL screenMoveChe;
    int screenMovementFindValue;
    int screenMovementFindValue2;
    int screenMovementFindValue3;
    CGFloat hotSmokingCount[5];
    int hotSmokingRelease;
    int stickyStopValue;
    
    int testAngle;
    int visibleCount;
    int stickyJumpValue;
    BOOL dragTrigoCheckChe;
    BOOL stickyLandChe;
    CGFloat iceQubeCount[6];
    BOOL iceQubeChe[8];
    int plateStopCount;
    int plateAnimationReleaseCount;
    int plateAnimationReleaseCount2;
    int stickyYPos;
    int iceBlastAnimationCount;
    CGFloat iceSmokingCount[10][2];
    CGFloat iceSmokingCount2[10][2];
    int iceSmokingReleaseCount;
    int iceSmokingReleaseCount2;
    CGFloat pieScaleCount;
    int iceQubeReleaseCount;
    int combinationFreezeCount[2];
    int combinationInterValCount;
    int freezeArrCount;
    int combinationValue;
    int combinationValue2;
    int combinationValue3;
    BOOL combJumpChe;
    BOOL combinationPosChe2;
    int thirdFreezeIntervalTimeCount;
    
    //Cat 1
    BOOL catJumpChe;
    BOOL catBackChe;
    int catJumpingAnimationCount;
    BOOL catForwardChe;
    CGFloat catMovementValue;
    CGFloat catMovementCount;
    int turnAnimationCount;
    int catAnimationCount;
    int catRunningCount,catRunningCount2;
    CGFloat catX,catY;
    BOOL trigoLeftLandChe;
    BOOL trigoLeftLandChe2;
    BOOL catEscapeChe;
    CGFloat knifeCount;
    
    //Cat 2
    BOOL catBackChe2;
    BOOL catJumpChe2;
    int catJumpingAnimationCount2;
    BOOL catForwardChe2;
    CGFloat catMovementCount2;
    int turnAnimationCount2;
    int catAnimationCount2;
    CGFloat catX2,catY2;
    
    
}
+(CCScene *) scene;

@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *background;

-(void)heroRunFunc;
@end
