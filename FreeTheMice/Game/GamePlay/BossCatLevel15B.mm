//
//  BossCatLevel15B.m
//  FreeTheMice
//
//  Created by Muhammad Kamran on 27/11/2013.
//
//

#import "BossCatLevel15B.h"
#import "FTMConstants.h"
#import "FTMUtil.h"

#import "GirlMouseEngine02.h"
#import "LevelScreen.h"
#import "StrongGameFunc.h"
// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "LoadingLayer.h"
#import "BossCatLevel15C.h"
#import "DB.h"


enum {
    kTagParentNode = 1,
};

GirlMouseEngineMenu15B *gLayer15b;

@implementation GirlMouseEngineMenu15B


-(id) init {
    if( (self=[super init])) {
    }
    return self;
}
@end

@implementation BossCatLevel15B

@synthesize tileMap = _tileMap;
@synthesize background = _background;

+(CCScene *) scene {
    CCScene *scene = [CCScene node];
    gLayer15b = [GirlMouseEngineMenu15B node];
    [scene addChild:gLayer15b z:1];
    
    BossCatLevel15B *layer = [BossCatLevel15B node];
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
        
        gameFunc=[[StrongGameFunc alloc] init];
        soundEffect=[[sound alloc] init];
        [self initValue];
        gameFunc.gameLevel=motherLevel;
        
        winSize = [CCDirector sharedDirector].winSize;
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
        
        
        
        for(int i=0;i<20;i++){
            heroPimpleSprite[i]=[CCSprite spriteWithFile:@"dotted.png"];
            heroPimpleSprite[i].position=ccp(-100,160);
            heroPimpleSprite[i].scale = 0.3;
            if (![FTMUtil sharedInstance].isRetinaDisplay) {
                heroPimpleSprite[i].scale = 0.15;
            }
            [self addChild:heroPimpleSprite[i] z:10];
        }
        
        cache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [cache addSpriteFramesWithFile:@"strong0_default.plist"];
        [cache addSpriteFramesWithFile:@"bossCatWalk.plist"];
        [cache addSpriteFramesWithFile:@"bossCatKnocked.plist"];
        [cache addSpriteFramesWithFile:@"bossCatTurn.plist"];
        [cache addSpriteFramesWithFile:@"electricity_anim1.plist"];
        [cache addSpriteFramesWithFile:@"electricity_anim2.plist"];
        [cache addSpriteFramesWithFile:@"motherCageAnim.plist"];
        [cache addSpriteFramesWithFile:@"keyAnimation.plist"];
        [cache addSpriteFramesWithFile:@"mother_mouse_default.plist"];
        [cache addSpriteFramesWithFile:@"boxAnim.plist"];
        
        spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"strong0_default.png"];
        bossCatWalkBatch = [CCSpriteBatchNode batchNodeWithFile:@"bossCatWalk.png"];
        
        [self addChild:spriteSheet z:10];
        [self addChild:bossCatWalkBatch z:10];
        
        // boss cat Animations
        CCSpriteBatchNode *bossCatKnockedBatch = [CCSpriteBatchNode batchNodeWithFile:@"bossCatKnocked.png"];
        
        [self addChild:bossCatKnockedBatch];
        CCSpriteBatchNode *motherBatch = [CCSpriteBatchNode batchNodeWithFile:@"mother_mouse_default.png"];
        
        [self addChild:motherBatch];
        
        motherMouse = [CCSprite spriteWithSpriteFrameName:@"mother_run01.png"];
        motherMouse.position = ccp(200, 200);
        motherMouse.scale = MAMA_SCALE;
        motherMouse.visible = NO;
        [motherBatch addChild:motherMouse];
        
        NSMutableArray *animFrames = [NSMutableArray array];
        for(int i = 1; i < 8; i++) {
            CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"mother_run0%d.png",i]];
            [animFrames addObject:frame];
        }
        CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.06f];
        [motherMouse runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation]]];
        
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
        
        bossCatWalk = [CCSprite spriteWithSpriteFrameName:@"boss_cat_walk_0.png"];
        bossCatWalk.position = ccp(200, 274);
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

        //
        [self makeCageAnimation];
        [self addStrongMouseRunningSprite];
        [self addStrongMousePushingSprite];
        
        mouseDragSprite=[CCSprite spriteWithFile:@"mouse_drag.png"];
        mouseDragSprite.position=ccp(platformX +2,platformY+3);
        mouseDragSprite.scale=MICE_TAIL_SCALE;
        mouseDragSprite.visible=NO;
        mouseDragSprite.anchorPoint=ccp(0.99f, 0.9f);
        [self addChild:mouseDragSprite z:9];
        
        [self heroAnimationFunc:0 animationType:@"stand"];
        heroSprite.visible=NO;
        
        for(int i=0;i<3;i++){
            boxSprite[i]=[CCSprite spriteWithSpriteFrameName:@"box_sprite_0.png"];
            if(i==0){
                boxSprite[i].position=ccp(210,396);
            }
            else if(i==1){
                boxSprite[i].position=ccp(320,396);
            }
            else if(i==2){
                boxSprite[i].position=ccp(570,396);
            }
    
            blocksPosiotionsArr[i] = boxSprite[i].position;
            boxSprite[i].scale = 0.56;
            if (![FTMUtil sharedInstance].isRetinaDisplay) {
                boxSprite[i].scale = 0.28;
            }
            [self addChild:boxSprite[i] z:1];
        }
        
        CCSprite *platformSprite=[CCSprite spriteWithFile:@"move_platform3.png"];
        platformSprite.position = ccp(250,363);
        platformSprite.scaleX = 1.25;
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            platformSprite.scaleX = 0.625;
            platformSprite.scaleY = NON_RETINA_SCALE;
        }
        [self addChild:platformSprite z:1];
        
        platformSprite=[CCSprite spriteWithFile:@"move_platform3.png"];
        platformSprite.position=ccp(570,363);
        platformSprite.scaleX = 1.25;
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            platformSprite.scaleX = 0.625;
            platformSprite.scaleY = NON_RETINA_SCALE;
        }
        [self addChild:platformSprite z:1];

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

        [self HeroDrawing];
        
        dotSprite=[CCSprite spriteWithFile:@"dotted.png"];
        dotSprite.position=ccp(745,620);
        dotSprite.scale=0.2;
        [self addChild:dotSprite z:10];
        [self addHudLayerToTheScene];
        [self moveElectricitySpriteLeft];
        [self moveElectricitySpriteRight];
        [self scheduleUpdate];
        
        
    }
    return self;
}

-(void) makeKeyAnimation{
    DB *db = [DB new];
    int currentLvl = [[db getSettingsFor:@"girlCurrLvl"] intValue];
    if(currentLvl <= 17){
        [db setSettingsFor:@"CurrentLevel" withValue:[NSString stringWithFormat:@"%d", 17]];
        [db setSettingsFor:@"girlCurrLvl" withValue:[NSString stringWithFormat:@"%d", 17]];
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
    CGPoint point = CGPointMake(930, 478);
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
    CCMoveTo *move2 = [CCMoveTo actionWithDuration:2 position:CGPointMake(914, 385)];
    CCSequence *seq2 = [CCSequence actions:delay,move2,animationDone, nil];
    CCAnimation *cageAnim = [CCAnimation animationWithSpriteFrames:cageFrames delay:0.05f];
    [girlCage runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:cageAnim]]];
    [girlCage runAction:seq2];
}

-(void) keyAnimationDone{
    girlKeyBatch.visible = NO;
    girlCageBatch.visible = NO;
    motherMouse.position = ccp(914, 390);
    CCMoveTo *move = [CCMoveTo actionWithDuration:0.5 position:CGPointMake(980, 390)];
    CCCallFunc *animationDone = [CCCallFunc actionWithTarget:self selector:@selector(strongMouseMoveDone)];
    CCSequence *seq = [CCSequence actions:move, animationDone, nil];
    motherMouse.visible = YES;
    [motherMouse runAction:seq];
}

-(void) strongMouseMoveDone{
    [FTMUtil sharedInstance].mouseClicked = FTM_MAMA_MICE_ID;
    [[CCDirector sharedDirector] replaceScene:[LoadingLayer scene:17 currentMice:FTM_MAMA_MICE_ID]];
}

-(void) makeCageAnimation{
    girlCageBatch = [CCSpriteBatchNode batchNodeWithFile:@"motherCageAnim.png"];
    [self addChild:girlCageBatch];
    
    CCSprite *girlCage = [CCSprite spriteWithSpriteFrameName:@"mm_cage_0.png"];
    girlCage.position = ccp(930, 478);
    girlCage.visible = YES;
    if (![FTMUtil sharedInstance].isRetinaDisplay) {
        girlCage.scale = NON_RETINA_SCALE;
    }
    [girlCageBatch addChild:girlCage];
    
    NSMutableArray *cageFrames = [NSMutableArray array];
    for(int i = 0; i <= 27; i++) {
        CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"mm_cage_%d.png",i]];
        [cageFrames addObject:frame];
    }
    CCAnimation *cageAnim = [CCAnimation animationWithSpriteFrames:cageFrames delay:0.05f];
    [girlCage runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:cageAnim]]];
}
-(void) moveElectricitySpriteLeft{

    wavesSprite = [CCSprite spriteWithSpriteFrameName:@"moving_electricity_0.png"];
    wavesSprite.position = ccp(400, 373);
    wavesSprite.scaleX = 1.7;
    wavesSprite.scaleY = 2.4;
    if (![FTMUtil sharedInstance].isRetinaDisplay) {
        wavesSprite.scaleX = 0.85;
        wavesSprite.scaleY = 1.2;
    }
    [self addChild:wavesSprite z:9999];
    
    NSMutableArray *frameArr1 = [NSMutableArray array];
    for(int i = 0; i <= 35; i++) {
        CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"moving_electricity_%d.png",i]];
        [frameArr1 addObject:frame];
    }
    CCAnimation *animation1 = [CCAnimation animationWithSpriteFrames:frameArr1 delay:0.03f];
    CCAnimate *anim1 = [CCAnimate actionWithAnimation:animation1];
    
    NSMutableArray *frameArr2 = [NSMutableArray array];
    for(int i = 36; i <= 70; i++) {
        CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"moving_electricity_%d.png",i]];
        [frameArr2 addObject:frame];
    }
    CCAnimation *animation2 = [CCAnimation animationWithSpriteFrames:frameArr2 delay:0.03f];
    CCAnimate *anim2 = [CCAnimate actionWithAnimation:animation2];
    CCCallFunc *animationDone = [CCCallFunc actionWithTarget:self selector:@selector(electricSpriteMovedLeftDone)];
    CCCallFunc *animationDone2 = [CCCallFunc actionWithTarget:self selector:@selector(electricSpriteMovedLeftAgain)];
    CCSequence *seq11 = [CCSequence actions:anim1,anim2, nil];
    CCDelayTime *delay = [CCDelayTime actionWithDuration:5];
    [wavesSprite runAction:[CCRepeatForever actionWithAction: seq11]];
    CCMoveTo *move1 = [CCMoveTo actionWithDuration:1.2 position:CGPointMake(165, 373)];
    
    CCSequence *seq1 = [CCSequence actions:move1, animationDone,delay,animationDone2, nil];
    [wavesSprite runAction: seq1];
}

-(void) moveElectricitySpriteRight{

    wavesSprite2 = [CCSprite spriteWithSpriteFrameName:@"moving_electricity_0.png"];
    wavesSprite2.position = ccp(400, 373);
    wavesSprite2.scaleX = 1.7;
    wavesSprite2.scaleY = 2.4;
    if (![FTMUtil sharedInstance].isRetinaDisplay) {
        wavesSprite2.scaleX = 0.85;
        wavesSprite2.scaleY = 1.2;
    }
    wavesSprite2.flipX=1;
    [self addChild:wavesSprite2 z:9999];
    
    NSMutableArray *frameArr1 = [NSMutableArray array];
    for(int i = 0; i <= 35; i++) {
        CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"moving_electricity_%d.png",i]];
        [frameArr1 addObject:frame];
    }
    CCAnimation *animation1 = [CCAnimation animationWithSpriteFrames:frameArr1 delay:0.03f];
    CCAnimate *anim1 = [CCAnimate actionWithAnimation:animation1];
    
    NSMutableArray *frameArr2 = [NSMutableArray array];
    for(int i = 36; i <= 70; i++) {
        CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"moving_electricity_%d.png",i]];
        [frameArr2 addObject:frame];
    }
    
    CCAnimation *animation2 = [CCAnimation animationWithSpriteFrames:frameArr2 delay:0.03f];
    CCAnimate *anim2 = [CCAnimate actionWithAnimation:animation2];
    CCCallFunc *animationDone = [CCCallFunc actionWithTarget:self selector:@selector(electricSpriteMovedRightDone)];
    CCCallFunc *animationDone2 = [CCCallFunc actionWithTarget:self selector:@selector(electricSpriteMovedRightAgain)];
    CCSequence *seq12 = [CCSequence actions:anim1,anim2, nil];

    CCDelayTime *delay = [CCDelayTime actionWithDuration:5];
    [wavesSprite2 runAction:[CCRepeatForever actionWithAction: seq12]];
    CCMoveTo *move2 = [CCMoveTo actionWithDuration:1.2 position:CGPointMake(645, 373)];
    CCSequence *seq2 = [CCSequence actions:move2, animationDone,delay,animationDone2, nil];
    
    [wavesSprite2 runAction: seq2];
}
-(void) electricSpriteMovedLeftDone{
    wavesSprite.visible = NO;
}
-(void) electricSpriteMovedRightDone{
    wavesSprite2.visible = NO;
}
-(void) electricSpriteMovedLeftAgain{
    [wavesSprite stopAllActions];
    [self removeChild:wavesSprite cleanup:YES];
    [self moveElectricitySpriteLeft];
}
-(void) electricSpriteMovedRightAgain{
    [wavesSprite2 stopAllActions];
    [self removeChild:wavesSprite2 cleanup:YES];
    [self moveElectricitySpriteRight];
}
-(void) addHudLayerToTheScene{
    hudLayer = [[HudLayer alloc] init];
    hudLayer.tag = 15;
    [gLayer15b addChild: hudLayer z:2000];
    [hudLayer updateNoOfCheeseCollected:0 andMaxValue:[cheeseSetValue[motherLevel-1] intValue]];
}

-(void) addLevelCompleteLayerToTheScene{
    [self levelCompleted :2];
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
        if (knockoutCount == 3) {
            [self makeKeyAnimation];
        }
        [bossCatTurn runAction: animSeq];
        
    }
}

-(void) catTurnAnimationDone{
    isTurnAnimation = NO;
    bossCatTurn.visible = NO;
    if (!isCatKnockedOut) {
        bossCatWalk.visible = YES;
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
    }
}
-(void) checkCatCollision{
    
    if (knockoutCount == 3 || heroTrappedChe) {
        // cat is knocked out.
        return;
        
    }
    CGRect catRect;
    if (bossCatWalk.flipX == 0) {
        catRect = CGRectMake(bossCatWalk.position.x, bossCatWalk.position.y, bossCatWalk.contentSize.width* 0.3, 5);
    }else{
        catRect = CGRectMake(bossCatWalk.position.x, bossCatWalk.position.y, bossCatWalk.contentSize.width* 0.3, 5);
    }
    for (int i = 0; i < 3; i++) {
        CGRect heroRect = CGRectMake(heroSprite.position.x, heroSprite.position.y, heroSprite.contentSize.width *STRONG_SCALE, heroSprite.contentSize.height/2);
        CGRect electricity1Rect = CGRectMake(wavesSprite.position.x, wavesSprite.position.y, wavesSprite.contentSize.width *wavesSprite.scaleX, wavesSprite.contentSize.height*wavesSprite.scaleY);
        CGRect electricity2Rect = CGRectMake(wavesSprite2.position.x, wavesSprite2.position.y, wavesSprite2.contentSize.width *wavesSprite2.scaleX, heroSprite.contentSize.height*wavesSprite2.scaleY);
        
        int boxX = boxSprite[i].position.x;
        int boxY = boxSprite[i].position.y;
        int catX = bossCatWalk.position.x;
//        if (bossCatWalk.flipX == 1) {
            catX = catX+40;
//        }
        int catY = bossCatWalk.position.y;
        if (![FTMUtil sharedInstance].isInvincibilityOn && !isCatKnockedOut && (!CGRectIsNull(CGRectIntersection(catRect, heroRect)))) {
            gameFunc.trappedChe = YES;
            heroTrappedChe=YES;
            heroSprite.visible=NO;
            heroStandChe=NO;
            heroRunSprite.visible=NO;
            [self schedule:@selector(addLevelFailureScreen) interval:1.2];
        }
        else if (!CGRectIsNull(CGRectIntersection(electricity1Rect, heroRect)) || !CGRectIsNull(CGRectIntersection(electricity2Rect, heroRect))){
            if (![FTMUtil sharedInstance].isInvincibilityOn && (wavesSprite.visible || wavesSprite2.visible)) {
                gameFunc.trappedChe = YES;
                heroTrappedChe=YES;
                heroSprite.visible=NO;
                heroStandChe=NO;
                heroRunSprite.visible=NO;
                [self schedule:@selector(addLevelFailureScreen) interval:1.2];
            }
        }
        else if (!isCatKnockedOut) {
            if (boxX > (catX - 60) && boxX < catX  && boxY > (catY +10) && boxY < (catY + 20) )  {
            knockoutCount ++;
            isCatKnockedOut = YES;
            boxSprite[i].visible = NO;
            bossCatWalk.visible = NO;
            bossCatTurn.visible = NO;
            bossCatKnocked.visible = YES;
            [self makeCatKnockedAnimation];
            }
        }
    }
}

-(void) moveMiceAndPlatform{
    heroSprite.visible = YES;
    
    CCCallFunc *animationDone = [CCCallFunc actionWithTarget:self selector:@selector(miceMoveMentDone)];
    CGPoint point;
    if (!forwardChe) {
        point = CGPointMake(heroSprite.position.x + 130, 264);
    }else{
        point = CGPointMake(heroSprite.position.x  - 130 - heroForwardX, 264);
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
        bossCatWalk.flipX = 1;
        bossCatDirection = 1;
        isTurnAnimation = YES;
        [self makeCatTurnAnimation];
    }else if(bossCatDirection == 1 && bossCatWalk.position.x < 150){
        bossCatWalk.visible = NO;
        bossCatDirection = 0;
        bossCatWalk.flipX = 0;
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
    motherLevel=15;
    
    cheeseCount=[cheeseSetValue[motherLevel-1] intValue];
    
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
    heroForwardX=56;
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
    [self moveBossCatLeftAndRight];
    [self checkCatCollision];
    gameFunc.runChe=runningChe;
    [gameFunc render];
    
}

-(void)switchFunc{
    
    if (gameFunc.trappedChe) {
        heroRunSprite.visible = NO;
        heroPushSprite.visible = NO;
        heroSprite.visible = NO;
        heroStandChe = YES;
        jumpingChe = NO;
        runningChe = NO;
    }
    
}

-(void) addLevelFailureScreen{
    [self unschedule:@selector(addLevelFailureScreen)];
    [self showLevelFailedUI:motherLevel];
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
                
                //                starSprite[i].position=ccp([gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].x-12+cheeseX2,[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].y+8+cheeseY2);
            }
            
            int mValue=0;
            int mValue2=0;
            if(i==0){
                mValue=gameFunc.stoolCount;
                //                starSprite[i].position=ccp([gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].x-12+cheeseX2+mValue,[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].y+8+cheeseY2);
                mValue=-mValue;
            }
            if(i==4){
                mValue2=cheeseFallCount;
                //                starSprite[i].position=ccp([gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].x-12+cheeseX2,[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].y+8+cheeseY2-mValue2);
                mValue2=-mValue2;
            }
            
            cheeseAnimationCount+=2;
            cheeseAnimationCount=(cheeseAnimationCount>=500?0:cheeseAnimationCount);
            CGFloat localCheeseAnimationCount=0;
            localCheeseAnimationCount=(cheeseAnimationCount<=250?cheeseAnimationCount:250-(cheeseAnimationCount-250));
            cheeseSprite2[i].opacity=localCheeseAnimationCount/4;
            
            CGFloat cheeseX=[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].x;
            CGFloat cheeseY=[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].y;
            BOOL ch2=YES;
            if(i==2){
                if(gameFunc.honeyPotCount2==67){
                    ch2=NO;
                    //                    starSprite[2].visible=NO;
                }
                cheeseSprite[2].zOrder=0;
                cheeseSprite2[2].zOrder=0;
            }
            
            if(!forwardChe){
                if(heroX>=cheeseX-70-mValue &&heroX<=cheeseX+10-mValue&&heroY>cheeseY-20+mValue2&&heroY<cheeseY+30+mValue2&&ch2){
                    [soundEffect cheeseCollectedSound];
                    cheeseCollectedChe[i]=NO;
                    cheeseSprite[i].visible=NO;
                    cheeseSprite2[i].visible=NO;
                    cheeseCollectedScore+=1;
                    //                    starSprite[i].visible=NO;
                    
                    [hudLayer updateNoOfCheeseCollected:cheeseCollectedScore andMaxValue:[cheeseSetValue[motherLevel-1] intValue]];
                    [self createExplosionX:cheeseX-mValue y:cheeseY+mValue2];
                    break;
                }
            }else{
                if(heroX>=cheeseX-10-mValue &&heroX<=cheeseX+70-mValue&&heroY>cheeseY-20+mValue2&&heroY<cheeseY+30+mValue2&&ch2){
                    [soundEffect cheeseCollectedSound];
                    cheeseCollectedChe[i]=NO;
                    cheeseSprite[i].visible=NO;
                    cheeseSprite2[i].visible=NO;
                    cheeseCollectedScore+=1;
                    //                    starSprite[i].visible=NO;
                    
                    [hudLayer updateNoOfCheeseCollected:cheeseCollectedScore andMaxValue:[cheeseSetValue[motherLevel-1] intValue]];
                    [self createExplosionX:cheeseX-mValue y:cheeseY+mValue2];
                    break;
                }
            }
        }else{
            //            starSprite[i].visible=NO;
        }
    }
}

-(void)heroTrappedFunc{
    
    if(heroTrappedChe){
        heroTrappedCount+=1;
        heroTrappedCount+=1;
        if(heroTrappedCount==10){
            for (int i = 0; i < 20; i=i+1){
                heroPimpleSprite[i].position=ccp(-100,100);
            }
            
            heroTrappedMove=1;
            
            mouseDragSprite.visible = NO;
            heroTrappedSprite = [CCSprite spriteWithFile:@"sm_mist_0.png"];
            if(!forwardChe){
                heroTrappedSprite.position = ccp(heroRunSprite.position.x, heroRunSprite.position.y+5);
            }
            else{
                heroTrappedSprite.position = ccp(heroRunSprite.position.x+heroForwardX, heroRunSprite.position.y+5);
            }
            if (![FTMUtil sharedInstance].isRetinaDisplay) {
                heroTrappedSprite.scale = 0.5;
            }
            
            [self addChild:heroTrappedSprite z:99999];
            heroSprite.visible=NO;
        }
    }
}
-(void)heroWinFunc{
    if (isLevelCompleted) {
        return;
    }
    
    if(mouseWinChe){
        heroWinCount+=1;
        if (heroWinCount <2) {
            DB *db = [DB new];
            int currentLvl = [[db getSettingsFor:@"strongCurrLvl"] intValue];
            if(currentLvl <= motherLevel){
                [db setSettingsFor:@"CurrentLevel" withValue:[NSString stringWithFormat:@"%d", motherLevel+1]];
                [db setSettingsFor:@"strongCurrLvl" withValue:[NSString stringWithFormat:@"%d", motherLevel+1]];
            }
            [db release];
        }
        
        if(heroWinCount==15){
            heroWinSprite = [CCSprite spriteWithSpriteFrameName:@"strong_win1.png"];
            heroWinSprite.scale = STRONG_SCALE;
            if(!forwardChe)
                heroWinSprite.position = ccp(platformX+30, platformY+5);
            else
                heroWinSprite.position = ccp(platformX+30, platformY+5);
            [spriteSheet addChild:heroWinSprite];
            
            NSMutableArray *animFrames2 = [NSMutableArray array];
            for(int i = 0; i < 27; i++) {
                CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"strong_win%d.png",i+1]];
                [animFrames2 addObject:frame];
            }
            CCAnimation *animation2 = [CCAnimation animationWithSpriteFrames:animFrames2 delay:0.05f];
            [heroWinSprite runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation2]]];
            //            [self addLevelCompleteLayerToTheScene];
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

-(void) checkMiceCollisionWithBox :(CGFloat) previousX{
    
    CGFloat forwarOffset = 2.2;
    if (forwardChe) {
        forwarOffset = -2.2;
    }
    if (shouldCheckCollision && !gameFunc.autoJumpChe && previousX == platformX && previousX > 20 && previousX < 890) {
        isPushing = YES;
        CGFloat widthScale = 1;
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            widthScale = 0.5;
        }
        CGRect box0Rect = CGRectMake(boxSprite[0].position.x, boxSprite[0].position.y, 82* widthScale, 76* 0.3);
        CGRect box1Rect = CGRectMake(boxSprite[1].position.x, boxSprite[1].position.y, 82* widthScale, 76* 0.3);
        CGRect box2Rect = CGRectMake(boxSprite[2].position.x, boxSprite[2].position.y, 82* widthScale, 76* 0.3);
        for (int i =0; i<3; i++) {
            CGRect boxRect = CGRectMake(boxSprite[i].position.x, boxSprite[i].position.y, 82*widthScale, 82* 0.3);
            if (i == 0) {
                if (!CGRectIsNull(CGRectIntersection(box0Rect, box1Rect))){
                    boxSprite[0].tag = 1111;
                    boxSprite[1].tag = 1111;
                }else if(!CGRectIsNull(CGRectIntersection(box0Rect, box2Rect))){
                    boxSprite[0].tag = 1111;
                    boxSprite[2].tag = 1111;
                }
            }else if(i == 1){
                if (!CGRectIsNull(CGRectIntersection(box1Rect, box2Rect))){
                    boxSprite[1].tag = 1111;
                    boxSprite[2].tag = 1111;
                }else if ( !CGRectIsNull(CGRectIntersection(box1Rect, box0Rect))) {
                    boxSprite[0].tag = 1111;
                    boxSprite[1].tag = 1111;
                }
            }else if (i == 2){
                if (!CGRectIsNull(CGRectIntersection(box2Rect, box1Rect))){
                    boxSprite[2].tag = 1111;
                    boxSprite[1].tag = 1111;
                }else if ( !CGRectIsNull(CGRectIntersection(box2Rect, box0Rect))) {
                    boxSprite[2].tag = 1111;
                    boxSprite[0].tag = 1111;
                }
            }
            CGRect heroRect;
            if (!forwardChe) {
                heroRect = CGRectMake(heroRunSprite.position.x, heroRunSprite.position.y, heroRunSprite.contentSize.width* STRONG_SCALE, heroRunSprite.contentSize.height* 0.3);
            }else{
                int offsetX = 38;
                if (![FTMUtil sharedInstance].isRetinaDisplay) {
                    offsetX = 38;
                }
                heroRect = CGRectMake(heroRunSprite.position.x - offsetX, heroRunSprite.position.y, heroRunSprite.contentSize.width* STRONG_SCALE, heroRunSprite.contentSize.height* 0.3);
            }
            if (!CGRectIsNull(CGRectIntersection(boxRect, heroRect)) && boxSprite[i].tag != 1111) {
                platformX+=forwarOffset;
                blocksPosiotionsArr[i] = ccp(blocksPosiotionsArr[i].x +forwarOffset, blocksPosiotionsArr[i].y);
                boxSprite[i].position = blocksPosiotionsArr[i];
                if (boxSprite[i].visible && boxSprite[i].position.y > 278) {
                    if ((boxSprite[i].position.x < 420 && (boxSprite[i].position.x < 110 ||  boxSprite[i].position.x > 390)) || (boxSprite[i].position.x > 390 && (boxSprite[i].position.x < 440 || boxSprite[i].position.x > 710)) ) {
                        CCMoveTo *moveDown = [CCMoveTo actionWithDuration:1 position:CGPointMake(boxSprite[i].position.x, 268)];
                        CCCallFuncN *animationDone = [CCCallFuncN actionWithTarget:self selector:@selector(blockMovementDone:)];
                        blocksPosiotionsArr[i] = ccp(boxSprite[i].position.x, 268);
                        
                        NSMutableArray *catKnockedFrames = [NSMutableArray array];
                        for(int i = 0; i <= 16; i++) {
                            CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"box_sprite_%d.png",i]];
                            [catKnockedFrames addObject:frame];
                        }
                        CCAnimation *catKnockedAnim1 = [CCAnimation animationWithSpriteFrames:catKnockedFrames delay:0.04f];
                        CCAnimate *animation1 = [CCAnimate actionWithAnimation:catKnockedAnim1];

                        
                        CCSequence *seq = [CCSequence actions:moveDown, animation1, animationDone, nil];
                        [boxSprite[i] runAction:seq];
                        heroPushSprite.visible = NO;
                        heroRunSprite.visible = YES;
                        isMiceMoving = YES;
                        isPushing = NO;
                    }
                }
                break;
            }
        }
        
        platformX=gameFunc.xPosition;
    }
    
}

-(void) blockMovementDone:(id) sender{
    CCSprite *boximage = (CCSprite*)sender;
    boximage.visible = NO;
    isMiceMoving = NO;
}
-(void)heroRunFunc{
    if(runningChe){
        CGFloat previousX = platformX;
        if(!forwardChe){
            platformX+=2.2;
            [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
            for (int i =0; i<3; i++) {
                BOOL isCollision = NO;
                if (boxSprite[i].tag == 1111) {
                    isCollision = YES;
                }
                if (boxSprite[i].visible && (!isMiceMoving || boxSprite[i].position.y > 390)) {
                    [gameFunc runningRenderLevel15B:platformX yPosition:platformY  fChe:forwardChe blockPositionsArr:blocksPosiotionsArr[i] isBlockCollide:isCollision];
                }
            }
            
            platformX=gameFunc.xPosition;
            [self checkMiceCollisionWithBox:previousX];
            
        }else{
            platformX-=2.2;
            [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
            for (int i =0; i<3; i++) {
                BOOL isCollision = NO;
                if (boxSprite[i].tag == 1111) {
                    isCollision = YES;
                }
                if (boxSprite[i].visible && (!isMiceMoving || boxSprite[i].position.y > 390)) {
                    [gameFunc runningRenderLevel15B:platformX yPosition:platformY  fChe:forwardChe blockPositionsArr:blocksPosiotionsArr[i] isBlockCollide:isCollision];
                }
            }
            platformX=gameFunc.xPosition;
            [self checkMiceCollisionWithBox:previousX];
        }
        if(gameFunc.autoJumpChe){
            jumpPower = 6;
            jumpAngle=(forwardChe?120:20);
            jumpingChe=YES;
            runningChe=NO;
            heroRunSprite.visible=NO;
            heroSprite.visible=YES;
        }
        
        CGPoint copyHeroPosition = ccp(platformX, platformY);
        heroRunSprite.position=ccp(platformX,platformY+2);
        [self setViewpointCenter:copyHeroPosition];
        [self heroUpdateForwardPosFunc];
        if(isPushing && !isMiceMoving){//Bhai  if(gameFunc.pushChe){
            if(!forwardChe)
                heroPushSprite.position=ccp(heroSprite.position.x+10,heroSprite.position.y);
            else
                heroPushSprite.position=ccp(heroSprite.position.x-10,heroSprite.position.y);
            
            heroRunSprite.visible=NO;
            if (!heroPushSprite.visible) {
                [soundEffect pushing];
            }else if (arc4random() % 20 == 1){
                [soundEffect pushing];
            }
            heroPushSprite.visible=YES;
            
        }
    }
}
-(void)heroAnimationFrameFunc{
    if(heroStandChe){
        [self heroAnimationFunc:heroStandAnimationCount/40 animationType:@"stand"];
        heroStandAnimationCount+=1;
        if(heroStandAnimationCount>=80){
            heroStandAnimationCount=0;
        }
    }
}

-(void)heroAnimationFunc:(int)fValue animationType:(NSString *)type{
    [self updateAnimationOnCurrentType:fValue animationType:type];
    [self heroUpdateForwardPosFunc];
}
-(void)heroUpdateForwardPosFunc{
    
    if(!forwardChe){
        heroSprite.flipX=0;
        heroRunSprite.flipX=0;
        heroPushSprite.flipX=0;
        heroSprite.position=ccp(platformX,platformY);
        heroRunSprite.position=ccp(platformX,platformY+2);
        heroPushSprite.position=ccp(platformX,platformY+2);
    }else{
        heroSprite.flipX=1;
        heroRunSprite.flipX=1;
        heroPushSprite.flipX=1;
        heroSprite.position=ccp(platformX+heroForwardX,platformY);
        heroRunSprite.position=ccp(platformX+heroForwardX,platformY+2);
        heroPushSprite.position=ccp(platformX+heroForwardX,platformY+2);
    }
}
-(void)heroJumpingFunc{
    if(jumpingChe){
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
            if(heroJumpingAnimationCount<=10)//kkk10
                heroJumpingAnimationCount+=1;//(gameFunc.autoJumpChe?5:1);
            
            
        }else{
            CGFloat angle=jumpAngle;
            
            if(!safetyJumpChe && !gameFunc.autoJumpChe&&!gameFunc.autoJumpChe2&&!gameFunc.minimumJumpingChe&&!gameFunc.topHittingCollisionChe){
                jumpPower = activeVect.Length();
                forwardChe=(angle<90.0?NO:YES);
                [self heroUpdateForwardPosFunc];
            }
            if(gameFunc.minimumJumpingChe)
                jumpPower=1;
            
            jumpPower=(jumpPower>17.5?17.5:jumpPower);
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
            CGFloat yy=platformY+point.y;
            
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
            for (int aa=0; aa < 3; aa++) {
                if (boxSprite[aa].visible && (!isMiceMoving || boxSprite[aa].position.y > 390)) {
                    [gameFunc jumpingRenderLevel15B:xx yPosition:yy fChe:forwardChe blockPositionsArr:blocksPosiotionsArr[aa]];
                }
            }
            
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
            if(gameFunc.autoJumpChe)
                gameFunc.autoJumpChe=NO;
            
            if(autoJumpValue2==1&&gameFunc.autoJumpChe2){
                jumpPower = (gameFunc.autoJumpSpeedValue==1?8:5);
                gameFunc.autoJumpSpeedValue=0;
                jumpAngle=(forwardChe?140:20);
                jumpingChe=YES;
                runningChe=NO;
                heroStandChe=NO;
                heroRunSprite.visible=NO;
                heroSprite.visible=YES;
            }else if(autoJumpValue2 == 2&&gameFunc.autoJumpChe2){
                gameFunc.autoJumpChe2=NO;
                
            }
            
            landingChe=NO;
            heroJumpingAnimationCount=0;
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
    
    jumpPower=(jumpPower>16.5?16.5:jumpPower);
    b2Vec2 impulse = b2Vec2(cosf(angle*3.14/180), sinf(angle*3.14/180));
    impulse *= (jumpPower/2.2)-0.6;
    
    heroBody->ApplyLinearImpulse(impulse, heroBody->GetWorldCenter());
    
    b2Vec2 velocity = heroBody->GetLinearVelocity();
    impulse *= -1;
    heroBody->ApplyLinearImpulse(impulse, heroBody->GetWorldCenter());
    velocity = b2Vec2(-velocity.x, velocity.y);
    
    for (int i = 0; i < 20&&!safetyJumpChe; i=i+1) {
        b2Vec2 point = [self getTrajectoryPoint:heroBody->GetWorldCenter() andStartVelocity:velocity andSteps:i*170 andAngle:angle];
        point = b2Vec2(-point.x, point.y);
        
        int lValue=(!forwardChe?65:27);
        CGFloat xx=platformX+point.x+lValue-20;
        CGFloat yy=platformY+point.y+12;
        
        heroPimpleSprite[i].position=ccp(xx,yy);
    }
    if(!forwardChe)
        mouseDragSprite.position=ccp(platformX - DRAG_SPRITE_OFFSET_X,platformY-DRAG_SPRITE_OFFSET_Y);
    else
        mouseDragSprite.position=ccp(platformX+DRAG_SPRITE_OFFSET_X/2+heroForwardX ,platformY-DRAG_SPRITE_OFFSET_Y/2);
    
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
    if (knockoutCount == 3 || heroTrappedChe) {
        // cat is knocked out.
        return;
    }
    if(!mouseWinChe&&!heroTrappedChe&&!screenMoveChe){
        
        int forwadeValue=(!forwardChe?0:heroForwardX);
        if(location.x>=screenHeroPosX-60+forwadeValue && location.x <= screenHeroPosX+40+forwadeValue && location.y>screenHeroPosY-30&&location.y<screenHeroPosY+18){
            if(!jumpingChe&&!dragChe&&!runningChe&&heroStandChe){
                
                heroJumpLocationChe=YES;
                dragChe=YES;
                heroStandChe=NO;
                shouldCheckCollision = NO;
                [self heroAnimationFunc:0 animationType:@"jump"];
                mouseDragSprite.visible=YES;
                if(!forwardChe){
                    mouseDragSprite.position=ccp(platformX -DRAG_SPRITE_OFFSET_X,platformY-DRAG_SPRITE_OFFSET_Y);
                    mouseDragSprite.rotation=(180-0)-170;
                }else{
                    mouseDragSprite.rotation=(180-180)-170;
                    mouseDragSprite.position=ccp(platformX+DRAG_SPRITE_OFFSET_X/2+heroForwardX,platformY-DRAG_SPRITE_OFFSET_Y/2);
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
                        shouldCheckCollision = YES;
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
    if (knockoutCount == 3 || heroTrappedChe) {
        // cat is knocked out.
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
    if (knockoutCount == 3 || heroTrappedChe) {
        // cat is knocked out.
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
            shouldCheckCollision = NO;
            mouseDragSprite.visible=NO;
            for (int i = 0; i < 20; i=i+1) {
                heroPimpleSprite[i].position=ccp(-100,100);
            }
        }else if(!jumpingChe&&!landingChe&&!firstRunningChe){
            if(runningChe){
                gameFunc.pushChe=NO;
                heroPushSprite.visible=NO;
                heroStandChe=YES;
                runningChe=NO;
                isPushing = NO;
                heroRunSprite.visible=NO;
                heroSprite.visible=YES;
            }
        }
    }
    
}
-(void)clickMenuButton{
    [[CCDirector sharedDirector] replaceScene:[LevelScreen scene]];
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

-(void)smokingAnimation {
    int i=smokingCount3;
    if(smokingCount2%40==0&&smokingCount2<300&&gameFunc.switchCount==0){
        if(smokingCount[i]==0){
            smokingCount[i]=3;
            smokingCount3+=1;
            smokingCount3=(smokingCount3>=6?0:smokingCount3);
        }
    }
    
    smokingCount2+=1;
    if(smokingCount2>=(motherLevel==3?500:300))
        smokingCount2=0;
    
    for(int i=0;i<=6;i++){
        if(smokingCount[i]>=1){
            smokingCount[i]+=1.5;
            if(smokingCount[i]>300)
                smokingCount[i]=0;
        }
        
        CGFloat sx=0;
        CGFloat sy=0;
        if(motherLevel == 3){
            sx=641;
            sy= 360;
        }else if(motherLevel == 4){
            sx=653;
            sy= 260;
        }
        
        for(int j=0;j<6;j++){
            if(i==0)
                smokingSprite[i][j].position=ccp(sx-(smokingCount[j]/18.0),sy+(smokingCount[j]/2.3));
            else if(i==1)
                smokingSprite[i][j].position=ccp(sx,sy+(smokingCount[j]/2.1));
            else if(i==2)
                smokingSprite[i][j].position=ccp(sx+(smokingCount[j]/18.0),sy+(smokingCount[j]/2.3));
            else if(i==3)
                smokingSprite[i][j].position=ccp(sx-(smokingCount[j]/26.0),sy+(smokingCount[j]/2.6));
            else if(i==4)
                smokingSprite[i][j].position=ccp(sx+(smokingCount[j]/18.0),sy+(smokingCount[j]/2.6));
            else if(i==5)
                smokingSprite[i][j].position=ccp(sx,sy+(smokingCount[j]/2.3));
            if(smokingCount[j]<=250)
                smokingSprite[i][j].opacity=250-smokingCount[j];
        }
        
    }
}
-(void) dealloc {
    [super dealloc];
}

@end
