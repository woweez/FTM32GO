//
//  BossCatLevel15A.m
//  FreeTheMice
//
//  Created by Muhammad Kamran on 27/11/2013.
//
//

#import "BossCatLevel15A.h"
#import "FTMConstants.h"
#import "FTMUtil.h"

#import "GirlMouseEngine02.h"
#import "LevelScreen.h"
// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "BossCatLevel15B.h"
#import "LoadingLayer.h"
#import "DB.h"


enum {
    kTagParentNode = 1,
};

GirlMouseEngineMenu15 *gLayer15;

@implementation GirlMouseEngineMenu15


-(id) init {
    if( (self=[super init])) {
    }
    return self;
}
@end

@implementation BossCatLevel15A

@synthesize tileMap = _tileMap;
@synthesize background = _background;

+(CCScene *) scene {
    CCScene *scene = [CCScene node];
    gLayer15 = [GirlMouseEngineMenu15 node];
    [scene addChild:gLayer15 z:1];
    
    BossCatLevel15A *layer = [BossCatLevel15A node];
    [scene addChild: layer];
    
    return scene;
}

-(id) init
{
    if( (self=[super init])) {
        
        heroJumpIntervalValue = [[NSArray alloc] initWithObjects:@"0",@"2",@"4",@"6",@"8",@"10",@"0",@"11",@"13",@"15",nil];
        cheeseSetValue= [[NSArray alloc] initWithObjects:@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",nil];
        cheeseArrX=[[NSArray alloc] initWithObjects:@"0",@"20",@"0",   @"20",@"10",nil];
        cheeseArrY=[[NSArray alloc] initWithObjects:@"0",@"0", @"-15", @"-15",@"-8",nil];
        heroRunningStopArr=[[NSArray alloc] initWithObjects:@"80",@"80",@"80", @"40",@"140",@"80",@"80",@"80",@"80",@"80",@"80",@"80",@"40",@"80",@"80",nil];
        winSize = [CCDirector sharedDirector].winSize;
        gameFunc=[[GirlGameFunc alloc] init];
        soundEffect=[[sound alloc] init];
        [self initValue];
        gameFunc.gameLevel=motherLevel;
        
        
        self.isTouchEnabled = YES;
        self.isAccelerometerEnabled = YES;
        b2Vec2 gravity;
        gravity.Set(0, -5.0f);
        world = new b2World(gravity);
        world->SetContinuousPhysics(true);
        m_debugDraw = new GLESDebugDraw( PTM_RATIO );
        world->SetDebugDraw(m_debugDraw);
        uint32 flags = 0;
        flags += b2Draw::e_shapeBit;
        m_debugDraw->SetFlags(flags);
        
        _contactListener = new MyContactListener();
        world->SetContactListener(_contactListener);
        
        
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"background.tmx"];
        self.background = [_tileMap layerNamed:@"background"];
        if ([FTMUtil sharedInstance].isRetinaDisplay) {
            self.background.scale = 2;
        }
        [self addChild:_tileMap z:-1 tag:1];
        
        cache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [cache addSpriteFramesWithFile:@"girl_default.plist"];
        [cache addSpriteFramesWithFile:@"bossCatWalk.plist"];
        [cache addSpriteFramesWithFile:@"bossCatKnocked.plist"];
        [cache addSpriteFramesWithFile:@"bossCatTurn.plist"];
        [cache addSpriteFramesWithFile:@"strongCageAnim.plist"];
        [cache addSpriteFramesWithFile:@"keyAnimation.plist"];
        [cache addSpriteFramesWithFile:@"strong0_default.plist"];
        
        spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"girl_default.png"];
        bossCatWalkBatch = [CCSpriteBatchNode batchNodeWithFile:@"bossCatWalk.png"];
        
        [self addChild:spriteSheet z:10];
        [self addChild:bossCatWalkBatch z:10];
        
        CCSpriteBatchNode *strongMouseBatch = [CCSpriteBatchNode batchNodeWithFile:@"strong0_default.png"];
        [self addChild:strongMouseBatch];
        
        strongMouse = [CCSprite spriteWithSpriteFrameName:@"strong_run01.png"];
         NSMutableArray *strongFrames = [NSMutableArray array];
        for(int i =1; i <= 12; i++) {
            CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"strong_run0%d.png",i]];
            [strongFrames addObject:frame];
        }
        strongMouse.scale = STRONG_SCALE;
        strongMouse.tag = HERO_RUN_SPRITE_TAG;
        strongMouse.visible = NO;
        strongMouse.position = ccp(200, 200);
        CCAnimation *strongAnimation = [CCAnimation animationWithSpriteFrames:strongFrames delay:0.04f];
    
        [strongMouse runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:strongAnimation]]];
        [strongMouseBatch addChild:strongMouse];
            
        CCSpriteBatchNode *bossCatKnockedBatch = [CCSpriteBatchNode batchNodeWithFile:@"bossCatKnocked.png"];
        [self addChild:bossCatKnockedBatch];
        
        
        bossCatKnocked = [CCSprite spriteWithSpriteFrameName:@"boss_cat_knocked out1_0.png"];
        bossCatKnocked.position = bossCatWalk.position;
        bossCatKnocked.visible = NO;
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            bossCatKnocked.scale = NON_RETINA_SCALE;
        }
        [bossCatKnockedBatch addChild:bossCatKnocked];
        //
        bossCatTurnBatch = [CCSpriteBatchNode batchNodeWithFile:@"bossCatTurn.png"];
        
        [self addChild:bossCatTurnBatch];
        
        [self makeCageAnimation];
        //
        bossCatWalk = [CCSprite spriteWithSpriteFrameName:@"boss_cat_walk_0.png"];
        bossCatWalk.position = ccp(200, 276);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            bossCatWalk.scale = NON_RETINA_SCALE;
        }
        [bossCatWalkBatch addChild:bossCatWalk];
        
        NSMutableArray *catFrames = [NSMutableArray array];
        for(int i = 0; i <= 29; i++) {
            CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"boss_cat_walk_%d.png",i]];
            [catFrames addObject:frame];
        }
        CCAnimation *catAnim = [CCAnimation animationWithSpriteFrames:catFrames delay:0.02f];
        [bossCatWalk runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:catAnim]]];
        
        heroRunSprite = [CCSprite spriteWithSpriteFrameName:@"girl_run1.png"];
        heroRunSprite.position = ccp(200, 200);
        heroRunSprite.scale = 0.65;
        [spriteSheet addChild:heroRunSprite];
        
        NSMutableArray *animFrames = [NSMutableArray array];
        for(int i = 1; i < 8; i++) {
            CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"girl_run%d.png",i]];
            [animFrames addObject:frame];
        }
        CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.07f];
        [heroRunSprite runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation]]];
        
        mouseDragSprite=[CCSprite spriteWithFile:@"mouse_drag.png"];
        mouseDragSprite.position=ccp(platformX+2,platformY+3);
        mouseDragSprite.scale = MICE_TAIL_SCALE;
        mouseDragSprite.visible = NO;
        mouseDragSprite.anchorPoint=ccp(0.99f, 0.9f);
        [self addChild:mouseDragSprite z:9];
        
        [self heroAnimationFunc:0 animationType:@"stand"];
        heroSprite.visible=NO;
        
        [self HeroDrawing];
        
        CCSprite *platformSprite=[CCSprite spriteWithFile:@"move_platform3.png"];
        platformSprite.position = ccp(230,441);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            platformSprite.scale = NON_RETINA_SCALE;
        }
        [self addChild:platformSprite z:1];
        
        platformSprite=[CCSprite spriteWithFile:@"move_platform3.png"];
        platformSprite.position=ccp(550,441);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            platformSprite.scale = NON_RETINA_SCALE;
        }
        [self addChild:platformSprite z:1];
        
        CCSprite *sPlatformSprite=[CCSprite spriteWithFile:@"sticky_platform.png"];
        sPlatformSprite.position=ccp(550,431);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            sPlatformSprite.scale = NON_RETINA_SCALE;
        }
        [self addChild:sPlatformSprite z:10];
        
        sPlatformSprite=[CCSprite spriteWithFile:@"sticky_platform.png"];
        sPlatformSprite.position=ccp(230,431);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            sPlatformSprite.scale = NON_RETINA_SCALE;
        }
        [self addChild:sPlatformSprite z:10];
        
        CCSprite *slapSprite=[CCSprite spriteWithFile:@"slap.png"];
        slapSprite.position=ccp(150,188);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            slapSprite.scale=0.3;
        }else{
            slapSprite.scale=0.6;
        }
        [self addChild:slapSprite z:2];
        
        slapSprite=[CCSprite spriteWithFile:@"slap.png"];
        slapSprite.position=ccp(450,188);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            slapSprite.scale=0.3;
        }else{
            slapSprite.scale=0.6;
        }
        [self addChild:slapSprite z:1];
        
        slapSprite=[CCSprite spriteWithFile:@"slap.png"];
        slapSprite.position=ccp(750,188);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            slapSprite.scale = 0.3;
        }else{
            slapSprite.scale = 0.6;
        }
        [self addChild:slapSprite z:1];
        
        slapSprite=[CCSprite spriteWithFile:@"slap.png"];
        slapSprite.position=ccp(1050,188);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            slapSprite.scale = 0.3;
        }else{
            slapSprite.scale = 0.6;
        }
        [self addChild:slapSprite z:1];

        for(int i=0;i<25;i++){
            heroPimpleSprite[i]=[CCSprite spriteWithFile:@"dotted.png"];
            heroPimpleSprite[i].position=ccp(-100,160);
            heroPimpleSprite[i].scale = 0.3;
            if (![FTMUtil sharedInstance].isRetinaDisplay) {
                heroPimpleSprite[i].scale = 0.15;
            }
            [self addChild:heroPimpleSprite[i] z:10];
        }
        
        //===================================================================
        dotSprite=[CCSprite spriteWithFile:@"dotted.png"];
        dotSprite.position=ccp(487,280);
        dotSprite.scale = 0.2;
        [self addChild:dotSprite z:10];
        [self addHudLayerToTheScene];
        [self starCheeseSpriteInitilized];
        [self schedule:@selector(moveBossCatLeftAndRight) interval:0.01];
        [self scheduleUpdate];
    }
    return self;
}

-(void) makeKeyAnimation{
    DB *db = [DB new];
    int currentLvl = [[db getSettingsFor:@"girlCurrLvl"] intValue];
    if(currentLvl <= motherLevel){
        [db setSettingsFor:@"CurrentLevel" withValue:[NSString stringWithFormat:@"%d", 16]];
        [db setSettingsFor:@"girlCurrLvl" withValue:[NSString stringWithFormat:@"%d", 16]];
    }
    [db release];
    girlKeyBatch = [CCSpriteBatchNode batchNodeWithFile:@"keyAnimation.png"];
    [self addChild:girlKeyBatch];
    
    CCSprite *girlCage = [CCSprite spriteWithSpriteFrameName:@"key_0.png"];
    if (bossCatTurn.flipX == 1) {
        girlCage.position = ccp(bossCatKnocked.position.x - 80, bossCatKnocked.position.y + 30);
    }else{
        girlCage.position = ccp(bossCatKnocked.position.x + 80, bossCatKnocked.position.y + 30);
    }
    
    if (![FTMUtil sharedInstance].isRetinaDisplay) {
        girlCage.scale = NON_RETINA_SCALE;
    }
    [girlKeyBatch addChild:girlCage];
    
    NSMutableArray *cageFrames = [NSMutableArray array];
    for(int i = 0; i <= 9; i++) {
        CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"key_%d.png",i]];
        [cageFrames addObject:frame];
    }
    CGPoint point = CGPointMake(390, 556);
    int x = MAX(point.x, winSize.width / 2);
    int y = MAX(point.y, winSize.height / 2);
    x = MIN(x, (_tileMap.mapSize.width * _tileMap.tileSize.width)
            - winSize.width / 2);
    y = MIN(y, (_tileMap.mapSize.height * _tileMap.tileSize.height)
            - winSize.height/2);
    CGPoint actualPosition = ccp(x, y);
    if(x<=winSize.width/2)
        screenHeroPosX=point.x;
    else if(x>=_tileMap.mapSize.width-winSize.width/2)
        screenHeroPosX=(point.x-x)+winSize.width/2;
    if(y<=winSize.height/2)
        screenHeroPosY=point.y;
    else if(y>=_tileMap.mapSize.height-winSize.height/2)
        screenHeroPosY=(point.y-y)+winSize.height/2;
    
    
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    
    CCDelayTime *delay = [CCDelayTime actionWithDuration:1.2];
    CCMoveTo *move1 = [CCMoveTo actionWithDuration:2 position:viewPoint];
    CCSequence *seq1 = [CCSequence actions:delay,move1, nil];
    [self runAction:seq1];
    
    CCCallFunc *animationDone = [CCCallFunc actionWithTarget:self selector:@selector(keyAnimationDone)];
    CCMoveTo *move2 = [CCMoveTo actionWithDuration:2 position:CGPointMake(374, 463)];
    CCSequence *seq2 = [CCSequence actions:delay,move2,animationDone, nil];
    CCAnimation *cageAnim = [CCAnimation animationWithSpriteFrames:cageFrames delay:0.05f];
    [girlCage runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:cageAnim]]];
    [girlCage runAction:seq2];
}

-(void) keyAnimationDone{
    girlKeyBatch.visible = NO;
    girlCageBatch.visible = NO;
    strongMouse.position = ccp(390, 474);
    CCMoveTo *move = [CCMoveTo actionWithDuration:1.2 position:CGPointMake(600, 480)];
    CCCallFunc *animationDone = [CCCallFunc actionWithTarget:self selector:@selector(strongMouseMoveDone)];
    CCSequence *seq = [CCSequence actions:move, animationDone, nil];
    strongMouse.visible = YES;
    [strongMouse runAction:seq];
}

-(void) strongMouseMoveDone{
    [FTMUtil sharedInstance].mouseClicked = FTM_STRONG_MICE_ID;
    [[CCDirector sharedDirector] replaceScene:[LoadingLayer scene:16 currentMice:FTM_STRONG_MICE_ID]];
}

-(void) makeCageAnimation{
    girlCageBatch = [CCSpriteBatchNode batchNodeWithFile:@"strongCageAnim.png"];
    [self addChild:girlCageBatch];
    
    CCSprite *girlCage = [CCSprite spriteWithSpriteFrameName:@"sm_cage_0.png"];
    girlCage.position = ccp(390, 556);
    girlCage.visible = YES;
    if (![FTMUtil sharedInstance].isRetinaDisplay) {
        girlCage.scale = NON_RETINA_SCALE;
    }
    [girlCageBatch addChild:girlCage];
    
    NSMutableArray *cageFrames = [NSMutableArray array];
    for(int i = 0; i <= 27; i++) {
        CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"sm_cage_%d.png",i]];
        [cageFrames addObject:frame];
    }
    CCAnimation *cageAnim = [CCAnimation animationWithSpriteFrames:cageFrames delay:0.05f];
    [girlCage runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:cageAnim]]];
}
-(void) makeCatKnockedAnimation{
    bossCatKnocked.visible = YES;
    bossCatKnocked.position = bossCatWalk.position;
    bossCatKnocked.flipX = bossCatWalk.flipX;
    NSMutableArray *catKnockedFrames = [NSMutableArray array];
    for(int i = 0; i <= 5; i++) {
        CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"boss_cat_knocked out1_%d.png",i]];
        [catKnockedFrames addObject:frame];
    }
    CCAnimation *catKnockedAnim1 = [CCAnimation animationWithSpriteFrames:catKnockedFrames delay:0.07f];
    CCAnimate *animation1 = [CCAnimate actionWithAnimation:catKnockedAnim1];
    
    catKnockedFrames = [NSMutableArray array];
    for(int i = 0; i <= 29; i++) {
        CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"boss_cat_knocked out2_%d.png",i]];
        [catKnockedFrames addObject:frame];
    }
    CCCallFunc *animationDone = [CCCallFunc actionWithTarget:self selector:@selector(catAnimationDone)];
    CCAnimation *catKnockedAnim2 = [CCAnimation animationWithSpriteFrames:catKnockedFrames delay:0.07f];
    CCAnimate *animation2 = [CCAnimate actionWithAnimation:catKnockedAnim2];
    catKnockedAnimSeq = [CCSequence actions:animation1,animation2,animationDone, nil];
    if (knockoutCount == 3) {
        [self makeKeyAnimation];
    }
    [bossCatKnocked runAction: catKnockedAnimSeq];
}

-(void) makeCatTurnAnimation{
    
    if (isTurnAnimation) {
        [bossCatTurn removeFromParentAndCleanup:YES];
        bossCatTurn = [CCSprite spriteWithSpriteFrameName:@"boss_cat_turn_0.png"];
        bossCatTurn.position = bossCatWalk.position;
        if (bossCatDirection == 1) {
            bossCatTurn.flipX = 1;
        }else{
            bossCatTurn.flipX = 0;
        }
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            bossCatTurn.scale = NON_RETINA_SCALE;
        }
        [bossCatTurnBatch addChild:bossCatTurn];
        
        NSMutableArray *catKnockedFrames = [NSMutableArray array];
        for(int i = 1; i <= 11; i++) {
            CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"boss_cat_turn_%d.png",i]];
            [catKnockedFrames addObject:frame];
        }
        CCAnimation *catKnockedAnim1 = [CCAnimation animationWithSpriteFrames:catKnockedFrames delay:0.07f];
        CCAnimate *animation1 = [CCAnimate actionWithAnimation:catKnockedAnim1];
        
        CCCallFunc *animationDone = [CCCallFunc actionWithTarget:self selector:@selector(catTurnAnimationDone)];
        CCSequence *animSeq = [CCSequence actions:animation1,animationDone, nil];
        
        [bossCatTurn runAction: animSeq];
        
    }
}

-(void) catTurnAnimationDone{
    isTurnAnimation = NO;
    bossCatTurn.visible = NO;
    bossCatWalk.visible = YES;
    if (bossCatDirection == 0) {
        bossCatWalk.flipX = 0;
    }else{
        bossCatWalk.flipX = 1;
    }
}
-(void) catAnimationDone{
    if(knockoutCount == 3){
        NSMutableArray *catKnockedFrames = [NSMutableArray array];
        for(int i = 0; i <= 29; i++) {
            CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"boss_cat_knocked out2_%d.png",i]];
            [catKnockedFrames addObject:frame];
        }
        CCAnimation *catKnockedAnim2 = [CCAnimation animationWithSpriteFrames:catKnockedFrames delay:0.07f];
        CCAnimate *animation2 = [CCAnimate actionWithAnimation:catKnockedAnim2];
        
        catKnockedAnimSeq = [CCSequence actions:animation2, nil];
        [bossCatKnocked runAction: [CCRepeatForever actionWithAction:catKnockedAnimSeq]];
        
    }else{
        bossCatWalk.visible = YES;
        bossCatKnocked.visible = NO;
        isCatKnockedOut = NO;
    }}
-(void) checkCatCallision{
    
    if (knockoutCount == 3) {
        // cat is knocked out.
        return;
        
    }
    CGRect catRect;
    if (bossCatWalk.flipX == 0) {
      catRect = CGRectMake(bossCatWalk.position.x, bossCatWalk.position.y, bossCatWalk.contentSize.width* 0.3, 5);
    }else{
        catRect = CGRectMake(bossCatWalk.position.x, bossCatWalk.position.y, bossCatWalk.contentSize.width* 0.3, 5);
    }
    
    CGRect heroRect = CGRectMake(heroSprite.position.x, heroSprite.position.y, heroSprite.contentSize.width/2, heroSprite.contentSize.height/2);
    
    int heroX = heroSprite.position.x;
    int heroY = heroSprite.position.y;
    int catX = bossCatWalk.position.x;
    if (bossCatWalk.flipX == 0 && heroSprite.flipX == 0) {
        catX = catX+40;
    }
    if (bossCatWalk.flipX == 0 && heroSprite.flipX == 1) {
        catX = catX+60;
    }
    int catY = bossCatWalk.position.y;
    if (![FTMUtil sharedInstance].isInvincibilityOn && !isCatKnockedOut && !CGRectIsNull(CGRectIntersection(catRect, heroRect))) {

        gameFunc.trappedChe = YES;
        heroTrappedChe=YES;
        heroSprite.visible=NO;
        heroStandChe=NO;
        heroRunSprite.visible=NO;
    }
    else if (!isCatKnockedOut) {
        if (heroX > (catX - 60) && heroX < catX  && heroY > (catY +10) && heroY < (catY + 20) )  {
            knockoutCount ++;
            jumpingChe = NO;
            runningChe = NO;
            heroStandChe = NO;
            landingChe = NO;
            isCatKnockedOut = YES;
            bossCatWalk.visible = NO;
            [self moveMiceAndPlatform];
            bossCatKnocked.visible = YES;
            [self makeCatKnockedAnimation];
        }
    }
    
}

-(void) moveMiceAndPlatform{
    heroSprite.visible = YES;

    CCCallFunc *animationDone = [CCCallFunc actionWithTarget:self selector:@selector(miceMoveMentDone)];
    CGPoint point;
    if (!forwardChe) {
        point = CGPointMake(heroSprite.position.x + 130, 266);
    }else{
        point = CGPointMake(heroSprite.position.x  - 130 - heroForwardX, 266);
    }
    platformX = point.x;
    platformY = point.y;
    
    
    CCJumpTo *jump = [CCJumpTo actionWithDuration:1 position:CGPointMake(point.x , point.y) height:50 jumps:1];
    if (forwardChe) {
        jump = [CCJumpTo actionWithDuration:1 position:CGPointMake(point.x + heroForwardX, point.y) height:50 jumps:1];
    }
    CCSequence *seq = [CCSequence actions:jump, animationDone, nil];
    [heroSprite runAction:seq];
    
    int x = MAX(point.x, winSize.width / 2);
    int y = MAX(point.y, winSize.height / 2);
    x = MIN(x, (_tileMap.mapSize.width * _tileMap.tileSize.width)
            - winSize.width / 2);
    y = MIN(y, (_tileMap.mapSize.height * _tileMap.tileSize.height)
            - winSize.height/2);
    CGPoint actualPosition = ccp(x, y);
    if(x<=winSize.width/2)
        screenHeroPosX=point.x;
    else if(x>=_tileMap.mapSize.width-winSize.width/2)
        screenHeroPosX=(point.x-x)+winSize.width/2;
    if(y<=winSize.height/2)
        screenHeroPosY=point.y;
    else if(y>=_tileMap.mapSize.height-winSize.height/2)
        screenHeroPosY=(point.y-y)+winSize.height/2;
    

    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    
    CCMoveTo *move = [CCMoveTo actionWithDuration:1 position:viewPoint];
    [self runAction:move];
    
}
-(void) miceMoveMentDone{
    jumpingChe = NO;
    runningChe = NO;
    heroStandChe = YES;
    landingChe = NO;
    gameFunc.stickyChe=NO;
    if (stickyJumpValue == 1) {
        stickyJumpValue = 0;
    }
}
-(void) moveBossCatLeftAndRight{
    // 1 for left movement. 0 for right movement.
    if (isCatKnockedOut || isTurnAnimation) {
        return;
    }
    if (bossCatDirection == 0 && bossCatWalk.position.x > 700) {
        bossCatWalk.visible = NO;
        bossCatDirection = 1;
        isTurnAnimation = YES;
        [self makeCatTurnAnimation];
    }else if(bossCatDirection == 1 && bossCatWalk.position.x < 150){
        bossCatWalk.visible = NO;
        bossCatDirection = 0;
        isTurnAnimation = YES;
        [self makeCatTurnAnimation];
    }
    
    if (!isTurnAnimation) {
        if (bossCatDirection == 1) {
            bossCatWalk.position = ccp(bossCatWalk.position.x - 2 , bossCatWalk.position.y);
        }else{
            bossCatWalk.position = ccp(bossCatWalk.position.x + 2 , bossCatWalk.position.y);
        }
    }
}
-(void)initValue{
    
    //    DB *db = [DB new];
    motherLevel = 15;//[[db getSettingsFor:@"CurrentLevel"] intValue];
    //    [db release];
    cheeseCount=[cheeseSetValue[motherLevel-1] intValue];
    
    platformX=820;
    platformY=570;
    
    platformX=[gameFunc getPlatformPosition:motherLevel].x;
    platformY=[gameFunc getPlatformPosition:motherLevel].y;
    screenHeroPosX=platformX;
    screenHeroPosY=platformY;
    
    jumpingChe=NO;
    heroStandChe=NO;
    heroStandAnimationCount=51;
    heroJumpingAnimationCount=0;
    dragChe=NO;
    forwardChe=NO;
    heroJumpingAnimationArrValue=0;
    landingChe=NO;
    runningChe=YES;
    heroJumpLocationChe=NO;
    heroForwardX=36;
    firstRunningChe=YES;
    mouseWinChe=NO;
    safetyJumpChe=NO;
    cheeseCollectedScore=0;
    jumpRunDiff=0;
    heroJumpRunningChe=NO;
    topHittingCount=0;
    heroTrappedChe=NO;
    autoJumpValue2=0;
}

-(void) draw {
    /*	[super draw];
     ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
     kmGLPushMatrix();
     world->DrawDebugData();
     kmGLPopMatrix();*/
}
-(void)HeroDrawing{
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position.Set(platformX/32.0,platformY/32.0);
    heroBody = world->CreateBody(&bodyDef);
    b2CircleShape shape;
    shape.m_radius = 0.53f;
    b2FixtureDef fd;
    fd.shape = &shape;
    fd.density = 1.0f;
    heroBody->CreateFixture(&fd);
    
    bodyDef.type = b2_staticBody;
    bodyDef.position.Set(platformX/32.0,(platformY/32.0)-0.5);
    b2Body *bottomBody = world->CreateBody(&bodyDef);
    b2PolygonShape dynamicBox;
    b2FixtureDef lFict;
    dynamicBox.SetAsBox(0.6f, 0.02f, b2Vec2(0.0f, 0.0f), 0.0f);
    lFict.shape = &dynamicBox;
    bottomBody->CreateFixture(&lFict);
}

-(void) update: (ccTime) dt {
    
    int32 velocityIterations = 8;
    int32 positionIterations = 1;
    
    world->Step(dt, velocityIterations, positionIterations);
    
    [self heroJumpingFunc];
    [self heroAnimationFrameFunc];
    [self heroLandingFunc];
    [self heroRunFunc];
    [self heroWinFunc];
    
    [self level01];
    [self progressBarFunc];
    [self cheeseCollisionFunc];
    [self heroJumpingRunning];
    [self heroTrappedFunc];
    [self switchFunc];
    gameFunc.runChe=runningChe;
    [gameFunc render];
    [self hotSmokingFunc];
    [self checkCatCallision];
    if(visibleCount>=1){
        visibleCount+=15;
        if(visibleCount>=249){
            visibleCount=249;
        }
        for(int i=0;i<5;i++)
            visibleSprite[i].opacity=250-visibleCount;
        
    }
    
}

-(void)switchFunc{
    
    
    if(screenMoveChe){
        CGPoint copyHeroPosition = ccp(screenShowX, screenShowY);
        [self setViewpointCenter:copyHeroPosition];
    }
    
}

-(void)level01{
    if(firstRunningChe){
        if(platformX>[heroRunningStopArr[motherLevel-1] intValue]){
            heroStandChe=YES;
            runningChe=NO;
            heroRunSprite.visible=NO;
            heroSprite.visible=YES;
            firstRunningChe=NO;
            screenShowX=233;
            screenShowY=platformY;
            screenShowX2=233;
            screenShowY2=platformY;
        }
    }
    if(gameFunc.trappedChe){
        heroTrappedChe=YES;
        heroSprite.visible=NO;
        heroStandChe=NO;
        heroRunSprite.visible=NO;
    }
    if(gameFunc.trappedChe){
        if(heroTrappedChe&&heroTrappedCount ==50 &&heroTrappedMove==0){
            [self showLevelFailedUI:motherLevel];
        }
    }
    
    
}
-(void)hotSmokingFunc{
 
}

-(void)starCheeseSpriteInitilized{
    for(int i=0;i<5;i++){
        starSprite[i] = [CCSprite spriteWithSpriteFrameName:@"star2.png"];
        starSprite[i].scale=0.4;
        starSprite[i].position=ccp([gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].x-12,[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].y+8);
        [spriteSheet addChild:starSprite[i] z:10];
        
        NSMutableArray *animFrames3 = [NSMutableArray array];
        for(int j = 0; j <5; j++) {
            CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"star%d.png",j+1]];
            [animFrames3 addObject:frame];
        }
        CCAnimation *animation2 = [CCAnimation animationWithSpriteFrames:animFrames3 delay:0.2f];
        [starSprite[i] runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation2]]];
    }
}
-(void)cheeseCollisionFunc{
    CGFloat heroX=heroSprite.position.x;
    CGFloat heroY=heroSprite.position.y;
    
    for(int i=0;i<cheeseCount;i++){
        
        if(cheeseCollectedChe[i]){
            cheeseStarAnimatedCount[i]+=1;
            if(cheeseStarAnimatedCount[i]>=60){
                cheeseStarAnimatedCount[i]=0;
                int x=(arc4random() % 5);
                cheeseX2=[cheeseArrX[x] intValue];
                cheeseY2=[cheeseArrY[x] intValue];
                
                starSprite[i].position=ccp([gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].x-12+cheeseX2,[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].y+8+cheeseY2);
            }
            
            int mValue=0;
            int mValue2=0;
            
            cheeseAnimationCount+=2;
            cheeseAnimationCount=(cheeseAnimationCount>=500?0:cheeseAnimationCount);
            CGFloat localCheeseAnimationCount=0;
            localCheeseAnimationCount=(cheeseAnimationCount<=250?cheeseAnimationCount:250-(cheeseAnimationCount-250));
            cheeseSprite2[i].opacity=localCheeseAnimationCount/4;
            
            CGFloat cheeseX=[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].x;
            CGFloat cheeseY=[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].y;
            
            
            if(!forwardChe){
                if(heroX>=cheeseX-70-mValue &&heroX<=cheeseX+10-mValue&&heroY>cheeseY-20+mValue2&&heroY<cheeseY+30+mValue2){
                    [soundEffect cheeseCollectedSound];
                    cheeseCollectedChe[i]=NO;
                    cheeseSprite[i].visible=NO;
                    cheeseSprite2[i].visible=NO;
                    cheeseCollectedScore+=1;
                    starSprite[i].visible=NO;
                    [hudLayer updateNoOfCheeseCollected:cheeseCollectedScore andMaxValue:[cheeseSetValue[motherLevel-1] intValue]];
                    [self createExplosionX:cheeseX-mValue y:cheeseY+mValue2];
                    break;
                }
            }else{
                if(heroX>=cheeseX-10-mValue &&heroX<=cheeseX+70-mValue&&heroY>cheeseY-20+mValue2&&heroY<cheeseY+30+mValue2){
                    [soundEffect cheeseCollectedSound];
                    cheeseCollectedChe[i]=NO;
                    cheeseSprite[i].visible=NO;
                    cheeseSprite2[i].visible=NO;
                    cheeseCollectedScore+=1;
                    starSprite[i].visible=NO;
                    [hudLayer updateNoOfCheeseCollected:cheeseCollectedScore andMaxValue:[cheeseSetValue[motherLevel-1] intValue]];
                    [self createExplosionX:cheeseX-mValue y:cheeseY+mValue2];
                    break;
                }
            }
        }else{
            starSprite[i].visible=NO;
        }
    }
}

-(void)heroTrappedFunc{
    
    if(heroTrappedChe){
        heroTrappedCount+=1;
        if(heroTrappedCount==10){
            for (int i = 0; i < 20; i=i+1)
                heroPimpleSprite[i].position=ccp(-100,100);
            
            if(trappedTypeValue==1)
                heroTrappedMove=1;
            
            mouseDragSprite.visible=NO;
            heroTrappedSprite = [CCSprite spriteWithSpriteFrameName:@"girl_trapped1.png"];
            heroTrappedSprite.scale = GIRL_SCALE;
            if(!forwardChe)
                heroTrappedSprite.position = heroSprite.position;
            else
                heroTrappedSprite.position = ccp(heroSprite.position.x+heroForwardX, heroSprite.position.y+15);
            [spriteSheet addChild:heroTrappedSprite z:9999];
            
            NSMutableArray *animFrames2 = [NSMutableArray array];
            for(int i = 1; i < 8; i++) {
                CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"girl_trapped%d.png",i]];
                [animFrames2 addObject:frame];
            }
            CCAnimation *animation2 = [CCAnimation animationWithSpriteFrames:animFrames2 delay:0.1f];
            [heroTrappedSprite runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation2]]];
            heroSprite.visible=NO;
        }
        if(heroTrappedMove!=0){
            int fValue = (forwardChe?heroForwardX:0);
            CGFloat xPos=0;
            if(trappedTypeValue<=3){
                xPos=450;//heroSprite.position.x-(forwardChe?40:-40);
            }
            
            heroTrappedSprite.position = ccp(xPos,heroSprite.position.y-heroTrappedMove);
            CGPoint copyHeroPosition = ccp(heroSprite.position.x-fValue, heroSprite.position.y-heroTrappedMove);
            [self setViewpointCenter:copyHeroPosition];
            if(trappedTypeValue <= 3){
                heroTrappedMove+=1;
                if(heroSprite.position.y-heroTrappedMove<=325)
                    heroTrappedMove=0;
            }
        }
    }
}
-(void)heroWinFunc{
    if (isLevelCompleted) {
        return;
    }
    if(mouseWinChe){
        heroWinCount+=1;
        
        if(heroWinCount==15){
            heroWinSprite = [CCSprite spriteWithSpriteFrameName:@"girl_win1.png"];
            heroWinSprite.scale=0.6;
            if(!forwardChe)
                heroWinSprite.position = ccp(platformX+30, platformY+5);
            else
                heroWinSprite.position = ccp(platformX+30, platformY+5);
            [spriteSheet addChild:heroWinSprite];
            
            NSMutableArray *animFrames2 = [NSMutableArray array];
            for(int i = 0; i < 4; i++) {
                CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"girl_win%d.png",i+1]];
                [animFrames2 addObject:frame];
            }
            CCAnimation *animation2 = [CCAnimation animationWithSpriteFrames:animFrames2 delay:0.1f];
            [heroWinSprite runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation2]]];
            heroSprite.visible=NO;
            if(runningChe){
                heroRunSprite.visible=NO;
                heroSprite.visible=NO;
                runningChe=NO;
            }else if(heroStandChe){
                heroSprite.visible=NO;
                heroStandChe=NO;
            }
        }
        
        if(heroWinCount == 100){
            [self addLevelCompleteLayerToTheScene];
        }
    }
}
-(void) addHudLayerToTheScene{
    hudLayer = [[HudLayer alloc] init];
    hudLayer.tag = 15;
    [gLayer15 addChild: hudLayer z:2000];
    [hudLayer updateNoOfCheeseCollected:0 andMaxValue:[cheeseSetValue[motherLevel-1] intValue]];
}

-(void) addLevelCompleteLayerToTheScene{
    [self levelCompleted :2];
}
-(void)heroJumpingRunning{
    if(heroJumpRunningChe){
        jumpRunDiff2+=2;
        if(jumpRunDiff2>40-gameFunc.jumpDiff){
            gameFunc.jumpDiffChe=NO;
            heroJumpRunningChe=NO;
            jumpRunDiff=0;
            jumpRunDiff2=0;
            heroStandChe=YES;
            runningChe=NO;
            heroRunSprite.visible=NO;
            heroSprite.visible=YES;
        }
    }
}
-(void)heroRunFunc{
    if(runningChe&&!gameFunc.trappedChe){
        if(!forwardChe){
            platformX+=2.2;
            [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
            platformX=gameFunc.xPosition;
        }else{
            platformX-=2.2;
            [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
            platformX=gameFunc.xPosition;
        }
        if(gameFunc.stickyChe){
            heroSprite.visible=YES;
            heroRunSprite.visible=NO;
        }
        if(gameFunc.autoJumpChe){
            jumpPower = 4;
            jumpAngle=(forwardChe?120:20);
            jumpingChe=YES;
            runningChe=NO;
            heroRunSprite.visible=NO;
            heroSprite.visible=YES;
            if(gameFunc.stickyChe){
                gameFunc.stickyChe=NO;
                gameFunc.stickyCount=1;
            }
        }
        
        CGPoint copyHeroPosition = ccp(platformX, platformY);
        heroRunSprite.position=ccp(platformX,platformY);
        [self setViewpointCenter:copyHeroPosition];
        [self heroUpdateForwardPosFunc];
    }
}
-(void)heroAnimationFrameFunc{
    if(heroStandChe){
        [self heroAnimationFunc:heroStandAnimationCount/40 animationType:@"stand"];
        
        if(gameFunc.stickyChe)
            heroSprite.flipY=1;
        
        heroStandAnimationCount+=1;
        if(heroStandAnimationCount>=80){
            heroStandAnimationCount=0;
        }
    }
}

-(void)heroAnimationFunc:(int)fValue animationType:(NSString *)type{
    [self girlAnimationWithType:fValue animationType:type];
    [self heroUpdateForwardPosFunc];
    
    if([type isEqualToString:@"jump"]){
        if(gameFunc.stickyChe){
            heroSprite.flipY=1;
        }
    }
}
-(void)heroUpdateForwardPosFunc{
    
    if(!forwardChe){
        heroSprite.flipX=0;
        heroRunSprite.flipX=0;
        heroSprite.position=ccp(platformX,platformY);
        heroRunSprite.position=ccp(platformX,platformY);
    }else{
        heroSprite.flipX=1;
        heroRunSprite.flipX=1;
        heroSprite.position=ccp(platformX+heroForwardX,platformY);
        heroRunSprite.position=ccp(platformX+heroForwardX,platformY);
    }
}
-(void)heroJumpingFunc{
    if(jumpingChe && !gameFunc.trappedChe){
        if(heroJumpingAnimationArrValue<=5){
            if(heroJumpingAnimationCount==[heroJumpIntervalValue[heroJumpingAnimationArrValue] intValue]){
                if(safetyJumpChe&&heroJumpingAnimationArrValue==3){
                    if(!gameFunc.topHittingCollisionChe)
                        forwardChe=(forwardChe?NO:YES);
                    else
                        forwardChe=(forwardChe?YES:NO);
                    [self heroUpdateForwardPosFunc];
                }
                [self heroAnimationFunc:heroJumpingAnimationArrValue animationType:@"jump"];
                if(heroJumpingAnimationArrValue<=5){
                    heroJumpingAnimationArrValue+=1;
                    heroJumpingAnimationArrValue=(heroJumpingAnimationArrValue>=6?6:heroJumpingAnimationArrValue);
                }
            }
            if(heroJumpingAnimationCount<=10)
                heroJumpingAnimationCount+=1;//(gameFunc.autoJumpChe?5:1);
            
            
        }else{
            CGFloat angle=jumpAngle;
            if(stickyJumpValue==1){
                if(!forwardChe)
                    angle=(angle>10?10:angle);
                else
                    angle=(angle<170?170:angle);
            }
            if(!safetyJumpChe && !gameFunc.autoJumpChe&&!gameFunc.autoJumpChe2&&!gameFunc.minimumJumpingChe&&!gameFunc.topHittingCollisionChe){
                jumpPower = activeVect.Length();
                forwardChe=(angle<90.0?NO:YES);
                [self heroUpdateForwardPosFunc];
            }
            if(gameFunc.minimumJumpingChe)
                jumpPower=1;
            
            jumpPower=(jumpPower>21.0?21.0:jumpPower);
            b2Vec2 impulse = b2Vec2(cosf(angle*3.14/180), sinf(angle*3.14/180));
            impulse *= (jumpPower/2.2);
            
            heroBody->ApplyLinearImpulse(impulse, heroBody->GetWorldCenter());
            
            b2Vec2 velocity = heroBody->GetLinearVelocity();
            impulse *= -1;
            heroBody->ApplyLinearImpulse(impulse, heroBody->GetWorldCenter());
            velocity = b2Vec2(-velocity.x, velocity.y);
            
            b2Vec2 point = [self getTrajectoryPoint:heroBody->GetWorldCenter() andStartVelocity:velocity andSteps:saveDottedPathCount*60 andAngle:angle];
            
            point = b2Vec2(-point.x, point.y);
            
            CGFloat xx=platformX+point.x;
            CGFloat yy=platformY+point.y-(stickyJumpValue==1?15:0);;
            
            if(safetyJumpChe){
                /*  if(motherLevel==2)
                 yy=yy-8;
                 else if(motherLevel==3)
                 yy=yy-12;*/
                
            }
            
            if(gameFunc.autoJumpChe2&&autoJumpValue2==0){
                autoJumpValue2=1;
                [self endJumping:xx yValue:yy+8];
            }else if(gameFunc.autoJumpChe2 && autoJumpValue2>=1){
                autoJumpValue2+=1;
                if(autoJumpValue2>=40){
                    gameFunc.autoJumpChe2=NO;
                    autoJumpValue2=0;
                }
            }
            
            
            [gameFunc jumpingRender:xx yPosition:yy fChe:forwardChe];
            
            if(gameFunc.reverseJump){
                xx=gameFunc.xPosition;
                gameFunc.reverseJump=NO;
                safetyJumpChe=YES;
                [self endJumping:gameFunc.xPosition yValue:gameFunc.yPosition];
            }else if(gameFunc.landingChe){
                yy=gameFunc.yPosition;
                gameFunc.landingChe=NO;
                if(safetyJumpChe){
                    safetyJumpChe=NO;
                    gameFunc.topHittingCollisionChe=NO;
                }
                [self endJumping:gameFunc.xPosition yValue:gameFunc.yPosition];
            }
            
            if(xx>950){
                xx=950;
                safetyJumpChe=YES;
                [self endJumping:xx yValue:yy];
            }else if(xx<(firstRunningChe?-100:3)){
                xx=3;
                safetyJumpChe=YES;
                [self endJumping:xx yValue:yy];
            }else if(yy<[gameFunc getPlatformPosition:motherLevel].y){
                yy=[gameFunc getPlatformPosition:motherLevel].y;
                if(safetyJumpChe){
                    safetyJumpChe=NO;
                    gameFunc.topHittingCollisionChe=NO;
                }
                [self endJumping:xx yValue:yy];
            }
            
            if(backHeroJumpingY>=yy&&heroJumpingAnimationArrValue==6)
                [self heroAnimationFunc:heroJumpingAnimationArrValue animationType:@"jump"];
            
            backHeroJumpingY=yy;
            if(!forwardChe)
                heroSprite.position=ccp(xx,yy);
            else
                heroSprite.position=ccp(xx+heroForwardX,yy);
            
            CGPoint copyHeroPosition = ccp(xx, yy);
            [self setViewpointCenter:copyHeroPosition];
            saveDottedPathCount+=1;
        }
    }
}
-(void)endJumping:(CGFloat)xx yValue:(CGFloat)yy{
    platformX=xx;
    platformY=yy;
    saveDottedPathCount=0;
    jumpingChe=NO;
    landingChe=YES;
    heroJumpingAnimationArrValue=7;
    [self heroAnimationFunc:heroJumpingAnimationArrValue animationType:@"jump"];
    
    if(gameFunc.topHittingCollisionChe&&topHittingCount==0){
        topHittingCount=1;
        jumpAngle=(forwardChe?160:20);
        heroJumpingAnimationCount=18;
        jumpPower = 4;
        if(gameFunc.objectJumpChe){
            gameFunc.objectJumpChe=NO;
            jumpPower=7;
        }
        jumpingChe=YES;
        landingChe=NO;
        heroJumpingAnimationArrValue=6;
        [self heroAnimationFunc:heroJumpingAnimationArrValue animationType:@"jump"];
    }else{
        heroJumpingAnimationCount=11;
        topHittingCount=0;
        gameFunc.topHittingCollisionChe=NO;
    }
    
    
}
-(void)heroLandingFunc{
    if(landingChe){
        if(heroJumpingAnimationCount==[heroJumpIntervalValue[heroJumpingAnimationArrValue] intValue]){
            [self heroAnimationFunc:heroJumpingAnimationArrValue animationType:@"jump"];
            heroJumpingAnimationArrValue+=1;
            heroJumpingAnimationArrValue=(heroJumpingAnimationArrValue>=9?9:heroJumpingAnimationArrValue);
            if(safetyJumpChe&&heroJumpingAnimationArrValue==8){
                if(!gameFunc.topHittingCollisionChe){
                    BOOL localForwardChe=forwardChe;
                    localForwardChe=(localForwardChe?NO:YES);
                    jumpAngle=(localForwardChe?160:20);
                }else{
                    jumpAngle=(forwardChe?160:20);
                }
                heroJumpingAnimationCount=19;
                jumpPower = 4;
                if(gameFunc.objectJumpChe){
                    gameFunc.objectJumpChe=NO;
                    jumpPower=7;
                }
                heroJumpingAnimationArrValue=3;
                jumpingChe=YES;
            }
        }
        heroJumpingAnimationCount+=1;
        if(heroJumpingAnimationCount>18){
            if(!safetyJumpChe){
                heroStandChe=YES;
                heroJumpingAnimationArrValue=0;
                if(gameFunc.jumpDiff<=40&&gameFunc.jumpDiffChe&&!heroJumpRunningChe){
                    heroJumpRunningChe=YES;
                    jumpRunDiff=gameFunc.jumpDiff;
                    heroStandChe=NO;
                    runningChe=YES;
                    heroSprite.visible=NO;
                    heroRunSprite.visible=YES;
                }
            }
            if(gameFunc.autoJumpChe){
                gameFunc.autoJumpChe=NO;
                gameFunc.stickyChe=NO;
            }
            
            if(autoJumpValue2==1&&gameFunc.autoJumpChe2){
                jumpPower = (gameFunc.autoJumpSpeedValue==1?8:5);
                gameFunc.autoJumpSpeedValue=0;
                jumpAngle=(forwardChe?140:20);
                jumpingChe = YES;
                runningChe = NO;
                heroStandChe = NO;
                heroRunSprite.visible = NO;
                heroSprite.visible = YES;
            }else if(autoJumpValue2 == 2&&gameFunc.autoJumpChe2){
                gameFunc.autoJumpChe2=NO;
                
            }
            
            landingChe=NO;
            heroJumpingAnimationCount=0;
            if(gameFunc.visibleWindowChe&&visibleCount==0)
                visibleCount=1;
            
            if(stickyJumpValue==1)
                stickyJumpValue=0;

        }
    }
}

-(void)HeroLiningDraw:(int)cPath{
    
    CGFloat angle=jumpAngle;
    if (heroPimpleSprite[1].position.x == -100) {
        [soundEffect pulling_tail];
    }
    if(!safetyJumpChe){
        jumpPower = activeVect.Length();
        forwardChe=(angle<90.0?NO:YES);
        [self heroUpdateForwardPosFunc];
        
    }
    
    int dValue=0;
    if(gameFunc.stickyChe){
        if(!forwardChe)
            angle=(angle>10?10:angle);
        else
            angle=(angle<170?170:angle);
        dValue=9;
    }
    
    jumpPower=(jumpPower>20.0?20.0:jumpPower);
    b2Vec2 impulse = b2Vec2(cosf(angle*3.14/180), sinf(angle*3.14/180));
    impulse *= (jumpPower/2.2)-0.6;
    
    heroBody->ApplyLinearImpulse(impulse, heroBody->GetWorldCenter());
    
    b2Vec2 velocity = heroBody->GetLinearVelocity();
    impulse *= -1;
    heroBody->ApplyLinearImpulse(impulse, heroBody->GetWorldCenter());
    velocity = b2Vec2(-velocity.x, velocity.y);
    
    for (int i = 0; i < 25&&!safetyJumpChe; i=i+1) {
        b2Vec2 point = [self getTrajectoryPoint:heroBody->GetWorldCenter() andStartVelocity:velocity andSteps:i*170 andAngle:angle];
        point = b2Vec2(-point.x, point.y);
        
        int lValue=(!forwardChe?35:-28);
        CGFloat xx=platformX+point.x+lValue+15;
        CGFloat yy=platformY+point.y+3 -dValue;
        
        heroPimpleSprite[i].position=ccp(xx,yy);
    }
    int y = gameFunc.stickyChe? -11: 11;
    if(!forwardChe)
        mouseDragSprite.position=ccp(platformX,platformY-y);
    else
        mouseDragSprite.position=ccp(platformX+heroForwardX,platformY-y);
    
    mouseDragSprite.rotation=(180-angle)-170;
    mouseDragSprite.scale=MICE_TAIL_SCALE/2+(jumpPower/40.0);
    
    
}

-(b2Vec2) getTrajectoryPoint:(b2Vec2) startingPosition andStartVelocity:(b2Vec2) startingVelocity andSteps: (float)n andAngle:(CGFloat)a {
    
    float t = 1 / 60.0f;
    float lhPtmRatio = 32.0f;
    b2Vec2 gravity2;
    gravity2.Set(0, -10.0f);
    b2Vec2 gravity = gravity2;
    b2Vec2 stepVelocity = t * startingVelocity;
    b2Vec2 gravityForCocos2dWorld = b2Vec2(gravity.x/lhPtmRatio, gravity.y/lhPtmRatio);
    b2Vec2 stepGravity = t * t * gravityForCocos2dWorld;
    
    return startingPosition + n * stepVelocity + 0.5f * (n*n+n) * stepGravity;
}
-(void)setViewpointCenter:(CGPoint) position {
    
    int x = MAX(position.x, winSize.width / 2);
    int y = MAX(position.y, winSize.height / 2);
    x = MIN(x, (_tileMap.mapSize.width * _tileMap.tileSize.width)
            - winSize.width / 2);
    y = MIN(y, (_tileMap.mapSize.height * _tileMap.tileSize.height)
            - winSize.height/2);
    CGPoint actualPosition = ccp(x, y);
    if(x<=winSize.width/2)
        screenHeroPosX=position.x;
    else if(x>=_tileMap.mapSize.width-winSize.width/2)
        screenHeroPosX=(position.x-x)+winSize.width/2;
    if(y<=winSize.height/2)
        screenHeroPosY=position.y;
    else if(y>=_tileMap.mapSize.height-winSize.height/2)
        screenHeroPosY=(position.y-y)+winSize.height/2;
    
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    self.position = ccp(viewPoint.x, viewPoint.y - 15);
    
    
}
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    CGPoint prevLocation = [myTouch previousLocationInView: [myTouch view]];
    prevLocation = [[CCDirector sharedDirector] convertToGL: prevLocation];
    if (knockoutCount == 3) {
        return;
    }
    if(!mouseWinChe&&!heroTrappedChe&&!screenMoveChe){
        
        int forwadeValue=(!forwardChe?0:heroForwardX);
        if(location.x>=screenHeroPosX-60+forwadeValue && location.x <= screenHeroPosX+40+forwadeValue && location.y>screenHeroPosY-30&&location.y<screenHeroPosY+18){
            if(!jumpingChe&&!dragChe&&!runningChe&&heroStandChe){
                
                heroJumpLocationChe=YES;
                dragChe=YES;
                heroStandChe=NO;
                [self heroAnimationFunc:0 animationType:@"jump"];
                mouseDragSprite.visible=YES;
                int y = gameFunc.stickyChe ? -11:11;
                if(!forwardChe){
                    mouseDragSprite.position=ccp(platformX+10,platformY-y);
                    mouseDragSprite.rotation=(180-0)-170;
                }else{
                    mouseDragSprite.rotation=(180-180)-170;
                    mouseDragSprite.position=ccp(platformX-10+heroForwardX,platformY-y);
                }
                startVect = b2Vec2(location.x, location.y);
                activeVect = startVect - b2Vec2(location.x, location.y);
                jumpAngle = fabsf( CC_RADIANS_TO_DEGREES( atan2f(-activeVect.y, activeVect.x)));
            }
        }else{
            if((location.x<70 || location.x>winSize.width-70) && location.y < 70){
                if(!jumpingChe&&!landingChe&&!firstRunningChe){
                    if(!runningChe){
                        if(screenHeroPosX+25<location.x)
                            forwardChe=NO;
                        else
                            forwardChe=YES;
                        heroStandChe=NO;
                        runningChe=YES;
                        heroSprite.visible=NO;
                        heroRunSprite.visible=YES;
                    }
                }
            }
        }
    }
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    if (knockoutCount == 3) {
        return;
    }
    if(!jumpingChe&&!runningChe&&heroJumpLocationChe&&!mouseWinChe&&motherLevel!=1&&!heroTrappedChe&&!screenMoveChe){
        activeVect = startVect - b2Vec2(location.x, location.y);
        jumpAngle = fabsf( CC_RADIANS_TO_DEGREES( atan2f(-activeVect.y, activeVect.x)));
        [self HeroLiningDraw:0];
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    if (knockoutCount == 3) {
        return;
    }

    if(!mouseWinChe&&!heroTrappedChe){
        if(!jumpingChe&&!runningChe&&heroJumpLocationChe&&!screenMoveChe){
            heroJumpLocationChe=NO;
            saveDottedPathCount=0;
            jumpPower = activeVect.Length();
            activeVect = startVect - b2Vec2(location.x, location.y);
            jumpAngle = fabsf( CC_RADIANS_TO_DEGREES( atan2f(-activeVect.y, activeVect.x)));
            jumpingChe=YES;
            dragChe=NO;
            mouseDragSprite.visible=NO;
            for (int i = 0; i < 25; i=i+1) {
                heroPimpleSprite[i].position=ccp(-100,100);
            }
            if(gameFunc.stickyChe){
                gameFunc.stickyChe=NO;
                gameFunc.movePlatformChe=NO;
                stickyJumpValue=1; //bhai
                gameFunc.stickyCount=1;
            }
        }else if(!jumpingChe&&!landingChe&&!firstRunningChe){
            if(runningChe){
                heroStandChe=YES;
                runningChe=NO;
                heroRunSprite.visible=NO;
                heroSprite.visible=YES;
            }
        }
    }
    
}
-(void)clickMenuButton{
    [[CCDirector sharedDirector] replaceScene:[LevelScreen scene]];
}
-(void)clickLevel:(CCMenuItem *)sender {
    if(sender.tag == 1){
        [[CCDirector sharedDirector] replaceScene:[GirlMouseEngine02 scene]];
        //        [self respwanTheMice];
    }else if(sender.tag ==2){
        [[CCDirector sharedDirector] replaceScene:[LevelScreen scene]];
    }
}

-(void ) respwanTheMice{
    gameFunc.trappedChe = NO;
    safetyJumpChe = YES;
    [FTMUtil sharedInstance].isRespawnMice = YES;
    menu2.visible=NO;
    mouseTrappedBackground.visible=NO;
    runningChe = NO;
    heroTrappedSprite.visible = NO;
    [self endJumping:(platformX + gameFunc.xPosition)/2 yValue:gameFunc.yPosition];
    [self schedule:@selector(startRespawnTimer) interval:2];
}

-(void) startRespawnTimer{
    [self unschedule:@selector(startRespawnTimer)];
    if ([FTMUtil sharedInstance].isRespawnMice) {
        [FTMUtil sharedInstance].isRespawnMice = NO;
        heroTrappedChe = NO;
        heroTrappedCount = 0;
    }
}

-(void) createExplosionX: (float) x y: (float) y {
    [self removeChild:cheeseEmitter cleanup:YES];
    cheeseEmitter = [CCParticleSun node];
    [self addChild:cheeseEmitter ];
    cheeseEmitter.texture = [[CCTextureCache sharedTextureCache] addImage: @"Cheese.png"];
    cheeseEmitter.position=ccp(x,y);
    cheeseEmitter.duration = 0.1f;
    cheeseEmitter.lifeVar = 0.3f;
    
    
    if(screenHeroPosX>=240&&screenHeroPosX<=760){
        if(!forwardChe){
            cheeseEmitter.life = 0.2f;
            cheeseEmitter.angleVar=-50.0;
            cheeseEmitter.angle=-180;
            cheeseEmitter.speed=90;
            cheeseEmitter.speedVar =50;
            cheeseEmitter.startSize=20.5;
            cheeseEmitter.endSize=2.2;
        }else{
            cheeseEmitter.life = 0.2f;
            cheeseEmitter.angleVar=50.0;
            cheeseEmitter.angle=180;
            cheeseEmitter.speed=-70;
            cheeseEmitter.speedVar =-50;
            cheeseEmitter.startSize=20.5;
            cheeseEmitter.endSize=2.2;
        }
    }else{
        if(!forwardChe){
            cheeseEmitter.life = 0.5f;
            cheeseEmitter.angleVar=-50.0;
            cheeseEmitter.angle=-180;
            cheeseEmitter.speed=20;
            cheeseEmitter.speedVar =30;
            cheeseEmitter.startSize=10.5;
            cheeseEmitter.endSize=2.2;
        }else{
            cheeseEmitter.life = 0.5f;
            cheeseEmitter.angleVar=50.0;
            cheeseEmitter.angle=180;
            cheeseEmitter.speed=-20;
            cheeseEmitter.speedVar =-30;
            cheeseEmitter.startSize=10.5;
            cheeseEmitter.endSize=2.2;
        }
    }
    ccColor4F startColor = {0.8f, 0.7f, 0.3f, 1.0f};
    cheeseEmitter.startColor = startColor;
}


-(void) dealloc {
    [super dealloc];
}

@end
