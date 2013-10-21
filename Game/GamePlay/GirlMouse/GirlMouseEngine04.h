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
#import "GirlLevel4Cat.h"

#define PTM_RATIO 32

@interface GirlMouseEngineMenu04 : CCLayer {
    

}

@end
@interface GirlMouseEngine04 : CommonEngine {
	GirlGameFunc *gameFunc;
    sound *soundEffect;
    b2World* world;
    Trigo *trigo;
//    HudLayer *hudLayer;
    GirlLevel4Cat *catObj1;
    GirlLevel4Cat *catObj2;
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
//    CCSprite *heroRunSprite;
    CCSprite *heroWinSprite;
    CCSprite *heroTrappedSprite;
    CCSprite *mouseDragSprite;
    CCSprite *progressBarBackSprite;
    CCSprite *cheeseCollectedSprite;
    CCSprite *mouseTrappedBackground;
    CCSprite *timeCheeseSprite;
//    CCSprite *catSprite2;
    CCSprite *cheeseSprite[5];
    CCSprite *cheeseSprite2[5];
    CCSprite *starSprite[6];
    CCSprite *hotSprite[10];
    CCSprite *stickyPlatfromSprite;

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
    CCLabelAtlas *switchAtlas;
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
    CGFloat hotSmokingCount[10];
    int hotSmokingRelease;
    int stickyStopValue;
    
    int testAngle;
    int visibleCount;
    int stickyJumpValue;
    
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
