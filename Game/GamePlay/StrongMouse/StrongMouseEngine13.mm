//
//  HelloWorldLayer.mm
//  Tap
//
//  Created by karthik g on 27/09/12.
//  Copyright karthik g 2012. All rights reserved.
//

// Import the interfaces
#import "StrongMouseEngine13.h"
#import "LevelScreen.h"
#import "FTMUtil.h"
#import "FTMConstants.h"
// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "DB.h"
enum {
    kTagParentNode = 1,
};

StrongMouseEngineMenu13 *sLayer13;

@implementation StrongMouseEngineMenu13


-(id) init {
    if( (self=[super init])) {
    }
    return self;
}
@end

@implementation StrongMouseEngine13

@synthesize tileMap = _tileMap;
@synthesize background = _background;

+(CCScene *) scene {
    CCScene *scene = [CCScene node];
    sLayer13=[StrongMouseEngineMenu13 node];
    [scene addChild:sLayer13 z:1];
    
    StrongMouseEngine13 *layer = [StrongMouseEngine13 node];
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
        heroRunningStopArr=[[NSArray alloc] initWithObjects:@"80",@"80",@"80", @"40",@"140",@"80",@"80",@"80",@"20",@"80",@"80",@"80",@"40",@"80",nil];
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
        [self addChild:_tileMap z:-1 tag:1];
        
        cache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [cache addSpriteFramesWithFile:@"strong0_default.plist"];
        [cache addSpriteFramesWithFile:@"sink_waterAnim.plist"];
        spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"strong0_default.png"];
        [self addChild:spriteSheet z:10];
        
        [self addStrongMouseRunningSprite];
        
//        catCache = [CCSpriteFrameCache sharedSpriteFrameCache];
//        [catCache addSpriteFramesWithFile:@"cat_default.plist"];
//        catSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"cat_default.png"];
//        [self addChild:catSpriteSheet z:0];
        
        [self addStrongMousePushingSprite];
        
        
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
        [sLayer13 addChild:menu z:10];
        
        mouseTrappedBackground=[CCSprite spriteWithFile:@"mouse_trapped_background.png"];
        mouseTrappedBackground.position=ccp(240,160);
        mouseTrappedBackground.visible=NO;
        [sLayer13 addChild:mouseTrappedBackground z:10];
        
        CCMenuItem *aboutMenuItem = [CCMenuItemImage itemWithNormalImage:@"main_menu_button_1.png" selectedImage:@"main_menu_button_2.png" target:self selector:@selector(clickLevel:)];
        aboutMenuItem.tag=2;
        
        CCMenuItem *optionMenuItem = [CCMenuItemImage itemWithNormalImage:@"try_again_button_1.png" selectedImage:@"try_again_button_2.png" target:self selector:@selector(clickLevel:)];
        optionMenuItem.tag=1;
        
        menu2 = [CCMenu menuWithItems: optionMenuItem,aboutMenuItem,  nil];
        [menu2 alignItemsHorizontallyWithPadding:4.0];
        menu2.position=ccp(241,136);
        menu2.visible=NO;
        [sLayer13 addChild: menu2 z:10];
        
        cheeseCollectedSprite=[CCSprite spriteWithFile:@"cheese_collected.png"];
        cheeseCollectedSprite.position=ccp(430,300);
        cheeseCollectedSprite.visible = NO;
        [sLayer13 addChild:cheeseCollectedSprite z:10];
        
        timeCheeseSprite=[CCSprite spriteWithFile:@"time_cheese.png"];
        timeCheeseSprite.position=ccp(121+240,301);
        timeCheeseSprite.visible = NO;
        [sLayer13 addChild:timeCheeseSprite z:10];
        
        lifeMinutesAtlas = [[CCLabelAtlas labelWithString:@"01.60" charMapFile:@"numbers.png" itemWidth:15 itemHeight:20 startCharMap:'.'] retain];
        lifeMinutesAtlas.position=ccp(250,292);
        lifeMinutesAtlas.visible = NO;
        [sLayer13 addChild:lifeMinutesAtlas z:10];
        
        cheeseCollectedAtlas = [[CCLabelAtlas labelWithString:@"0/3" charMapFile:@"numbers.png" itemWidth:15 itemHeight:20 startCharMap:'.'] retain];
        cheeseCollectedAtlas.position=ccp(422,292);
        cheeseCollectedAtlas.scale=0.8;
        cheeseCollectedAtlas.visible = NO;
        [sLayer13 addChild:cheeseCollectedAtlas z:10];
        [cheeseCollectedAtlas setString:[NSString stringWithFormat:@"%d/%d",0,[cheeseSetValue[motherLevel-1] intValue]]];
        
        for(int i=0;i<cheeseCount;i++){
            cheeseCollectedChe[i]=YES;
            cheeseSprite2[i]=[CCSprite spriteWithFile:@"cheeseGlow.png"];
            cheeseSprite2[i].position=[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i];
            [self addChild:cheeseSprite2[i] z:9];
            
            cheeseSprite[i]=[CCSprite spriteWithFile:@"Cheese.png"];
            cheeseSprite[i].position=[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i];
            [self addChild:cheeseSprite[i] z:9];
        }
        
        iceBlastAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"ice_blast.png" itemWidth:100 itemHeight:50 startCharMap:'0'] retain];
        iceBlastAtlas.position=ccp(-270,200);
        [self addChild:iceBlastAtlas z:9];
        
        CCSprite *sprite=[CCSprite spriteWithFile:@"fridge.png"];
        sprite.position=ccp(-50,320);
        [self addChild:sprite z:10];
        
        fridgeSprite=[CCSprite spriteWithFile:@"fridge3.png"];
        fridgeSprite.position=ccp(-50,490);
        fridgeSprite.opacity=50;
        [self addChild:fridgeSprite z:10];
        
        sprite=[CCSprite spriteWithFile:@"fridge2.png"];
        sprite.position=ccp(-50,287);
        [self addChild:sprite z:10];
        
        CCSprite *slapSprite=[CCSprite spriteWithFile:@"slap.png"];
        slapSprite.position=ccp(150,188);
        slapSprite.scale=0.6;
        [self addChild:slapSprite z:2];
        
        slapSprite=[CCSprite spriteWithFile:@"slap.png"];
        slapSprite.position=ccp(450,188);
        slapSprite.scale=0.6;
        [self addChild:slapSprite z:1];
        
        slapSprite=[CCSprite spriteWithFile:@"slap.png"];
        slapSprite.position=ccp(750,188);
        slapSprite.scale=0.6;
        [self addChild:slapSprite z:1];
        
        slapSprite=[CCSprite spriteWithFile:@"slap.png"];
        slapSprite.position=ccp(1050,188);
        slapSprite.scale=0.6;
        [self addChild:slapSprite z:1];
        
        for(int i=0;i<20;i++){
            waterDropsSprite[i]=[CCSprite spriteWithFile:@"dotted.png"];
            waterDropsSprite[i].position=ccp(-275,415);
            waterDropsSprite[i].rotation=arc4random() % 360 + 1;
            waterDropsSprite[i].scale=0.4;
            [self addChild:waterDropsSprite[i] z:0];
        }
        
        CCSprite *platformSprite=[CCSprite spriteWithFile:@"move_platform2.png"];
        platformSprite.position=ccp(450,330);
        [self addChild:platformSprite z:1];
        
        platformSprite=[CCSprite spriteWithFile:@"move_platform3.png"];
        platformSprite.position=ccp(30,450);
        [self addChild:platformSprite z:1];
        
        platformSprite=[CCSprite spriteWithFile:@"move_platform2.png"];
        platformSprite.position=ccp(930,330);
        [self addChild:platformSprite z:1];
        
        platformSprite=[CCSprite spriteWithFile:@"move_platform2.png"];
        platformSprite.position=ccp(710,410);
        [self addChild:platformSprite z:1];
        
        platformSprite=[CCSprite spriteWithFile:@"move_platform3.png"];
        platformSprite.position=ccp(450,470);
        [self addChild:platformSprite z:1];
        
        platformSprite=[CCSprite spriteWithFile:@"move_platform3.png"];
        platformSprite.position=ccp(900,510);
        [self addChild:platformSprite z:1];
        
        sprite=[CCSprite spriteWithFile:@"plate_groupe.png"];
        sprite.position=ccp(400,525);
        [self addChild:sprite z:1];
        
        sprite=[CCSprite spriteWithFile:@"plate_groupe.png"];
        sprite.position=ccp(500,525);
        [self addChild:sprite z:1];
        
        sprite=[CCSprite spriteWithFile:@"water_sink_1.png"];
        sprite.position=ccp(450,240);
        [self addChild:sprite z:1];
        
        sprite=[CCSprite spriteWithSpriteFrameName:@"sink_water_0.png"];
        sprite.position=ccp(450,230);
        NSMutableArray *frameArr3 = [NSMutableArray array];
        for(int i = 0; i <= 29; i++) {
            CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"sink_water_%d.png",i]];
            [frameArr3 addObject:frame];
        }
        CCAnimation *animation4 = [CCAnimation animationWithSpriteFrames:frameArr3 delay:0.03f];
        CCAnimate *anim3 = [CCAnimate actionWithAnimation:animation4];
        [sprite runAction:[CCRepeatForever actionWithAction: anim3]];
        [self addChild:sprite z:1];
        
        sprite=[CCSprite spriteWithFile:@"water_sink_2.png"];
        sprite.position=ccp(450,177);
        [self addChild:sprite z:1];
        
        sprite=[CCSprite spriteWithFile:@"water_sink_3.png"];
        sprite.position=ccp(452,247);
        sprite.scale=0.5;
        [self addChild:sprite z:1];
        
        sprite=[CCSprite spriteWithFile:@"water_plate.png"];
        sprite.position=ccp(496,234);
        sprite.scale=0.5;
        [self addChild:sprite z:1];
        
        sprite=[CCSprite spriteWithFile:@"water_plate.png"];
        sprite.position=ccp(405,234);
        sprite.scale=0.5;
        [self addChild:sprite z:1];
        
        CCSprite *pushButtonSprite=[CCSprite spriteWithFile:@"push_button.png"];
        pushButtonSprite.position=ccp(496,234);
        pushButtonSprite.scaleY=0.35;
        pushButtonSprite.scaleX=0.55;
        [self addChild:pushButtonSprite z:1];
        
        pushButtonSprite=[CCSprite spriteWithFile:@"push_button.png"];
        pushButtonSprite.position=ccp(404,242);
        pushButtonSprite.scaleY=0.35;
        pushButtonSprite.scaleX=0.55;
        [self addChild:pushButtonSprite z:1];
        
        movePlatformSprite=[CCSprite spriteWithFile:@"move_platform2.png"];
        movePlatformSprite.position=ccp(990,470);
        [self addChild:movePlatformSprite z:0];
        
        CCSprite *holeSprite=[CCSprite spriteWithFile:@"hole.png"];
        holeSprite.position=ccp(970,280);
        [self addChild:holeSprite z:1];
        
        milkSprite=[CCSprite spriteWithFile:@"milk.png"];
        milkSprite.position=ccp(665,428);
        milkSprite.scale=0.55;
        milkSprite.anchorPoint=ccp(0.1f, 0.1f);
        [self addChild:milkSprite z:1];
        
        for(int i=0;i<5;i++){
            for(int j=0;j<2;j++){
                iceSmokingSprite[i][j]=[CCSprite spriteWithFile:@"ice_smoke.png"];
                iceSmokingSprite[i][j].position=ccp(-100,258);
                [self addChild:iceSmokingSprite[i][j] z:1];
            }
        }
        
        CCSprite *waterPipeSprite=[CCSprite spriteWithFile:@"water_pipe.png"];
        waterPipeSprite.position=ccp(443,292);
        waterPipeSprite.flipX=1;
        waterPipeSprite.scale=0.8;
        [self addChild:waterPipeSprite z:1];
        
        hoenyPotSprite=[CCSprite spriteWithFile:@"honey_pot.png"];
        hoenyPotSprite.position=ccp(723,273);
        hoenyPotSprite.scale=0.8;
        [self addChild:hoenyPotSprite z:10];
        
        for(int i=0;i<4;i++){
            iceQubeSprite[i]=[CCSprite spriteWithFile:@"ice_qube.png"];
            iceQubeSprite[i].position=ccp(-107,525);
            iceQubeSprite[i].scale=0.9;
            iceQubeSprite[i].rotation=arc4random() % 360 + 1;
            [self addChild:iceQubeSprite[i] z:0];
        }
        
        catStopWoodSprite=[CCSprite spriteWithFile:@"cat_stop_wood.png"];
        catStopWoodSprite.position=ccp(808,603);
        catStopWoodSprite.scale=0.8;
        [self addChild:catStopWoodSprite z:10];
        
        for(int i=0;i<20;i++){
            heroPimpleSprite[i]=[CCSprite spriteWithFile:@"dotted.png"];
            heroPimpleSprite[i].position=ccp(-100,160);
            heroPimpleSprite[i].scale=0.3;
            [self addChild:heroPimpleSprite[i] z:10];
        }
        
        pulbSprite=[CCSprite spriteWithFile:@"pulb.png"];
        pulbSprite.position=ccp(450,705);
        pulbSprite.anchorPoint=ccp(0.5f, 0.4f);
        [self addChild:pulbSprite z:10];
        
        //===================================================================
        dotSprite=[CCSprite spriteWithFile:@"dotted.png"];
        dotSprite.position=ccp(795,515);
        dotSprite.scale=0.2;
        [self addChild:dotSprite z:10];
        [self addHudLayerToTheScene];
        [self starCheeseSpriteInitilized];
        [self scheduleUpdate];
               
    }
    return self;
}
-(void) addHudLayerToTheScene{
    hudLayer = [[HudLayer alloc] init];
    hudLayer.tag = 13;
    [sLayer13 addChild: hudLayer z:2000];
    [hudLayer updateNoOfCheeseCollected:0 andMaxValue:[cheeseSetValue[motherLevel-1] intValue]];
}

-(void) addLevelCompleteLayerToTheScene{
    hudLayer.visible = NO;
    LevelCompleteScreen *lvlCompleteLayer = [[LevelCompleteScreen alloc] init];
    lvlCompleteLayer.tag = 13;
    [sLayer13 addChild: lvlCompleteLayer z:2000];
}

-(void)initValue{
    //Cheese Count Important
//    DB *db = [DB new];
    motherLevel = 13;//[[db getSettingsFor:@"CurrentLevel"] intValue];
//    [db release];
    
    cheeseCount=[cheeseSetValue[motherLevel-1] intValue];
    
    platformX=800;//[gameFunc getPlatformPosition:motherLevel].x;
    platformY=620;//[gameFunc getPlatformPosition:motherLevel].y;
    
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
    iceQubeCount[0]=-40;
    iceQubeCount[1]=-40;
    iceQubeCount[2]=-40;
    iceQubeCount[3]=-40;
    turnAnimationCount=1;
    catX=960;
    catY=533;
    
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
    [self waterDropsFunc];
    gameFunc.runChe=runningChe;
    [gameFunc render];
    [self catFunc];
    [self collision];
    
    [self level05];
    
}


-(void) startCatResumeTimer{
    [self unschedule:@selector(startCatResumeTimer)];
    [[catObj getCatSprite] resumeSchedulerAndActions];
    [self schedule:@selector(enableCatSchedular) interval:1];
}
-(void) enableCatSchedular{
    [self unschedule:@selector(enableCatSchedular)];
    isNotScheduled = NO;
}
-(void)catFunc{
    
    if(!catJumpChe && catObj == nil){
        catObj = [[StrongLevel13Cat alloc] init];
        [catObj runCurrentSequence];
        [self addChild:catObj];
    }
    
    if (milkStopChe && [catObj getCatSprite].position.x == 650 && !isNotScheduled) {
        isNotScheduled = YES;
        [[catObj getCatSprite] pauseSchedulerAndActions];
        [self schedule:@selector(startCatResumeTimer) interval:5];
    }
    BOOL ch2=YES;
    if(screenMoveChe&&screenMovementFindValue!=0)
        ch2=NO;
    
    
    if(catSpillTimeCount==0&&ch2){
        if(!catBackChe){
            if(catMovementCount<=60){
                if(turnAnimationCount==0){
                    catX=[trigo circlex:catMovementCount*2 a:179]+960;
                    catY=[trigo circley:catMovementCount a:179]+533;
                    if(catAnimationCount%2 == 0)
                        [self catSpriteGenerate:catAnimationCount/2 animationType:@"run"];
                    catMovementCount+=0.5;
                    
                    if(!catReleaseChe){
                        if(catMovementCount>=40){
                            catBackChe=YES;
                            turnAnimationCount=1;
                            catMovementCount=40;
                        }
                    }else{
                        if(catMovementCount>=60)
                            catJumpChe=YES;
                    }
                }
            }else if(catMovementCount>60&&catMovementCount<=175){
                if(catJumpingAnimationCount>=55){
                    catX=[trigo circlex:50 a:catMovementCount]+780;
                    catY=[trigo circley:100 a:catMovementCount]+423;
                    catMovementCount+=2;
                    
                    if(catJumpingAnimationCount>=55){
                        catJumpingAnimationCount+=1;
                        catJumpingAnimationCount=(catJumpingAnimationCount>=90?90:catJumpingAnimationCount);
                        if(catJumpingAnimationCount%5==0)
                            [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                    }
                }
            }else if(catMovementCount>175 && catMovementCount<=222){
                if(!catJumpChe&&turnAnimationCount==0){
                    catX=[trigo circlex:catMovementCount a:359]+498;
                    catY=[trigo circley:catMovementCount a:359]+430;
                    catMovementCount+=1;
                    if(catAnimationCount%2 == 0)
                        [self catSpriteGenerate:catAnimationCount/2 animationType:@"run"];
                    
                }else{
                    if(catJumpChe){
                        if(catJumpingAnimationCount<=105){
                            catJumpingAnimationCount+=1;
                            if(catJumpingAnimationCount%5 == 0)
                                [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                        }else{
                            catJumpingAnimationCount=0;
                            catJumpChe=NO;
                            turnAnimationCount=1;
                        }
                    }
                }
            }else if(catMovementCount>222 && catMovementCount<=360 ){
                if(catJumpingAnimationCount==0)
                    catJumpChe=YES;
                if(catJumpingAnimationCount>=55){
                    catX=[trigo circlex:55 a:360-catMovementCount]+827;
                    catY=[trigo circley:67 a:350-catMovementCount]+365;
                    catMovementCount+=2;
                    if(catJumpingAnimationCount>=55&&catJumpingAnimationCount<=90){
                        catJumpingAnimationCount+=1;
                        catJumpingAnimationCount=(catJumpingAnimationCount>=90?90:catJumpingAnimationCount);
                        if(catJumpingAnimationCount%5==0)
                            [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                    }
                }
            }else if(catMovementCount>360 && catMovementCount<=430){
                if(!catJumpChe){
                    catX=[trigo circlex:catMovementCount a:359]+445;
                    catY=[trigo circley:catMovementCount a:359]+352;
                    if(catAnimationCount%2 == 0)
                        [self catSpriteGenerate:catAnimationCount/2 animationType:@"run"];
                    catMovementCount+=1;
                    if(catMovementCount>=430)
                        turnAnimationCount=1;
                }else{
                    if(catJumpingAnimationCount<=105){
                        catJumpingAnimationCount+=1;
                        if(catJumpingAnimationCount%5 == 0)
                            [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                    }else{
                        catJumpingAnimationCount=0;
                        catJumpChe=NO;
                    }
                }
            }else if(catMovementCount>430 && catMovementCount<=500){
                if(turnAnimationCount==0){
                    catX=[trigo circlex:catMovementCount a:179]+1520;
                    catY=[trigo circley:catMovementCount a:179]+352;
                    if(catAnimationCount%2 == 0)
                        [self catSpriteGenerate:catAnimationCount/2 animationType:@"run"];
                    catMovementCount+=1;
                    if(catMovementCount>=500)
                        catJumpChe=YES;
                }
            }else if(catMovementCount>500&&catMovementCount<=615){
                if(catJumpingAnimationCount>=55){
                    catX=[trigo circlex:80 a:catMovementCount-80]+847;
                    catY=[trigo circley:96 a:catMovementCount-80]+247;
                    catMovementCount+=2;
                    if(catJumpingAnimationCount>=55){
                        catJumpingAnimationCount+=1;
                        catJumpingAnimationCount=(catJumpingAnimationCount>=90?90:catJumpingAnimationCount);
                        if(catJumpingAnimationCount%5==0)
                            [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                    }
                }
            }else if(catMovementCount<=805){
                if(!catJumpChe){
                    if(catMovementCount<705){
                        catX=[trigo circlex:(catMovementCount-615) a:179]+747;
                        catY=[trigo circley:catMovementCount-615 a:179]+255;
                        if(catAnimationCount%2 == 0)
                            [self catSpriteGenerate:catAnimationCount/2 animationType:@"run"];
                        catMovementCount+=1;
                        
                    }else{
                        catMovementCount+=1;
                        if(gameFunc.milkRotateCount>=90&&catMovementCount<=708){
                            catSpillTimeCount=1; // kamran. pasuse all actions.
                            catMovementCount=709;
                            
                        }
                        if(catSpillTimeCount==0){
                            if(catMovementCount>=710 &&catMovementCount<=712&&turnAnimationCount==0){
                                turnAnimationCount=1;
                            }
                            if(turnAnimationCount==0&&catMovementCount>712){
                                catBackChe=YES;
                                catMovementCount=705;
                            }
                        }
                    }
                }else{
                    if(catJumpingAnimationCount<=105){
                        catJumpingAnimationCount+=1;
                        if(catJumpingAnimationCount%5 == 0)
                            [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                    }else{
                        catJumpingAnimationCount=0;
                        catJumpChe=NO;
                    }
                }
            }
        }else{
            
            if(catMovementCount>=615 && catMovementCount<=705){
                if(turnAnimationCount==0){
                    catX=[trigo circlex:(catMovementCount-615) a:179]+747;
                    catY=[trigo circley:catMovementCount-615 a:179]+255;
                    if(catAnimationCount%2 == 0)
                        [self catSpriteGenerate:catAnimationCount/2 animationType:@"run"];
                    catMovementCount-=1;
                    if(catMovementCount<=615)
                        catJumpChe=YES;
                }
            }else if(catMovementCount>=500 &&catMovementCount<615){
                if(catJumpingAnimationCount>=55){
                    catX=[trigo circlex:80 a:catMovementCount-80]+847;
                    catY=[trigo circley:96 a:catMovementCount-80]+247;
                    catMovementCount-=2.0;
                    if(catJumpingAnimationCount>=55&&catMovementCount<540){
                        catJumpingAnimationCount+=1;
                        catJumpingAnimationCount=(catJumpingAnimationCount>=90?90:catJumpingAnimationCount);
                        if(catJumpingAnimationCount%5==0)
                            [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                    }
                }
            }else if(catMovementCount>=430 && catMovementCount<500){
                if(!catJumpChe){
                    catX=[trigo circlex:catMovementCount a:179]+1520;
                    catY=[trigo circley:catMovementCount a:179]+352;
                    if(catAnimationCount%2 == 0)
                        [self catSpriteGenerate:catAnimationCount/2 animationType:@"run"];
                    catMovementCount-=1;
                    if(catMovementCount<=430)
                        turnAnimationCount=1;
                }else{
                    if(catJumpingAnimationCount<=105){
                        catJumpingAnimationCount+=1;
                        if(catJumpingAnimationCount%5 == 0)
                            [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                    }else{
                        catJumpingAnimationCount=0;
                        catJumpChe=NO;
                    }
                }
            }else if(catMovementCount>=360 && catMovementCount<430){
                if(turnAnimationCount==0){
                    catX=[trigo circlex:catMovementCount a:359]+445;
                    catY=[trigo circley:catMovementCount a:359]+352;
                    if(catAnimationCount%2 == 0)
                        [self catSpriteGenerate:catAnimationCount/2 animationType:@"run"];
                    catMovementCount-=1;
                    if(catMovementCount<=360)
                        catJumpChe=YES;
                }
            }else if(catMovementCount>=222 && catMovementCount<360 ){
                if(catJumpingAnimationCount>=55){
                    catX=[trigo circlex:55 a:360-catMovementCount]+827;
                    catY=[trigo circley:67 a:350-catMovementCount]+365;
                    catMovementCount-=1.9;
                    if(catJumpingAnimationCount>=55&&catMovementCount<270){
                        catJumpingAnimationCount+=1;
                        catJumpingAnimationCount=(catJumpingAnimationCount>=90?90:catJumpingAnimationCount);
                        if(catJumpingAnimationCount%5==0)
                            [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                    }
                }
            }else if(catMovementCount>=175 && catMovementCount<222){
                if(!catJumpChe){
                    catX=[trigo circlex:catMovementCount a:359]+498;
                    catY=[trigo circley:catMovementCount a:359]+430;
                    catMovementCount-=1;
                    if(catAnimationCount%2 == 0)
                        [self catSpriteGenerate:catAnimationCount/2 animationType:@"run"];
                    if(catMovementCount<=175){
                        turnAnimationCount=1;
                    }
                }else{
                    if(catJumpingAnimationCount<=105){
                        catJumpingAnimationCount+=1;
                        if(catJumpingAnimationCount%5 == 0)
                            [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                    }else{
                        catJumpingAnimationCount=0;
                        catJumpChe=NO;
                    }
                }
            }else if(catMovementCount>=60&&catMovementCount<175){
                if(turnAnimationCount==0)
                    catJumpChe=YES;
                if(turnAnimationCount==0&&catJumpingAnimationCount>=55){
                    catX=[trigo circlex:50 a:catMovementCount]+780;
                    catY=[trigo circley:100 a:catMovementCount]+423;
                    catMovementCount-=2;
                    if(catJumpingAnimationCount>=55&&catMovementCount<100){
                        catJumpingAnimationCount+=1;
                        catJumpingAnimationCount=(catJumpingAnimationCount>=90?90:catJumpingAnimationCount);
                        if(catJumpingAnimationCount%5==0)
                            [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                    }
                }
            }else if(catMovementCount<60){
                if(!catJumpChe){
                    if(turnAnimationCount==0){
                        catX=[trigo circlex:catMovementCount*2 a:179]+960;
                        catY=[trigo circley:catMovementCount a:179]+533;
                        if(catAnimationCount%2 == 0)
                            [self catSpriteGenerate:catAnimationCount/2 animationType:@"run"];
                        catMovementCount-=0.5;
                        
                        if(catMovementCount<=0){
                            catBackChe=NO;
                            //catJumpChe=YES;
                            turnAnimationCount=1;
                            catMovementCount=0;
                        }
                    }
                }else{
                    if(catJumpingAnimationCount<=105){
                        catJumpingAnimationCount+=1;
                        if(catJumpingAnimationCount%5 == 0)
                            [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                    }else{
                        catJumpingAnimationCount=0;
                        catJumpChe=NO;
                    }
                }
            }
        }
    }
    
    if(turnAnimationCount>0){
        turnAnimationCount+=1;
        if(turnAnimationCount%4==0)
            [self catSpriteGenerate:turnAnimationCount/4 animationType:@"turn"];
        if(turnAnimationCount>=40){
            turnAnimationCount=0;
            if(!catForwardChe)
                catForwardChe=YES;
            else
                catForwardChe=NO;
        }
    }
    
    if(catJumpChe){
        if(catJumpingAnimationCount<55){
            catJumpingAnimationCount+=1;
            if(catJumpingAnimationCount%5==0)
                [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
        }
    }
    
    catAnimationCount+=2;
    catAnimationCount=(catAnimationCount>=43?0:catAnimationCount);
    
//    if(turnAnimationCount==0)
//        catSprite.position=ccp(catX,catY+16);
//    else
//        catSprite.position=ccp(catX,catY+13);
    
    if(catSpillTimeCount>=1){
        if(milkStopChe)
            catSpillTimeCount+=1;
        catSpillTimeCount=(catSpillTimeCount>=1500?0:catSpillTimeCount);
        
    }
}



-(void)catSpriteGenerate:(int)fValue animationType:(NSString *)type{
//    NSString *fStr=@"";
//    if([type isEqualToString:@"run"])
//        fStr=[NSString stringWithFormat:@"cat_run%d.png",fValue+1];
//    else if([type isEqualToString:@"turn"]){
//        fStr=[NSString stringWithFormat:@"cat_turn_run%d.png",fValue];
//    }else if([type isEqualToString:@"jump"])
//        fStr=[NSString stringWithFormat:@"cat_jump%d.png",fValue];
    
//    [catSpriteSheet removeChild:catSprite cleanup:YES];
//    catSprite = [CCSprite spriteWithSpriteFrameName:fStr];
//    catSprite.position = ccp(catX,catY);
//    catSprite.scale=0.6;
//    if(!catForwardChe){
//        catSprite.flipX=0;
//    }else{
//        catSprite.flipX=1;
//    }
//    [catSpriteSheet addChild:catSprite z:10];
    
    
}
-(void)waterDropsFunc{
    if(!screenMoveChe ){
        for(int i=0;i<4;i++){
            if(iceQubeCount[i]!=-40){
                if(iceQubeCount[i]<=25){
                    iceQubeCount[i]+=1.5;
                    iceQubePos[i][0]=[trigo circlex:120 a:180-(iceQubeCount[i]-230)]+100;
                    iceQubePos[i][1]=[trigo circley:120 a:180-(iceQubeCount[i]-230)]+200;
                }else {
                    iceQubeCount[i]+=1.2;
                    iceQubePos[i][0]=[trigo circlex:iceQubeCount[i] a:359]+200;
                    iceQubePos[i][1]=[trigo circley:iceQubeCount[i] a:359]+263;
                }
                
                
                if(iceQubeCount[i]>26&&iceQubeCount[i]<=28){
                    iceBlastAnimationCount=1;
                    iceBlastAtlas.position=ccp(iceQubePos[i][0]-82,iceQubePos[i][1]-16);
                }
                
                if(iceQubeCount[i]>=185){
                    iceBlastAnimationCount=1;
                    iceBlastAtlas.position=ccp(iceQubePos[i][0]-90,iceQubePos[i][1]-14);
                    iceQubeSprite[i].rotation=arc4random() % 360 + 1;
                    iceQubeCount[i]=-40;
                    iceQubeSprite[i].position=ccp(-300,100);
                    iceQubeSprite[i].visible=NO;
                }else{
                    iceQubeSprite[i].position=ccp(iceQubePos[i][0]-35,iceQubePos[i][1]);
                }
            }
        }
        
        iceQubeReleaseCount+=1;
        if(iceQubeReleaseCount>(iceQubeDelayCount==4?600:20)){
            iceQubeReleaseCount=0;
            for(int i=0;i<4;i++){
                if(iceQubeCount[i]==-40){
                    iceQubeCount[i]=-39;
                    iceQubeDelayCount+=1;
                    iceQubeSprite[i].visible=YES;
                    iceQubeDelayCount=(iceQubeDelayCount>4?1:iceQubeDelayCount);
                    break;
                }
            }
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
    if(screenMoveChe ){
        for(int i=0;i<20;i++){
            CGFloat xx=0;
            CGFloat yy=0;
            if(waterDropsCount[i]>=1){
                waterDropsCount[i]+=1.5;
                xx=[trigo circlex:waterDropsCount[i] a:270]+618;
                yy=[trigo circley:waterDropsCount[i] a:270]+450;
                
                waterDropsSprite[i].position=ccp(xx,yy);
                if(waterDropsCount[i]>=156){
                    waterDropsCount[i]=156;
                    waterDropsSprite[i].position=ccp(xx-(i*2),yy);
                    milkStopChe=YES;
                    [[catObj getCatSprite] resumeSchedulerAndActions];
                }
            }
        }
        
        if(gameFunc.milkRotateCount>=90){
            waterDropsReleaseCount+=1;
            if(waterDropsReleaseCount>1){
                waterDropsReleaseCount=0;
                for(int i=0;i<20;i++){
                    if(waterDropsCount[i]==0){
                        waterDropsCount[i]=1;
                        break;
                    }
                }
            }
        }
    }
    
    //Smoking
    for(int i=0;i<5;i++){
        for(int j=0;j<2;j++){
            if(iceSmokingCount[i][j]!=0){
                int xx=0;
                int yy=0;
                xx=[trigo circlex:iceSmokingCount[i][j] a:255+(j*12)]+423;
                yy=[trigo circley:iceSmokingCount[i][j] a:255+(j*12)]+305;
                
                iceSmokingSprite[i][j].position=ccp(xx,yy);
                iceSmokingSprite[i][j].scale=(iceSmokingCount[i][j]/70.0)+0.1;
                iceSmokingCount[i][j]+=1.2;
                if(iceSmokingCount[i][j]>=46){
                    iceSmokingCount[i][j]=0;
                    iceSmokingSprite[i][j].position=ccp(-200,100);
                }
            }
        }
    }
    
    if(waterIntervalTimeCount<300){
        iceSmokingReleaseCount+=1;
        if(iceSmokingReleaseCount>=8){
            iceSmokingReleaseCount=0;
            for(int i=0;i<5;i++){
                if(iceSmokingCount[i][0]==0){
                    iceSmokingCount[i][0]=1;
                    iceSmokingCount[i][1]=1;
                    break;
                }
            }
        }
    }
    
    if(waterIntervalTimeCount>=1){
        waterIntervalTimeCount+=1;
        waterIntervalTimeCount=(waterIntervalTimeCount>500?1:waterIntervalTimeCount);
    }
}


-(void)collision{
    CGFloat hx=heroSprite.position.x;
    CGFloat hy=heroSprite.position.y;
    int iValue=(forwardChe?43:0);
    
    if(hx-iValue<70&&hy>480 && hy< 532){
        fridgeVisibleCount-=15;
        if(fridgeVisibleCount<=0)
            fridgeVisibleCount=0;
    }else{
        fridgeVisibleCount+=15;
        if(fridgeVisibleCount>=250)
            fridgeVisibleCount=250;
    }
    fridgeSprite.opacity=fridgeVisibleCount;
    for(int i=0;i<4;i++){
        if(hx-iValue>iceQubePos[i][0]-70 &&hx-iValue<iceQubePos[i][0]-30 &&hy > iceQubePos[i][1]-30 &&hy<iceQubePos[i][1]+20&&iceQubeCount[i]<187 &&!gameFunc.trappedChe){
            gameFunc.trappedChe=YES;
            trappedTypeValue=1;
        }
    }
    
    for(int i=0;i<5;i++){
        for(int j=0;j<2;j++){
            if(hx-iValue>iceSmokingSprite[i][j].position.x-30 &&hx-iValue<iceSmokingSprite[i][j].position.x+20 &&hy > iceSmokingSprite[i][j].position.y-30 &&hy<iceSmokingSprite[i][j].position.y+20&&!gameFunc.trappedChe){
                 gameFunc.trappedChe=YES;
                trappedTypeValue=2;
            }
        }
    }
    
    if(hx-iValue>[catObj getCatSprite].position.x-90 &&hx-iValue<[catObj getCatSprite].position.x+40 &&hy > [catObj getCatSprite].position.y-30 &&hy<[catObj getCatSprite].position.y+50 &&!gameFunc.
       trappedChe){
        gameFunc.trappedChe=YES;
        trappedTypeValue=3;
    }
    
    if(hx-iValue>375&&hx-iValue<=401 && hy==266&&!screenMoveChe&&screenMovementFindValue2==0){
        screenMoveChe=YES;
        [[catObj getCatSprite] pauseSchedulerAndActions];
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
        gameFunc.moveCount2=1;
    }
}

-(void)switchFunc{
    if(!screenMoveChe&&gameFunc.milkRotateCount>=10&&screenMovementFindValue==0){
        screenMoveChe=YES;
        [[catObj getCatSprite] pauseSchedulerAndActions];
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
    }
    
    if(screenMoveChe){
        if(screenMovementFindValue==1){
            if(gameFunc.milkRotateCount>=90){
                screenShowY-=1;
                if(screenShowY<300){
                    screenMovementFindValue=2;
                    milkSprite.visible=NO;
                }
            }
        }else if(screenMovementFindValue==2){
            screenShowY+=1;
            if(screenShowY>screenShowY2){
                screenShowY=screenShowY2;
                screenMovementFindValue=5;
                screenMoveChe=NO;
                [[catObj getCatSprite] resumeSchedulerAndActions];
                screenHeroPosX=platformX;
                screenHeroPosY=platformY;
                screenShowX=platformX;
                screenShowY=platformY;
            }
        }
        
        if(screenMovementFindValue2==1){
            screenShowY+=3;
            if(screenShowY>500)
                screenMovementFindValue2=2;
        }else if(screenMovementFindValue2 == 2){
            screenShowX+=5;
            if(screenShowX>750){
                screenShowX=750;
                if(gameFunc.catStopWoodCount==0){
                    gameFunc.catStopWoodCount=1;
                    catReleaseChe=YES;
                }
            }
            if(gameFunc.catStopWoodCount>=100)
                screenMovementFindValue2=3;
        }else if(screenMovementFindValue2 == 3){
            screenShowX-=5;
            if(screenShowX<screenShowX2){
                screenShowX=screenShowX2;
                screenMovementFindValue2=4;
            }
        }else if(screenMovementFindValue2 == 4){
            screenShowY-=5;
            if(screenShowY<=screenShowY2){
                screenShowY=screenShowY2;
                screenMovementFindValue2=5;
                screenMoveChe=NO;
                [[catObj getCatSprite] resumeSchedulerAndActions];
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
        platformY=gameFunc.movePlatformY-gameFunc.landMoveCount+gameFunc.moveCount2;
        if(!forwardChe)
            heroSprite.position=ccp(platformX,platformY);
        else
            heroSprite.position=ccp(platformX+heroForwardX,platformY);
        CGPoint copyHeroPosition = ccp(platformX, platformY);
        [self setViewpointCenter:copyHeroPosition];
        
        if(heroJumpLocationChe)
            [self HeroLiningDraw:0];
    }
    
    hoenyPotSprite.position=ccp(723+gameFunc.honeyPotCount,273-gameFunc.honeyPotCount2);
    if(gameFunc.honeyPotCount2>=10&&waterIntervalTimeCount==0)
        waterIntervalTimeCount=300;
    
    movePlatformSprite.position=ccp(240,500+gameFunc.moveCount2);
    milkSprite.rotation=-gameFunc.milkRotateCount;
    milkSprite.position=ccp(665,428-(gameFunc.milkRotateCount/15));
    
    catStopWoodSprite.position=ccp(808,603+gameFunc.catStopWoodCount);
    if (gameFunc.catStopWoodCount == 50) {
        catObj.isJumpEnabled = YES;
    }
    pulbCount+=1.7;
    pulbCount=(pulbCount>=250?0:pulbCount);
    if(pulbCount<=125){
        pulbSprite.rotation=(pulbCount-63);
    }else{
        pulbSprite.rotation=(125-(pulbCount-125)-63);
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
    if(heroSprite.position.x>=920+fValue&&heroSprite.position.y>=250 && heroSprite.position.y<300&&!mouseWinChe){
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
        if(heroTrappedChe&&heroTrappedCount>=100&&heroTrappedMove==0){
            menu2.visible=YES;
            mouseTrappedBackground.visible=YES;
        }
    }
    
    if(gameFunc.honeyPotCount==0&&!cheeseSprite[0].visible)
        gameFunc.honeyPotCount=1;
    
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
        if(heroTrappedCount==10){
            for (int i = 0; i < 20; i=i+1)
                heroPimpleSprite[i].position=ccp(-100,100);
            
            if(trappedTypeValue==1||trappedTypeValue==2 ||trappedTypeValue == 3)
                heroTrappedMove=1;
            
            mouseDragSprite.visible=NO;
            if (trappedTypeValue != 3) {
                heroTrappedSprite = [CCSprite spriteWithFile:@"sm_mist_0.png"];
                int posY = 270;
                heroTrappedSprite.scale=0.5;
                heroTrappedSprite.position = ccp(heroSprite.position.x, heroSprite.position.y);
                [self addChild:heroTrappedSprite z:1000];
                
                CCMoveTo *move = [CCMoveTo actionWithDuration:1 position:ccp(heroSprite.position.x, posY)];
                [heroTrappedSprite runAction:move];
            }
            else{
                heroTrappedSprite = [CCSprite spriteWithFile:@"sm_mist_0.png"];
                if(!forwardChe)
                    heroTrappedSprite.position = ccp(platformX, platformY+5);
                else
                    heroTrappedSprite.position = ccp(platformX+heroForwardX, platformY+5);
                heroTrappedSprite.scale = 0.5;
                [self addChild:heroTrappedSprite];
                
//                NSMutableArray *animFrames2 = [NSMutableArray array];
//                for(int i = 1; i < 4; i++) {
//                    
//                    CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"strong_trapped%d.png",i]];
//                    [animFrames2 addObject:frame];
//                    
//                }
//                CCAnimation *animation2 = [CCAnimation animationWithSpriteFrames:animFrames2 delay:0.1f];
//                [heroTrappedSprite runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation2]]];
            }
            heroSprite.visible=NO;
        }
        if(heroTrappedMove!=0){
            int fValue = (forwardChe?heroForwardX:0);
            CGFloat xPos=0;
            if(trappedTypeValue<=3)
                xPos=heroSprite.position.x-(forwardChe?40:-40);
            
            if (trappedTypeValue == 3) {
                heroTrappedSprite.position = ccp(xPos,heroSprite.position.y-heroTrappedMove);
            }
            
            CGPoint copyHeroPosition = ccp(heroSprite.position.x-fValue, heroSprite.position.y-heroTrappedMove);
            [self setViewpointCenter:copyHeroPosition];
            if(trappedTypeValue <= 3){
                heroTrappedMove+=1;
                if(heroSprite.position.y-heroTrappedMove<=270)
                    heroTrappedMove=0;
            }
        }
    }
    
}
-(void)heroWinFunc{
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
            for(int i = 0; i <27; i++) {
                CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"strong_win%d.png",i+1]];
                [animFrames2 addObject:frame];
            }
            CCAnimation *animation2 = [CCAnimation animationWithSpriteFrames:animFrames2 delay:0.05f];
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
                platformX+=2.2;
                platformY=gameFunc.movePlatformY-gameFunc.landMoveCount+gameFunc.moveCount2;
                [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
                platformY=gameFunc.yPosition;
                platformX=gameFunc.xPosition;
            }else{
                platformX-=2.2;
                platformY=gameFunc.movePlatformY-gameFunc.landMoveCount+gameFunc.moveCount2;
                [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
                platformY=gameFunc.yPosition;
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
                    [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
                    platformX=gameFunc.xPosition;
                    platformY=gameFunc.yPosition;
                }
            }else{
                if(!gameFunc.trigoVisibleChe){
                    platformX-=2.2;
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
        if(gameFunc.pushChe){
            if(!forwardChe)
                heroPushSprite.position=ccp(heroSprite.position.x+10,heroSprite.position.y);
            else
                heroPushSprite.position=ccp(heroSprite.position.x-10,heroSprite.position.y);
            
            heroRunSprite.visible=NO;
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
        }
    }
}

-(void)HeroLiningDraw:(int)cPath{
    
    CGFloat angle=jumpAngle;
    
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
        mouseDragSprite.position=ccp(platformX + DRAG_SPRITE_OFFSET_X/2 +heroForwardX,platformY-DRAG_SPRITE_OFFSET_Y/2);
    
    mouseDragSprite.rotation=(180-angle)-170;
    mouseDragSprite.scale=0.3+(jumpPower/40.0);
    
    
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
                    mouseDragSprite.position=ccp(platformX - DRAG_SPRITE_OFFSET_X,platformY-DRAG_SPRITE_OFFSET_Y);
                    mouseDragSprite.rotation=(180-0)-170;
                }else{
                    mouseDragSprite.rotation=(180-180)-170;
                    mouseDragSprite.position=ccp(platformX+ DRAG_SPRITE_OFFSET_X/2+heroForwardX,platformY-DRAG_SPRITE_OFFSET_Y/2);
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
            mouseDragSprite.visible=NO;
            for (int i = 0; i < 20; i=i+1) {
                heroPimpleSprite[i].position=ccp(-100,100);
            }
            if(gameFunc.movePlatformChe)
                gameFunc.movePlatformChe=NO;
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
        [[CCDirector sharedDirector] replaceScene:[StrongMouseEngine13 scene]];
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
    if ( trappedTypeValue == 2 ||  trappedTypeValue == 1) {
        [self endJumping:platformX - 30 yValue:gameFunc.yPosition];
        [self schedule:@selector(startRespawnTimer) interval:1];
    }else{
        [self endJumping:(platformX + gameFunc.xPosition)/2 yValue:gameFunc.yPosition];
        [self schedule:@selector(startRespawnTimer) interval:1];
    }
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
