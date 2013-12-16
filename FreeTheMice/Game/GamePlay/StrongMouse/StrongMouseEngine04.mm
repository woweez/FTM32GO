//
//  HelloWorldLayer.mm
//  Tap
//
//  Created by karthik g on 27/09/12.
//  Copyright karthik g 2012. All rights reserved.
//

// Import the interfaces
#import "StrongMouseEngine04.h"
#import "LevelScreen.h"
#import "LevelCompleteScreen.h"
#import "FTMUtil.h"
#import "FTMConstants.h"
// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "DB.h"
enum {
    kTagParentNode = 1,
};

StrongMouseEngineMenu04 *sLayer04;

@implementation StrongMouseEngineMenu04


-(id) init {
    if( (self=[super init])) {
    }
    return self;
}
@end

@implementation StrongMouseEngine04

@synthesize tileMap = _tileMap;
@synthesize background = _background;

+(CCScene *) scene {
    CCScene *scene = [CCScene node];
    sLayer04=[StrongMouseEngineMenu04 node];
    [scene addChild:sLayer04 z:1];
    
    StrongMouseEngine04 *layer = [StrongMouseEngine04 node];
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
        heroRunningStopArr=[[NSArray alloc] initWithObjects:@"80",@"80",@"80", @"40",@"140",@"80",@"80",@"80",@"80",@"80",@"80",@"80",@"40",@"80",nil];
        winSize = [CCDirector sharedDirector].winSize;
        gameFunc=[[StrongGameFunc alloc] init];
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
        
        
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"background.tmx"];
        self.background = [_tileMap layerNamed:@"background"];
        if ([FTMUtil sharedInstance].isRetinaDisplay) {
            self.background.scale = 2;
        }
        [self addChild:_tileMap z:-1 tag:1];
        
        
        
        cache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [cache addSpriteFramesWithFile:@"strong0_default.plist"];
        spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"strong0_default.png"];
        [self addChild:spriteSheet z:10];
        
        [self addStrongMouseRunningSprite];
        [self addStrongMousePushingSprite];
        
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
        [sLayer04 addChild:menu z:10];
        
        mouseTrappedBackground=[CCSprite spriteWithFile:@"mouse_trapped_background.png"];
        mouseTrappedBackground.position=ccp(240,160);
        mouseTrappedBackground.visible=NO;
        [sLayer04 addChild:mouseTrappedBackground z:10];
        
        CCMenuItem *aboutMenuItem = [CCMenuItemImage itemWithNormalImage:@"main_menu_button_1.png" selectedImage:@"main_menu_button_2.png" target:self selector:@selector(clickLevel:)];
        aboutMenuItem.tag=2;
        
        CCMenuItem *optionMenuItem = [CCMenuItemImage itemWithNormalImage:@"try_again_button_1.png" selectedImage:@"try_again_button_2.png" target:self selector:@selector(clickLevel:)];
        optionMenuItem.tag=1;
        
        menu2 = [CCMenu menuWithItems: optionMenuItem,aboutMenuItem,  nil];
        [menu2 alignItemsHorizontallyWithPadding:4.0];
        menu2.position=ccp(241,136);
        menu2.visible=NO;
        [sLayer04 addChild: menu2 z:10];
        
        cheeseCollectedSprite=[CCSprite spriteWithFile:@"cheese_collected.png"];
        cheeseCollectedSprite.position=ccp(430,300);
        cheeseCollectedSprite.visible = NO;
        [sLayer04 addChild:cheeseCollectedSprite z:10];
        
        timeCheeseSprite=[CCSprite spriteWithFile:@"time_cheese.png"];
        timeCheeseSprite.position=ccp(121+240,301);
        timeCheeseSprite.visible = NO;
        [sLayer04 addChild:timeCheeseSprite z:10];
        
        
        lifeMinutesAtlas = [[CCLabelAtlas labelWithString:@"01.60" charMapFile:@"numbers.png" itemWidth:15 itemHeight:20 startCharMap:'.'] retain];
        lifeMinutesAtlas.position=ccp(250,292);
        lifeMinutesAtlas.visible = NO;
        [sLayer04 addChild:lifeMinutesAtlas z:10];
        
        
        cheeseCollectedAtlas = [[CCLabelAtlas labelWithString:@"0/3" charMapFile:@"numbers.png" itemWidth:15 itemHeight:20 startCharMap:'.'] retain];
        cheeseCollectedAtlas.position=ccp(422,292);
        cheeseCollectedAtlas.scale=0.8;
        [sLayer04 addChild:cheeseCollectedAtlas z:10];
        cheeseCollectedAtlas.visible = NO;
        [cheeseCollectedAtlas setString:[NSString stringWithFormat:@"%d/%d",0,[cheeseSetValue[motherLevel-1] intValue]]];
        
        for(int i=0;i<cheeseCount;i++){
            cheeseCollectedChe[i]=YES;
            cheeseSprite[i]=[CCSprite spriteWithFile:@"Cheese.png"];
            cheeseSprite[i].position=[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i];
            [self playStaticCheeseAnimation:cheeseSprite[i]];
            [self addChild:cheeseSprite[i] z:9];
            cheeseSprite[i].scale = CHEESE_SCALE;
        }
        
        
        CCSprite *slapSprite=[CCSprite spriteWithFile:@"slap.png"];
        slapSprite.position=ccp(178,211);
        slapSprite.scale=0.7;
        [self addChild:slapSprite z:1];
        
        slapSprite=[CCSprite spriteWithFile:@"slap.png"];
        slapSprite.position=ccp(526,211);
        slapSprite.scale=0.7;
        [self addChild:slapSprite z:1];
        
        slapSprite=[CCSprite spriteWithFile:@"slap.png"];
        slapSprite.position=ccp(836,211);
        slapSprite.scale=0.7;
        [self addChild:slapSprite z:1];
        
        CCSprite *platformSprite=[CCSprite spriteWithFile:@"move_platform3.png"];
        platformSprite.position=ccp(70,380);
        [self addChild:platformSprite z:1];
        
        platformSprite=[CCSprite spriteWithFile:@"move_platform2.png"];
        platformSprite.position=ccp(33,490);
        platformSprite.scaleX=0.9;
        [self addChild:platformSprite z:1];
        
        platformSprite=[CCSprite spriteWithFile:@"move_platform2.png"];
        platformSprite.position=ccp(660,505);
        [self addChild:platformSprite z:1];
        
        platformSprite=[CCSprite spriteWithFile:@"move_platform3.png"];
        platformSprite.position=ccp(840,585);
        [self addChild:platformSprite z:1];
        
        platformSprite=[CCSprite spriteWithFile:@"move_platform3.png"];
        platformSprite.position=ccp(690,405);
        [self addChild:platformSprite z:1];
        
        platformSprite=[CCSprite spriteWithFile:@"move_platform3.png"];
        platformSprite.position=ccp(880,405);
        [self addChild:platformSprite z:1];
        
        platformSprite=[CCSprite spriteWithFile:@"move_platform3.png"];
        platformSprite.position=ccp(1070,405);
        [self addChild:platformSprite z:1];
        
        CCSprite *windowSprite=[CCSprite spriteWithFile:@"window1.png"];
        windowSprite.position=ccp(320,490);
        [self addChild:windowSprite z:1];
        
        windowSprite=[CCSprite spriteWithFile:@"window1.png"];
        windowSprite.position=ccp(430,490);
        [self addChild:windowSprite z:1];
        
        windowSprite=[CCSprite spriteWithFile:@"window1.png"];
        windowSprite.position=ccp(540,490);
        [self addChild:windowSprite z:1];
        
        
        toasterBreadSprite=[CCSprite spriteWithFile:@"toaster_bread.png"];
        toasterBreadSprite.position=ccp(300,369);
        toasterBreadSprite.scale=0.8;
        [self addChild:toasterBreadSprite z:1];
        
        CCSprite *toasterSprite=[CCSprite spriteWithFile:@"toaster.png"];
        toasterSprite.position=ccp(300,319);
        toasterSprite.scale=0.8;
        [self addChild:toasterSprite z:1];
        
        silverPotSprite=[CCSprite spriteWithFile:@"silver_pot.png"];
        silverPotSprite.position=ccp(420,593);
        silverPotSprite.scale=0.8;
        [self addChild:silverPotSprite z:1];
        
        CCSprite *boxSprite=[CCSprite spriteWithFile:@"box.png"];
        boxSprite.position=ccp(350,439);
        boxSprite.scale=0.5;
        boxSprite.scaleX=0.6;
        [self addChild:boxSprite z:1];
        
        boxSprite=[CCSprite spriteWithFile:@"box.png"];
        boxSprite.position=ccp(402,439);
        boxSprite.scale=0.5;
        boxSprite.scaleX=0.6;
        [self addChild:boxSprite z:1];
        
        boxSprite=[CCSprite spriteWithFile:@"box.png"];
        boxSprite.position=ccp(454,439);
        boxSprite.scale=0.5;
        boxSprite.scaleX=0.6;
        [self addChild:boxSprite z:1];
        
        boxSprite=[CCSprite spriteWithFile:@"box.png"];
        boxSprite.position=ccp(506,439);
        boxSprite.scale=0.5;
        boxSprite.scaleX=0.6;
        [self addChild:boxSprite z:1];
        
        
        boxSprite=[CCSprite spriteWithFile:@"box.png"];
        boxSprite.position=ccp(370,461);
        boxSprite.scale=0.5;
        boxSprite.scaleX=0.6;
        [self addChild:boxSprite z:1];
        
        boxSprite=[CCSprite spriteWithFile:@"box.png"];
        boxSprite.position=ccp(422,461);
        boxSprite.scale=0.5;
        boxSprite.scaleX=0.6;
        [self addChild:boxSprite z:1];
        
        boxSprite=[CCSprite spriteWithFile:@"box.png"];
        boxSprite.position=ccp(474,461);
        boxSprite.scale=0.5;
        boxSprite.scaleX=0.6;
        [self addChild:boxSprite z:1];
        
        boxSprite=[CCSprite spriteWithFile:@"box.png"];
        boxSprite.position=ccp(394,481);
        boxSprite.scale=0.5;
        boxSprite.scaleX=0.6;
        [self addChild:boxSprite z:1];
        
        boxSprite=[CCSprite spriteWithFile:@"box.png"];
        boxSprite.position=ccp(444,481);
        boxSprite.scale=0.5;
        boxSprite.scaleX=0.6;
        [self addChild:boxSprite z:1];
        
        CCSprite *cookerSprite=[CCSprite spriteWithFile:@"cooker.png"];
        cookerSprite.position=ccp(550,300);
        cookerSprite.scale=0.8;
        cookerSprite.flipX=1;
        [self addChild:cookerSprite z:1];
        
        for(int i=0;i<10;i++){
            hotSprite[i]=[CCSprite spriteWithFile:@"smoke.png"];
            hotSprite[i].position=ccp(-275,415);
            [self addChild:hotSprite[i] z:0];
        }
        
        pushButtonSprite=[CCSprite spriteWithFile:@"push_button.png"];
        pushButtonSprite.position = ccp(301,442);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            pushButtonSprite.scale = NON_RETINA_SCALE;
        }
        [self playPushRedBtnAnimation:pushButtonSprite];
        [self addChild:pushButtonSprite z:1];
//        pushButtonSprite.position=ccp(301,430);
//        pushButtonSprite.scaleY=0.35;
//        pushButtonSprite.scaleX=0.55;
        
        greyBoxSprite=[CCSprite spriteWithFile:@"box.png"];
        greyBoxSprite.position=ccp(415,505);
        greyBoxSprite.scale=0.5;
        greyBoxSprite.scaleX=0.6;
        [self addChild:greyBoxSprite z:2];
        
        for(int i=0;i<6;i++){
            visibleSprite[i]=[CCSprite spriteWithFile:@"window2.png"];
            if(i==0)
                visibleSprite[i].position=ccp(300,490);
            else if(i==1){
                visibleSprite[i].position=ccp(355,490);
                visibleSprite[i].flipX=1;
            }else if(i==2)
                visibleSprite[i].position=ccp(410,490);
            else if(i==3){
                visibleSprite[i].position=ccp(465,490);
                visibleSprite[i].flipX=1;
            }else if(i==4)
                visibleSprite[i].position=ccp(510,490);
            else if(i==5){
                visibleSprite[i].position=ccp(562,490);
                visibleSprite[i].flipX=1;
            }
            
            [self addChild:visibleSprite[i] z:9];
            
        }
        
        CCSprite *crackedSprite=[CCSprite spriteWithFile:@"cracked.png"];
        crackedSprite.position=ccp(578,444);
        crackedSprite.flipX=1;
        [self addChild:crackedSprite z:9];
        
        
        CCSprite *holeSprite=[CCSprite spriteWithFile:@"hole.png"];
        holeSprite.position=ccp(970,310);
        [self addChild:holeSprite z:1];
        
        for(int i=0;i<20;i++){
            heroPimpleSprite[i]=[CCSprite spriteWithFile:@"dotted.png"];
            heroPimpleSprite[i].position=ccp(-100,160);
            heroPimpleSprite[i].scale=0.3;
            [self addChild:heroPimpleSprite[i] z:10];
        }
        
        //===================================================================
        dotSprite=[CCSprite spriteWithFile:@"dotted.png"];
        dotSprite.position=ccp(400,555);
        dotSprite.scale=0.2;
        [self addChild:dotSprite z:10];
        [self addHudLayerToTheScene];
        [self starCheeseSpriteInitilized];
        [self scheduleHotPotSmokeSound];
        [self scheduleUpdate];
    }
    return self;
}

-(void) addHudLayerToTheScene{
    hudLayer = [[HudLayer alloc] init];
    hudLayer.tag = 4;
    [sLayer04 addChild: hudLayer z:2000];
    [hudLayer updateNoOfCheeseCollected:0 andMaxValue:[cheeseSetValue[motherLevel-1] intValue]];
}

-(void) addLevelCompleteLayerToTheScene{
    [self levelCompleted :4];
}

-(void)initValue{
    //Cheese Count Important
//    DB *db = [DB new];
    motherLevel= 4;//[[db getSettingsFor:@"CurrentLevel"] intValue];
//    [db release];
    
    cheeseCount=[cheeseSetValue[motherLevel-1] intValue];
    
    platformX=650;//[gameFunc getPlatformPosition:motherLevel].x;
    platformY=450;//[gameFunc getPlatformPosition:motherLevel].y;
    
    platformX=[gameFunc getPlatformPosition:motherLevel].x;
    platformY=[gameFunc getPlatformPosition:motherLevel].y;
    
    screenHeroPosX=platformX;
    screenHeroPosY=platformY;
    
    isHotPotSoundEnabled = YES;
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
    gameFunc.appleWoodCount=50;
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
    [self hotSmokingFunc];
    
    gameFunc.runChe=runningChe;
    [gameFunc render];
    
    if(visibleCount>=1){
        visibleCount+=15;
        if(visibleCount>=249){
            visibleCount=249;
        }
        for(int i=0;i<6;i++)
            visibleSprite[i].opacity=250-visibleCount;
        
    }
    
}
-(void)switchFunc{
    if(motherLevel==4){
        if(gameFunc.switchCount==1){
            gameFunc.switchCount=2;
            [self startClockTimer];
//            clockBackgroundSprite.visible=YES;
//            clockArrowSprite.visible=YES;
        }else if(gameFunc.switchCount>=1){
            gameFunc.switchCount+=1;
            if(gameFunc.switchCount%60==0)
                clockArrowSprite.rotation=((gameFunc.switchCount/60)*6)-40;
            if(gameFunc.switchCount/60>60){
                gameFunc.switchCount=0;
//                if (newClockSprite != nil) {
//                    [newClockSprite removeFromParentAndCleanup:YES];
//                    newClockSprite = nil;
//                }
                clockBackgroundSprite.visible=NO;
                clockArrowSprite.visible=NO;
            }
        }
    }
    
    if(!screenMoveChe&&gameFunc.siverPotCount<=-175&&screenMovementFindValue==0){
        screenMoveChe=YES;
        screenMovementFindValue=1;
        screenShowX=platformX;
        screenShowY=platformY;
        screenShowX2=platformX;
        screenShowY2=platformY;
        
        heroStandChe=YES;
        runningChe=NO;
        heroRunSprite.visible=NO;
        heroSprite.visible=YES;
        heroPushSprite.visible=NO;
        gameFunc.pushChe=NO;
    }else if(!screenMoveChe&&gameFunc.boxCount<=-20&&screenMovementFindValue2==0){
        screenMoveChe=YES;
        screenMovementFindValue2=1;
        screenShowX=platformX;
        screenShowY=platformY;
        screenShowX2=platformX;
        screenShowY2=platformY;
        
        heroStandChe=YES;
        runningChe=NO;
        heroRunSprite.visible=NO;
        heroSprite.visible=YES;
        heroPushSprite.visible=NO;
        gameFunc.pushChe=NO;
        
        
    }
    
    if(screenMoveChe){
        if(screenMovementFindValue==1){
            screenShowY-=1;
            if(screenShowY<350)
                screenMovementFindValue=2;
            
        }else if(screenMovementFindValue==2){
            screenShowY+=4;
            if(screenShowY>screenShowY2){
                screenShowY=screenShowY2;
                screenMoveChe=NO;
                screenMovementFindValue=3;
                screenHeroPosX=platformX;
                screenHeroPosY=platformY;
                screenShowX=platformX;
                screenShowY=platformY;
            }
        }
        
        if(screenMovementFindValue2==1){
            screenShowX+=3;
            if(screenShowX>500)
                screenMovementFindValue2=2;
            
        }else if(screenMovementFindValue2==2){
            screenShowY-=2;
            if(screenShowY<400)
                screenMovementFindValue2=3;
        }else if(screenMovementFindValue2==3){
            screenShowY+=3;
            if(screenShowY>screenShowY2)
                screenMovementFindValue2=4;
        }else if(screenMovementFindValue2==4){
            screenShowX-=3;
            if(screenShowX<screenShowX2){
                screenShowX=screenShowX2;
                screenMoveChe=NO;
                screenMovementFindValue2=5;
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
    
    
    silverPotSprite.position=ccp(420+gameFunc.siverPotCount,593-gameFunc.siverPotCount2);
    
    if (gameFunc.siverPotCount2 == 278) {
        [soundEffect extinguish_pot];
    }
    toasterBreadSprite.position=ccp(300,369-gameFunc.toasterBreadCount);
    greyBoxSprite.position=ccp(415+gameFunc.boxCount,505-gameFunc.boxCount2);
    if(gameFunc.boxCount2 == 67 && pushButtonSprite.tag != 10 ){
        [self resetRedPushBtn:ccp(301,430)];
    }
    int fValue=(!forwardChe?0:30);
    if(heroSprite.position.x>=920+fValue &&heroSprite.position.y<=430&&!mouseWinChe){
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
        if(heroTrappedChe&&heroTrappedCount ==100 &&heroTrappedMove==0){
            [self showLevelFailedUI:motherLevel];
        }
    }
}
-(void)hotSmokingFunc{
    CGFloat sx=0;
    CGFloat sy=0;
    CGFloat hotScale=0;
    CGFloat divideLength=2.3;
    
    sx=535;
    sy= 285;
    hotScale=0.8;
    divideLength=2.0;
    
    for(int i=0;i<10;i++){
        if(hotSmokingCount[i]>=1){
            hotSmokingCount[i]+=2.5;
            if(hotSmokingCount[i]>=250)
                hotSmokingCount[i]=0;
            hotSprite[i].position=ccp(sx,sy+(hotSmokingCount[i]/divideLength));
            hotSprite[i].opacity=250-(hotSmokingCount[i]);
            hotSprite[i].scale=hotScale+(hotSmokingCount[i]/400.0);
        }
    }
    
    if(hotSmokingRelease == 0&&gameFunc.boxCount2!=40){
        for(int i=0;i<10;i++){
            if(hotSmokingCount[i]==0){
                if(gameFunc.switchCount==0){
                    hotSmokingCount[i]=1;
                    hotSmokingRelease=1;
                    break;
                }
            }
        }
    }
    if(hotSmokingRelease>=1&&!waterStopChe){
        hotSmokingRelease+=1;
        if(hotSmokingRelease>=12){
            hotSmokingRelease=0;
        }
    }
    
    if (waterStopChe && isHotPotSoundEnabled) {
        isHotPotSoundEnabled = NO;
        [self unScheduleHotPotSmokeSound];
    }
    else if (!waterStopChe && !isHotPotSoundEnabled){
        [self scheduleHotPotSmokeSound];
    }
    int iValue=(forwardChe?60:0);
    if(![FTMUtil sharedInstance].isInvincibilityOn && heroSprite.position.x-iValue>470 && heroSprite.position.x-iValue<= 550&& heroSprite.position.y>330&&heroSprite.position.y<=430&&!heroTrappedChe&&gameFunc.boxCount2!=40){
        gameFunc.trappedChe=YES;
        trappedTypeValue=1;
    }
}

-(void)starCheeseSpriteInitilized{
//    for(int i=0;i<5;i++){
//        starSprite[i] = [CCSprite spriteWithSpriteFrameName:@"star2.png"];
//        starSprite[i].scale=0.4;
//        starSprite[i].position=ccp([gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].x-12,[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].y+8);
//        [spriteSheet addChild:starSprite[i] z:10];
//        
//        NSMutableArray *animFrames3 = [NSMutableArray array];
//        for(int j = 0; j <5; j++) {
//            CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"star%d.png",j+1]];
//            [animFrames3 addObject:frame];
//        }
//        CCAnimation *animation2 = [CCAnimation animationWithSpriteFrames:animFrames3 delay:0.2f];
//        [starSprite[i] runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation2]]];
//    }
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
            
            cheeseAnimationCount+=2;
            cheeseAnimationCount=(cheeseAnimationCount>=500?0:cheeseAnimationCount);
            CGFloat localCheeseAnimationCount=0;
            localCheeseAnimationCount=(cheeseAnimationCount<=250?cheeseAnimationCount:250-(cheeseAnimationCount-250));
            
            CGFloat cheeseX=[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].x;
            CGFloat cheeseY=[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].y;
            BOOL ch2=YES;
            if(i==2){
                if(gameFunc.honeyPotCount2==67){
                    ch2=NO;
//                    starSprite[2].visible=NO;
                }
                cheeseSprite[2].zOrder=0;
              
            }
            
            if(!forwardChe){
                if(heroX>=cheeseX-70-mValue &&heroX<=cheeseX+10-mValue&&heroY>cheeseY-20+mValue2&&heroY<cheeseY+30+mValue2&&ch2){
                    [soundEffect cheeseCollectedSound];
                    cheeseCollectedChe[i]=NO;
                    cheeseSprite[i].visible=NO;
                    cheeseCollectedScore+=1;
                    [self playCheeseCollectedAnimation:cheeseSprite[i]];
                    break;
                }
            }else{
                if(heroX>=cheeseX-10-mValue &&heroX<=cheeseX+70-mValue&&heroY>cheeseY-20+mValue2&&heroY<cheeseY+30+mValue2&&ch2){
                    [soundEffect cheeseCollectedSound];
                    cheeseCollectedChe[i]=NO;
                    cheeseSprite[i].visible=NO;
                    cheeseCollectedScore+=1;
                    [self playCheeseCollectedAnimation:cheeseSprite[i]];
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
        if(heroTrappedCount==10){
            for (int i = 0; i < 20; i=i+1)
                heroPimpleSprite[i].position=ccp(-100,100);
            
            if(trappedTypeValue==1)
//                heroTrappedMove=1;
            
            mouseDragSprite.visible=NO;
            heroTrappedSprite = [CCSprite spriteWithFile:@"sm_mist_0.png"];
            if(!forwardChe)
                heroTrappedSprite.position = ccp(heroSprite.position.x + heroForwardX, heroSprite.position.y+5);
            else
                heroTrappedSprite.position = ccp(heroSprite.position.x - heroForwardX, heroSprite.position.y+5);
            
            heroTrappedSprite.scale=0.5;
            [self addChild:heroTrappedSprite z:1000];
            int posY = 310;
            
            CCMoveTo *move = [CCMoveTo actionWithDuration:1 position:ccp(heroTrappedSprite.position.x, posY)];
            [heroTrappedSprite runAction:move];
            

            heroSprite.visible=NO;
        }
        if(heroTrappedMove!=0){
            int fValue = (forwardChe?heroForwardX:0);
            CGFloat xPos=0;
            if(trappedTypeValue==1){
                xPos=532;
            }
            
//            heroTrappedSprite.position = ccp(xPos,heroSprite.position.y-heroTrappedMove);
            CGPoint copyHeroPosition = ccp(heroSprite.position.x-fValue, heroSprite.position.y-heroTrappedMove);
            [self setViewpointCenter:copyHeroPosition];
            if(trappedTypeValue == 1){
                heroTrappedMove+=1;
                if(heroSprite.position.y-heroTrappedMove<=322)
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
-(void)heroRunFunc{
    if(runningChe){
        if(!forwardChe){
            platformX+=2.2;
            [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
            platformX=gameFunc.xPosition;
        }else{
            platformX-=2.2;
            [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
            platformX=gameFunc.xPosition;
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
        if(gameFunc.pushChe){
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
            
            if(gameFunc.visibleWindowChe&&visibleCount==0)
                visibleCount=1;
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
        mouseDragSprite.position=ccp(platformX -DRAG_SPRITE_OFFSET_X,platformY-DRAG_SPRITE_OFFSET_Y);
    else
        mouseDragSprite.position=ccp(platformX + DRAG_SPRITE_OFFSET_X/2 +heroForwardX,platformY-DRAG_SPRITE_OFFSET_Y/2);
    
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
    
//    if ([FTMUtil sharedInstance].isBoostPowerUpEnabled) {
//        return;
//    }
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
    if(!mouseWinChe&&!heroTrappedChe){
        if(!jumpingChe&&!runningChe&&heroJumpLocationChe&&!screenMoveChe){
            heroJumpLocationChe=NO;
            saveDottedPathCount=0;
            jumpPower = activeVect.Length();
            activeVect = startVect - b2Vec2(location.x, location.y);
            jumpAngle = fabsf( CC_RADIANS_TO_DEGREES( atan2f(-activeVect.y, activeVect.x)));
            jumpingChe=YES;
            dragChe=NO;
            [soundEffect strong_jump];
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
        [[CCDirector sharedDirector] replaceScene:[StrongMouseEngine04 scene]];
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
