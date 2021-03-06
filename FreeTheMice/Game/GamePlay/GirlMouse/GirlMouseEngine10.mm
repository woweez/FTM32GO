//
//  HelloWorldLayer.mm
//  Tap
//
//  Created by karthik g on 27/09/12.
//  Copyright karthik g 2012. All rights reserved.
//

// Import the interfaces
#import "GirlMouseEngine10.h"
#import "LevelScreen.h"
#import "FTMUtil.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "DB.h"
#import "FTMConstants.h"

enum {
    kTagParentNode = 1,
};

GirlMouseEngineMenu10 *gLayer10;

@implementation GirlMouseEngineMenu10


-(id) init {
    if( (self=[super init])) {
    }
    return self;
}
@end

@implementation GirlMouseEngine10

@synthesize tileMap = _tileMap;
@synthesize background = _background;

+(CCScene *) scene {
    CCScene *scene = [CCScene node];
    gLayer10=[GirlMouseEngineMenu10 node];
    [scene addChild:gLayer10 z:1];
    
    GirlMouseEngine10 *layer = [GirlMouseEngine10 node];
    [scene addChild: layer];
    
    return scene;
}

-(id) init
{
    if( (self=[super init])) {
        
        heroJumpIntervalValue = [[NSArray alloc] initWithObjects:@"0",@"4",@"7",@"9",@"12",@"14",@"0",@"15",@"18",@"21",nil];
        cheeseSetValue= [[NSArray alloc] initWithObjects:@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",nil];
        cheeseArrX=[[NSArray alloc] initWithObjects:@"0",@"20",@"0",   @"20",@"10",nil];
        cheeseArrY=[[NSArray alloc] initWithObjects:@"0",@"0", @"-15", @"-15",@"-8",nil];
        heroRunningStopArr=[[NSArray alloc] initWithObjects:@"80",@"80",@"80", @"40",@"140",@"80",@"80",@"80",@"80",@"80",@"80",@"80",@"40",@"80",nil];
        freezeArr=[[NSArray alloc] initWithObjects:@"430",@"590",@"430",@"513",@"513",@"590",nil];
        winSize = [CCDirector sharedDirector].winSize;
        gameFunc=[[GirlGameFunc alloc] init];
        soundEffect=[[sound alloc] init];
        trigo=[[Trigo alloc] init];
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
        
        
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"bridge_background.tmx"];
        self.background = [_tileMap layerNamed:@"bridge_background"];
        if ([FTMUtil sharedInstance].isRetinaDisplay) {
            self.background.scale = 2;
        }
        _tileMap.position=ccp(0,-158);
        _tileMap.scaleY=1.3;
        [self addChild:_tileMap z:-1 tag:1];
        
        
        
        cache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [cache addSpriteFramesWithFile:@"girl_default.plist"];
        spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"girl_default.png"];
        [self addChild:spriteSheet z:10];
        
        
        heroRunSprite = [CCSprite spriteWithSpriteFrameName:@"girl_run1.png"];
        heroRunSprite.position = ccp(200, 200);
        heroRunSprite.scale=0.65;
        [spriteSheet addChild:heroRunSprite];
        
        NSMutableArray *animFrames = [NSMutableArray array];
        for(int i = 1; i < 8; i++) {
            CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"girl_run%d.png",i]];
            [animFrames addObject:frame];
        }
        CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.07f];
        [heroRunSprite runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation]]];
        
        
        catCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [catCache addSpriteFramesWithFile:@"cat_default.plist"];
        catSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"cat_default.png"];
        [self addChild:catSpriteSheet z:1];
        
        mouseDragSprite=[CCSprite spriteWithFile:@"mouse_drag.png"];
        mouseDragSprite.position=ccp(platformX+2,platformY+3);
        mouseDragSprite.scale=MICE_TAIL_SCALE;
        mouseDragSprite.visible=NO;
        mouseDragSprite.anchorPoint=ccp(0.99f, 0.9f);
        [self addChild:mouseDragSprite z:9];
        
        [self heroAnimationFunc:0 animationType:@"stand"];
        heroSprite.visible=NO;
        
        [self HeroDrawing];
        
        CCMenuItem *item1=[CCMenuItemImage itemWithNormalImage:@"play_screen_button_menu_1.png" selectedImage:@"play_screen_button_menu_2.png" target:self selector:@selector(clickMenuButton)];
        item1.position=ccp(0,0);
        
        menu=[CCMenu menuWithItems:item1, nil];
        menu.position=ccp(52,302);
        menu.visible = NO;
        [gLayer10 addChild:menu z:10];
        
        mouseTrappedBackground=[CCSprite spriteWithFile:@"mouse_trapped_background.png"];
        mouseTrappedBackground.position=ccp(240,160);
        mouseTrappedBackground.visible=NO;
        [gLayer10 addChild:mouseTrappedBackground z:10];
        
        CCMenuItem *aboutMenuItem = [CCMenuItemImage itemWithNormalImage:@"main_menu_button_1.png" selectedImage:@"main_menu_button_2.png" target:self selector:@selector(clickLevel:)];
        aboutMenuItem.tag=2;
        
        CCMenuItem *optionMenuItem = [CCMenuItemImage itemWithNormalImage:@"try_again_button_1.png" selectedImage:@"try_again_button_2.png" target:self selector:@selector(clickLevel:)];
        optionMenuItem.tag=1;
        
        menu2 = [CCMenu menuWithItems: optionMenuItem,aboutMenuItem,  nil];
        [menu2 alignItemsHorizontallyWithPadding:4.0];
        menu2.position=ccp(241,136);
        menu2.visible=NO;
        [gLayer10 addChild: menu2 z:10];
        
        clockBackgroundSprite=[CCSprite spriteWithFile:@"clock_background.png"];
        clockBackgroundSprite.position=ccp(-100,258);
        clockBackgroundSprite.scale=0.5;
        [gLayer10 addChild:clockBackgroundSprite z:0];
        
        clockArrowSprite=[CCSprite spriteWithFile:@"clock_arrow.png"];
        clockArrowSprite.position=ccp(-100,258);
        clockArrowSprite.scale=0.5;
        clockArrowSprite.anchorPoint=ccp(0.2f, 0.2f);
        clockArrowSprite.rotation=-40;
        [gLayer10 addChild:clockArrowSprite z:0];
        
        
        progressBarBackSprite=[CCSprite spriteWithFile:@"grey_bar_57.png"];
        progressBarBackSprite.position=ccp(240,300);
        progressBarBackSprite.visible = NO;
        [gLayer10 addChild:progressBarBackSprite z:10];
        
        cheeseCollectedSprite=[CCSprite spriteWithFile:@"cheese_collected.png"];
        cheeseCollectedSprite.position=ccp(430,300);
        cheeseCollectedSprite.visible = NO;
        [gLayer10 addChild:cheeseCollectedSprite z:10];
        
        timeCheeseSprite=[CCSprite spriteWithFile:@"time_cheese.png"];
        timeCheeseSprite.position=ccp(121+240,301);
        timeCheeseSprite.visible = NO;
        [gLayer10 addChild:timeCheeseSprite z:10];
        
        
        lifeMinutesAtlas = [[CCLabelAtlas labelWithString:@"01.60" charMapFile:@"numbers.png" itemWidth:15 itemHeight:20 startCharMap:'.'] retain];
        lifeMinutesAtlas.visible = NO;
        lifeMinutesAtlas.position=ccp(250,292);
        [gLayer10 addChild:lifeMinutesAtlas z:10];
        
        
        cheeseCollectedAtlas = [[CCLabelAtlas labelWithString:@"0/3" charMapFile:@"numbers.png" itemWidth:15 itemHeight:20 startCharMap:'.'] retain];
        cheeseCollectedAtlas.visible = NO;
        cheeseCollectedAtlas.position=ccp(422,292);
        cheeseCollectedAtlas.scale=0.8;
        [gLayer10 addChild:cheeseCollectedAtlas z:10];
        [cheeseCollectedAtlas setString:[NSString stringWithFormat:@"%d/%d",0,[cheeseSetValue[motherLevel-1] intValue]]];
        
        for(int i=0;i<cheeseCount;i++){
            cheeseCollectedChe[i]=YES;
            cheeseSprite[i]=[CCSprite spriteWithFile:@"Cheese.png"];
            cheeseSprite[i].position=[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i];
            [self playStaticCheeseAnimation:cheeseSprite[i]];
            [self addChild:cheeseSprite[i] z:9];
            cheeseSprite[i].scale = CHEESE_SCALE;
        }
        
        
        CCLabelAtlas *bridgeAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"fridge_platform.png" itemWidth:395 itemHeight:49 startCharMap:'0'] retain];
        bridgeAtlas.position=ccp(-25,154);
        [self addChild:bridgeAtlas z:0];
        bridgeAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"fridge_platform.png" itemWidth:395 itemHeight:49 startCharMap:'0'] retain];
        bridgeAtlas.position=ccp(349,154);
        [self addChild:bridgeAtlas z:0];
        bridgeAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"fridge_platform.png" itemWidth:395 itemHeight:49 startCharMap:'0'] retain];
        bridgeAtlas.position=ccp(724,154);
        [self addChild:bridgeAtlas z:0];
        
        bridgeAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"fridge_platform.png" itemWidth:395 itemHeight:49 startCharMap:'0'] retain];
        bridgeAtlas.position=ccp(-25,54);
        [self addChild:bridgeAtlas z:0];
        bridgeAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"fridge_platform.png" itemWidth:395 itemHeight:49 startCharMap:'0'] retain];
        bridgeAtlas.position=ccp(349,54);
        [self addChild:bridgeAtlas z:0];
        bridgeAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"fridge_platform.png" itemWidth:395 itemHeight:49 startCharMap:'0'] retain];
        bridgeAtlas.position=ccp(724,54);
        [self addChild:bridgeAtlas z:0];
        
        CCSprite *bridgeSprite=[CCSprite spriteWithFile:@"fridge_platform2.png"];
        bridgeSprite.position=ccp(92,340);
        [self addChild:bridgeSprite z:0];
        
        bridgeSprite=[CCSprite spriteWithFile:@"fridge_platform2.png"];
        bridgeSprite.position=ccp(496,320);
        [self addChild:bridgeSprite z:0];
        
        bridgeSprite=[CCSprite spriteWithFile:@"fridge_platform2.png"];
        bridgeSprite.position=ccp(904,340);
        [self addChild:bridgeSprite z:0];
        
        bridgeSprite=[CCSprite spriteWithFile:@"fridge_platform2.png"];
        bridgeSprite.position=ccp(92,510);
        [self addChild:bridgeSprite z:0];
        
        bridgeSprite=[CCSprite spriteWithFile:@"fridge_platform.png"];
        bridgeSprite.position=ccp(518,490);
        bridgeSprite.scaleX=0.8;
        [self addChild:bridgeSprite z:0];
        
        bridgeSprite=[CCSprite spriteWithFile:@"fridge_platform2.png"];
        bridgeSprite.position=ccp(938,550);
        [self addChild:bridgeSprite z:0];
        
        
        CCSprite *holeSprite=[CCSprite spriteWithFile:@"bridge_hole.png"];
        holeSprite.position=ccp(973,605);
        [self addChild:holeSprite z:0];
        
        
        switchAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"switch.png" itemWidth:40 itemHeight:103 startCharMap:'0'] retain];
        switchAtlas.position=ccp(417,543);
        switchAtlas.scale=0.7;
        [self addChild:switchAtlas z:1];
        
        switchAtlas2 = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"switch.png" itemWidth:40 itemHeight:103 startCharMap:'0'] retain];
        switchAtlas2.position=ccp(500,543);
        switchAtlas2.scale=0.7;
        [self addChild:switchAtlas2 z:1];
        
        switchAtlas3 = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"switch.png" itemWidth:40 itemHeight:103 startCharMap:'0'] retain];
        switchAtlas3.position=ccp(577,543);
        switchAtlas3.scale=0.7;
        [self addChild:switchAtlas3 z:1];
        
        CCSprite *combSprite=[CCSprite spriteWithFile:@"c.png"];
        combSprite.position=ccp(427,523);
        combSprite.scale = 0.4;
        [self addChild:combSprite z:1];
        
        combSprite=[CCSprite spriteWithFile:@"a.png"];
        combSprite.position=ccp(510,523);
        combSprite.scale = 0.4;
        [self addChild:combSprite z:1];
        
        combSprite=[CCSprite spriteWithFile:@"b.png"];
        combSprite.position=ccp(587,523);
        combSprite.scale = 0.4;
        [self addChild:combSprite z:1];
        
        CCSprite *sprite=[CCSprite spriteWithFile:@"ice_box.png"];
        sprite.position=ccp(530,350);
        sprite.opacity=200;
        [self addChild:sprite z:10];
        
        CCSprite *bridgeObjectSprite=[CCSprite spriteWithFile:@"bridge_object3.png"];
        bridgeObjectSprite.position=ccp(490,190);
        [self addChild:bridgeObjectSprite z:1];
        
        for(int i=0;i<10;i++){
            for(int j=0;j<2;j++){
                iceSmokingSprite[i][j]=[CCSprite spriteWithFile:@"ice_smoke.png"];
                iceSmokingSprite[i][j].position=ccp(-100,258);
                [self addChild:iceSmokingSprite[i][j] z:1];
                
                iceSmokingSprite2[i][j]=[CCSprite spriteWithFile:@"ice_smoke.png"];
                iceSmokingSprite2[i][j].position=ccp(-100,258);
                [self addChild:iceSmokingSprite2[i][j] z:1];
            }
        }
        for(int i=0;i<6;i++){
            iceQubeSprite[i]=[CCSprite spriteWithFile:@"ice_qube.png"];
            iceQubeSprite[i].position=ccp(-107,525);
            //iceQubeSprite[i].rotation=arc4random() % 360 + 1;
            [self addChild:iceQubeSprite[i] z:1];
        }
        
        for(int i=0;i<2;i++){
            for(int j=0;j<2;j++){
                combinationFreezeSprite[i][j]=[CCSprite spriteWithFile:@"ice_smoke.png"];
                combinationFreezeSprite[i][j].position=ccp(-107,525);
                combinationFreezeSprite[i][j].rotation=arc4random() % 360 + 1;
                [self addChild:combinationFreezeSprite[i][j] z:1];
            }
        }
        for(int i=0;i<25;i++){
            heroPimpleSprite[i]=[CCSprite spriteWithFile:@"dotted.png"];
            heroPimpleSprite[i].position=ccp(-100,160);
            heroPimpleSprite[i].scale=0.3;
            [self addChild:heroPimpleSprite[i] z:10];
        }
        
        CCSprite *freezeWindowSprite=[CCSprite spriteWithFile:@"freeze_window.png"];
        freezeWindowSprite.position=ccp(945,223);
        [self addChild:freezeWindowSprite z:0];
        
        freezeWindowSprite=[CCSprite spriteWithFile:@"freeze_window2.png"];
        freezeWindowSprite.position=ccp(90,393);
        freezeWindowSprite.scale=0.5;
        [self addChild:freezeWindowSprite z:0];
        
        freezeWindowSprite=[CCSprite spriteWithFile:@"freeze_window.png"];
        freezeWindowSprite.position=ccp(430,543);
        [self addChild:freezeWindowSprite z:0];
        
        freezeWindowSprite=[CCSprite spriteWithFile:@"freeze_window.png"];
        freezeWindowSprite.position=ccp(513,543);
        [self addChild:freezeWindowSprite z:0];
        
        freezeWindowSprite=[CCSprite spriteWithFile:@"freeze_window.png"];
        freezeWindowSprite.position=ccp(590,543);
        [self addChild:freezeWindowSprite z:0];
        
        CCSprite *pieSprite2=[CCSprite spriteWithFile:@"pie.png"];
        pieSprite2.position=ccp(870,343);
        [self addChild:pieSprite2 z:0];
        
        pieSprite=[CCSprite spriteWithFile:@"pie_ice.png"];
        pieSprite.position=ccp(870,343);
        [self addChild:pieSprite z:9];
        
        iceBlastAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"ice_blast.png" itemWidth:100 itemHeight:50 startCharMap:'0'] retain];
        iceBlastAtlas.position=ccp(-270,200);
        [self addChild:iceBlastAtlas z:9];
        
        //===================================================================
        
        dotSprite=[CCSprite spriteWithFile:@"dotted.png"];
        dotSprite.position=ccp(580,210);
        dotSprite.scale=0.2;
        [self addChild:dotSprite z:10];
        [self addHudLayerToTheScene];
        [self starCheeseSpriteInitilized];
        [self scheduleFridgeMotorFallSound];
        [self scheduleUpdate];
        
    }
    return self;
}
-(void) addHudLayerToTheScene{
    hudLayer = [[HudLayer alloc] init];
    hudLayer.tag = 10;
    [gLayer10 addChild: hudLayer z:2000];
    [hudLayer updateNoOfCheeseCollected:0 andMaxValue:[cheeseSetValue[motherLevel-1] intValue]];
}

-(void) addLevelCompleteLayerToTheScene{
    [self levelCompleted :10];
}

-(void)initValue{
    
//    DB *db = [DB new];
    motherLevel = 10;//[[db getSettingsFor:@"CurrentLevel"] intValue];
//    [db release];
    cheeseCount=[cheeseSetValue[motherLevel-1] intValue];
    
    platformX=550;
    platformY=535;
    
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
    catMovementCount=20;
    plateAnimationReleaseCount2=1;
    turnAnimationCount2=1;
    catBackChe2=YES;
    catMovementCount2=640;
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
    [self level05];
    if(!gameFunc.trappedChe)
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
    [self collisionFunc];
    [self iceQubeAnimation];
    
    if(visibleCount>=1){
        visibleCount+=15;
        if(visibleCount>=249){
            visibleCount=249;
        }
    }
    
    if(gameFunc.trigoVisibleChe){
        heroSprite.rotation=-gameFunc.trigoHeroAngle;
        heroRunSprite.rotation=-gameFunc.trigoHeroAngle;
    }
}



-(void)collisionFunc{
    CGFloat hx=heroSprite.position.x;
    CGFloat hy=heroSprite.position.y;
    int iValue=(forwardChe?43:0);
    
    if(hx-iValue>380&& hx-iValue<440 && hy> 560 && hy<590&&combJumpChe){
        if ([[switchAtlas string] isEqualToString:@"0"]){
            [soundEffect switchSound];
        }
        [switchAtlas setString:@"1"];
        if(combinationValue==0&&combinationValue2==0&&combinationValue3==0){
            combinationValue=1;
        }
        if(combinationValue2==1)
            combinationValue2=2;
        if(combinationValue3==1)
            combinationValue3=2;
        combJumpChe=NO;
    }
    if(hx-iValue>463&& hx-iValue<523 && hy> 560 && hy<590&&combJumpChe){
        if ([[switchAtlas2 string] isEqualToString:@"0"]){
            [soundEffect switchSound];
        }
        [switchAtlas2 setString:@"1"];
        if(combinationValue==1){
            combinationValue=0;
            if ([[switchAtlas string] isEqualToString:@"1"]){
                [soundEffect correct_switch];
            }
            [switchAtlas setString:@"0"];
            combinationValue2=1;
        }else if(combinationValue == 2){
            combinationValue=3;
        }else if(combinationValue == 0 && combinationValue2==0 && combinationValue3 == 0){
            combinationValue2=1;
        }
        if(combinationValue3==2)
            combinationValue3=3;
        else if(combinationValue3==1){
            combinationValue3=0;
            if ([[switchAtlas3 string] isEqualToString:@"1"]){
                [soundEffect correct_switch];
            }
            [switchAtlas3 setString:@"0"];
            combinationValue2=1;
        }
        combJumpChe=NO;
    }
    if(hx-iValue>540&& hx-iValue<600 && hy> 560 && hy<590&&combJumpChe){
        if ([[switchAtlas3 string] isEqualToString:@"0"]){
            [soundEffect switchSound];
        }
        [switchAtlas3 setString:@"1"];
        if(combinationValue==1){
            combinationValue=2;
        }
        if(combinationValue2==2)
            combinationValue2=3;
        if(combinationValue2==1){
            combinationValue2=0;
            if ([[switchAtlas2 string] isEqualToString:@"1"]){
                [soundEffect correct_switch];
            }
            [switchAtlas2 setString:@"0"];
        }
        
        if(combinationValue==0&&combinationValue2==0&&combinationValue3==0){
            combinationValue3=1;
        }
        combJumpChe=NO;
    }
    
    if (![FTMUtil sharedInstance].isInvincibilityOn) {
        
        for(int i=0;i<6;i++){
            if(hx-iValue>iceQubeSprite[i].position.x-90 &&hx-iValue<iceQubeSprite[i].position.x-30 &&hy > iceQubeSprite[i].position.y-30 &&hy<iceQubeSprite[i].position.y+20 &&!gameFunc.trappedChe){
                gameFunc.trappedChe=YES;
                trappedTypeValue=1;
            }
        }
        
        for(int i=0;i<10;i++){
            for(int j=0;j<2;j++){
                if(hx-iValue>iceSmokingSprite[i][j].position.x-70 &&hx-iValue<iceSmokingSprite[i][j].position.x-20 &&hy > iceSmokingSprite[i][j].position.y-30 &&hy<iceSmokingSprite[i][j].position.y+20 &&!gameFunc.trappedChe){
                    gameFunc.trappedChe=YES;
                    trappedTypeValue=1;
                }
                if(hx-iValue>iceSmokingSprite2[i][j].position.x-70 &&hx-iValue<iceSmokingSprite2[i][j].position.x-20 &&hy > iceSmokingSprite2[i][j].position.y-30 &&hy<iceSmokingSprite2[i][j].position.y+20 &&!gameFunc.trappedChe){
                    gameFunc.trappedChe=YES;
                    trappedTypeValue=1;
                }
                
            }
        }
    }
    
}
-(void)iceQubeAnimation{
    for(int i=0;i<6;i++){
        CGFloat xx=0;
        CGFloat yy=0;
        if(iceQubeCount[i]!=0){
            if(iceQubeCount[i]<230){
                if (iceQubeCount[i] > 2 && iceQubeCount[i] < 4) {
                   [soundEffect ice_cubes_appear];
                }
                iceQubeCount[i]+=1.2;
                xx=[trigo circlex:iceQubeCount[i] a:359];
                yy=[trigo circley:iceQubeCount[i] a:359]+410;
            }else if(iceQubeCount[i]>=230&&iceQubeCount[i]<310){
                iceQubeCount[i]+=2.7;
                xx=[trigo circlex:25 a:90-(iceQubeCount[i]-230)]+288;
                yy=[trigo circley:25 a:90-(iceQubeCount[i]-230)]+379;
            }else{
                iceQubeCount[i]+=1.7;
                xx=[trigo circlex:iceQubeCount[i]-230 a:276]+308;
                yy=[trigo circley:iceQubeCount[i]-230 a:276]+483;
            }
        }
        if(iceQubeCount[i]>=560){
            [soundEffect ice_cubes_fall];
            iceBlastAnimationCount=1;
            iceBlastAtlas.position=ccp(xx-125,yy+100);
            iceQubeCount[i]=0;
            //iceQubeSprite[i].rotation=arc4random() % 360 + 1;
        }
        iceQubeSprite[i].position=ccp(xx-70,yy+115);
        
    }
    if(iceQubeReleaseCount==0){
        for(int i=0;i<6;i++){
            if(iceQubeCount[i]==0){
                iceQubeCount[i]=1;
                break;
            }
        }
    }
    
    iceQubeReleaseCount+=1;
    if(iceQubeReleaseCount>30){
        iceQubeReleaseCount=0;
    }
    
    
    if(iceBlastAnimationCount>=1){
        iceBlastAnimationCount+=3;
        if(iceBlastAnimationCount>=90){
            iceBlastAnimationCount=90;
            iceBlastAtlas.position=ccp(-200,100);
        }
        [iceBlastAtlas setString:[NSString stringWithFormat:@"%d",iceBlastAnimationCount/10]];
    }
    
    //Smoking
    for(int i=0;i<10;i++){
        for(int j=0;j<2;j++){
            if(iceSmokingCount[i][j]!=0){
                int xx=0;
                int yy=0;
                xx=[trigo circlex:25+(j*25) a:65-(iceSmokingCount[i][j]-230)]+930;
                yy=[trigo circley:130 a:65-(iceSmokingCount[i][j]-230)]+372;
                
                iceSmokingSprite[i][j].position=ccp(xx,yy);
                iceSmokingSprite[i][j].scale=(iceSmokingCount[i][j]/25.0)+0.1;
                iceSmokingSprite[i][j].opacity=(250-(iceSmokingCount[i][j]*2.5));
                iceSmokingCount[i][j]+=0.8;
                if(iceSmokingCount[i][j]>=100){
                    iceSmokingCount[i][j]=0;
                }
            }
        }
    }
    
    
    if((combinationValue3==4?NO:YES)){
        iceSmokingReleaseCount+=1;
        if(iceSmokingReleaseCount>=14){
            iceSmokingReleaseCount=0;
            for(int i=0;i<10;i++){
                if(iceSmokingCount[i][0]==0){
                    iceSmokingCount[i][0]=1;
                    iceSmokingCount[i][1]=1;
                    break;
                }
            }
        }
        pieScaleCount+=1.0;
        pieScaleCount=(pieScaleCount>=230?230:pieScaleCount);
        pieSprite.opacity=pieScaleCount;
    }else{
        pieScaleCount-=1.0;
        pieScaleCount=(pieScaleCount<=0?0:pieScaleCount);
        pieSprite.opacity=pieScaleCount;
    }
    
    // Big Freezer
    for(int i=0;i<10;i++){
        for(int j=0;j<2;j++){
            if(iceSmokingCount2[i][j]!=0){
                int xx=0;
                int yy=0;
                xx=[trigo circlex:25 a:45-(iceSmokingCount2[i][j]-180)]+100+(j*30);
                yy=[trigo circley:70 a:65-(iceSmokingCount2[i][j]-180)]+462;
                
                iceSmokingSprite2[i][j].position=ccp(xx,yy);
                iceSmokingSprite2[i][j].scale=(iceSmokingCount2[i][j]/15.0)+0.1;
                iceSmokingSprite2[i][j].opacity=(250-(iceSmokingCount2[i][j]*2.5));
                iceSmokingCount2[i][j]+=0.8;
                if(iceSmokingCount2[i][j]>=100){
                    iceSmokingCount2[i][j]=0;
                }
            }
        }
    }
    
    if((combinationValue==4?NO:YES)){
        iceSmokingReleaseCount2+=1;
        if(iceSmokingReleaseCount2>=14){
            iceSmokingReleaseCount2=0;
            for(int i=0;i<10;i++){
                if(iceSmokingCount2[i][0]==0){
                    iceSmokingCount2[i][0]=1;
                    iceSmokingCount2[i][1]=1;
                    break;
                }
            }
        }
    }
    
    
    for(int i=0;i<2;i++){
        for(int j=0;j<2;j++){
            if(combinationFreezeCount[i]!=0){
                int xx=0;
                int yy=0;
                if(combinationFreezeCount[i]<100){
                    xx=[trigo circlex:1 a:-(combinationFreezeCount[i]-250)]+[freezeArr[(freezeArrCount*2)+j] intValue];
                    yy=[trigo circley:50 a:-(combinationFreezeCount[i]-250)]+600;
                    
                    combinationFreezeSprite[i][j].position=ccp(xx,yy);
                    combinationFreezeSprite[i][j].scale=(combinationFreezeCount[i]/40.0)+0.1;
                    combinationFreezeSprite[i][j].opacity=(250-(combinationFreezeCount[i]*2.5));
                }
            }
        }
        combinationFreezeCount[i]+=3.0;
        if(combinationFreezeCount[i]>=100){
            combinationFreezeCount[i]=0;
            if(combinationInterValCount==0){
                freezeArrCount+=1;
                freezeArrCount=(freezeArrCount>=3?0:freezeArrCount);
                combinationInterValCount=1;
            }
        }
    }
    
    if(combinationInterValCount>=1){
        combinationInterValCount+=1;
        if(combinationInterValCount>=250){
            combinationInterValCount=0;
        }
    }
}
-(void)switchFunc{
    
    if(gameFunc.switchCount==1){
        gameFunc.switchCount=2;
        [self startClockTimer];
//        clockArrowSprite.position=ccp(450,258);
//        clockBackgroundSprite.position=ccp(450,258);
        
    }else if(gameFunc.switchCount>=1){
        gameFunc.switchCount+=1;
        if(gameFunc.switchCount%30==0)
            clockArrowSprite.rotation=((gameFunc.switchCount/60)*24)-40;
        if(gameFunc.switchCount/30>30){
            clockBackgroundSprite.position=ccp(-100,258);
            clockArrowSprite.position=ccp(-100,258);
//            if (newClockSprite != nil) {
//                [newClockSprite removeFromParentAndCleanup:YES];
//                newClockSprite = nil;
//            }
            gameFunc.switchCount=0;
            combinationValue=0;
            combinationValue2=0;
            combinationValue3=0;
            [switchAtlas setString:@"0"];
            [switchAtlas2 setString:@"0"];
            [switchAtlas3 setString:@"0"];
            screenMovementFindValue=0;
        }
    }
    
    
    if(screenMoveChe){
        if(screenMovementFindValue==1){
            screenShowX-=5;
            if(screenShowX<250){
                screenShowX=250;
                screenMovementFindValue=2;
            }
        }else if(screenMovementFindValue==2){
            screenShowY-=5;
            if(screenShowY<300){
                screenShowY=300;
                combinationValue=4;
                if(iceSmokingCount2[0][0]==0){
                    screenMovementFindValue=3;
                }
            }
        }else if(screenMovementFindValue==3){
            screenShowY+=5;
            if(screenShowY>screenShowY2){
                screenShowY=screenShowY2;
                screenMovementFindValue=4;
            }
        }else if(screenMovementFindValue == 4){
            screenShowX+=5;
            if(screenShowX>=screenShowX2){
                screenShowX=screenShowX2;
                screenMoveChe=NO;
                screenHeroPosX=platformX;
                screenHeroPosY=platformY;
                screenShowX=platformX;
                screenShowY=platformY;
                screenMovementFindValue=5;
                gameFunc.switchCount=1;
            }
        }
        
        if(!combinationPosChe2){
            if(screenMovementFindValue2==1){
                screenShowX-=5;
                if(screenShowX<400){
                    screenShowX=400;
                    screenMovementFindValue2=2;
                }
            }else if(screenMovementFindValue2==2){
                screenShowY-=5;
                if(screenShowY<240){
                    screenShowY=240;
                        screenMovementFindValue2=3;
                }
            }else if(screenMovementFindValue2==3){
                screenShowY+=5;
                if(screenShowY>screenShowY2){
                    screenShowY=screenShowY2;
                    screenMovementFindValue2=4;
                }
            }else if(screenMovementFindValue2 == 4){
                screenShowX+=5;
                if(screenShowX>=screenShowX2){
                    screenShowX=screenShowX2;
                    screenMoveChe=NO;
                    screenHeroPosX=platformX;
                    screenHeroPosY=platformY;
                    screenShowX=platformX;
                    screenShowY=platformY;
                    screenMovementFindValue2=5;
                    gameFunc.switchCount=1;
                }
            }
        }else{
            if(screenMovementFindValue2==1){
                screenShowX-=5;
                if(screenShowX<400){
                    screenShowX=400;
                    screenMovementFindValue2=2;
                }
            }else if(screenMovementFindValue2==2){
                screenShowX+=5;
                if(screenShowX>=screenShowX2){
                    screenShowX=screenShowX2;
                    screenMoveChe=NO;
                    screenHeroPosX=platformX;
                    screenHeroPosY=platformY;
                    screenShowX=platformX;
                    screenShowY=platformY;
                    screenMovementFindValue2=5;
                    gameFunc.switchCount=1;
                }
            }
        }
        if(screenMovementFindValue3==1){
            screenShowX+=5;
            if(screenShowX>=750){
                screenShowX=750;
                screenMovementFindValue3=2;
            }
        }else if(screenMovementFindValue3 == 2){
            screenShowY-=5;
            if(screenShowY<=300){
                screenShowY=300;
                combinationValue3=4;
                thirdFreezeIntervalTimeCount+=1;
                if(thirdFreezeIntervalTimeCount>100){
                    thirdFreezeIntervalTimeCount=0;
                    screenMovementFindValue3=3;
                }
            }
        }else if(screenMovementFindValue3 == 3){
            screenShowY+=5;
            if(screenShowY>screenShowY2){
                screenShowY=screenShowY2;
                screenMovementFindValue3=4;
            }
        }else if(screenMovementFindValue3 == 4){
            screenShowX-=5;
            if(screenShowX<screenShowX2){
                screenShowX=screenShowX2;
                screenMovementFindValue3=5;
                screenMoveChe=NO;
                screenHeroPosX=platformX;
                screenHeroPosY=platformY;
                screenShowX=platformX;
                screenShowY=platformY;
                gameFunc.switchCount=1;
            }
        }

        
        CGPoint copyHeroPosition = ccp(screenShowX, screenShowY);
        [self setViewpointCenter:copyHeroPosition];
    }
}

-(void)level05{
    
    if(gameFunc.movePlatformChe){
        platformX=gameFunc.movePlatformX-gameFunc.landMoveCount+gameFunc.moveCount2;
        if(!forwardChe)
            heroSprite.position=ccp(platformX,platformY);
        else
            heroSprite.position=ccp(platformX+heroForwardX,platformY);
        
        CGPoint copyHeroPosition = ccp(platformX, platformY);
        [self setViewpointCenter:copyHeroPosition];
        if(heroJumpLocationChe){
            [self HeroLiningDraw:0];
        }
    }
    
    if(gateCount>=1) {
        gateCount+=0.1;
        gateCount=(gateCount>=35?35:gateCount);
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
    
    
    int fValue=(!forwardChe?0:30);
    if(heroSprite.position.x>=850+fValue && heroSprite.position.y>350 && heroSprite.position.y<=450&&!mouseWinChe&&!gameFunc.trappedChe){
        if(runningChe||heroStandChe){
            if (cheeseCollectedScore < 3 && locker.tag != 911) {
                [self playDoorLockAnimation:ccp(heroSprite.position.x, heroSprite.position.y)];
                locker.tag = 911;
            }else if(cheeseCollectedScore > 2){
                mouseWinChe=YES;
                heroStandChe=YES;
                runningChe=NO;
                heroRunSprite.visible=NO;
            }
        }
    }else if(locker.tag == 911){
        locker.tag = 1;
        locker.visible = NO;
    }else if(gameFunc.trappedChe){
        heroTrappedChe=YES;
        heroSprite.visible=NO;
        heroStandChe=NO;
        heroRunSprite.visible=NO;
    }
    if(gameFunc.trappedChe){
        if(heroTrappedChe&&heroTrappedCount ==100){
            [self showLevelFailedUI:motherLevel];
        }
    }
    
    
}
-(void)hotSmokingFunc{
    CGFloat sx=0;
    CGFloat sy=0;
    CGFloat hotScale=0;
    CGFloat divideLength=0;
    
    sx=570;
    sy=250;
    hotScale=0.7;
    divideLength=5.0;
    
    for(int i=0;i<5;i++){
        if(hotSmokingCount[i]>=1){
            hotSmokingCount[i]+=4.5;
            hotSprite[i].position=ccp(sx,sy+(hotSmokingCount[i]/divideLength));
            hotSprite[i].opacity=250-(hotSmokingCount[i]);
            hotSprite[i].scale=hotScale+(hotSmokingCount[i]/400.0);
            if(hotSmokingCount[i]>=250){
                hotSmokingCount[i]=0;
                hotSprite[i].position=ccp(-200,100);
            }
        }
    }
    
    
    if(hotSmokingRelease == 0&&screenMovementFindValue<2){
        for(int i=0;i<5;i++){
            if(hotSmokingCount[i]==0){
                hotSmokingCount[i]=1;
                hotSmokingRelease=1;
                break;
            }
        }
    }
    if(hotSmokingRelease>=1){
        hotSmokingRelease+=1;
        if(hotSmokingRelease>=12){
            hotSmokingRelease=0;
        }
    }
}

-(void)starCheeseSpriteInitilized{
   
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
            }
            
            int mValue=0;
            int mValue2=0;
            
            cheeseAnimationCount+=2;
            cheeseAnimationCount=(cheeseAnimationCount>=500?0:cheeseAnimationCount);
            CGFloat localCheeseAnimationCount=0;
            localCheeseAnimationCount=(cheeseAnimationCount<=250?cheeseAnimationCount:250-(cheeseAnimationCount-250));
            
            CGFloat cheeseX=[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].x;
            CGFloat cheeseY=[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].y;
            
            if(!forwardChe){
                if(heroX>=cheeseX-70-mValue &&heroX<=cheeseX+10-mValue&&heroY>cheeseY-20+mValue2&&heroY<cheeseY+30+mValue2){
                    [soundEffect cheeseCollectedSound];
                    cheeseCollectedChe[i]=NO;
                    cheeseSprite[i].visible=NO;
                    cheeseCollectedScore+=1;
                    [self playCheeseCollectedAnimation:cheeseSprite[i]];
                    break;
                }
            }else{
                if(heroX>=cheeseX-10-mValue &&heroX<=cheeseX+70-mValue&&heroY>cheeseY-20+mValue2&&heroY<cheeseY+30+mValue2){
                    [soundEffect cheeseCollectedSound];
                    cheeseCollectedChe[i]=NO;
                    cheeseSprite[i].visible=NO;
                    cheeseCollectedScore+=1;
                    [self playCheeseCollectedAnimation:cheeseSprite[i]];
                    break;
                }
            }
        }
    }
}

-(void)heroTrappedFunc{
    
    if(heroTrappedChe){
        heroTrappedCount+=1;
        if(heroTrappedCount==10){
            for (int i = 0; i < 20; i=i+1)
                heroPimpleSprite[i].position=ccp(-100,100);
            
            if(trappedTypeValue<=1){
                heroTrappedMove=1;
            }
            
            mouseDragSprite.visible=NO;
            heroTrappedSprite = [CCSprite spriteWithFile:@"gm_mist_0.png"];
            heroTrappedSprite.scale=0.5;
            if(!forwardChe)
                heroTrappedSprite.position = ccp(heroSprite.position.x , heroSprite.position.y+15);
            else
                heroTrappedSprite.position = ccp(heroSprite.position.x, heroSprite.position.y+15);
            
            heroTrappedSprite.scale=0.5;
            [self addChild:heroTrappedSprite z:1000];
            CCMoveTo *move = [CCMoveTo actionWithDuration:1 position:ccp(heroTrappedSprite.position.x, 190)];
            [heroTrappedSprite runAction:move];
            heroSprite.visible=NO;
        }
        if(heroTrappedMove!=0){
            int fValue = (forwardChe?heroForwardX:0);
            CGFloat xPos=0;
            if(trappedTypeValue== 1)
                xPos=heroSprite.position.x-(forwardChe?40:-40);
            
//            heroTrappedSprite.position = ccp(xPos,heroSprite.position.y-heroTrappedMove);
            CGPoint copyHeroPosition = ccp(heroSprite.position.x-fValue, heroSprite.position.y-heroTrappedMove);
            [self setViewpointCenter:copyHeroPosition];
            if(trappedTypeValue == 1){
                heroTrappedMove+=2;
                if(heroSprite.position.y-heroTrappedMove<=190)
                    heroTrappedMove=0;
            }
        }
    }
}
-(void)heroWinFunc{
    if (isLevelCompleted) {
        return;
    }
    if(mouseWinChe&&!gameFunc.trappedChe){
        heroWinCount+=1;
        if(heroWinCount==15){
            heroWinSprite = [CCSprite spriteWithSpriteFrameName:@"girl_win1.png"];
            heroWinSprite.scale = GIRL_SCALE;
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
        if(gameFunc.movePlatformChe){
            if(!forwardChe){
                gameFunc.movePlatformX+=2.2;
                platformX=gameFunc.movePlatformX-gameFunc.landMoveCount+gameFunc.moveCount2;
                [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
                platformX=gameFunc.xPosition;
            }else{
                gameFunc.movePlatformX-=2.2;
                platformX=gameFunc.movePlatformX-gameFunc.landMoveCount+gameFunc.moveCount2;
                [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
                platformX=gameFunc.xPosition;
            }
        }else{
            if(!forwardChe){
                if(!gameFunc.trigoVisibleChe){
                    platformX+=2.2;
                    [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
                    platformX=gameFunc.xPosition;
                    heroSprite.rotation=0;
                    heroRunSprite.rotation=0;
                }else{
                    int hValue=0;
                    if(trigoLeftLandChe)
                        hValue=13;
                    [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
                    platformX=gameFunc.xPosition;
                    platformY=gameFunc.yPosition-hValue;
                }
            }else{
                if(!gameFunc.trigoVisibleChe){
                    platformX-=2.2;
                    [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
                    platformX=gameFunc.xPosition;
                    heroSprite.rotation=0;
                    heroRunSprite.rotation=0;
                }else{
                    int hValue=0;
                    if(trigoLeftLandChe)
                        hValue=13;
                    [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
                    platformX=gameFunc.xPosition;
                    platformY=gameFunc.yPosition+13-hValue;
                }
            }
            if(gameFunc.trigoVisibleChe)
                dragTrigoCheckChe=forwardChe;
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
        if(gameFunc.stickyChe2){
            if(forwardChe){
                heroSprite.rotation=90;
                heroSprite.flipY=1;
                stickyYPos=-30;
            }else{
                heroSprite.rotation=-90;
                heroSprite.flipY=1;
                stickyYPos=-30;
            }
        }
        
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
        if(gameFunc.stickyChe)
            heroSprite.flipY=1;
    }
}
-(void)heroUpdateForwardPosFunc{
    
    
    if(!forwardChe){
        heroSprite.flipX=0;
        heroRunSprite.flipX=0;
        heroSprite.position=ccp(platformX,platformY+stickyYPos);
        heroRunSprite.position=ccp(platformX,platformY);
    }else{
        heroSprite.flipX=1;
        heroRunSprite.flipX=1;
        heroSprite.position=ccp(platformX+heroForwardX,platformY+stickyYPos);
        heroRunSprite.position=ccp(platformX+heroForwardX,platformY);
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
            if(heroJumpingAnimationCount<=14)
                heroJumpingAnimationCount+=1;
            
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
            CGFloat yy=platformY+point.y-(stickyJumpValue==1?15:0);
            
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
    
    if(gameFunc.trigoVisibleChe&&forwardChe&&!safetyJumpChe){
        //trigoLeftLandChe=YES;
        //trigoLeftLandChe2=YES;
    }
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
            if(gameFunc.visibleWindowChe&&visibleCount==0)
                visibleCount=1;
            
            if(stickyJumpValue==1)
                stickyJumpValue=0;
            
            if(gameFunc.stickyChe2){
                forwardChe=(forwardChe?NO:YES);
                stickyLandChe=forwardChe;
            }
            
            if(!screenMoveChe&&combinationValue==3&&screenMovementFindValue==0){
                screenMovementFindValue=1;
                screenShowX=platformX;
                screenShowY=platformY;
                screenShowX2=platformX;
                screenShowY2=platformY;
                screenMoveChe=YES;
            }else if(!screenMoveChe&&combinationValue2==3&&screenMovementFindValue2==0){
                screenMovementFindValue2=1;
                screenShowX=platformX;
                screenShowY=platformY;
                screenShowX2=platformX;
                screenShowY2=platformY;
                screenMoveChe=YES;
                if(heroSprite.position.y<300)
                    combinationPosChe2=YES;
            }else if(!screenMoveChe&&combinationValue3==3&&screenMovementFindValue3==0){
                screenMovementFindValue3=1;
                screenShowX=platformX;
                screenShowY=platformY;
                screenShowX2=platformX;
                screenShowY2=platformY;
                screenMoveChe=YES;
            }
        }
    }
}

-(void)HeroLiningDraw:(int)cPath{
    if(trigoLeftLandChe2){
        platformY-=13;
        trigoLeftLandChe2=NO;
    }
    CGFloat angle=jumpAngle;
    int tValue=0;
    int tValue2=0;
    int tValue3=0;
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
                    tValue=13;
                    tValue3=13;
                }else{
                    tValue=-13;
                    tValue3=0;
                }
                tValue2=0;
            }else{
                if(forwardChe){
                    tValue=23;
                    tValue3=0;
                }else{
                    tValue=0;
                    tValue3=-13;
                }
                tValue2=13;
            }
        }
    }
    int dValue=0;
    if(gameFunc.stickyChe){
        if(!forwardChe)
            angle=(angle>10?10:angle);
        else
            angle=(angle<170?170:angle);
        dValue=9;
    }
    
    jumpPower=(jumpPower>20.5?20.5:jumpPower);
    b2Vec2 impulse = b2Vec2(cosf(angle*3.14/180), sinf(angle*3.14/180));
    impulse *= (jumpPower/2.2)-0.6;
    
    heroBody->ApplyLinearImpulse(impulse, heroBody->GetWorldCenter());
    
    b2Vec2 velocity = heroBody->GetLinearVelocity();
    impulse *= -1;
    heroBody->ApplyLinearImpulse(impulse, heroBody->GetWorldCenter());
    velocity = b2Vec2(-velocity.x, velocity.y);
    
    int sDotValue=0;
    if(gameFunc.stickyChe2)
        sDotValue=(forwardChe?30:-30);
    
    for (int i = 0; i < 25&&!safetyJumpChe; i=i+1) {
        b2Vec2 point = [self getTrajectoryPoint:heroBody->GetWorldCenter() andStartVelocity:velocity andSteps:i*170 andAngle:angle];
        point = b2Vec2(-point.x, point.y);
        
        int lValue=(!forwardChe?35:-28);
        CGFloat xx=platformX+point.x+lValue+15+sDotValue;
        CGFloat yy=platformY+point.y+3-dValue-tValue;
        
        heroPimpleSprite[i].position=ccp(xx,yy);
    }
    if(!forwardChe){
        mouseDragSprite.position=ccp(platformX,platformY-11+tValue3);
        if(gameFunc.trigoVisibleChe)
            heroSprite.position=ccp(platformX+2,platformY+tValue3);
    }else{
        mouseDragSprite.position=ccp(platformX+heroForwardX,platformY-11+tValue3);
        if(gameFunc.trigoVisibleChe)
            heroSprite.position=ccp(platformX-2+heroForwardX,platformY+tValue3);
    }
    
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
        screenHeroPosY=position.y-60;
    else if(y>=_tileMap.mapSize.height-winSize.height/2)
        screenHeroPosY=(position.y-y)+winSize.height/2-60;
    
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/3);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    self.position = viewPoint;
}
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    CGPoint prevLocation = [myTouch previousLocationInView: [myTouch view]];
    prevLocation = [[CCDirector sharedDirector] convertToGL: prevLocation];
    
    if(!mouseWinChe&&!heroTrappedChe&&!screenMoveChe){
        
        int forwadeValue=(!forwardChe?0:heroForwardX);
        if(location.x>=screenHeroPosX-60+forwadeValue && location.x <= screenHeroPosX+40+forwadeValue && location.y>screenHeroPosY-30&&location.y<screenHeroPosY+18){
            if(!jumpingChe&&!dragChe&&!runningChe&&heroStandChe){
                heroJumpLocationChe=YES;
                dragChe=YES;
                heroStandChe=NO;
                [self heroAnimationFunc:0 animationType:@"jump"];
                if(gameFunc.stickyChe2){
                    if(forwardChe){
                        heroSprite.rotation=90;
                        heroSprite.flipY=1;
                        stickyYPos=-30;
                    }else{
                        heroSprite.rotation=-90;
                        heroSprite.flipY=1;
                        stickyYPos=-30;
                    }
                }
                
                mouseDragSprite.visible=YES;
                if(!forwardChe){
                    mouseDragSprite.position=ccp(platformX+10,platformY-11);
                    mouseDragSprite.rotation=(180-0)-170;
                }else{
                    mouseDragSprite.rotation=(180-180)-170;
                    mouseDragSprite.position=ccp(platformX-10+heroForwardX,platformY-11);
                }
                startVect = b2Vec2(location.x, location.y);
                activeVect = startVect - b2Vec2(location.x, location.y);
                jumpAngle = fabsf( CC_RADIANS_TO_DEGREES( atan2f(-activeVect.y, activeVect.x)));
                if(trigoLeftLandChe)
                    trigoLeftLandChe=NO;
            }
        }else{
            if((location.x<70 || location.x>winSize.width-70) && location.y < 70){

                if(!jumpingChe&&!landingChe&&!firstRunningChe&&!gameFunc.stickyChe2){
                    if(!runningChe){
                        if(screenHeroPosX+25<location.x)
                            forwardChe=NO;
                        else
                            forwardChe=YES;
                        runningChe=YES;
                        heroStandChe=NO;
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
    
    if(!jumpingChe&&!runningChe&&heroJumpLocationChe&&!mouseWinChe&&motherLevel!=1&&!heroTrappedChe&&!screenMoveChe){
        activeVect = startVect - b2Vec2(location.x, location.y);
        jumpAngle = fabsf( CC_RADIANS_TO_DEGREES( atan2f(-activeVect.y, activeVect.x)));
        if(gameFunc.stickyChe2){
            if(stickyLandChe){
                jumpAngle=(jumpAngle<90?90:jumpAngle);
            }else{
                jumpAngle=(jumpAngle>=90?89:jumpAngle);
            }
        }
        
        [self HeroLiningDraw:0];
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    if(!mouseWinChe&&!heroTrappedChe){
        if(!jumpingChe&&!runningChe&&heroJumpLocationChe&&!screenMoveChe){
            heroJumpLocationChe=NO;
            saveDottedPathCount=0;
            jumpPower = activeVect.Length();
            activeVect = startVect - b2Vec2(location.x, location.y);
            jumpAngle = fabsf( CC_RADIANS_TO_DEGREES( atan2f(-activeVect.y, activeVect.x)));
            jumpingChe=YES;
            dragChe=NO;
            [soundEffect girl_jump];
            mouseDragSprite.visible=NO;
            for (int i = 0; i < 25; i=i+1) {
                heroPimpleSprite[i].position=ccp(-100,100);
            }
            if(gameFunc.stickyChe){
                gameFunc.stickyChe=NO;
                gameFunc.movePlatformChe=NO;
                stickyJumpValue=1;
                gameFunc.stickyCount=1;
            }else{
                if(gameFunc.movePlatformChe)
                    gameFunc.movePlatformChe=NO;
            }
            if(gameFunc.trigoVisibleChe)
                gameFunc.trigoVisibleChe=NO;
            if(gameFunc.stickyChe2){
                gameFunc.stickyChe2=NO;
                gameFunc.stickyReleaseCount=1;
                stickyYPos=0;
            }
            combJumpChe=YES;
        }else if(!jumpingChe&&!landingChe&&!firstRunningChe){
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
}
-(void)clickMenuButton{
    [[CCDirector sharedDirector] replaceScene:[LevelScreen scene]];
}
-(void)clickLevel:(CCMenuItem *)sender {
    if(sender.tag == 1){
        [[CCDirector sharedDirector] replaceScene:[GirlMouseEngine10 scene]];
    }else if(sender.tag ==2){
        [[CCDirector sharedDirector] replaceScene:[LevelScreen scene]];
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
-(CGFloat)platesMovingpath:(int)cValue position:(int)pValue{
    
    CGFloat angle=2;
    
    b2Vec2 impulse = b2Vec2(cosf(angle*3.14/180), sinf(angle*3.14/180));
    impulse *= 14.6;
    
    heroBody->ApplyLinearImpulse(impulse, heroBody->GetWorldCenter());
    
    b2Vec2 velocity = heroBody->GetLinearVelocity();
    impulse *= -1;
    heroBody->ApplyLinearImpulse(impulse, heroBody->GetWorldCenter());
    velocity = b2Vec2(-velocity.x, velocity.y);
    
    b2Vec2 point = [self getTrajectoryPoint:heroBody->GetWorldCenter() andStartVelocity:velocity andSteps:cValue*15 andAngle:angle];
    point = b2Vec2(-point.x+(point.x/1.5), point.y+(point.y/1.5));
    
    int lValue=65;
    CGFloat xx=150+point.x+lValue-20;
    CGFloat yy=450+point.y+12;
    
    return (pValue==0?xx:yy);
}


-(void) dealloc {
    [super dealloc];
}


@end
