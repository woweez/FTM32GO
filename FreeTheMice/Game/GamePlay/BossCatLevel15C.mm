//
//  BossCatLevel15C.m
//  FreeTheMice
//
//  Created by Muhammad Kamran on 27/11/2013.
//
//

#import "BossCatLevel15C.h"
#import "AppDelegate.h"
#import "LevelScreen.h"
#import "LevelCompleteScreen.h"
#import "FTMConstants.h"
#import "DB.h"
#import "FTMUtil.h"
enum {
    kTagParentNode = 1,
};


GameEngineMenu15 *layer15;

@implementation GameEngineMenu15


-(id) init {
    if( (self=[super init])) {
    }
    return self;
}
@end

@implementation BossCatLevel15C

@synthesize tileMap = _tileMap;
@synthesize background = _background;


+(CCScene *) scene {
    CCScene *scene = [CCScene node];
    layer15=[GameEngineMenu15 node];
    [scene addChild:layer15 z:1];
    BossCatLevel15C *layer = [BossCatLevel15C node];
    [scene addChild: layer z:0];
    return scene;
}


-(id) init
{
    if( (self=[super init])) {
        
        heroJumpIntervalValue = [[NSArray alloc] initWithObjects:@"0",@"2",@"4",@"6",@"8",@"10",@"0",@"11",@"13",@"15",nil];
        cheeseSetValue= [[NSArray alloc] initWithObjects:@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",nil];
        cheeseArrX=[[NSArray alloc] initWithObjects:@"0",@"20",@"0",@"20",@"10",nil];
        cheeseArrY=[[NSArray alloc] initWithObjects:@"0",@"0", @"-15", @"-15",@"-8",nil];
        heroRunningStopArr=[[NSArray alloc] initWithObjects:@"80",@"80",@"80", @"40",@"140",@"80",@"80",@"80",@"80",@"80",@"80",@"80",@"40",@"80",@"80", nil];
        
        gameFunc=[[GameFunc alloc] init];
        soundEffect=[[sound alloc] init];
        trigo=[[Trigo alloc] init];
        winSize = [[CCDirector sharedDirector] winSize];
        [self initValue];
        gameFunc.gameLevel = motherLevel;
        
        
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
        self.background.position = ccp(0, -15);
        if ([FTMUtil sharedInstance].isRetinaDisplay) {
            self.background.scale = 2;
        }
        [self addChild:_tileMap z:-1 tag:1];
        
        cache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [cache addSpriteFramesWithFile:@"mother_mouse_default.plist"];
        [cache addSpriteFramesWithFile:@"bossCatWalk.plist"];
        [cache addSpriteFramesWithFile:@"bossCatKnocked.plist"];
        [cache addSpriteFramesWithFile:@"bossCatTurn.plist"];
        [cache addSpriteFramesWithFile:@"keyAnimation.plist"];
        [cache addSpriteFramesWithFile:@"motherCageAnim.plist"];
        
        
        spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"mother_mouse_default.png"];
        bossCatWalkBatch = [CCSpriteBatchNode batchNodeWithFile:@"bossCatWalk.png"];
        
        [self addChild:spriteSheet z:10];
        [self addChild:bossCatWalkBatch z:10];
        
        //boss cat Animations
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
        
        [self addChild:bossCatTurnBatch z:100];
        
        bossCatWalk = [CCSprite spriteWithSpriteFrameName:@"boss_cat_walk_0.png"];
        bossCatWalk.position = ccp(200, 266);
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
        
        
        heroRunSprite = [CCSprite spriteWithSpriteFrameName:@"mother_run01.png"];
        heroRunSprite.position = ccp(200, 200);
        heroRunSprite.scale = MAMA_SCALE;
        [spriteSheet addChild:heroRunSprite];
        
        NSMutableArray *animFrames = [NSMutableArray array];
        for(int i = 1; i < 8; i++) {
            CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"mother_run0%d.png",i]];
            [animFrames addObject:frame];
        }
        CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.06f];
        [heroRunSprite runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation]]];
        
        mouseDragSprite=[CCSprite spriteWithFile:@"mouse_drag.png"];
        mouseDragSprite.position=ccp(platformX+2,platformY+3);
        mouseDragSprite.scale = MICE_TAIL_SCALE;
        mouseDragSprite.visible=NO;
        mouseDragSprite.anchorPoint=ccp(0.99f, 0.9f);
        [self addChild:mouseDragSprite z:9];
        
        [self heroAnimationFunc:0 animationType:@"stand"];
        heroSprite.visible=NO;
        
        [self HeroDrawing];
        
        
        int switchWidth = [FTMUtil sharedInstance].isRetinaDisplay ? 40: 80;
        int switchHeight = [FTMUtil sharedInstance].isRetinaDisplay ? 103: 206;
        switchAtlas1 = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"switch.png" itemWidth:switchWidth itemHeight:switchHeight startCharMap:'0'] retain];
        switchAtlas1.position=ccp(20,300);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            switchAtlas1.scale=0.35;
        }else{
            switchAtlas1.scale=0.7;
        }
        [self addChild:switchAtlas1 z:9];
        
        switchAtlas2 = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"switch.png" itemWidth:switchWidth itemHeight:switchHeight startCharMap:'0'] retain];
        switchAtlas2.position=ccp(20,510);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            switchAtlas2.scale=0.35;
        }else{
            switchAtlas2.scale=0.7;
        }
        [self addChild:switchAtlas2 z:9];
        
        switchAtlas3 = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"switch.png" itemWidth:switchWidth itemHeight:switchHeight startCharMap:'0'] retain];
        switchAtlas3.position=ccp(971,510);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            switchAtlas3.scale = 0.35;
        }else{
            switchAtlas3.scale = 0.7;
        }
        [self addChild:switchAtlas3 z:9];
        
        switchAtlas4 = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"switch.png" itemWidth:switchWidth itemHeight:switchHeight startCharMap:'0'] retain];
        switchAtlas4.position=ccp(971,300);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            switchAtlas4.scale=0.35;
        }else{
            switchAtlas4.scale=0.7;
        }
        [self addChild:switchAtlas4 z:9];
        
        clockBackgroundSprite=[CCSprite spriteWithFile:@"clock_background.png"];
        clockBackgroundSprite.position=ccp(-100,258);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            clockBackgroundSprite.scale=0.25;
        }else{
            clockBackgroundSprite.scale = 0.5;
        }
        [layer15 addChild:clockBackgroundSprite z:0];
        
        clockArrowSprite=[CCSprite spriteWithFile:@"clock_arrow.png"];
        clockArrowSprite.position=ccp(-100,258);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            clockArrowSprite.scale = 0.25;
        }else{
            clockArrowSprite.scale = 0.5;
        }
        clockArrowSprite.anchorPoint=ccp(0.2f, 0.2f);
        clockArrowSprite.rotation = -40;
        [layer15 addChild:clockArrowSprite z:0];
        
        storyBoard = [CCSprite spriteWithFile:@"endingStory.png"];
        storyBoard.position = ccp(567,-70);
        storyBoard.visible = NO;
        storyBoard.scaleX = 2.3;
        storyBoard.scaleY = 1.78;
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            storyBoard.position = ccp(480,-70);
            storyBoard.scaleX = 0.97;
            storyBoard.scaleY = 0.89;
        }
        [self addChild:storyBoard z:999999];
        
        
        CCSprite *platformSprite=[CCSprite spriteWithFile:@"move_platform3.png"];
        platformSprite.position = ccp(250,340);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            platformSprite.scale = NON_RETINA_SCALE;
        }
        [self addChild:platformSprite z:1];
        
        platformSprite=[CCSprite spriteWithFile:@"move_platform3.png"];
        platformSprite.position=ccp(741,340);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            platformSprite.scale = NON_RETINA_SCALE;
        }
        [self addChild:platformSprite z:1];
        
        platformSprite=[CCSprite spriteWithFile:@"move_platform3.png"];
        platformSprite.position=ccp(500,460);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            platformSprite.scale = NON_RETINA_SCALE;
        }
        [self addChild:platformSprite z:1];
        
        platformSprite=[CCSprite spriteWithFile:@"move_platform3.png"];
        platformSprite.position=ccp(90,460);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            platformSprite.scale = NON_RETINA_SCALE;
        }
        [self addChild:platformSprite z:1];
        
        platformSprite=[CCSprite spriteWithFile:@"move_platform3.png"];
        platformSprite.position=ccp(911,460);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            platformSprite.scale = NON_RETINA_SCALE;
        }
        [self addChild:platformSprite z:1];

        
        CCSprite *slapSprite=[CCSprite spriteWithFile:@"slap.png"];
        slapSprite.position=ccp(150,173);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            slapSprite.scale=0.3;
        }else{
            slapSprite.scale=0.6;
        }
        [self addChild:slapSprite z:2];
        
        slapSprite=[CCSprite spriteWithFile:@"slap.png"];
        slapSprite.position=ccp(450,173);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            slapSprite.scale=0.3;
        }else{
            slapSprite.scale=0.6;
        }
        [self addChild:slapSprite z:1];
        
        slapSprite=[CCSprite spriteWithFile:@"slap.png"];
        slapSprite.position=ccp(750,173);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            slapSprite.scale = 0.3;
        }else{
            slapSprite.scale = 0.6;
        }
        [self addChild:slapSprite z:1];
        
        slapSprite=[CCSprite spriteWithFile:@"slap.png"];
        slapSprite.position=ccp(1050,173);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            slapSprite.scale = 0.3;
        }else{
            slapSprite.scale = 0.6;
        }
        [self addChild:slapSprite z:1];
        
        //===================================================================
        for(int i=0;i<0;i++){
            testSprite[i]=[CCSprite spriteWithFile:@"dotted.png"];
            testSprite[i].position=ccp(275,415);
            testSprite[i].scale=0.1;
            [self addChild:testSprite[i] z:9];
        }
        
        mouseTrappedBackground=[CCSprite spriteWithFile:@"mouse_trapped_background.png"];
        mouseTrappedBackground.position=ccp(240,160);
        mouseTrappedBackground.visible=NO;
        [layer15 addChild:mouseTrappedBackground z:10];
        
        CCMenuItem *aboutMenuItem = [CCMenuItemImage itemWithNormalImage:@"main_menu_button_1.png" selectedImage:@"main_menu_button_2.png" target:self selector:@selector(clickLevel:)];
        aboutMenuItem.tag=2;
        
        
        CCMenuItem *optionMenuItem = [CCMenuItemImage itemWithNormalImage:@"try_again_button_1.png" selectedImage:@"try_again_button_2.png" target:self selector:@selector(clickLevel:)];
        optionMenuItem.tag=1;
        
        menu2 = [CCMenu menuWithItems: optionMenuItem,aboutMenuItem,  nil];
        [menu2 alignItemsHorizontallyWithPadding:4.0];
        menu2.position=ccp(241,136);
        menu2.visible=NO;
        [layer15 addChild: menu2 z:10];
        
        for(int i=0;i<20;i++){
            heroPimpleSprite[i]=[CCSprite spriteWithFile:@"dotted.png"];
            heroPimpleSprite[i].position=ccp(-100,160);
            if (![FTMUtil sharedInstance].isRetinaDisplay) {
                heroPimpleSprite[i].scale = 0.15;
            }else{
                heroPimpleSprite[i].scale=0.3;
            }
            [self addChild:heroPimpleSprite[i] z:10];
        }
        
        dotSprite=[CCSprite spriteWithFile:@"dotted.png"];
        dotSprite.position=ccp(453,525);
        dotSprite.scale=0.2;
        [self addChild:dotSprite z:10];
        [self addHudLayerToTheScene];
        
        if (catObj1 == nil) {
            catObj1 = [[MotherLevel15Cat alloc] init];
            [catObj1 runCurrentSequenceForFirstCat];
            [self addChild:catObj1];
        }
        if (catObj2 == nil) {
            catObj2 = [[MotherLevel15Cat alloc] init];
            [catObj2 runCurrentSequenceForSecondCat];
            [self addChild:catObj2];
        }
        [self scheduleUpdate];
//        [self makeStoryAnimation];
    }
    return self;
}

-(void) makeStoryAnimation{
    [self unschedule:@selector(makeStoryAnimation)];
    hudLayer.visible = NO;
    storyBoard.visible = YES;
    self.position = ccp(0, -106);
    CGFloat scaleX = [FTMUtil sharedInstance].isRetinaDisplay ? 1.2:1;
    CCMoveTo *move1 = [CCMoveTo actionWithDuration:5 position:CGPointMake(0, -70)];
    CCMoveTo *move2 = [CCMoveTo actionWithDuration:5 position:CGPointMake(0, 265)];
    CCMoveTo *move3 = [CCMoveTo actionWithDuration:5 position:CGPointMake(480 *scaleX, 265)];
    CCMoveTo *move4 = [CCMoveTo actionWithDuration:5 position:CGPointMake(480 *scaleX, 590)];
    CCMoveTo *move5 = [CCMoveTo actionWithDuration:5 position:CGPointMake(0, 590)];
    CCDelayTime *delay = [CCDelayTime actionWithDuration:2];
    CCSequence *seq = [CCSequence actions:delay,move1, delay, move2,delay,move3,delay,move4,delay,move5, nil];
    [storyBoard runAction:seq];
}
-(void) addHudLayerToTheScene{
    hudLayer = [[HudLayer alloc] init];
    hudLayer.tag = 15;
    [layer15 addChild: hudLayer z:2000];
//    [hudLayer updateNoOfCheeseCollected:0 andMaxValue:[cheeseSetValue[motherLevel-1] intValue]];
}

-(void) makeKeyAnimation{
    CCSpriteBatchNode *girlCageBatch = [CCSpriteBatchNode batchNodeWithFile:@"keyAnimation.png"];
    [self addChild:girlCageBatch];
    
    CCSprite *girlCage = [CCSprite spriteWithSpriteFrameName:@"key_0.png"];
    girlCage.position = ccp(bossCatWalk.position.x + 80, bossCatWalk.position.y + 30);
    if (![FTMUtil sharedInstance].isRetinaDisplay) {
        girlCage.scale = NON_RETINA_SCALE;
    }
    [girlCageBatch addChild:girlCage];
    
    NSMutableArray *cageFrames = [NSMutableArray array];
    for(int i = 0; i <= 9; i++) {
        CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"key_%d.png",i]];
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

-(void) checkSwitchesCollision{
    CGRect heroRect = CGRectMake(heroSprite.position.x, heroSprite.position.y+20, 20, 30);
    CGRect catRect1 = CGRectMake(switchAtlas1.position.x, switchAtlas1.position.y+55, 10, 10);
    CGRect catRect2 = CGRectMake(switchAtlas2.position.x, switchAtlas2.position.y+55, 10, 10);
    CGRect catRect3 = CGRectMake(switchAtlas3.position.x, switchAtlas3.position.y+55, 10, 10);
    CGRect catRect4 = CGRectMake(switchAtlas4.position.x, switchAtlas4.position.y+55, 10, 10);

    
    if (switchAtlas1.tag != 1212 && !CGRectIsNull(CGRectIntersection(catRect1, heroRect))) {
        [switchAtlas1  setString:@"1"];
        switchAtlas1.tag = 1212;
        if (!isSwitchOn) {
            isSwitchOn = YES;
            [self schedule:@selector(switchesOnSchedular) interval:60];
        }
    }else if (switchAtlas2.tag != 1212 && !CGRectIsNull(CGRectIntersection(catRect2, heroRect))){
        [switchAtlas2  setString:@"1"];
        switchAtlas2.tag = 1212;
        if (!isSwitchOn) {
            isSwitchOn = YES;
            [self schedule:@selector(switchesOnSchedular) interval:60];
        }
        
    }else if (switchAtlas3.tag != 1212 && !CGRectIsNull(CGRectIntersection(catRect3, heroRect))){
        [switchAtlas3  setString:@"1"];
        switchAtlas3.tag = 1212;
        if (!isSwitchOn) {
            isSwitchOn = YES;
            [self schedule:@selector(switchesOnSchedular) interval:60];
        }
        
    }else if (switchAtlas4.tag != 1212 && !CGRectIsNull(CGRectIntersection(catRect4, heroRect))){
        [switchAtlas4  setString:@"1"];
        switchAtlas4.tag = 1212;
        if (!isSwitchOn) {
            isSwitchOn = YES;
            [self schedule:@selector(switchesOnSchedular) interval:60];
        }
        
    }
    
    if (switchAtlas1.tag == 1212 && switchAtlas2.tag == 1212 && switchAtlas3.tag == 1212 && switchAtlas4.tag == 1212) {
        switchAtlas1.tag = 121;
        self.isTouchEnabled = NO;
        [self schedule:@selector(makeStoryAnimation) interval:0.2];
    }
}

-(void) switchesOnSchedular{
    isSwitchOn = NO;
    [self unschedule:@selector(switchesOnSchedular)];
    if (switchAtlas1.tag == 1212 && switchAtlas2.tag == 1212 && switchAtlas3.tag == 1212 && switchAtlas4.tag == 1212) {
        switchAtlas1.tag = 121;
//        [self addLevelCompleteLayerToTheScene];
    }else{
        [switchAtlas1  setString:@"0"];
        [switchAtlas2  setString:@"0"];
        [switchAtlas3  setString:@"0"];
        [switchAtlas4  setString:@"0"];
        
        switchAtlas1.tag = 1;
        switchAtlas2.tag = 1;
        switchAtlas3.tag = 1;
        switchAtlas4.tag = 1;
    }
}
-(void) checkCatCollision{
    [self checkSwitchesCollision];
    if (heroTrappedChe) {
        heroSprite.visible=NO;
        heroRunSprite.visible=NO;
        mouseDragSprite.visible = NO;
        if (heroPimpleSprite[1].visible) {
            for (int i = 0; i < 20; i++) {
                heroPimpleSprite[i].visible = NO;
            }
        }
        
        return;
    }
    CGRect bossCatRect = CGRectMake(bossCatWalk.position.x, bossCatWalk.position.y, bossCatWalk.contentSize.width* 0.2, 5);
    CGRect catRect1 = CGRectMake([catObj1 getCatSprite].position.x, [catObj1 getCatSprite].position.y, [catObj1 getCatSprite].contentSize.width* 0.2, 5);
    CGRect catRect2 = CGRectMake([catObj2 getCatSprite].position.x, [catObj2 getCatSprite].position.y, [catObj2 getCatSprite].contentSize.width* 0.2, 5);
    
    CGRect heroRect = CGRectMake(heroSprite.position.x, heroSprite.position.y, heroSprite.contentSize.width *STRONG_SCALE, heroSprite.contentSize.height/2);
    
    int catX = bossCatWalk.position.x;
    if (bossCatWalk.flipX == 1) {
        catX = catX+40;
    }
    //        int catY = bossCatWalk.position.y;
    if ((!CGRectIsNull(CGRectIntersection(bossCatRect, heroRect)) ||!CGRectIsNull(CGRectIntersection(catRect1, heroRect)) ||!CGRectIsNull(CGRectIntersection(catRect2, heroRect)) ) && ![FTMUtil sharedInstance].isInvincibilityOn) {
        gameFunc.trappedChe = YES;
        heroTrappedChe=YES;
        heroSprite.visible=NO;
        heroStandChe=NO;
        heroRunSprite.visible=NO;
    }
}

-(void) moveMiceAndPlatform{
    heroSprite.visible = YES;
    
    CCCallFunc *animationDone = [CCCallFunc actionWithTarget:self selector:@selector(miceMoveMentDone)];
    CGPoint point;
    if (!forwardChe) {
        point = CGPointMake(heroSprite.position.x + 130, 226);
    }else{
        point = CGPointMake(heroSprite.position.x  - 130 - heroForwardX, 226);
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
}
-(void) moveBossCatLeftAndRight{
    // 1 for left movement. 0 for right movement.
    if (isCatKnockedOut || isTurnAnimation) {
        return;
    }
    if (bossCatDirection == 0 && bossCatWalk.position.x > 830) {
        bossCatWalk.visible = NO;
        bossCatWalk.flipX = 1;
        bossCatDirection = 1;
        isTurnAnimation = YES;
        [self makeCatTurnAnimation];
    }else if(bossCatDirection == 1 && bossCatWalk.position.x < 210){
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


-(void) addLevelCompleteLayerToTheScene{
    [self levelCompleted : 15];
}

-(void)initValue{
    //Cheese Count Important
    DB *db = [DB new];
    motherLevel= 15;//[[db getSettingsFor:@"CurrentLevel"] intValue];
    [db release];
    
//    cheeseCount=[cheeseSetValue[motherLevel-1] intValue];
    platformX=800;
    platformY=270;
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
    
    if ([FTMUtil sharedInstance].isBoostPowerUpEnabled) {
        if (previousPosition.x == 0 && previousPosition.y == 0) {
            previousPosition = self.position;
        }
        [FTMUtil sharedInstance].isBoostPowerUpEnabled = NO;
        CCMoveTo *move = [CCMoveTo actionWithDuration:0.5 position:ccp(-126, -85)];
        CCScaleTo *scale = [CCScaleTo actionWithDuration:0.5 scaleX:0.48 scaleY:0.4571];
        //        CCScaleTo *scale1 = [CCScaleTo actionWithDuration:0.05 scaleX:0.62 scaleY:0.5971];
        CCSpawn *span = [CCSpawn actions:move,scale, nil];
        //        CCSequence *seq = [CCSequence actions:span,scale1,scale,  nil];
        [self runAction:span];
    }else if ([FTMUtil sharedInstance].isFirstTutorial){
        [FTMUtil sharedInstance].isFirstTutorial = NO;
        CCMoveTo *move = [CCMoveTo actionWithDuration:0.5 position:previousPosition];
        CCScaleTo *scale = [CCScaleTo actionWithDuration:0.5 scaleX:1 scaleY:1];
        CCSpawn *span = [CCSpawn actions:move,scale, nil];
        [self runAction:span];
        previousPosition = ccp(0, 0);
    }
    
    [self heroJumpingFunc];
    [self heroAnimationFrameFunc];
    [self heroLandingFunc];
    [self heroRunFunc];
    [self heroWinFunc];
    
    [self level01];
    [self progressBarFunc];
    [self heroJumpingRunning];
    [self heroTrappedFunc];
    [self moveBossCatLeftAndRight];
    [self checkCatCollision];
    gameFunc.runChe=runningChe;
    [gameFunc render];
    
    if(gameFunc.trigoVisibleChe){
        heroSprite.rotation=-gameFunc.trigoHeroAngle;
        heroRunSprite.rotation=-gameFunc.trigoHeroAngle;
    }
    
    
}
-(void)trigoJumpingFunc:(CGFloat)xPos yPosition:(CGFloat)yPos{

    
}


-(void)level01{
    if(firstRunningChe){
        if(platformX>[heroRunningStopArr[motherLevel-1] intValue]&&screenFirstViewCount==0){
            heroStandChe=YES;
            runningChe=NO;
            heroRunSprite.visible=NO;
            heroSprite.visible=YES;
            if([self levelView]){
                screenFirstViewCount=1;
                screenShowX=233;
                screenShowY=platformY;
                screenShowX2=233;
                screenShowY2=platformY;
            }else{
                firstRunningChe=NO;
            }
        }else if(screenFirstViewCount>=1){
            if(screenFirstViewCount==1){
                screenShowY+=3;
                if(screenShowY>520)
                    screenFirstViewCount=2;
            }else if(screenFirstViewCount==2){
                screenShowX+=3;
                if(screenShowX>750)
                    screenFirstViewCount=3;
            }else if(screenFirstViewCount==3){
                screenShowY-=3;
                if(screenShowY<screenShowY2){
                    screenFirstViewCount=4;
                    screenShowY=screenShowY2;
                }
            }else if(screenFirstViewCount==4){
                screenShowX-=3;
                if(screenShowX<screenShowX2){
                    screenFirstViewCount=4;
                    screenShowX=screenShowX2;
                    firstRunningChe=NO;
                    screenHeroPosX=platformX;
                    screenHeroPosY=platformY;
                    screenShowX=platformX;
                    screenShowY=platformY;
                }
            }
            
            CGPoint copyHeroPosition = ccp(screenShowX, screenShowY);
            [self setViewpointCenter:copyHeroPosition];
        }
    }
    if(motherLevel==1){
        if(platformX>=830&&platformY<=170&&!mouseWinChe&&!heroTrappedChe){
            if(runningChe){
                mouseWinChe=YES;
                heroRunSprite.visible=NO;
                runningChe=NO;
            }else if(heroStandChe){
                mouseWinChe=YES;
                heroSprite.visible=NO;
                heroStandChe=NO;
            }
        }
    }else if(motherLevel == 2){
        
        int fValue=(!forwardChe?0:30);
        if(heroSprite.position.x>=920+fValue &&heroSprite.position.y<=430&&!mouseWinChe){
            if(runningChe||heroStandChe){
                mouseWinChe=YES;
                heroStandChe=YES;
                runningChe=NO;
                heroRunSprite.visible=NO;
            }
        }
        
    }else if(motherLevel == 3){
        int fValue=(!forwardChe?0:30);
        if(heroSprite.position.x>=920+fValue&&heroSprite.position.y<=430&&!mouseWinChe){
            if(runningChe||heroStandChe){
                mouseWinChe=YES;
                heroStandChe=YES;
                runningChe=NO;
                heroRunSprite.visible=NO;
            }
        }else if(gameFunc.trappedChe){
            heroTrappedChe=YES;
            heroSprite.visible=NO;
            heroStandChe=NO;
        }
    }else if(motherLevel == 4){
        int fValue=(!forwardChe?0:30);
        if(heroSprite.position.x>=920+fValue&&heroSprite.position.y<=295&&!mouseWinChe){
            if(runningChe||heroStandChe){
                mouseWinChe=YES;
                heroStandChe=YES;
                runningChe=NO;
                heroRunSprite.visible=NO;
            }
        }else if(gameFunc.trappedChe){
            heroTrappedChe=YES;
            heroSprite.visible=NO;
            heroStandChe=NO;
        }
    }else if(motherLevel == 5 || motherLevel == 6 ){
        int fValue=(!forwardChe?0:30);
        if(heroSprite.position.x>=920+fValue&&heroSprite.position.y<=295&&!mouseWinChe){
            if(runningChe||heroStandChe){
                mouseWinChe=YES;
                heroStandChe=YES;
                runningChe=NO;
                heroRunSprite.visible=NO;
            }
        }else if(gameFunc.trappedChe){
            heroTrappedChe=YES;
            heroSprite.visible=NO;
            heroStandChe=NO;
            heroRunSprite.visible=NO;
        }
    }else if(motherLevel == 7 ){
        int fValue=(!forwardChe?0:30);
        if(heroSprite.position.x>=920+fValue&&heroSprite.position.y>=440 && heroSprite.position.y<500 &&!mouseWinChe){
            if(runningChe||heroStandChe){
                mouseWinChe=YES;
                heroStandChe=YES;
                runningChe=NO;
                heroRunSprite.visible=NO;
            }
        }else if(gameFunc.trappedChe){
            heroTrappedChe=YES;
            heroSprite.visible=NO;
            heroStandChe=NO;
            heroRunSprite.visible=NO;
        }
    }else if(motherLevel == 8){
        int fValue=(!forwardChe?0:30);
        if(heroSprite.position.x>=920+fValue&&heroSprite.position.y>=400 && heroSprite.position.y<500 &&!mouseWinChe){
            if(runningChe||heroStandChe){
                mouseWinChe=YES;
                heroStandChe=YES;
                runningChe=NO;
                heroRunSprite.visible=NO;
            }
        }else if(gameFunc.trappedChe){
            heroTrappedChe=YES;
            heroSprite.visible=NO;
            heroStandChe=NO;
            heroRunSprite.visible=NO;
        }
    }
    
    if(gameFunc.trappedChe){
        if(heroTrappedChe&&heroTrappedCount ==100){
            [self showLevelFailedUI:motherLevel];
        }
    }
}

-(void)heroTrappedFunc{
    
    if(heroTrappedChe){
        heroTrappedCount+=1;
        if(heroTrappedCount==10){
            heroTrappedSprite = [CCSprite spriteWithFile:@"mm_mist_0.png"];
            if(!forwardChe)
                heroTrappedSprite.position = ccp(heroSprite.position.x , heroSprite.position.y);
            else
                heroTrappedSprite.position = ccp(heroSprite.position.x , heroSprite.position.y);
            
            if (![FTMUtil sharedInstance].isRetinaDisplay) {
                heroTrappedSprite.scale=0.5;
            }
            
            [self addChild:heroTrappedSprite z:1000];
//            int posY = 300;
//            
//            CCMoveTo *move = [CCMoveTo actionWithDuration:1 position:ccp(heroTrappedSprite.position.x, posY)];
//            [heroTrappedSprite runAction:move];
            
            heroSprite.visible=NO;
        }
    }
}
-(void)heroWinFunc{
    if (isLevelCompleted) {
        return;
    }
    if(mouseWinChe){
        DB *db = [DB new];
        int currentLvl = [[db getSettingsFor:@"mamaCurrLvl"] intValue];
        if(currentLvl <= motherLevel){
            [db setSettingsFor:@"CurrentLevel" withValue:[NSString stringWithFormat:@"%d", motherLevel+1]];
            [db setSettingsFor:@"mamaCurrLvl" withValue:[NSString stringWithFormat:@"%d", motherLevel+1]];
        }
        [db release];
        heroWinCount+=1;
        if(heroWinCount==15){
            heroWinSprite = [CCSprite spriteWithSpriteFrameName:@"mother_win01.png"];
            if(!forwardChe)
                heroWinSprite.position = ccp(950, platformY+5);
            else
                heroWinSprite.position = ccp(950, platformY+5);
            heroWinSprite.scale=0.8;
            [spriteSheet addChild:heroWinSprite];
            
            NSMutableArray *animFrames2 = [NSMutableArray array];
            for(int i = 2; i < 5; i++) {
                CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"mother_win0%d.png",i]];
                [animFrames2 addObject:frame];
            }
            CCAnimation *animation2 = [CCAnimation animationWithSpriteFrames:animFrames2 delay:0.1f];
            [heroWinSprite runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation2]]];
            heroSprite.visible=NO;
            [self addLevelCompleteLayerToTheScene];
            if(runningChe){
                heroRunSprite.visible=NO;
                heroSprite.visible=NO;
                runningChe=NO;
            }else if(heroStandChe){
                heroSprite.visible=NO;
                heroStandChe=NO;
            }
        }
    }
}
-(void)heroJumpingRunning{
    if(heroJumpRunningChe){
        jumpRunDiff2+=3;
        if(jumpRunDiff2>40-gameFunc.jumpDiff){
            gameFunc.jumpDiffChe=NO;
            heroJumpRunningChe=NO;
            jumpRunDiff=0;
            jumpRunDiff2=0;
            heroStandChe=YES;
            runningChe=NO;
            heroRunSprite.visible=NO;
            if(!gameFunc.trappedChe)
                heroSprite.visible=YES;
        }
    }
}
-(void)heroRunFunc{
    if(runningChe&&!gameFunc.trappedChe){
        if(gameFunc.movePlatformChe){
            if(!forwardChe){
                if(motherLevel == 5){
                    gameFunc.movePlatformX+=(gameFunc.moveCount<=150?2.8:3.4);
                    platformX=gameFunc.movePlatformX-gameFunc.landMoveCount+gameFunc.moveCount2;
                    [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
                    platformX=gameFunc.xPosition;
                }else if(motherLevel == 6){
                    if(!gameFunc.moveSideChe){
                        platformX+=3.0;
                        platformY=gameFunc.movePlatformY-gameFunc.landMoveCount+gameFunc.moveCount2;
                    }else{
                        gameFunc.movePlatformX+=(!gameFunc.heightMoveChe?3.4:2.8);
                        platformX=gameFunc.movePlatformX+gameFunc.landMoveCount-gameFunc.moveCount3;
                    }
                    
                    [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
                    platformY=gameFunc.yPosition;
                    platformX=gameFunc.xPosition;
                }else if(motherLevel==7){
                    platformX+=3.0;
                    platformY=gameFunc.movePlatformY-gameFunc.landMoveCount+gameFunc.moveCount2;
                    [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
                    platformY=gameFunc.yPosition;
                    platformX=gameFunc.xPosition;
                }
            }else{
                if(motherLevel == 5){
                    gameFunc.movePlatformX-=(gameFunc.moveCount<=150?3.4:2.8);
                    platformX=gameFunc.movePlatformX-gameFunc.landMoveCount+gameFunc.moveCount2;
                    [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
                    platformX=gameFunc.xPosition;
                }else if(motherLevel == 6){
                    if(!gameFunc.moveSideChe){
                        platformX-=3.0;
                        platformY=gameFunc.movePlatformY-gameFunc.landMoveCount+gameFunc.moveCount2;
                    }else{
                        gameFunc.movePlatformX-=(!gameFunc.heightMoveChe?2.2:2.8);
                        platformX=gameFunc.movePlatformX+gameFunc.landMoveCount-gameFunc.moveCount3;
                    }
                    [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
                    platformY=gameFunc.yPosition;
                    platformX=gameFunc.xPosition;
                }else if(motherLevel == 7){
                    platformX-=3.0;
                    platformY=gameFunc.movePlatformY-gameFunc.landMoveCount+gameFunc.moveCount2;
                    [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
                    platformY=gameFunc.yPosition;
                    platformX=gameFunc.xPosition;
                }
            }
        }else{
            
            if(!forwardChe){
                if(!gameFunc.trigoVisibleChe){
                    platformX+=3.0;
                    [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
                    platformX=gameFunc.xPosition;
                    heroSprite.rotation=0;
                    heroRunSprite.rotation=0;
                }else{
                    [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
                    platformX=gameFunc.xPosition;
                    platformY=gameFunc.yPosition;
                }
            }else{
                if(!gameFunc.trigoVisibleChe){
                    platformX-=3.0;
                    [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
                    platformX=gameFunc.xPosition;
                    heroSprite.rotation=0;
                    heroRunSprite.rotation=0;
                }else{
                    [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
                    platformX=gameFunc.xPosition;
                    platformY=gameFunc.yPosition+20;
                }
            }
            
            if(gameFunc.trigoVisibleChe)
                dragTrigoCheckChe=forwardChe;
        }
        
        
        if(gameFunc.autoJumpChe){
            if(!gameFunc.domChe){
                jumpPower = 6;
                jumpAngle=(forwardChe?120:20);
                jumpingChe=YES;
                runningChe=NO;
                heroRunSprite.visible=NO;
                heroSprite.visible=YES;
            }else{
                if(!gameFunc.domeSideChe&&!forwardChe)
                    forwardChe=(forwardChe?NO:YES);
                else if(gameFunc.domeSideChe&&forwardChe)
                    forwardChe=(forwardChe?NO:YES);
                
                jumpPower = 6;
                jumpAngle=(forwardChe?120:20);
                jumpingChe=YES;
                runningChe=NO;
                heroRunSprite.visible=NO;
                heroSprite.visible=YES;
                gameFunc.domChe=NO;
                domeLessCount=0;
            }
        }
        
        CGPoint copyHeroPosition = ccp(platformX, platformY);
        heroRunSprite.position=ccp(platformX,platformY+2);
        
        [self setViewpointCenter:copyHeroPosition];
        [self heroUpdateForwardPosFunc];
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
    [self mamaAnimationWithType:fValue animationType:type];
    [self heroUpdateForwardPosFunc];
}
-(void)heroUpdateForwardPosFunc{
    
    if(!forwardChe){
        heroSprite.flipX=0;
        heroRunSprite.flipX=0;
        heroSprite.position=ccp(platformX,platformY);
        heroRunSprite.position=ccp(platformX,platformY+2);
    }else{
        heroSprite.flipX=1;
        heroRunSprite.flipX=1;
        
        heroSprite.position=ccp(platformX+heroForwardX,platformY);
        heroRunSprite.position=ccp(platformX+heroForwardX,platformY+2);
    }
}
-(void)heroJumpingFunc{
    if(jumpingChe&&!gameFunc.trappedChe){
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
            
            if(!safetyJumpChe && !gameFunc.autoJumpChe&&!gameFunc.autoJumpChe2&&!gameFunc.minimumJumpingChe&&!gameFunc.topHittingCollisionChe){
                jumpPower = activeVect.Length();
                forwardChe=(angle<90.0?NO:YES);
                if(jumpPower<=5)
                    jumpPower=5;
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
                xx=xx-4;
                yy=yy-8;
            }
            if(gameFunc.autoJumpChe){
                xx=xx-4;
                yy=yy-8;
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
                if(gameFunc.trigoVisibleChe)
                    dragTrigoCheckChe=forwardChe;
                
                
                [self endJumping:gameFunc.xPosition yValue:gameFunc.yPosition];
            }
            
            if(xx>950){
                xx=950;
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
            else{
                heroSprite.position=ccp(xx+heroForwardX,yy);
            }
            
            CGPoint copyHeroPosition = ccp(xx, yy);
            [self setViewpointCenter:copyHeroPosition];
            saveDottedPathCount+=1.5;
        }
    }
}
-(void)endJumping:(CGFloat)xx yValue:(CGFloat)yy{
    platformX=xx;
    platformY=yy;
    if(gameFunc.trigoVisibleChe&&forwardChe&&!safetyJumpChe)
        platformY+=20;
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
                jumpPower = (gameFunc.autoJumpSpeedValue!=1?5:8);
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
    int tValue=0;
    int tValue2=0;
    if (heroPimpleSprite[1].position.x == -100) {
        [soundEffect pulling_tail];
    }
    if(!safetyJumpChe){
        jumpPower = activeVect.Length();
        forwardChe=(angle<90.0?NO:YES);
        [self heroUpdateForwardPosFunc];
        if(gameFunc.trigoVisibleChe){
            if(!dragTrigoCheckChe){
                if(forwardChe){
                    tValue=20;
                }else
                    tValue=0;
                tValue2=20;
            }else{
                if(forwardChe){
                    tValue=0;
                }else
                    tValue=-20;
                tValue2=-20;
            }
        }
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
        
        int lValue=(!forwardChe?55:0);
        CGFloat xx=platformX+point.x+lValue;
        CGFloat yy=platformY+point.y+6-tValue+tValue2;
        heroPimpleSprite[i].position=ccp(xx,yy);
    }
    if(!forwardChe){
        
        mouseDragSprite.position=ccp(platformX+2,platformY+3+tValue);
        if(gameFunc.trigoVisibleChe)
            heroSprite.position=ccp(platformX+2,platformY+tValue);
    }else{
        mouseDragSprite.position=ccp(platformX-2+heroForwardX,platformY+3+tValue);
        if(gameFunc.trigoVisibleChe)
            heroSprite.position=ccp(platformX-2+heroForwardX,platformY+tValue);
    }
    
    mouseDragSprite.rotation=(180-angle)-170;
    mouseDragSprite.scale=MICE_TAIL_SCALE+(jumpPower/40.0);
    
    
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
    
    if ([FTMUtil sharedInstance].isBoostPowerUpEnabled) {
        return;
    }
    
    int x = MAX(position.x, winSize.width / 2);
    int y = MAX(position.y, winSize.height / 2);
    x = MIN(x, (_tileMap.mapSize.width * _tileMap.tileSize.width)
            - winSize.width / 2);
    y = MIN(y, (_tileMap.mapSize.height * _tileMap.tileSize.height)
            - winSize.height/2);
    CGPoint actualPosition = ccp(x, y);
    if(x<=winSize.width / 2)
        screenHeroPosX=position.x;
    else if(x>=_tileMap.mapSize.width-(winSize.width / 2))
        screenHeroPosX=(position.x-x)+(winSize.width / 2);
    if(y<=(winSize.height / 2))
        screenHeroPosY=position.y;
    else if(y>=_tileMap.mapSize.height-(winSize.height / 2))
        screenHeroPosY=(position.y-y)+(winSize.height / 2);
    
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    int offset = 15;
    if (heroSprite.position.y > 530) {
        offset = -10;
    }
    self.position = ccp(viewPoint.x, viewPoint.y - offset);
}
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    CGPoint prevLocation = [myTouch previousLocationInView: [myTouch view]];
    prevLocation = [[CCDirector sharedDirector] convertToGL: prevLocation];
    if (knockoutCount == 3 || heroTrappedChe) {
        return;
    }
    if(motherLevel!=1){
        if(!mouseWinChe&&!heroTrappedChe&&!firstRunningChe){
            int forwadeValue=(!forwardChe?0:heroForwardX);
            if(location.x>=screenHeroPosX-60+forwadeValue && location.x <= screenHeroPosX+40+forwadeValue && location.y>screenHeroPosY-30&&location.y<screenHeroPosY+18){
                if(!jumpingChe&&!dragChe&&!runningChe&&heroStandChe){
                    heroJumpLocationChe=YES;
                    dragChe=YES;
                    heroStandChe=NO;
                    [self heroAnimationFunc:0 animationType:@"jump"];
                    mouseDragSprite.visible=YES;
                    if(!forwardChe){
                        mouseDragSprite.position=ccp(platformX+2,platformY+3);
                        mouseDragSprite.rotation=(180-0)-170;
                    }else{
                        mouseDragSprite.rotation=(180-180)-170;
                        mouseDragSprite.position=ccp(platformX-2+heroForwardX,platformY+3);
                    }
                    startVect = b2Vec2(location.x, location.y);
                    activeVect = startVect - b2Vec2(location.x, location.y);
                    jumpAngle = fabsf( CC_RADIANS_TO_DEGREES( atan2f(-activeVect.y, activeVect.x)));
                }
            }else{
                if(!jumpingChe&&!landingChe){
                    if((location.x<70 || location.x>winSize.width-70) && location.y < 70){
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
    }else{
        if(!jumpingChe&&!landingChe&&!firstRunningChe){
            if(!runningChe&&!mouseWinChe&&!heroTrappedChe){
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

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    if (knockoutCount == 3 || heroTrappedChe) {
        return;
    }
    if(!jumpingChe&&!runningChe&&heroJumpLocationChe&&!mouseWinChe&&motherLevel!=1&&!heroTrappedChe&&!firstRunningChe){
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
        return;
    }
    if(motherLevel!=1){
        if(!mouseWinChe&&!heroTrappedChe&&!firstRunningChe){
            if(!jumpingChe&&!runningChe&&heroJumpLocationChe){
                heroJumpLocationChe=NO;
                saveDottedPathCount=0;
                jumpPower = activeVect.Length();
                activeVect = startVect - b2Vec2(location.x, location.y);
                jumpAngle = fabsf( CC_RADIANS_TO_DEGREES( atan2f(-activeVect.y, activeVect.x)));
                jumpingChe=YES;
                dragChe=NO;
                mouseDragSprite.visible=NO;
                for (int i = 0; i < 20; i=i+1) {
                    heroPimpleSprite[i].position=ccp(-100,100);
                }
                if(gameFunc.movePlatformChe)
                    gameFunc.movePlatformChe=NO;
                if(gameFunc.trigoVisibleChe)
                    gameFunc.trigoVisibleChe=NO;
            }else if(!jumpingChe&&!landingChe){
                if(runningChe){
                    heroStandChe=YES;
                    runningChe=NO;
                    heroRunSprite.visible=NO;
                    heroSprite.visible=YES;
                }
            }
            if(gameFunc.trigoVisibleChe&&gameFunc.trigoRunningCheck)
                gameFunc.trigoRunningCheck=NO;
        }
    }else{
        if(!jumpingChe&&!landingChe&&!firstRunningChe){
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
        [[CCDirector sharedDirector] replaceScene:[BossCatLevel15C scene]];
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
    //    [gameFunc jumpingRender:(platformX + gameFunc.xPosition)/2 yPosition:gameFunc.yPosition fChe:forwardChe];
    //    for (int i = 1; i<=5 ; i++) {
    //
    //    }
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

-(BOOL)levelView{
    DB *db = [DB new];
    NSString *lStr=[db getSettingsFor:@"MotherLevelShow"];
    NSMutableString *string1 = [NSMutableString stringWithString:lStr];
    NSString *aStr=@"";
    BOOL rChValue=NO;
    
    for(int i=0;i<14;i++){
        if(i==(motherLevel-1)){
            NSString *string2=[string1 substringWithRange: NSMakeRange (i, 1)];
            if([string2 isEqualToString:@"n"]){
                rChValue=YES;
                aStr=[aStr stringByAppendingString:@"y"];
            }
            
        }else {
            NSString *string2=[string1 substringWithRange: NSMakeRange (i, 1)];
            aStr=[aStr stringByAppendingString:string2];
        }
    }
    if(rChValue)
        [db setSettingsFor:@"MotherLevelShow" withValue:aStr];
    [db release];
    
    return rChValue;
}

-(void) dealloc {
    [super dealloc];
}


@end
