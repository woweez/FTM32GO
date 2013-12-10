//
//  BossCatLevel15C.h
//  FreeTheMice
//
//  Created by Muhammad Kamran on 27/11/2013.
//
//

#import "CCLayer.h"
#import "CommonEngine.h"
#import "cocos2d.h"
#import "Box2D.h"
#import "FTMConstants.h"
#import "FTMUtil.h"

#import "AppDelegate.h"
#import "MyContactListener.h"
#import "GameFunc.h"
#import "sound.h"
#import "HudLayer.h"
#import "Trigo.h"
#import "MotherLevel15Cat.h"
#define PTM_RATIO 32

@interface GameEngineMenu15 : CCLayer {
    
}
@end

@interface BossCatLevel15C : CommonEngine{
    GameFunc *gameFunc;
    sound *soundEffect;
    Trigo *trigo;
    CGSize winSize;
    b2World* world;
    MotherLevel15Cat *catObj1;
    MotherLevel15Cat *catObj2;
    CCSpriteBatchNode *bossCatTurnBatch;
    CCSpriteBatchNode *bossCatWalkBatch;
    CCSprite *bossCatWalk;
    CCSprite *storyBoard;
    BOOL isPushing;
    BOOL isMiceMoving;
    BOOL shouldCheckCollision;
    BOOL isCatKnockedOut;
    BOOL isSwitchOn;
    BOOL isTurnAnimation;
    int knockoutCount;
    CCSprite *bossCatKnocked;
    CCSprite *bossCatTurn;
    CCSequence *catKnockedAnimSeq;
    int bossCatDirection;

    CGPoint previousPosition;
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
    
    CGFloat saveDottedPathCount;
    
    CCParticleSystem	*cheeseEmitter;
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
    
    CCSprite *dotSprite;
    
    BOOL heroStandChe;
    int heroStandAnimationCount;
    BOOL dragChe;
    int heroJumpingAnimationCount;
    int heroJumpingAnimationArrValue;
    
    NSArray * heroJumpIntervalValue;
    NSArray * cheeseSetValue;
    NSArray *cheeseArrX;
    NSArray *cheeseArrY;
    NSArray *heroRunningStopArr;
    CGFloat backHeroJumpingY;

    BOOL dragTrigoCheckChe;
    
    CGFloat screenHeroPosX;
    CGFloat screenHeroPosY;
    CGFloat heroForwardX;
    
    int heroRunningCount,heroRunningCount2;
    int heroWinCount;
    
    CCSprite *numbersSprite[15];
    CCLabelAtlas *lifeMinutesAtlas;
    CCLabelAtlas *cheeseCollectedAtlas;
    CCLabelAtlas *switchAtlas1;
    CCLabelAtlas *switchAtlas2;
    CCLabelAtlas *switchAtlas3;
    CCLabelAtlas *switchAtlas4;
    
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
    
    CCSprite *tileMove;
    CCSprite *tileMove2;
    
    int testAngle;
}

+(CCScene *) scene;

@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *background;

-(void)heroRunFunc;
@end
