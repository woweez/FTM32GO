//
//  HelloWorldLayer.mm
//  Tap
//
//  Created by karthik g on 27/09/12.
//  Copyright karthik g 2012. All rights reserved.
//

// Import the interfaces
#import "GirlMouseEngine13.h"
#import "LevelScreen.h"


// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "DB.h"
enum {
    kTagParentNode = 1,
};

GirlMouseEngineMenu13 *gLayer13;

@implementation GirlMouseEngineMenu13


-(id) init {
    if( (self=[super init])) {
    }
    return self;
}
@end

@implementation GirlMouseEngine13

@synthesize tileMap = _tileMap;
@synthesize background = _background;

+(CCScene *) scene {
    CCScene *scene = [CCScene node];
    gLayer13=[GirlMouseEngineMenu13 node];
    [scene addChild:gLayer13 z:1];
    
    GirlMouseEngine13 *layer = [GirlMouseEngine13 node];
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
        heroRunningStopArr=[[NSArray alloc] initWithObjects:@"80",@"80",@"80", @"40",@"140",@"80",@"80",@"80",@"80",@"80",@"80",@"80",@"80",@"80",nil];
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
        
        
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"background.tmx"];
        self.background = [_tileMap layerNamed:@"background"];
        _tileMap.position=ccp(0,-158);
        _tileMap.scaleY=1.3;
        [self addChild:_tileMap z:-1 tag:1];
        
        
        cache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [cache addSpriteFramesWithFile:@"girl_default.plist"];
        [cache addSpriteFramesWithFile:@"sink_waterAnim.plist"];
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
        [gLayer13 addChild:menu z:10];
        
        mouseTrappedBackground=[CCSprite spriteWithFile:@"mouse_trapped_background.png"];
        mouseTrappedBackground.position=ccp(240,160);
        mouseTrappedBackground.visible=NO;
        [gLayer13 addChild:mouseTrappedBackground z:10];
        
        CCMenuItem *aboutMenuItem = [CCMenuItemImage itemWithNormalImage:@"main_menu_button_1.png" selectedImage:@"main_menu_button_2.png" target:self selector:@selector(clickLevel:)];
        aboutMenuItem.tag=2;
        
        CCMenuItem *optionMenuItem = [CCMenuItemImage itemWithNormalImage:@"try_again_button_1.png" selectedImage:@"try_again_button_2.png" target:self selector:@selector(clickLevel:)];
        optionMenuItem.tag=1;
        
        menu2 = [CCMenu menuWithItems: optionMenuItem,aboutMenuItem,  nil];
        [menu2 alignItemsHorizontallyWithPadding:4.0];
        menu2.position=ccp(241,136);
        menu2.visible=NO;
        [gLayer13 addChild: menu2 z:10];
        
        progressBarBackSprite=[CCSprite spriteWithFile:@"grey_bar_57.png"];
        progressBarBackSprite.position=ccp(240,300);
        progressBarBackSprite.visible = NO;
        [gLayer13 addChild:progressBarBackSprite z:10];
        
        cheeseCollectedSprite=[CCSprite spriteWithFile:@"cheese_collected.png"];
        cheeseCollectedSprite.position=ccp(430,300);
        cheeseCollectedSprite.visible = NO;
        [gLayer13 addChild:cheeseCollectedSprite z:10];
        
        timeCheeseSprite=[CCSprite spriteWithFile:@"time_cheese.png"];
        timeCheeseSprite.position=ccp(121+240,301);
        timeCheeseSprite.visible = NO;
        [gLayer13 addChild:timeCheeseSprite z:10];
        
        
        lifeMinutesAtlas = [[CCLabelAtlas labelWithString:@"01.60" charMapFile:@"numbers.png" itemWidth:15 itemHeight:20 startCharMap:'.'] retain];
        lifeMinutesAtlas.visible = NO;
        lifeMinutesAtlas.position=ccp(250,292);
        [gLayer13 addChild:lifeMinutesAtlas z:10];
        
        
        cheeseCollectedAtlas = [[CCLabelAtlas labelWithString:@"0/3" charMapFile:@"numbers.png" itemWidth:15 itemHeight:20 startCharMap:'.'] retain];
        cheeseCollectedAtlas.visible = NO;
        cheeseCollectedAtlas.position=ccp(422,292);
        cheeseCollectedAtlas.scale=0.8;
        [gLayer13 addChild:cheeseCollectedAtlas z:10];
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
        slapSprite.position=ccp(178,140);
        slapSprite.scale=0.7;
        [self addChild:slapSprite z:1];
        
        slapSprite=[CCSprite spriteWithFile:@"slap.png"];
        slapSprite.position=ccp(526,140);
        slapSprite.scale=0.7;
        [self addChild:slapSprite z:1];
        
        slapSprite=[CCSprite spriteWithFile:@"slap.png"];
        slapSprite.position=ccp(828,140);
        slapSprite.scale=0.7;
        [self addChild:slapSprite z:1];
        
        for(int i=0;i<4;i++){
            iceQubeSprite[i]=[CCSprite spriteWithFile:@"ice_qube.png"];
            iceQubeSprite[i].position=ccp(-107,525);
            [self addChild:iceQubeSprite[i] z:0];
        }
        
        
        sprite=[CCSprite spriteWithFile:@"water_sink_1.png"];
        sprite.position=ccp(450,210);
        [self addChild:sprite z:1];
        
        sprite=[CCSprite spriteWithSpriteFrameName:@"sink_water_0.png"];
        sprite.position=ccp(450,200);
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
        sprite.position=ccp(450,147);
        [self addChild:sprite z:1];
        
        sprite=[CCSprite spriteWithFile:@"water_sink_3.png"];
        sprite.position=ccp(452,217);
        sprite.scale=0.5;
        [self addChild:sprite z:1];
        
        sprite=[CCSprite spriteWithFile:@"water_plate.png"];
        sprite.position=ccp(496,204);
        sprite.scale=0.5;
        [self addChild:sprite z:1];
        
        sprite=[CCSprite spriteWithFile:@"water_plate.png"];
        sprite.position=ccp(405,204);
        sprite.scale=0.5;
        [self addChild:sprite z:1];
        
        sprite=[CCSprite spriteWithFile:@"plate_groupe.png"];
        sprite.position=ccp(400,560);
        [self addChild:sprite z:1];
        
        sprite=[CCSprite spriteWithFile:@"plate_groupe.png"];
        sprite.position=ccp(500,560);
        [self addChild:sprite z:1];
        
        for(int i=0;i<5;i++){
            for(int j=0;j<2;j++){
                iceSmokingSprite[i][j]=[CCSprite spriteWithFile:@"ice_smoke.png"];
                iceSmokingSprite[i][j].position=ccp(-100,258);
                [self addChild:iceSmokingSprite[i][j] z:1];
            }
        }
        
        CCSprite *waterPipeSprite=[CCSprite spriteWithFile:@"water_pipe.png"];
        waterPipeSprite.position=ccp(443,262);
        waterPipeSprite.flipX=1;
        waterPipeSprite.scale=0.8;
        [self addChild:waterPipeSprite z:1];
        
        CCSprite *platformSprite=[CCSprite spriteWithFile:@"move_platform2.png"];
        platformSprite.position=ccp(450,300);
        [self addChild:platformSprite z:1];
        
        platformSprite=[CCSprite spriteWithFile:@"sticky_platform.png"];
        platformSprite.position=ccp(905,320);
        [self addChild:platformSprite z:10];
        
        platformSprite=[CCSprite spriteWithFile:@"sticky_platform.png"];
        platformSprite.position=ccp(680,420);
        [self addChild:platformSprite z:10];
        
        platformSprite=[CCSprite spriteWithFile:@"move_platform3.png"];
        platformSprite.position=ccp(30,450);
        [self addChild:platformSprite z:1];
        
        platformSprite=[CCSprite spriteWithFile:@"sticky_platform.png"];
        platformSprite.position=ccp(450,520);
        [self addChild:platformSprite z:1];
        
        platformSprite=[CCSprite spriteWithFile:@"sticky_platform.png"];
        platformSprite.position=ccp(905,550);
        [self addChild:platformSprite z:1];
        
        movePlatformSprite=[CCSprite spriteWithFile:@"sticky_platform.png"];
        movePlatformSprite.position=ccp(240,500);
        movePlatformSprite.scaleX=0.72;
        [self addChild:movePlatformSprite z:10];
        
        catStopWoodSprite=[CCSprite spriteWithFile:@"cat_stop_wood.png"];
        catStopWoodSprite.position=ccp(815,650);
        catStopWoodSprite.scale=0.8;
        [self addChild:catStopWoodSprite z:1];
        
        CCSprite *holeSprite=[CCSprite spriteWithFile:@"hole.png"];
        holeSprite.position=ccp(970,592);
        [self addChild:holeSprite z:0];
        
        switchAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"switch.png" itemWidth:40 itemHeight:103 startCharMap:'0'] retain];
        switchAtlas.position=ccp(500,205);
        switchAtlas.scale=0.7;
        [self addChild:switchAtlas z:1];
        
        switchAtlas2 = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"switch.png" itemWidth:40 itemHeight:103 startCharMap:'0'] retain];
        switchAtlas2.position=ccp(10,440);
        switchAtlas2.scale=0.7;
        [self addChild:switchAtlas2 z:1];
        
        iceBlastAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"ice_blast.png" itemWidth:100 itemHeight:50 startCharMap:'0'] retain];
        iceBlastAtlas.position=ccp(-270,200);
        [self addChild:iceBlastAtlas z:9];
        
        combButtonAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"push_button2.png" itemWidth:60 itemHeight:30 startCharMap:'0'] retain];
        combButtonAtlas.position=ccp(385,200);
        combButtonAtlas.scale=0.4;
        combButtonAtlas.scaleX=0.6;
        [self addChild:combButtonAtlas z:9];
        
        pulbSprite=[CCSprite spriteWithFile:@"pulb.png"];
        pulbSprite.position=ccp(450,755);
        pulbSprite.anchorPoint=ccp(0.5f, 0.6f);
        [self addChild:pulbSprite z:10];
        
        for(int i=0;i<25;i++){
            heroPimpleSprite[i]=[CCSprite spriteWithFile:@"dotted.png"];
            heroPimpleSprite[i].position=ccp(-100,160);
            heroPimpleSprite[i].scale=0.3;
            [self addChild:heroPimpleSprite[i] z:10];
        }
        
        //===================================================================
        
        dotSprite=[CCSprite spriteWithFile:@"dotted.png"];
        dotSprite.position=ccp(440,305);
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
    [gLayer13 addChild: hudLayer z:2000];
    [hudLayer updateNoOfCheeseCollected:0 andMaxValue:[cheeseSetValue[motherLevel-1] intValue]];
}

-(void) addLevelCompleteLayerToTheScene{
    hudLayer.visible = NO;
    LevelCompleteScreen *lvlCompleteLayer = [[LevelCompleteScreen alloc] init];
    lvlCompleteLayer.tag = 13;
    [gLayer13 addChild: lvlCompleteLayer z:2000];
}
-(void)initValue{
    
//    DB *db = [DB new];
    motherLevel = 13;//[[db getSettingsFor:@"CurrentLevel"] intValue];
//    [db release];
    cheeseCount=[cheeseSetValue[motherLevel-1] intValue];
    
    platformX=100;
    platformY=505;
    
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
    turnAnimationCount3=1;
    iceQubeCount[0]=-40;
    iceQubeCount[1]=-40;
    iceQubeCount[2]=-40;
    iceQubeCount[3]=-40;
    turnAnimationCount2=1;
    
    
    
    
    
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
    [self waterDropsFunc];
    if(!screenMoveChe){
        [self catFunc];
        [self secondCatFunc];
        [self thirdCatFunc];
    }
    
    
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
-(void)catFunc{
    
//    if (!catJumpChe && catObj1 == nil) {
//        catObj1 = [[GirlLevel13Cat alloc] init];
//        [catObj1 runCurrentSequence];
//        [self addChild:catObj1];
//    }
    if(!catBackChe){
        if(catMovementCount<80){
            if(turnAnimationCount==0){
                catX=[trigo circlex:catMovementCount a:359]+190;
                catY=[trigo circley:catMovementCount a:359]+523;
                catMovementCount+=1;
                if(catAnimationCount%2 == 0)
                    [self catSpriteGenerate:catAnimationCount/2 animationType:@"run"];
                if(catMovementCount >=80){
                    if(!gameFunc.catFirstJumpChe){
                        catBackChe=YES;
                        turnAnimationCount=1;
                        catMovementCount=80;
                    }else{
                        catJumpChe=YES;
                    }
                }
            }
        }else if(catMovementCount>=80 && catMovementCount<205){
            if(catJumpingAnimationCount>=55){
                if(catMovementCount==80){
                    catFirstPosChe=YES;
                    gameFunc.catFirstJumpChe=NO;
                }
                catX=[trigo circlex:50 a:220-catMovementCount]+340;
                catY=[trigo circley:60 a:220-catMovementCount]+302;
                catMovementCount+=2.0;
                
                if(catJumpingAnimationCount>=55){
                    catJumpingAnimationCount+=1;
                    catJumpingAnimationCount=(catJumpingAnimationCount>=90?90:catJumpingAnimationCount);
                    if(catJumpingAnimationCount%5==0)
                        [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                }
            }
        }else if(catMovementCount>=205){
            
            if(!catJumpChe&&turnAnimationCount==0){
                catX=[trigo circlex:catMovementCount-207 a:359]+403;
                catY=[trigo circley:catMovementCount-207 a:359]+323;
                catMovementCount+=1;
                if(catAnimationCount%2 == 0)
                    [self catSpriteGenerate:catAnimationCount/2 animationType:@"run"];
                if(catMovementCount>=285){
                    catMovementCount=285;
                    turnAnimationCount=1;
                    catBackChe=YES;
                }
                
            }else{
                if(catJumpChe){
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
        
        
    }else{
        
        if(catMovementCount>205&&catMovementCount<=285){
            if(turnAnimationCount==0){
                catX=[trigo circlex:catMovementCount-207 a:359]+403;
                catY=[trigo circley:catMovementCount-207 a:359]+323;
                catMovementCount-=1;
                if(catAnimationCount%2 == 0)
                    [self catSpriteGenerate:catAnimationCount/2 animationType:@"run"];
                if(catMovementCount<=205){
                    if(gameFunc.catFirstJumpChe){
                        catJumpChe=YES;
                    }else{
                        catBackChe=NO;
                        turnAnimationCount=1;
                    }
                }
            }
        }else if(catMovementCount>80 && catMovementCount<=205){
            if(catJumpingAnimationCount>=55){
                
                catX=[trigo circlex:50 a:220-catMovementCount]+340;
                catY=[trigo circley:60 a:220-catMovementCount]+302;
                catMovementCount-=2.0;
                
                if(catJumpingAnimationCount>=55){
                    catJumpingAnimationCount+=1;
                    catJumpingAnimationCount=(catJumpingAnimationCount>=90?90:catJumpingAnimationCount);
                    if(catJumpingAnimationCount%5==0)
                        [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                }
            }
        }else if(catMovementCount<=80){
            if(!catJumpChe&&turnAnimationCount==0){
                catX=[trigo circlex:catMovementCount a:359]+190;
                catY=[trigo circley:catMovementCount a:359]+523;
                catMovementCount-=1;
                if(catAnimationCount%2 == 0)
                    [self catSpriteGenerate:catAnimationCount/2 animationType:@"run"];
                if(catMovementCount<=0){
                    
                    turnAnimationCount=1;
                    catBackChe=NO;
                }
            }else{
                if(catJumpChe){
                    if(catJumpingAnimationCount<=105){
                        catJumpingAnimationCount+=1;
                        if(catJumpingAnimationCount%5 == 0)
                            [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                    }else{
                        catJumpingAnimationCount=0;
                        catFirstPosChe=NO;
                        gameFunc.catFirstJumpChe=NO;
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
    if(turnAnimationCount==0)
        catSprite.position=ccp(catX,catY+16+(!catFirstPosChe?gameFunc.moveCount2:0));
    else
        catSprite.position=ccp(catX,catY+13+(!catFirstPosChe?gameFunc.moveCount2:0));
    
}
-(void)secondCatFunc{
    
//    if (!catJumpChe2 && catObj2 == nil) {
//        catObj2 = [[GirlLevel13Cat alloc] init];
//        [catObj2 runCurrentSequenceForFirstCat];
//        [self addChild:catObj2];
//    }
    if(!catBackChe2){
        if(catMovementCount2<100){
            if(turnAnimationCount2==0){
                catX2=[trigo circlex:catMovementCount2 a:179]+970;
                catY2=[trigo circley:catMovementCount2 a:179]+573;
                catMovementCount2+=1;
                if(catAnimationCount2%2 == 0)
                    [self secondCatSpriteGenerate:catAnimationCount2/2 animationType:@"run"];
                if(catMovementCount2>=100){
                    if(gameFunc.plateWoodStopCount>=70)
                        catJumpChe2=YES;
                    else{
                        catBackChe2=YES;
                        turnAnimationCount2=1;
                    }
                    
                }
            }
        }else if(catMovementCount2>=100&&catMovementCount2<228){
            if(catJumpingAnimationCount2>=55){
                catX2=[trigo circlex:120 a:catMovementCount2-50]+750;
                catY2=[trigo circley:140 a:catMovementCount2-50]+438;
                catMovementCount2+=1;
                if(catJumpingAnimationCount2>=55&&catMovementCount2<370){
                    catJumpingAnimationCount2+=1;
                    catJumpingAnimationCount2=(catJumpingAnimationCount2>=90?90:catJumpingAnimationCount2);
                    if(catJumpingAnimationCount2%5==0)
                        [self secondCatSpriteGenerate:catJumpingAnimationCount2/5 animationType:@"jump"];
                }
            }
        }else if(catMovementCount2>=228&&catMovementCount2<350){
            if(!catJumpChe2&&turnAnimationCount2==0){
                catX2=[trigo circlex:catMovementCount2-228 a:359]+600;
                catY2=[trigo circley:catMovementCount2-228 a:359]+443;
                catMovementCount2+=1;
                if(catAnimationCount2%2 == 0)
                    [self secondCatSpriteGenerate:catAnimationCount2/2 animationType:@"run"];
                
                if(catMovementCount2>=350){
                    catMovementCount2=350;
                    catJumpChe2=YES;
                }
                
            }else if(catJumpChe2){
                if(catJumpingAnimationCount2<=105){
                    catJumpingAnimationCount2+=1;
                    if(catJumpingAnimationCount2%5 == 0)
                        [self secondCatSpriteGenerate:catJumpingAnimationCount2/5 animationType:@"jump"];
                }else{
                    catJumpingAnimationCount2=0;
                    catJumpChe2=NO;
                    turnAnimationCount2=1;
                }
            }
        }else if(catMovementCount2>=350&&catMovementCount2<460){
            if(catJumpingAnimationCount2>=55){
                catX2=[trigo circlex:40 a:110-catMovementCount2]+778;
                catY2=[trigo circley:120 a:110-catMovementCount2]+314;
                catMovementCount2+=1;
                if(catJumpingAnimationCount2>=55){
                    catJumpingAnimationCount2+=1;
                    catJumpingAnimationCount2=(catJumpingAnimationCount2>=90?90:catJumpingAnimationCount2);
                    if(catJumpingAnimationCount2%5==0)
                        [self secondCatSpriteGenerate:catJumpingAnimationCount2/5 animationType:@"jump"];
                }
            }
            
        }else if(catMovementCount2>=460){
            if(!catJumpChe2&&turnAnimationCount2==0){
                catX2=[trigo circlex:catMovementCount2-460 a:359]+828;
                catY2=[trigo circley:catMovementCount2-460 a:359]+344;
                catMovementCount2+=1;
                if(catAnimationCount2%2 == 0)
                    [self secondCatSpriteGenerate:catAnimationCount2/2 animationType:@"run"];
                if(catMovementCount2>=570){
                    catMovementCount2=570;
                    turnAnimationCount2=1;
                    catBackChe2=YES;
                }
                
            }else if(catJumpChe2){
                if(catJumpingAnimationCount2<=105){
                    catJumpingAnimationCount2+=1;
                    if(catJumpingAnimationCount2%5 == 0)
                        [self secondCatSpriteGenerate:catJumpingAnimationCount2/5 animationType:@"jump"];
                }else{
                    catJumpingAnimationCount2=0;
                    catJumpChe2=NO;
                }
            }
        }
    }else{
        if(catMovementCount2>=460&& catAnimationCount2<=570){
            if(turnAnimationCount2==0){
                catX2=[trigo circlex:catMovementCount2-460 a:359]+828;
                catY2=[trigo circley:catMovementCount2-460 a:359]+344;
                catMovementCount2-=1;
                if(catAnimationCount2%2 == 0)
                    [self secondCatSpriteGenerate:catAnimationCount2/2 animationType:@"run"];
                if(catMovementCount2<=460){
                    catJumpChe2=YES;
                }
            }
        }else if(catMovementCount2>350&&catMovementCount2<=460){
            if(catJumpingAnimationCount2>=55){
                catX2=[trigo circlex:40 a:110-catMovementCount2]+778;
                catY2=[trigo circley:120 a:110-catMovementCount2]+314;
                catMovementCount2-=1;
                if(catJumpingAnimationCount2>=55&&catMovementCount2<400){
                    catJumpingAnimationCount2+=1;
                    catJumpingAnimationCount2=(catJumpingAnimationCount2>=90?90:catJumpingAnimationCount2);
                    if(catJumpingAnimationCount2%5==0)
                        [self secondCatSpriteGenerate:catJumpingAnimationCount2/5 animationType:@"jump"];
                }
            }
        }else if(catMovementCount2>228&&catMovementCount2<=350){
            if(!catJumpChe2&&turnAnimationCount2==0){
                catX2=[trigo circlex:catMovementCount2-228 a:359]+600;
                catY2=[trigo circley:catMovementCount2-228 a:359]+443;
                catMovementCount2-=1;
                if(catAnimationCount2%2 == 0)
                    [self secondCatSpriteGenerate:catAnimationCount2/2 animationType:@"run"];
                
                if(catMovementCount2<=228){
                    turnAnimationCount2=1;
                }
                
            }else if(catJumpChe2){
                if(catJumpingAnimationCount2<=105){
                    catJumpingAnimationCount2+=1;
                    if(catJumpingAnimationCount2%5 == 0)
                        [self secondCatSpriteGenerate:catJumpingAnimationCount2/5 animationType:@"jump"];
                }else{
                    catJumpingAnimationCount2=0;
                    catJumpChe2=NO;
                }
            }
        }else if(catMovementCount2>100&&catMovementCount2<=228){
            if(catMovementCount2==228){
                if(turnAnimationCount2==0){
                    catJumpChe2=YES;
                    catMovementCount2=227;
                }
            }else{
                if(catJumpingAnimationCount2>=55){
                    catX2=[trigo circlex:120 a:catMovementCount2-50]+750;
                    catY2=[trigo circley:140 a:catMovementCount2-50]+438;
                    catMovementCount2-=1;
                    if(catJumpingAnimationCount2>=55&&catMovementCount2<160){
                        catJumpingAnimationCount2+=1;
                        catJumpingAnimationCount2=(catJumpingAnimationCount2>=90?90:catJumpingAnimationCount2);
                        if(catJumpingAnimationCount2%5==0)
                            [self secondCatSpriteGenerate:catJumpingAnimationCount2/5 animationType:@"jump"];
                    }
                }
            }
        }else if(catMovementCount2<=100){
            if(!catJumpChe2&&turnAnimationCount2==0){
                catX2=[trigo circlex:catMovementCount2 a:179]+970;
                catY2=[trigo circley:catMovementCount2 a:179]+573;
                catMovementCount2-=1;
                if(catAnimationCount2%2 == 0)
                    [self secondCatSpriteGenerate:catAnimationCount2/2 animationType:@"run"];
                if(catMovementCount2<=0){
                    catBackChe2=NO;
                    turnAnimationCount2=1;
                }
            }else{
                if(catJumpChe2){
                    if(catJumpingAnimationCount2<=105){
                        catJumpingAnimationCount2+=1;
                        if(catJumpingAnimationCount2%5 == 0)
                            [self secondCatSpriteGenerate:catJumpingAnimationCount2/5 animationType:@"jump"];
                    }else{
                        catJumpingAnimationCount2=0;
                        catJumpChe2=NO;
                    }
                }
            }
        }
    }
    
    
    if(turnAnimationCount2>0){
        turnAnimationCount2+=1;
        if(turnAnimationCount2%4==0)
            [self secondCatSpriteGenerate:turnAnimationCount2/4 animationType:@"turn"];
        if(turnAnimationCount2>=40){
            turnAnimationCount2=0;
            if(!catForwardChe2)
                catForwardChe2=YES;
            else
                catForwardChe2=NO;
        }
    }
    
    if(catJumpChe2){
        if(catJumpingAnimationCount2<55){
            catJumpingAnimationCount2+=1;
            if(catJumpingAnimationCount2%5==0)
                [self secondCatSpriteGenerate:catJumpingAnimationCount2/5 animationType:@"jump"];
        }
    }
    catAnimationCount2+=2;
    catAnimationCount2=(catAnimationCount2>=43?0:catAnimationCount2);
    if(turnAnimationCount2==0)
        catSprite2.position=ccp(catX2,catY2+16);
    else
        catSprite2.position=ccp(catX2,catY2+13);
}
-(void)thirdCatFunc{
    
//    if (!catJumpChe3 && catObj3 == nil) {
//        catObj3 = [[GirlLevel13Cat alloc] init];
//        [catObj3 runCurrentSequenceForSecondCat];
//        [self addChild:catObj3];
//    }
//    
    if(!catBackChe3){
        if(turnAnimationCount3==0){
            catX3=[trigo circlex:catMovementCount3 a:179]+850;
            catY3=[trigo circley:catMovementCount3 a:179]+220;
            catMovementCount3+=1;
            if(catAnimationCount3%2 == 0)
                [self thirdCatSpriteGenerate:catAnimationCount3/2 animationType:@"run"];
            if(catMovementCount3>=220){
                catBackChe3=YES;
                turnAnimationCount3=1;
                catMovementCount3=220;
            }
        }
    }else{
        if(turnAnimationCount3==0){
            catX3=[trigo circlex:catMovementCount3 a:179]+850;
            catY3=[trigo circley:catMovementCount3 a:179]+220;
            catMovementCount3-=1;
            if(catAnimationCount3%2 == 0)
                [self thirdCatSpriteGenerate:catAnimationCount3/2 animationType:@"run"];
            if(catMovementCount3<=0){
                catBackChe3=NO;
                turnAnimationCount3=1;
            }
        }
    }
    
    if(turnAnimationCount3>0){
        turnAnimationCount3+=1;
        if(turnAnimationCount3%4==0)
            [self thirdCatSpriteGenerate:turnAnimationCount3/4 animationType:@"turn"];
        if(turnAnimationCount3>=40){
            turnAnimationCount3=0;
            if(!catForwardChe3)
                catForwardChe3=YES;
            else
                catForwardChe3=NO;
        }
    }
    
    if(catJumpChe3){
        if(catJumpingAnimationCount3<55){
            catJumpingAnimationCount3+=1;
            if(catJumpingAnimationCount3%5==0)
                [self thirdCatSpriteGenerate:catJumpingAnimationCount3/5 animationType:@"jump"];
        }
    }
    catAnimationCount3+=2;
    catAnimationCount3=(catAnimationCount3>=43?0:catAnimationCount3);
    if(turnAnimationCount3==0)
        catSprite3.position=ccp(catX3,catY3+16);
    else
        catSprite3.position=ccp(catX3,catY3+13);
}
-(void)catSpriteGenerate:(int)fValue animationType:(NSString *)type{
    NSString *fStr=@"";
    if([type isEqualToString:@"run"])
        fStr=[NSString stringWithFormat:@"cat_run%d.png",fValue+1];
    else if([type isEqualToString:@"turn"]){
        fStr=[NSString stringWithFormat:@"cat_turn_run%d.png",fValue];
    }else if([type isEqualToString:@"jump"])
        fStr=[NSString stringWithFormat:@"cat_jump%d.png",fValue];
    
    [catSpriteSheet removeChild:catSprite cleanup:YES];
    catSprite = [CCSprite spriteWithSpriteFrameName:fStr];
    catSprite.position = ccp(catX,catY);
    catSprite.scale=0.6;
    if(!catForwardChe){
        catSprite.flipX=0;
    }else{
        catSprite.flipX=1;
    }
    [catSpriteSheet addChild:catSprite z:10];
}
-(void)secondCatSpriteGenerate:(int)fValue animationType:(NSString *)type{
    NSString *fStr=@"";
    if([type isEqualToString:@"run"])
        fStr=[NSString stringWithFormat:@"cat_run%d.png",fValue+1];
    else if([type isEqualToString:@"turn"]){
        fStr=[NSString stringWithFormat:@"cat_turn_run%d.png",fValue];
    }else if([type isEqualToString:@"jump"])
        fStr=[NSString stringWithFormat:@"cat_jump%d.png",fValue];
    
    [catSpriteSheet removeChild:catSprite2 cleanup:YES];
    catSprite2 = [CCSprite spriteWithSpriteFrameName:fStr];
    catSprite2.position = ccp(catX2,catY2);
    catSprite2.scale=0.6;
    if(!catForwardChe2){
        catSprite2.flipX=0;
    }else{
        catSprite2.flipX=1;
    }
    [catSpriteSheet addChild:catSprite2 z:10];
}
-(void)thirdCatSpriteGenerate:(int)fValue animationType:(NSString *)type{
    NSString *fStr=@"";
    if([type isEqualToString:@"run"])
        fStr=[NSString stringWithFormat:@"cat_run%d.png",fValue+1];
    else if([type isEqualToString:@"turn"]){
        fStr=[NSString stringWithFormat:@"cat_turn_run%d.png",fValue];
    }else if([type isEqualToString:@"jump"])
        fStr=[NSString stringWithFormat:@"cat_jump%d.png",fValue];
    
    [catSpriteSheet removeChild:catSprite3 cleanup:YES];
    catSprite3 = [CCSprite spriteWithSpriteFrameName:fStr];
    catSprite3.position = ccp(catX3,catY3);
    catSprite3.scale=0.6;
    if(!catForwardChe3){
        catSprite3.flipX=0;
    }else{
        catSprite3.flipX=1;
    }
    [catSpriteSheet addChild:catSprite3 z:10];
}
-(void)collisionFunc{
    CGFloat hx=heroSprite.position.x;
    CGFloat hy=heroSprite.position.y;
    int iValue=(forwardChe?43:0);
    
    if(!gameFunc.trappedChe){
        trappedTypeValue=2;
    }
    
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
    
    if(hx-iValue>460 &&hx-iValue<520 &&hy>210 &&hy<250 &&screenMovementFindValue==0){
        screenMovementFindValue=1;
        [switchAtlas setString:@"1"];
        waterIntervalTimeCount=300;
    }
    
    if(hx-iValue<50&&hy>480 &&hy<510 &&screenMovementFindValue2==0){
        screenMovementFindValue2=1;
        [switchAtlas2 setString:@"1"];
        
        screenMoveChe=YES;
        screenShowX=platformX;
        screenShowY=platformY;
        screenShowX2=platformX;
        screenShowY2=platformY;
    }
    
    if(hx-iValue>365 &&hx-iValue<=400 && hy==228 &&gameFunc.moveCount==0){
        gameFunc.moveCount=-0.1;
        [combButtonAtlas setString:@"1"];
    }
    
    
    for(int i=0;i<4;i++){
        if(hx-iValue>iceQubeSprite[i].position.x-60 &&hx-iValue<iceQubeSprite[i].position.x-30 &&hy > iceQubeSprite[i].position.y-30 &&hy<iceQubeSprite[i].position.y+20 &&!gameFunc.trappedChe){
            gameFunc.trappedChe=YES;
            trappedTypeValue=2;
        }
    }
    for(int i=0;i<5;i++){
        for(int j=0;j<2;j++){
            if(hx-iValue>iceSmokingSprite[i][j].position.x-40 &&hx-iValue<iceSmokingSprite[i][j].position.x-30 &&hy > iceSmokingSprite[i][j].position.y-30 &&hy<iceSmokingSprite[i][j].position.y+20 &&!gameFunc.trappedChe){
                gameFunc.trappedChe=YES;
                 trappedTypeValue=2;
            }
        }
    }
    
    if(hx-iValue>360 && hx-iValue<470 && hy> 615 && hy<630){
        if((pulbCount>50&&pulbCount<70)|| (pulbCount>175&&pulbCount<195)){
            gameFunc.trappedChe=YES;
            trappedTypeValue=2;
        }
    }
    
    
    
    if(hx-iValue>catSprite.position.x-90 &&hx-iValue<catSprite.position.x+40 &&hy > catSprite.position.y-30 &&hy<catSprite.position.y+50 &&!gameFunc.
       trappedChe&&!gameFunc.stickyChe){
        gameFunc.trappedChe=YES;
        trappedTypeValue=1;
    }else if(hx-iValue>catSprite2.position.x-90 &&hx-iValue<catSprite2.position.x+40 &&hy > catSprite2.position.y-30 &&hy<catSprite2.position.y+50 &&!gameFunc.
             trappedChe&&!gameFunc.stickyChe){
        gameFunc.trappedChe=YES;
        trappedTypeValue=1;
    }else if(hx-iValue>catSprite3.position.x-90 &&hx-iValue<catSprite3.position.x+40 &&hy > catSprite3.position.y-30 &&hy<catSprite3.position.y+50 &&!gameFunc.
             trappedChe&&!gameFunc.stickyChe){
        gameFunc.trappedChe=YES;
        trappedTypeValue=1;
    }
    
    
}
-(void)waterDropsFunc{
    if(!screenMoveChe ){
        for(int i=0;i<4;i++){
            if(iceQubeCount[i]!=-40){
                if(iceQubeCount[i]<=25){
                    iceQubeCount[i]+=1.5;
                    iceQubePos[i][0]=[trigo circlex:120 a:180-(iceQubeCount[i]-230)]+100;
                    iceQubePos[i][1]=[trigo circley:120 a:180-(iceQubeCount[i]-230)]+160;
                }else{
                    iceQubeCount[i]+=1.2;
                    iceQubePos[i][0]=[trigo circlex:iceQubeCount[i] a:359]+200;
                    iceQubePos[i][1]=[trigo circley:iceQubeCount[i] a:359]+223;
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
    
    //Smoking
    for(int i=0;i<5;i++){
        for(int j=0;j<2;j++){
            if(iceSmokingCount[i][j]!=0){
                int xx=0;
                int yy=0;
                xx=[trigo circlex:iceSmokingCount[i][j] a:255+(j*12)]+423;
                yy=[trigo circley:iceSmokingCount[i][j] a:255+(j*12)]+275;
                
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
    waterIntervalTimeCount+=1;
    waterIntervalTimeCount=(waterIntervalTimeCount>(screenMovementFindValue==0?300:500)?1:waterIntervalTimeCount);
    
}
-(void)switchFunc{
    
    if(screenMoveChe){
        if(screenMovementFindValue2==1){
            screenShowX+=5;
            if(screenShowX>750)
                screenMovementFindValue2=2;
            
        }else if(screenMovementFindValue2==2){
            screenShowY+=5;
            if(screenShowY>550){
                screenShowY=550;
                if(gameFunc.plateWoodStopCount==0)
                    gameFunc.plateWoodStopCount=1;
                if(gameFunc.plateWoodStopCount>=150)
                    screenMovementFindValue2=3;
            }
        }else if(screenMovementFindValue2==3){
            screenShowY-=5;
            if(screenShowY<screenShowY2){
                screenShowY=screenShowY2;
                screenMovementFindValue2=4;
            }
        }else if(screenMovementFindValue2==4){
            screenShowX-=5;
            if(screenShowX<screenShowX2){
                screenShowX=screenShowX2;
                screenMoveChe=NO;
                screenHeroPosX=platformX;
                screenHeroPosY=platformY;
                screenShowX=platformX;
                screenShowY=platformY;
                screenMovementFindValue2=5;
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
        if(heroJumpLocationChe){
            [self HeroLiningDraw:0];
        }
    }
    
    movePlatformSprite.position=ccp(240,500+gameFunc.moveCount2);
    catStopWoodSprite.position=ccp(815,650+gameFunc.plateWoodStopCount);
    pulbCount+=1.0;
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
    if(heroSprite.position.x>=920+fValue &&heroSprite.position.y>540&&heroSprite.position.y<=650&&!mouseWinChe&&!gameFunc.trappedChe&&gameFunc.gateOpenChe){
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
            
            if(trappedTypeValue<=1){
                heroTrappedMove=1;
            }
            
            if(trappedTypeValue == 2){
                heroTrappedSprite = [CCSprite spriteWithFile:@"gm_mist_0.png"];
                heroTrappedSprite.scale=0.5;
                if(!forwardChe)
                    heroTrappedSprite.position = ccp(heroSprite.position.x +heroForwardX, heroSprite.position.y+15);
                else
                    heroTrappedSprite.position = ccp(heroSprite.position.x - heroForwardX, heroSprite.position.y+15);
                
                heroTrappedSprite.scale=0.5;
                [self addChild:heroTrappedSprite z:1000];
                CCMoveTo *move = [CCMoveTo actionWithDuration:1.5 position:ccp(heroTrappedSprite.position.x, 230)];
                [heroTrappedSprite runAction:move];
            }
            else{
                mouseDragSprite.visible=NO;
                heroTrappedSprite = [CCSprite spriteWithSpriteFrameName:@"girl_trapped1.png"];
                heroTrappedSprite.scale=0.7;
                if(!forwardChe)
                    heroTrappedSprite.position = ccp(platformX, platformY+15);
                else
                    heroTrappedSprite.position = ccp(platformX+heroForwardX, platformY+15);
                [spriteSheet addChild:heroTrappedSprite];
                spriteSheet.zOrder=11;
                
                NSMutableArray *animFrames2 = [NSMutableArray array];
                for(int i = 1; i < 8; i++) {
                    CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"girl_trapped%d.png",i]];
                    [animFrames2 addObject:frame];
                }
                CCAnimation *animation2 = [CCAnimation animationWithSpriteFrames:animFrames2 delay:0.1f];
                [heroTrappedSprite runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation2]]];
            }
            heroSprite.visible=NO;
        }
        if(heroTrappedMove!=0){
            int fValue = (forwardChe?heroForwardX:0);
            CGFloat xPos=0;
            if(trappedTypeValue== 1)
                xPos=heroSprite.position.x-(forwardChe?40:-40);
            if (trappedTypeValue != 2) {
                heroTrappedSprite.position = ccp(xPos,heroSprite.position.y-heroTrappedMove);
            }
           
            CGPoint copyHeroPosition = ccp(heroSprite.position.x-fValue, heroSprite.position.y-heroTrappedMove);
            [self setViewpointCenter:copyHeroPosition];
            if(trappedTypeValue == 1){
                heroTrappedMove+=2;
                if(heroSprite.position.y-heroTrappedMove<=230)
                    heroTrappedMove=0;
            }
        }
    }
}
-(void)heroWinFunc{
    if(mouseWinChe&&!gameFunc.trappedChe){
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
        
        if(heroWinCount == 100) {
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
            heroSprite.rotation=90;
            heroSprite.flipY=1;
            stickyYPos=-30;
        }
        
        heroStandAnimationCount+=1;
        if(heroStandAnimationCount>=80){
            heroStandAnimationCount=0;
        }
    }
}

-(void)heroAnimationFunc:(int)fValue animationType:(NSString *)type{
    NSString *fStr=@"";
    if([type isEqualToString:@"jump"])
        fStr=[NSString stringWithFormat:@"girl_jump%d.png",fValue+1];
    else if([type isEqualToString:@"stand"]){
        fStr=[NSString stringWithFormat:@"girl_stand%d.png",fValue+1];
    }else if([type isEqualToString:@"win"])
        fStr=@"girl_win1.png";
    
    [spriteSheet removeChild:heroSprite cleanup:YES];
    heroSprite = [CCSprite spriteWithSpriteFrameName:fStr];
    heroSprite.position = ccp(platformX, platformY);
    heroSprite.scale=0.65;
    [spriteSheet addChild:heroSprite z:10];
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
        sDotValue=(forwardChe?30:0);
    
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
                    heroSprite.rotation=90;
                    heroSprite.flipY=1;
                    stickyYPos=-30;
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
            if(stickyLandChe)
                jumpAngle=(jumpAngle<90?90:jumpAngle);
            else
                jumpAngle=(jumpAngle>=90?90:jumpAngle);
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
        [[CCDirector sharedDirector] replaceScene:[GirlMouseEngine13 scene]];
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
