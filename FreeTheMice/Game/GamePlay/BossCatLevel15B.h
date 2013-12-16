//
//  BossCatLevel15B.h
//  FreeTheMice
//
//  Created by Muhammad Kamran on 27/11/2013.
//
//

#import "CCLayer.h"
#import "CCLayer.h"
#import "CommonEngine.h"
#import "cocos2d.h"
#import "Box2D.h"
#import "MyContactListener.h"
#import "BossCatLevel15.h"
#import "StrongGameFunc.h"
#define PTM_RATIO 32

@interface GirlMouseEngineMenu15B : CCLayer {
    
    
}

@end

@interface BossCatLevel15B : CommonEngine{
	StrongGameFunc *gameFunc;
    sound *soundEffect;
    CCSpriteBatchNode *bossCatTurnBatch;
    b2World* world;
    CGPoint  blocksPosiotionsArr[3];
    CCSpriteBatchNode *bossCatWalkBatch;
    CCSpriteBatchNode *girlKeyBatch;
    CCSpriteBatchNode *girlCageBatch;
    CCSprite *bossCatWalk;
    CCSprite *motherMouse;
    BOOL isPushing;
    BOOL isMiceMoving;
    BOOL shouldCheckCollision;
    CCSprite *boxSprite[3];
    CCSprite *wavesSprite;
    CCSprite *wavesSprite2;
    BOOL isCatKnockedOut;
    BOOL isTurnAnimation;
    int knockoutCount;
    CCSprite *bossCatKnocked;
    CCSprite *bossCatTurn;
    CCSequence *catKnockedAnimSeq;
    int bossCatDirection;
    CGSize winSize;
	GLESDebugDraw *m_debugDraw;
	MyContactListener *_contactListener;
    b2Body *heroBody;
    b2Vec2 activeVect, startVect;
    float32 jumpPower,jumpAngle;
    CCSprite *heroPimpleSprite[25];
    BOOL heroReleaseChe;
    int stickyJumpValue;
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_background;
    
    CCMenu *menu;
    CCMenu *menu2;
    
    int saveDottedPathCount;
    
    CCParticleSystem	*cheeseEmitter;
    
    CCSprite *heroWinSprite;
    CCSprite *heroTrappedSprite;
    CCSprite *mouseDragSprite;
    CCSprite *progressBarBackSprite;
    CCSprite *cheeseCollectedSprite;
    CCSprite *mouseTrappedBackground;
    CCSprite *timeCheeseSprite;
    CCSprite *cheeseSprite[5];
    CCSprite *cheeseSprite2[5];
    CCSprite *smokingSprite[6][6];
    CCSprite *starSprite[6];
    CCSprite *clockBackgroundSprite;
    CCSprite *clockArrowSprite;
    CCSprite *lightSprite;
    CCSprite *visibleSprite[5];
    CCSprite *hotSprite[10];
    
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
    int cheeseX2;
    int cheeseY2;
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
    int testAngle;
    int visibleCount;
}
+(CCScene *) scene;

@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *background;

-(void)heroRunFunc;

@end
