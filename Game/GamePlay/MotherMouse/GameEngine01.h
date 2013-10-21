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
#import "GameFunc.h"
#import "sound.h"
#import "Trigo.h"
#import "HudLayer.h"
#import "CommonEngine.h"
#define PTM_RATIO 32

@interface GameEngine01Menu : CCLayer {
        
}
@end

@interface GameEngine01 : CommonEngine {
    
    GameFunc *gameFunc;
    sound *soundEffect;
    Trigo *trigo;
    b2World* world;
    CGSize winSize;
    CCSprite *pressImage;
    CCSprite *tutorialCircle;
    CCSprite *tutorialArrow;
	GLESDebugDraw *m_debugDraw;
	MyContactListener *_contactListener;
    b2Body *heroBody;
    b2Vec2 activeVect, startVect;
    float32 jumpPower,jumpAngle;
    CCSprite *heroPimpleSprite[20];
    BOOL heroReleaseChe;
    
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_background;
    
    CCMenu *menu,*menu2;

    CGFloat saveDottedPath[200][2];
    
//    BOOL jumpingChe;
    CGFloat saveDottedPathCount;
    
    CCParticleSystem	*cheeseEmitter;
//    CCSprite *heroSprite;
//    CCSprite *heroRunSprite;
    CCSprite *heroWinSprite;
    CCSprite *heroTrappedSprite;
    CCSprite *mouseDragSprite;
    CCSprite *progressBarBackSprite;
    CCSprite *cheeseCollectedSprite;
    CCSprite *progressBarSprite[120];
    CCSprite *timeCheeseSprite;
    CCSprite *cheeseSprite[5];
    CCSprite *cheeseSprite2[5];
    CCSprite *starSprite[5];
    CCSprite *clockBackgroundSprite;
    CCSprite *clockArrowSprite;
    CCSprite *teaPotSprite;
    CCSprite *hotSprite[15];
    CCSprite *mouseTrappedBackground;
    CCSprite *domeSprite;
    CCSprite *vegetableCloseSprite;
    
    CCSprite *testSprite[360];
    
//    HudLayer *hudLayer;
    CCSprite *dotSprite;
    
    BOOL heroStandChe;
    int heroStandAnimationCount;
    BOOL dragChe;
//    BOOL forwardChe;
    int heroJumpingAnimationCount;
    int heroJumpingAnimationArrValue;
//    CCSpriteFrameCache *cache;
//    CCSpriteBatchNode *spriteSheet;
    
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
    BOOL dragTrigoCheckChe;
    
    
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
    int cheeseCollectedScore;
    BOOL cheeseCollectedChe[10];
    int cheeseCount;
    int motherLevel;
    int jumpRunDiff;
    int jumpRunDiff2;
    int topHittingCount;
    int cheeseAnimationCount;
    int heroTrappedCount;
    int cheeseStarAnimatedCount[5];
    int autoJumpValue2;
    CGFloat hotSmokingCount[15];
    int hotSmokingRelease;
    int hotIntervel;
    int cheeseX2;
    int cheeseY2;
    int domeLessCount;
    int domeRotateCount;
    CGFloat screenShowX;
    CGFloat screenShowY;
    CGFloat screenShowX2;
    CGFloat screenShowY2;
    int screenFirstViewCount;
    
    //level 5
    CCSprite *tileMove;
    
    //level 6
    CCSprite *tileMove2;
    
    int testAngle;
}

+(CCScene *) scene;

@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *background;

-(void)heroRunFunc;
@end
