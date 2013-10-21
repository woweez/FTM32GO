//
//  HelloWorldLayer.mm
//  Tap
//
//  Created by karthik g on 27/09/12.
//  Copyright karthik g 2012. All rights reserved.
//

#import "GameEngine12.h"

#import "AppDelegate.h"
#import "LevelScreen.h"
#import "LevelCompleteScreen.h"
#import "FTMUtil.h"
#import "DB.h"

enum {
    kTagParentNode = 1,
};


GameEngine12Menu *layer12;


@implementation GameEngine12Menu


-(id) init {
    if( (self=[super init])) {
    }
    return self;
}
@end

@implementation GameEngine12

@synthesize tileMap = _tileMap;
@synthesize background = _background;


+(CCScene *) scene {
    CCScene *scene = [CCScene node];
    layer12=[GameEngine12Menu node];
    [scene addChild:layer12 z:1];
    GameEngine12 *layer = [GameEngine12 node];
    [scene addChild: layer z:0];
    return scene;
}


-(id) init
{
    if( (self=[super init])) {
        
        heroJumpIntervalValue = [[NSArray alloc] initWithObjects:@"0",@"2",@"4",@"6",@"8",@"10",@"0",@"11",@"13",@"15",nil];
        cheeseSetValue= [[NSArray alloc] initWithObjects:@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",nil];
        cheeseArrX=[[NSArray alloc] initWithObjects:@"0",@"20",@"0",@"20",@"10",nil];
        cheeseArrY=[[NSArray alloc] initWithObjects:@"0",@"0", @"-15", @"-15",@"-8",nil];
        heroRunningStopArr=[[NSArray alloc] initWithObjects:@"80",@"80",@"80", @"40",@"140",@"80",@"80",@"80",@"80",@"80",@"80",@"80",@"80",@"80",nil];
        
        gameFunc=[[GameFunc alloc] init];
        soundEffect=[[sound alloc] init];
        trigo=[[Trigo alloc] init];
        winSize = [[CCDirector sharedDirector] winSize];
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
        [self addChild:_tileMap z:-1 tag:1];
        
        
        cache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [cache addSpriteFramesWithFile:@"mother_mouse_default.plist"];
        spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"mother_mouse_default.png"];
        [self addChild:spriteSheet z:10];
        
        heroRunSprite = [CCSprite spriteWithSpriteFrameName:@"mother_run01.png"];
        heroRunSprite.position = ccp(200, 200);
        heroRunSprite.scale=0.8;
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
        mouseDragSprite.scale=0.6;
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
        [layer12 addChild:menu z:10];
        
        
        progressBarBackSprite=[CCSprite spriteWithFile:@"grey_bar_57.png"];
        progressBarBackSprite.position=ccp(240,300);
        [layer12 addChild:progressBarBackSprite z:10];
        progressBarBackSprite.visible = NO;
        
        cheeseCollectedSprite=[CCSprite spriteWithFile:@"cheese_collected.png"];
        cheeseCollectedSprite.position=ccp(430,300);
        [layer12 addChild:cheeseCollectedSprite z:10];
        cheeseCollectedSprite.visible = NO;
        progressBarSprite[0]=[CCSprite spriteWithFile:@"red_end.png"];
        progressBarSprite[0].position=ccp(117,301);
        progressBarSprite[0].scaleX=2.2;
        progressBarSprite[0].visible = NO;
        [layer12 addChild:progressBarSprite[0] z:10];
        
        for(int i=1;i<120;i++){
            NSString *fStr=@"";
            if(i<=59)
                fStr=@"red_middle.png";
            else if(i>59&&i<119)
                fStr=@"blue_middle.png";
            else
                fStr=@"blue_end.png";
            
            progressBarSprite[i]=[CCSprite spriteWithFile:fStr];
            progressBarSprite[i].position=ccp(121+(i*2),301);
            progressBarSprite[i].scaleX=2.2;
            progressBarSprite[i].visible = NO;
            [layer12 addChild:progressBarSprite[i] z:10];
        }
        
        timeCheeseSprite=[CCSprite spriteWithFile:@"time_cheese.png"];
        timeCheeseSprite.position=ccp(121+240,301);
        timeCheeseSprite.visible = NO;
        [layer12 addChild:timeCheeseSprite z:10];
        
        
        lifeMinutesAtlas = [[CCLabelAtlas labelWithString:@"01.60" charMapFile:@"numbers.png" itemWidth:15 itemHeight:20 startCharMap:'.'] retain];
        lifeMinutesAtlas.visible = NO;
        lifeMinutesAtlas.position=ccp(250,292);
        [layer12 addChild:lifeMinutesAtlas z:10];
        
        cheeseCollectedAtlas = [[CCLabelAtlas labelWithString:@"0/3" charMapFile:@"numbers.png" itemWidth:15 itemHeight:20 startCharMap:'.'] retain];
        cheeseCollectedAtlas.visible = NO;
        cheeseCollectedAtlas.position=ccp(422,292);
        cheeseCollectedAtlas.scale=0.8;
        [layer12 addChild:cheeseCollectedAtlas z:10];
        [cheeseCollectedAtlas setString:[NSString stringWithFormat:@"%d/%d",0,[cheeseSetValue[motherLevel-1] intValue]]];
        
        movePlatformSprite=[CCSprite spriteWithFile:@"levelPlatformHole12.png"];
        movePlatformSprite.position=ccp(-220,512);
        [self addChild:movePlatformSprite z:9];
        
        for(int i=0;i<cheeseCount;i++){
            cheeseCollectedChe[i]=YES;
            cheeseSprite2[i]=[CCSprite spriteWithFile:@"cheeseGlow.png"];
            cheeseSprite2[i].position=[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i];
            [self addChild:cheeseSprite2[i] z:9];
            
            cheeseSprite[i]=[CCSprite spriteWithFile:@"Cheese.png"];
            cheeseSprite[i].position=[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i];
            [self addChild:cheeseSprite[i] z:9];
        }
        
        for(int i=0;i<3;i++){
            switchAtlas[i] = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"switch.png" itemWidth:40 itemHeight:103 startCharMap:'0'] retain];
            if(i==0)
                switchAtlas[i].position=ccp(490,315);
            else if(i==1)
                switchAtlas[i].position=ccp(540,445);
            else if(i==2)
                switchAtlas[i].position=ccp(200,435);
            switchAtlas[i].scale=0.7;
            [self addChild:switchAtlas[i] z:9];
        }
        
        iceBlastAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"ice_blast.png" itemWidth:100 itemHeight:50 startCharMap:'0'] retain];
        iceBlastAtlas.position=ccp(-270,200);
        [self addChild:iceBlastAtlas z:9];
        
        iceBlastAtlas2 = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"ice_blast.png" itemWidth:100 itemHeight:50 startCharMap:'0'] retain];
        iceBlastAtlas2.position=ccp(-270,200);
        [self addChild:iceBlastAtlas2 z:9];
        
        clockBackgroundSprite=[CCSprite spriteWithFile:@"clock_background.png"];
        clockBackgroundSprite.position=ccp(-100,258);
        clockBackgroundSprite.scale=0.5;
        [layer12 addChild:clockBackgroundSprite z:0];
        
        clockArrowSprite=[CCSprite spriteWithFile:@"clock_arrow.png"];
        clockArrowSprite.position=ccp(-100,258);
        clockArrowSprite.scale=0.5;
        clockArrowSprite.anchorPoint=ccp(0.2f, 0.2f);
        clockArrowSprite.rotation=-40;
        [layer12 addChild:clockArrowSprite z:0];
        
        
        mouseTrappedBackground=[CCSprite spriteWithFile:@"mouse_trapped_background.png"];
        mouseTrappedBackground.position=ccp(240,160);
        mouseTrappedBackground.visible=NO;
        [layer12 addChild:mouseTrappedBackground z:10];
        
        CCMenuItem *aboutMenuItem = [CCMenuItemImage itemWithNormalImage:@"main_menu_button_1.png" selectedImage:@"main_menu_button_2.png" target:self selector:@selector(clickLevel:)];
        aboutMenuItem.tag=2;
        
        CCMenuItem *optionMenuItem = [CCMenuItemImage itemWithNormalImage:@"try_again_button_1.png" selectedImage:@"try_again_button_2.png" target:self selector:@selector(clickLevel:)];
        optionMenuItem.tag=1;
        
        for(int i=0;i<4;i++){
            iceQubeSprite[i]=[CCSprite spriteWithFile:@"ice_qube.png"];
            iceQubeSprite[i].position=ccp(-107,525);
            iceQubeSprite[i].rotation=arc4random() % 360 + 1;
            [self addChild:iceQubeSprite[i] z:10];
            
            iceQubeSprite2[i]=[CCSprite spriteWithFile:@"ice_qube.png"];
            iceQubeSprite2[i].position=ccp(-107,525);
            iceQubeSprite2[i].rotation=arc4random() % 360 + 1;
            [self addChild:iceQubeSprite2[i] z:9];
        }
        
        menu2 = [CCMenu menuWithItems: optionMenuItem,aboutMenuItem,  nil];
        [menu2 alignItemsHorizontallyWithPadding:4.0];
        menu2.position=ccp(241,136);
        menu2.visible=NO;
        [layer12 addChild: menu2 z:10];
        
        tileWaterFull=[CCTMXTiledMap tiledMapWithTMXFile:@"water_full.tmx"];
        self.background = [tileWaterFull layerNamed:@"water_full"];
        [self addChild:tileWaterFull z:10 tag:1];
        tileWaterFull.position=ccp(0,-500);
        
        tileWaterFull2=[CCTMXTiledMap tiledMapWithTMXFile:@"water_full.tmx"];
        self.background = [tileWaterFull2 layerNamed:@"water_full"];
        [self addChild:tileWaterFull2 z:10 tag:1];
        
        for(int i=0;i<2;i++){
            waterBubbleAtlas[i] = [[CCLabelAtlas labelWithString:@"4" charMapFile:@"water_bubble.png" itemWidth:25 itemHeight:25 startCharMap:'0'] retain];
            waterBubbleAtlas[i].position=ccp(-430,50);
            waterBubbleAtlas[i].scaleX=2.5;
            waterBubbleAtlas[i].scaleY=0.5;
            waterBubbleAtlas[i].opacity=200;
            [self addChild:waterBubbleAtlas[i] z:9];
        }
        
        CCLabelAtlas *bridgeAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"fridge_platform.png" itemWidth:395 itemHeight:49 startCharMap:'0'] retain];
        bridgeAtlas.position=ccp(-25,52);
        [self addChild:bridgeAtlas z:0];
        bridgeAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"fridge_platform.png" itemWidth:395 itemHeight:49 startCharMap:'0'] retain];
        bridgeAtlas.position=ccp(349,52);
        [self addChild:bridgeAtlas z:0];
        bridgeAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"fridge_platform.png" itemWidth:395 itemHeight:49 startCharMap:'0'] retain];
        bridgeAtlas.position=ccp(724,52);
        [self addChild:bridgeAtlas z:0];
        
        CCSprite *bridgeSprite=[CCSprite spriteWithFile:@"fridge_platform.png"];
        bridgeSprite.position=ccp(173,178);
        [self addChild:bridgeSprite z:0];
        
        bridgeSprite=[CCSprite spriteWithFile:@"fridge_platform.png"];
        bridgeSprite.position=ccp(547,178);
        [self addChild:bridgeSprite z:0];
        
        bridgeSprite=[CCSprite spriteWithFile:@"fridge_platform3.png"];
        bridgeSprite.position=ccp(807,178);
        bridgeSprite.scaleX=1.05;
        [self addChild:bridgeSprite z:0];
        
        bridgeSprite=[CCSprite spriteWithFile:@"fridge_platform.png"];
        bridgeSprite.position=ccp(29,299);
        [self addChild:bridgeSprite z:0];
        
        bridgeSprite=[CCSprite spriteWithFile:@"fridge_platform2.png"];
        bridgeSprite.position=ccp(500,299);
        [self addChild:bridgeSprite z:0];
        
        bridgeSprite=[CCSprite spriteWithFile:@"fridge_platform2.png"];
        bridgeSprite.position=ccp(904,299);
        [self addChild:bridgeSprite z:0];
        
        bridgeSprite=[CCSprite spriteWithFile:@"fridge_platform.png"];
        bridgeSprite.position=ccp(90,398);
        [self addChild:bridgeSprite z:0];
        
        bridgeSprite=[CCSprite spriteWithFile:@"fridge_platform4.png"];
        bridgeSprite.position=ccp(550,412);
        [self addChild:bridgeSprite z:0];
        
        CCSprite *combSprite=[CCSprite spriteWithFile:@"b.png"];
        combSprite.position=ccp(186,475);
        combSprite.scale = 0.4;
        [self addChild:combSprite z:1];
        
        combSprite=[CCSprite spriteWithFile:@"a.png"];
        combSprite.position=ccp(528,484);
        combSprite.scale = 0.4;
        [self addChild:combSprite z:1];
        
        combSprite=[CCSprite spriteWithFile:@"c.png"];
        combSprite.position=ccp(480,358);
        combSprite.scale = 0.4;
        [self addChild:combSprite z:1];
        
        combSprite=[CCSprite spriteWithFile:@"d.png"];
        combSprite.position=ccp(864,518);
        combSprite.scale = 0.4;
        [self addChild:combSprite z:1];
        
        combSprite=[CCSprite spriteWithFile:@"box.png"];
        combSprite.position=ccp(898,518);
        [self addChild:combSprite z:1];
        
        combSprite=[CCSprite spriteWithFile:@"c.png"];
        combSprite.position=ccp(884,519);
        combSprite.scale = 0.4;
        [self addChild:combSprite z:1];
        
        combSprite=[CCSprite spriteWithFile:@"a.png"];
        combSprite.position=ccp(896,519);
        combSprite.scale = 0.4;
        [self addChild:combSprite z:1];
        
        combSprite=[CCSprite spriteWithFile:@"b.png"];
        combSprite.position=ccp(909,519);
        combSprite.scale = 0.4;
        [self addChild:combSprite z:1];
        
        CCSprite *sprite=[CCSprite spriteWithFile:@"bridge_ice_box3.png"];
        sprite.position=ccp(503,218);
        [self addChild:sprite z:0];
        
        sprite=[CCSprite spriteWithFile:@"ice_box2__11.png"];
        sprite.position=ccp(503,190);
        sprite.opacity=50;
        [self addChild:sprite z:10];
        
        CCSprite *objectSprite=[CCSprite spriteWithFile:@"bridge_object8.png"];
        objectSprite.position=ccp(910,348);
        objectSprite.scale=0.9;
        [self addChild:objectSprite z:0];
        
        objectSprite=[CCSprite spriteWithFile:@"box.png"];
        objectSprite.position=ccp(585,438);
        [self addChild:objectSprite z:0];
        
        objectSprite=[CCSprite spriteWithFile:@"bridge_object7.png"];
        objectSprite.position=ccp(565,328);
        objectSprite.scale=0.6;
        [self addChild:objectSprite z:0];
        
        objectSprite=[CCSprite spriteWithFile:@"object5.png"];
        objectSprite.position=ccp(40,220);
        [self addChild:objectSprite z:0];
        
        objectSprite=[CCSprite spriteWithFile:@"green_box.png"];
        objectSprite.position=ccp(100,330);
        objectSprite.scale=0.7;
        [self addChild:objectSprite z:0];
        
        objectSprite=[CCSprite spriteWithFile:@"fish3.png"];
        objectSprite.position=ccp(120,420);
        objectSprite.scale=0.7;
        [self addChild:objectSprite z:0];
        
        objectSprite=[CCSprite spriteWithFile:@"bridge_object1.png"];
        objectSprite.position=ccp(120,115);
        objectSprite.scale=0.6;
        [self addChild:objectSprite z:0];
        
        objectSprite=[CCSprite spriteWithFile:@"bridge_object4.png"];
        objectSprite.position=ccp(520,115);
        objectSprite.scale=0.7;
        [self addChild:objectSprite z:0];
        
        for(int i=0;i<20;i++){
            heroPimpleSprite[i]=[CCSprite spriteWithFile:@"dotted.png"];
            heroPimpleSprite[i].position=ccp(-100,160);
            heroPimpleSprite[i].scale=0.3;
            [self addChild:heroPimpleSprite[i] z:10];
        }
        
        dotSprite=[CCSprite spriteWithFile:@"dotted.png"];
        dotSprite.position=ccp(875,164);
        dotSprite.scale=0.3;
        [self addChild:dotSprite z:10 ];
        [self addHudLayerToTheScene];        
        [self starCheeseSpriteInitilized];
        [self scheduleUpdate];
        
        for(int i=0;i<0;i++){
            CGFloat xx=[trigo circlex:35 a:300-i]+132;
            CGFloat yy=[trigo circley:65 a:300-i]+210;
            
            CCSprite *sprite=[CCSprite spriteWithFile:@"dotted.png"];
            sprite.position=ccp(xx,yy);
            sprite.scale=0.2;
            [self addChild:sprite z:10];
        }
    }
    return self;
}

-(void) addHudLayerToTheScene{
    hudLayer = [[HudLayer alloc] init];
    hudLayer.tag = 12;
    [layer12 addChild: hudLayer z:2000];
    [hudLayer updateNoOfCheeseCollected:0 andMaxValue: 5];
}

-(void) addLevelCompleteLayerToTheScene{
    hudLayer.visible = NO;
    LevelCompleteScreen *lvlCompleteLayer = [[LevelCompleteScreen alloc] init];
    lvlCompleteLayer.tag = 12;
    [layer12 addChild: lvlCompleteLayer z:2000];
}

-(void)initValue{
    //Cheese Count Important
    DB *db = [DB new];
    motherLevel= 12;//[[db getSettingsFor:@"CurrentLevel"] intValue];
    [db release];
    
    cheeseCount=[cheeseSetValue[motherLevel-1] intValue];
    
    
    platformX=850;
    platformY=530;
    
    
    platformX=-50;
    platformY=190;
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
    for(int i=0;i<4;i++){
        iceQubePos[i][0]=10;
        iceQubePos[i][1]=410;
        iceQubeCount[i]=-40;
        iceQubePos2[i][0]=10;
        iceQubePos2[i][1]=410;
        iceQubeCount2[i]=0;
    }
    iceQubeCount[0]=-39;
    waterAnimationValue=0;
    waterAnimationValue=-1000;
    iceQubeCount2[0]=1;
    gameFunc.switchStatusChe=NO;
    iceSmokingCount=1;
    levelFloddedValue2=-20;
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
    [self hotSmokingFunc];
    [self iceQubeAnimation];
    [self switchFunc];
    [self iceCubeCollision];
    
    gameFunc.runChe=runningChe;
    [gameFunc render];
    
    [self level05];
    
    if(gameFunc.trigoVisibleChe){
        heroSprite.rotation=-gameFunc.trigoHeroAngle;
        heroRunSprite.rotation=-gameFunc.trigoHeroAngle;
    }
    
    waterAnimationValue+=1;
    if(waterAnimationValue>=1000)
        waterAnimationValue=-1000;
    waterAnimationValue2+=1;
    if(waterAnimationValue2>=1000)
        waterAnimationValue2=-1000;
    
    if(levelFloddedValue<levelFloddedValue2)
        levelFloddedValue+=0.25;
    
    tileWaterFull.position=ccp(0-waterAnimationValue,-600.0+levelFloddedValue);
    tileWaterFull2.position=ccp(0-waterAnimationValue2,-600.0+levelFloddedValue);
    
    
    
}
-(void)iceCubeCollision{
    
    CGFloat hx=heroSprite.position.x;
    CGFloat hy=heroSprite.position.y;
    int iValue=(forwardChe?60:0);
    for(int i=0;i<4;i++){
        if(hx-iValue>iceQubePos[i][0]-90 &&hx-iValue<iceQubePos[i][0]-30 &&hy > iceQubePos[i][1]-30 &&hy<iceQubePos[i][1]+20 &&!gameFunc.trappedChe){
             gameFunc.trappedChe=YES;
             mouseTrappedPosValue=iceQubeCount[i];
        }else if(hx-iValue>iceQubePos2[i][0]-90 &&hx-iValue<iceQubePos2[i][0]-30 &&hy > iceQubePos2[i][1]-30 &&hy<iceQubePos2[i][1]+20 &&!gameFunc.trappedChe){
             gameFunc.trappedChe=YES;
             mouseTrappedPosValue=iceQubeCount2[i];
        }
    }
    if(levelFloddedValue>heroSprite.position.y+20&&!waterTrappedChe){
        gameFunc.trappedChe=YES;
        waterTrappedChe=YES;
    }
    
}

-(void)iceQubeAnimation{
    if(!screenMoveChe){
        for(int i=0;i<4;i++){
            if(iceQubeCount[i]!=-40){
                if(iceQubeCount[i]<=50){
                    iceQubeCount[i]+=2;
                    iceQubePos[i][0]=[trigo circlex:25 a:180-(iceQubeCount[i]-230)]+32;
                    iceQubePos[i][1]=[trigo circley:25 a:180-(iceQubeCount[i]-230)]+410;
                }else if(iceQubeCount[i]>50&&iceQubeCount[i]<230){
                    if(iceQubeCount[i]==51 || iceQubeCount[i] == 52){
                        iceBlastAnimationCount=1;
                        iceBlastAtlas.position=ccp(iceQubePos[i][0]-80,iceQubePos[i][1]-15);
                    }
                    iceQubeCount[i]+=1.2;
                    iceQubePos[i][0]=[trigo circlex:iceQubeCount[i] a:359];
                    iceQubePos[i][1]=[trigo circley:iceQubeCount[i] a:359]+410;
                }else if(iceQubeCount[i]>=230&&iceQubeCount[i]<310){
                    iceQubeCount[i]+=2.7;
                    iceQubePos[i][0]=[trigo circlex:25 a:90-(iceQubeCount[i]-230)]+288;
                    iceQubePos[i][1]=[trigo circley:25 a:90-(iceQubeCount[i]-230)]+379;
                }else if(iceQubeCount[i]>=310 &&iceQubeCount[i]<470){
                    iceQubeCount[i]+=1.7;
                    iceQubePos[i][0]=[trigo circlex:iceQubeCount[i]-230 a:276]+308;
                    iceQubePos[i][1]=[trigo circley:iceQubeCount[i]-230 a:276]+483;
                }else{
                    iceQubeCount[i]+=1.2;
                    iceQubePos[i][0]=[trigo circlex:iceQubeCount[i] a:359]-245;
                    iceQubePos[i][1]=[trigo circley:iceQubeCount[i] a:359]+184;
                }
            }
            if(iceQubeCount[1]==-40&&iceQubeCount[0]>=20){
                iceQubeCount[1]=-39;
            }else if(iceQubeCount[2]==-40&&iceQubeCount[1]>=20){
                iceQubeCount[2]=-39;
            }else if(iceQubeCount[3]==-40&&iceQubeCount[2]>=20){
                iceQubeCount[3]=-39;
            }
            if(iceQubeCount[i]>480&&iceQubeCount[i]<=482){
                iceBlastAnimationCount=1;
                iceBlastAtlas.position=ccp(iceQubePos[i][0]-95,iceQubePos[i][1]-16);
            }
            
            if(iceQubeCount[i]>=600){
                iceBlastAnimationCount=1;
                iceBlastAtlas.position=ccp(iceQubePos[i][0]-90,iceQubePos[i][1]-14);
                iceQubeCount[i]=-39;
                iceQubeSprite[i].rotation=arc4random() % 360 + 1;
                if(i==0)
                    [self floddedFunc];
            }
            iceQubeSprite[i].position=ccp(iceQubePos[i][0]-35,iceQubePos[i][1]);
            
        }
        
        if(iceBlastAnimationCount>=1){
            iceBlastAnimationCount+=3;
            if(iceBlastAnimationCount>=90){
                iceBlastAnimationCount=90;
                iceBlastAtlas.position=ccp(-200,100);
            }
            [iceBlastAtlas setString:[NSString stringWithFormat:@"%d",iceBlastAnimationCount/10]];
        }
        
    }
    
    
    //Right Ice Cube
    for(int i=0;i<4;i++){
        if(iceQubeCount2[i]!=0){
            
            if(iceQubeCount2[i]<202){
                iceQubeCount2[i]+=1.4;
                iceQubePos2[i][0]=[trigo circlex:iceQubeCount2[i] a:180]+1060;
                iceQubePos2[i][1]=[trigo circley:iceQubeCount2[i] a:180]+315;
                
            }else if(iceQubeCount2[i]>=202 &&iceQubeCount2[i]<300){
                iceQubeCount2[i]+=2.4;
                iceQubePos2[i][0]=[trigo circlex:iceQubeCount2[i] a:270]+796;
                iceQubePos2[i][1]=[trigo circley:iceQubeCount2[i] a:270]+565;
            }else{
                iceQubeCount2[i]+=1.4;
                iceQubePos2[i][0]=[trigo circlex:iceQubeCount2[i] a:180]+1180;
                iceQubePos2[i][1]=[trigo circley:iceQubeCount2[i] a:180]+188;
            }
        }
        
        if(iceQubeCount2[1]==0&&iceQubeCount2[0]>=50){
            iceQubeCount2[1]=1;
        }else if(iceQubeCount2[2]==0&&iceQubeCount2[1]>=50){
            iceQubeCount2[2]=1;
        }else if(iceQubeCount2[3]==0&&iceQubeCount2[2]>=50){
            iceQubeCount2[3]=1;
        }
        if(iceQubeCount2[i]>=300&&iceQubeCount2[i]<302){
            iceBlastAnimationCount2=1;
            iceBlastAtlas2.position=ccp(iceQubePos2[i][0]-97,iceQubePos2[i][1]-25);
        }
        if(iceQubeCount2[i]>=510){
            iceBlastAnimationCount2=1;
            iceBlastAtlas2.position=ccp(iceQubePos2[i][0]-97,iceQubePos2[i][1]-12);
            iceQubeCount2[i]=1;
            iceQubeSprite2[i].rotation=arc4random() % 360 + 1;
            if(i==0)
                [self floddedFunc];
            
        }
        iceQubeSprite2[i].position=ccp(iceQubePos2[i][0]-35,iceQubePos2[i][1]);
    }
    
    if(iceBlastAnimationCount2>=1){
        iceBlastAnimationCount2+=3;
        if(iceBlastAnimationCount2>=90){
            iceBlastAnimationCount2=90;
            iceBlastAtlas2.position=ccp(-200,100);
        }
        [iceBlastAtlas2 setString:[NSString stringWithFormat:@"%d",iceBlastAnimationCount2/10]];
    }
    
    if(waterTrappedChe&&heroTrappedCount>=70){
        for(int i=0;i<6;i++){
            if(iceSmokingCount!=0){
                CGFloat xx=0;
                CGFloat yy=0;
                if(i<=2){
                    xx=[trigo circlex:35 a:260-iceSmokingCount+(i*10)]-5+heroTrappedSprite.position.x;
                    yy=[trigo circley:65 a:260-iceSmokingCount+(i*8)]+90+heroTrappedSprite.position.y;
                }else{
                    xx=[trigo circlex:35 a:303+iceSmokingCount-(i*10)]-5+heroTrappedSprite.position.x;
                    yy=[trigo circley:65 a:303+iceSmokingCount-(i*8)]+90+heroTrappedSprite.position.y;
                }
                
                if(yy>=levelFloddedValue-40){
                    yy=levelFloddedValue-40;
                     iceSmokingSprite[i].position=ccp(xx,yy+20);
                }else
                iceSmokingSprite[i].position=ccp(xx,yy);
                iceSmokingSprite[i].scale=(iceSmokingCount/100.0);
            }
        }
        iceSmokingCount+=1.2;
        if(iceSmokingCount>=60){
            iceSmokingCount=0;
            int lValue=0;
            if(iceSmokingSprite[0].position.y>=levelFloddedValue-40)
                lValue=20;
            waterBubbleAtlas[0].position=ccp(iceSmokingSprite[0].position.x-30,iceSmokingSprite[0].position.y);
            waterBubbleAtlas[1].position=ccp(iceSmokingSprite[3].position.x-30,iceSmokingSprite[3].position.y);
        }
        waterBubbleAnimationValue+=1;
        waterBubbleAnimationValue=(waterBubbleAnimationValue>=70?0:waterBubbleAnimationValue);
        [waterBubbleAtlas[0] setString:[NSString stringWithFormat:@"%d",waterBubbleAnimationValue/10]];
        [waterBubbleAtlas[1] setString:[NSString stringWithFormat:@"%d",waterBubbleAnimationValue/10]];
        
    }
    
}
-(void)floddedFunc{
    floddedValue+=1;
    if(floddedValue>=3){
        levelFloddedValue2+=30.0;
        floddedValue=0;
    }
}
-(void)switchFunc{
    if(gameFunc.switchStatusChe)
        [switchAtlas[0] setString:@"1"];
    else
        [switchAtlas[0] setString:@"0"];
    
    if(gameFunc.switchStatusChe2)
        [switchAtlas[1] setString:@"1"];
    else
        [switchAtlas[1] setString:@"0"];
    
    if(gameFunc.switchStatusChe3)
        [switchAtlas[2] setString:@"1"];
    else
        [switchAtlas[2] setString:@"0"];
    
    
    if(screenMoveChe){
        if(screenMovementFindValue==0){
            screenShowY+=10;
            if(screenShowY>480)
                screenMovementFindValue=2;
        }else if(screenMovementFindValue==2){
            screenShowX+=7;
            if(screenShowX>750)
                screenShowX=750;
            if(gameFunc.moveCount2==233)
                screenMovementFindValue=3;
        }else if(screenMovementFindValue == 3){
            screenShowX-=10;
            if(screenShowX<screenShowX2){
                screenShowX=screenShowX2;
                screenMovementFindValue=4;
            }
        }else if(screenMovementFindValue==4){
            screenShowY-=5;
            if(screenShowY<screenShowY2){
                screenShowY=screenShowY2;
                screenMoveChe=NO;
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

-(void)level05{
    
    if(gameFunc.movePlatformChe){
        if(motherLevel == 5)
            platformX=gameFunc.movePlatformX-gameFunc.landMoveCount+gameFunc.moveCount2;
        else if(motherLevel == 6){
            if(!gameFunc.moveSideChe)
                platformY=gameFunc.movePlatformY-gameFunc.landMoveCount+gameFunc.moveCount2;
            else
                platformX=gameFunc.movePlatformX+gameFunc.landMoveCount-gameFunc.moveCount3;
            
        }else if(motherLevel == 7){
            platformY=gameFunc.movePlatformY-gameFunc.landMoveCount+gameFunc.moveCount2;
        }
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
    
    movePlatformSprite.position=ccp(1118-gameFunc.moveCount2,505);
    cheeseSprite2[4].position=ccp([gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:4].x-gameFunc.moveCount2,[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:4].y);
    cheeseSprite[4].position=ccp([gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:4].x-gameFunc.moveCount2,[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:4].y);
}
-(void)hotSmokingFunc{
    
}

-(void)level01{
    if(firstRunningChe){
        if(platformX>[heroRunningStopArr[motherLevel-1] intValue]&&screenFirstViewCount==0){
            heroStandChe=YES;
            runningChe=NO;
            heroRunSprite.visible=NO;
            heroSprite.visible=YES;
            screenFirstViewCount=0;
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
                if(screenShowY>410)
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
    
    int fValue=(!forwardChe?0:30);
    if(heroSprite.position.x>=920+fValue&&heroSprite.position.y>=430 && heroSprite.position.y<500 &&!mouseWinChe&&gameFunc.switchStatusValue==3){
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
    if(gameFunc.trappedChe){
        if(heroTrappedChe&&heroTrappedCount>=(waterTrappedChe?300:100)&&heroTrappedMove==0){
            menu2.visible=YES;
            mouseTrappedBackground.visible=YES;
        }
    }
}

-(void)starCheeseSpriteInitilized{
    for(int i=0;i<5;i++){
        starSprite[i] = [CCSprite spriteWithSpriteFrameName:@"star2.png"];
        starSprite[i].scale=0.4;
        starSprite[i].position=ccp([gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].x-12,[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].y+8);
        [spriteSheet addChild:starSprite[i]];
        
        NSMutableArray *animFrames3 = [NSMutableArray array];
        for(int j = 0; j <5; j++) {
            CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"star%d.png",j+1]];
            [animFrames3 addObject:frame];
        }
        CCAnimation *animation2 = [CCAnimation animationWithSpriteFrames:animFrames3 delay:0.1f];
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
            if(i==4){
                mValue=gameFunc.moveCount2;
                starSprite[i].position=ccp([gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].x-12+cheeseX2-mValue,[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].y+8+cheeseY2);
            }
            
            
            cheeseAnimationCount+=2;
            cheeseAnimationCount=(cheeseAnimationCount>=500?0:cheeseAnimationCount);
            CGFloat localCheeseAnimationCount=0;
            localCheeseAnimationCount=(cheeseAnimationCount<=250?cheeseAnimationCount:250-(cheeseAnimationCount-250));
            cheeseSprite2[i].opacity=localCheeseAnimationCount/4;
            
            CGFloat cheeseX=[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].x;
            CGFloat cheeseY=[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].y;
            
            if(!forwardChe){
                if(heroX>=cheeseX-70-mValue &&heroX<=cheeseX+10-mValue&&heroY>cheeseY-20+mValue2&&heroY<cheeseY+30){
                    [soundEffect cheeseCollectedSound];
                    cheeseCollectedChe[i]=NO;
                    cheeseSprite[i].visible=NO;
                    cheeseSprite2[i].visible=NO;
                    cheeseCollectedScore+=1;
                    starSprite[i].visible=NO;
                    [hudLayer updateNoOfCheeseCollected:cheeseCollectedScore andMaxValue:[cheeseSetValue[motherLevel-1] intValue]];
//                    [cheeseCollectedAtlas setString:[NSString stringWithFormat:@"%d/%d",cheeseCollectedScore,[cheeseSetValue[motherLevel-1] intValue]]];
                    [self createExplosionX:cheeseX-mValue y:cheeseY];
                    break;
                }
            }else{
                if(heroX>=cheeseX-10-mValue &&heroX<=cheeseX+70-mValue&&heroY>cheeseY-20&&heroY<cheeseY+30){
                    [soundEffect cheeseCollectedSound];
                    cheeseCollectedChe[i]=NO;
                    cheeseSprite[i].visible=NO;
                    cheeseSprite2[i].visible=NO;
                    cheeseCollectedScore+=1;
                    starSprite[i].visible=NO;
                    [hudLayer updateNoOfCheeseCollected:cheeseCollectedScore andMaxValue:[cheeseSetValue[motherLevel-1] intValue]];
//                    [cheeseCollectedAtlas setString:[NSString stringWithFormat:@"%d/%d",cheeseCollectedScore,[cheeseSetValue[motherLevel-1] intValue]]];
                    [self createExplosionX:cheeseX-mValue y:cheeseY];
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
            mouseDragSprite.visible=NO;
            for (int i = 0; i < 20; i=i+1)
                heroPimpleSprite[i].position=ccp(-100,100);
            
            if (heroTrappedSprite != NULL) {
                [heroTrappedSprite removeFromParentAndCleanup:YES];
            }
            heroTrappedSprite = [CCSprite spriteWithFile:@"mm_mist_0.png"];
            int fValue=(forwardChe?heroForwardX:0);
            if(!waterTrappedChe){
                if(heroSprite.position.x<450){
                    if(mouseTrappedPosValue<230)
                        heroTrappedSprite.position = ccp(heroSprite.position.x-fValue+30, 415);
                    else if(mouseTrappedPosValue>=230&&mouseTrappedPosValue<460){
                        heroTrappedMove=1;
                    }else{
                        heroTrappedSprite.position = ccp(heroSprite.position.x-fValue+30, 210);
                    }
                }else{
                    if(mouseTrappedPosValue<=190){
                        heroTrappedSprite.position = ccp(heroSprite.position.x-fValue, 320);
                    }else if(mouseTrappedPosValue>190&&mouseTrappedPosValue<270){
                        heroTrappedMove=1;
                    }else{
                        heroTrappedSprite.position = ccp(heroSprite.position.x-fValue, 210);
                        
                    }
                }
            }else{
                heroTrappedSprite.position = ccp(heroSprite.position.x-fValue, heroSprite.position.y);
                heroTrappedMove=1;
                for(int i=0;i<6;i++){
                    iceSmokingSprite[i]=[CCSprite spriteWithFile:@"trapped_bubble.png"];
                    iceSmokingSprite[i].position=ccp(-100,258);
                    [self addChild:iceSmokingSprite[i] z:10];
                }
            }
            
            heroTrappedSprite.scale=0.4;
            int yPosOfTrappedSprite = heroSprite.position.y;
            if (yPosOfTrappedSprite < 210) {
                yPosOfTrappedSprite = 210;
            }
            heroTrappedSprite.position = ccp(heroSprite.position.x-fValue, yPosOfTrappedSprite);
            heroTrappedSprite.scale=0.5;
            [self addChild:heroTrappedSprite z:1000];
            int posY = 210;
            if(waterTrappedChe){
                posY = 90;
            }
            
            CCMoveTo *move = [CCMoveTo actionWithDuration:1 position:ccp(heroSprite.position.x-fValue, posY)];
            [heroTrappedSprite runAction:move];

            heroSprite.visible=NO;
        }
        if(heroTrappedMove!=0){
            
            int fValue=(forwardChe?heroForwardX:0);
            CGPoint copyHeroPosition = ccp(heroSprite.position.x-fValue, heroSprite.position.y-heroTrappedMove);
            [self setViewpointCenter:copyHeroPosition];
            if(!waterTrappedChe){
                heroTrappedMove+=5;
                if(heroSprite.position.y-heroTrappedMove<=210)
                    heroTrappedMove=0;
            }else{
                heroTrappedMove+=1;
                if(heroSprite.position.y-heroTrappedMove<=90){
                    waterTrappedChe = NO;
                    heroTrappedMove=0;
                }
                
            }
        }
    }
}
-(void)heroWinFunc{
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
        if(!forwardChe){
            
            platformX+=3.2;
            [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
            platformX=gameFunc.xPosition;
            heroSprite.rotation=0;
            heroRunSprite.rotation=0;
        }else{
            platformX-=3.2;
            [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
            platformX=gameFunc.xPosition;
            heroSprite.rotation=0;
            heroRunSprite.rotation=0;
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
    NSString *fStr=@"";
    if([type isEqualToString:@"jump"]){
        if(fValue!=9)
            fStr=[NSString stringWithFormat:@"mother_jump0%d.png",fValue+1];
        else
            fStr=[NSString stringWithFormat:@"mother_jump%d.png",fValue+1];
    }else if([type isEqualToString:@"stand"])
        fStr=[NSString stringWithFormat:@"mother_stand0%d.png",fValue+1];
    else if([type isEqualToString:@"win"])
        fStr=@"mother_win01.png";
    
    [spriteSheet removeChild:heroSprite cleanup:YES];
    heroSprite = [CCSprite spriteWithSpriteFrameName:fStr];
    heroSprite.position = ccp(platformX, platformY);
    heroSprite.scale=0.8;
    [spriteSheet addChild:heroSprite z:10];
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
            if(!screenMoveChe&&!safetyJumpChe&&gameFunc.switchStatusChe&&gameFunc.switchHitValue==1){
                gameFunc.switchHitValue=0;
            }else if(!screenMoveChe&&!safetyJumpChe&&gameFunc.switchStatusChe2&&gameFunc.switchHitValue==2){
                gameFunc.switchHitValue=0;
            }else if(!screenMoveChe&&!safetyJumpChe&&gameFunc.switchStatusChe3&&gameFunc.switchHitValue==3){
                screenShowX=233;
                screenShowY=platformY;
                screenShowX2=233;
                screenShowY2=platformY;
                gameFunc.switchHitValue=0;
                if(gameFunc.switchStatusValue==3){
                    screenMoveChe=YES;
                    gameFunc.moveCount2=1;
                }
                
            }
            
        }
    }
}

-(void)HeroLiningDraw:(int)cPath{
    
    CGFloat angle=jumpAngle;
    int tValue=0;
    int tValue2=0;
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
            heroSprite.position=ccp(platformX+2,platformY+3+tValue);
    }else{
        mouseDragSprite.position=ccp(platformX-2+heroForwardX,platformY+3+tValue);
        if(gameFunc.trigoVisibleChe)
            heroSprite.position=ccp(platformX-2+heroForwardX,platformY+tValue);
    }
    
    mouseDragSprite.rotation=(180-angle)-170;
    mouseDragSprite.scale=0.6+(jumpPower/40.0);
    
    
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
    self.position = viewPoint;
    
}
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    CGPoint prevLocation = [myTouch previousLocationInView: [myTouch view]];
    prevLocation = [[CCDirector sharedDirector] convertToGL: prevLocation];
    
    if(!mouseWinChe&&!heroTrappedChe&&!firstRunningChe&&!screenMoveChe){
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
                if((location.x<70 || location.x>winSize.width-70) && location.y <70){
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

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    if(!jumpingChe&&!runningChe&&heroJumpLocationChe&&!mouseWinChe&&motherLevel!=1&&!heroTrappedChe&&!firstRunningChe&&!screenMoveChe){
        activeVect = startVect - b2Vec2(location.x, location.y);
        jumpAngle = fabsf( CC_RADIANS_TO_DEGREES( atan2f(-activeVect.y, activeVect.x)));
        [self HeroLiningDraw:0];
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    if(!mouseWinChe&&!heroTrappedChe&&!firstRunningChe&&!screenMoveChe){
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
}
-(void)clickMenuButton{
    [[CCDirector sharedDirector] replaceScene:[LevelScreen scene]];
}
-(void)clickLevel:(CCMenuItem *)sender {
    if(sender.tag == 1){
        [[CCDirector sharedDirector] replaceScene:[GameEngine12 scene]];
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
    heroTrappedSprite.visible = NO;
    [self endJumping:(platformX + gameFunc.xPosition)/2 yValue:gameFunc.yPosition];
    [self schedule:@selector(startRespawnTimer) interval:1];
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
