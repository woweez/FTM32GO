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

@interface GirlMouseEngineMenu11 : CCLayer {
    

}

@end
@interface GirlMouseEngine11 : CommonEngine {
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
    CCSprite *heroRotateSprite;
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
    CCSprite *combinationFreezeSprite[2][2];
    CCSprite *clockBackgroundSprite;
    CCSprite *clockArrowSprite;
    CCSprite *movePlatformSprite;
    CCSprite *iceSmokingSprite[3];
    
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
    NSArray *freezeReleaseArr;
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
    BOOL stChe;
    
    int testAngle;
    int visibleCount;
    int stickyJumpValue;
    BOOL dragTrigoCheckChe;
    BOOL stickyLandChe;
    CGFloat iceQubeCount[6];
    BOOL iceQubeChe[8];
    int stickyYPos;
    int iceBlastAnimationCount;
    int iceQubeReleaseCount;
    int combinationFreezeCount[2];
    int combinationInterValCount;
    BOOL heroRotateChe2;
    int platformRotateIntervalCount;
    CGFloat heroRotateLessValue;
    CGFloat heroRotateStopValue;
    BOOL centerDoneChe;
    CGFloat iceSmokingCount;
    int freezeReleaseArrCount;
        
    
}
+(CCScene *) scene;

@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *background;

-(void)heroRunFunc;
@end
