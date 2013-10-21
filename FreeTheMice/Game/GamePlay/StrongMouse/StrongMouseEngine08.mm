
// Import the interfaces
#import "StrongMouseEngine08.h"
#import "LevelScreen.h"
#import "FTMUtil.h"
#import "AppDelegate.h"
#import "DB.h"
#import "LevelCompleteScreen.h"
#import "FTMConstants.h"

enum {
    kTagParentNode = 1,
};

StrongMouseEngineMenu08 *sLayer08;

@implementation StrongMouseEngineMenu08


-(id) init {
    if( (self=[super init])) {
    }
    return self;
}
@end

@implementation StrongMouseEngine08

@synthesize tileMap = _tileMap;
@synthesize background = _background;

+(CCScene *) scene {
    CCScene *scene = [CCScene node];
    sLayer08=[StrongMouseEngineMenu08 node];
    [scene addChild:sLayer08 z:1];
    
    StrongMouseEngine08 *layer = [StrongMouseEngine08 node];
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
        [self addChild:_tileMap z:-1 tag:1];
        
        cache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [cache addSpriteFramesWithFile:@"strong0_default.plist"];
        spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"strong0_default.png"];
        [self addChild:spriteSheet z:10];
        
        [self addStrongMouseRunningSprite];
        
//        catCache = [CCSpriteFrameCache sharedSpriteFrameCache];
//        [catCache addSpriteFramesWithFile:@"cat_default.plist"];
//        catSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"cat_default.png"];
//        [self addChild:catSpriteSheet z:10];
        
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
        [sLayer08 addChild:menu z:10];
        
        mouseTrappedBackground=[CCSprite spriteWithFile:@"mouse_trapped_background.png"];
        mouseTrappedBackground.position=ccp(240,160);
        mouseTrappedBackground.visible=NO;
        [sLayer08 addChild:mouseTrappedBackground z:10];
        
        CCMenuItem *aboutMenuItem = [CCMenuItemImage itemWithNormalImage:@"main_menu_button_1.png" selectedImage:@"main_menu_button_2.png" target:self selector:@selector(clickLevel:)];
        aboutMenuItem.tag=2;
        
        CCMenuItem *optionMenuItem = [CCMenuItemImage itemWithNormalImage:@"try_again_button_1.png" selectedImage:@"try_again_button_2.png" target:self selector:@selector(clickLevel:)];
        optionMenuItem.tag=1;
        
        menu2 = [CCMenu menuWithItems: optionMenuItem,aboutMenuItem,  nil];
        [menu2 alignItemsHorizontallyWithPadding:4.0];
        menu2.position=ccp(241,136);
        menu2.visible=NO;
        [sLayer08 addChild: menu2 z:10];
        
        cheeseCollectedSprite=[CCSprite spriteWithFile:@"cheese_collected.png"];
        cheeseCollectedSprite.position=ccp(430,300);
        cheeseCollectedSprite.visible = NO;
        [sLayer08 addChild:cheeseCollectedSprite z:10];
        
        timeCheeseSprite=[CCSprite spriteWithFile:@"time_cheese.png"];
        timeCheeseSprite.position=ccp(121+240,301);
        timeCheeseSprite.visible = NO;
        [sLayer08 addChild:timeCheeseSprite z:10];
        
        
        lifeMinutesAtlas = [[CCLabelAtlas labelWithString:@"01.60" charMapFile:@"numbers.png" itemWidth:15 itemHeight:20 startCharMap:'.'] retain];
        lifeMinutesAtlas.visible = NO;
        lifeMinutesAtlas.position=ccp(250,292);
        [sLayer08 addChild:lifeMinutesAtlas z:10];
        
        
        cheeseCollectedAtlas = [[CCLabelAtlas labelWithString:@"0/3" charMapFile:@"numbers.png" itemWidth:15 itemHeight:20 startCharMap:'.'] retain];
        cheeseCollectedAtlas.position=ccp(422,292);
        cheeseCollectedAtlas.scale=0.8;
        cheeseCollectedAtlas.visible = NO;
        [sLayer08 addChild:cheeseCollectedAtlas z:10];
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
        
        
        CCSprite *slapSprite=[CCSprite spriteWithFile:@"slap.png"];
        slapSprite.position=ccp(150,190);
        slapSprite.scale=0.6;
        [self addChild:slapSprite z:1];
        
        slapSprite=[CCSprite spriteWithFile:@"slap.png"];
        slapSprite.position=ccp(450,190);
        slapSprite.scale=0.6;
        [self addChild:slapSprite z:1];
        
        slapSprite=[CCSprite spriteWithFile:@"slap.png"];
        slapSprite.position=ccp(750,190);
        slapSprite.scale=0.6;
        [self addChild:slapSprite z:1];
        
        slapSprite=[CCSprite spriteWithFile:@"slap.png"];
        slapSprite.position=ccp(1050,190);
        slapSprite.scale=0.6;
        [self addChild:slapSprite z:1];
        
        CCSprite *platformSprite=[CCSprite spriteWithFile:@"move_platform3.png"];
        platformSprite.position=ccp(50,350);
        [self addChild:platformSprite z:1];
        
        platformSprite=[CCSprite spriteWithFile:@"move_platform2.png"];
        platformSprite.position=ccp(180,470);
        [self addChild:platformSprite z:1];
        
        platformSprite=[CCSprite spriteWithFile:@"move_platform2.png"];
        platformSprite.position=ccp(960,385);
        [self addChild:platformSprite z:1];
        
        platformSprite=[CCSprite spriteWithFile:@"platform4.png"];
        platformSprite.position=ccp(412,480);
        platformSprite.scale=0.45;
        [self addChild:platformSprite z:2];
        
        platformSprite=[CCSprite spriteWithFile:@"move_platform3.png"];
        platformSprite.position=ccp(860,550);
        [self addChild:platformSprite z:2];
        
        platformSprite=[CCSprite spriteWithFile:@"move_platform3.png"];
        platformSprite.position=ccp(1054,550);
        [self addChild:platformSprite z:2];
        
        platformSprite=[CCSprite spriteWithFile:@"move_platform2.png"];
        platformSprite.position=ccp(674,480);
        [self addChild:platformSprite z:2];
        
        CCSprite *windowSprite=[CCSprite spriteWithFile:@"window1.png"];
        windowSprite.position=ccp(280,490);
        windowSprite.scale=1.2;
        [self addChild:windowSprite z:1];
        
        windowSprite=[CCSprite spriteWithFile:@"window1.png"];
        windowSprite.position=ccp(410,490);
        windowSprite.scale=1.2;
        [self addChild:windowSprite z:1];
        
        windowSprite=[CCSprite spriteWithFile:@"window1.png"];
        windowSprite.position=ccp(540,490);
        windowSprite.scale=1.2;
        [self addChild:windowSprite z:1];
        
        CCSprite *vegetablePlateSprite=[CCSprite spriteWithFile:@"vegetable_plate.png"];
        vegetablePlateSprite.position=ccp(860,285);
        vegetablePlateSprite.flipX=1;
        [self addChild:vegetablePlateSprite z:1];
        
        vegetableCloseSprite=[CCSprite spriteWithFile:@"vegetable_close.png"];
        vegetableCloseSprite.position=ccp(960,300);
        vegetableCloseSprite.anchorPoint=ccp(0.9f, 0.2f);
        vegetableCloseSprite.scale=0.7;
        vegetableCloseSprite.rotation=-15;
        [self addChild:vegetableCloseSprite z:10];
        
        knifeSprite=[CCSprite spriteWithFile:@"knives_shelf.png"];
        knifeSprite.position=ccp(832,384);
//        knifeSprite.scale=0.65;
        [self addChild:knifeSprite z:1];
        
        CCSprite *pushButtonSprite=[CCSprite spriteWithFile:@"push_button.png"];
        pushButtonSprite.position=ccp(513,425);
        pushButtonSprite.scaleY=0.35;
        pushButtonSprite.scaleX=0.55;
        [self addChild:pushButtonSprite z:1];
        
        CCSprite *holeSprite=[CCSprite spriteWithFile:@"hole.png"];
        holeSprite.position=ccp(970,303);
        [self addChild:holeSprite z:0];
        
        for(int i=0;i<10;i++){
            hotSprite[i]=[CCSprite spriteWithFile:@"smoke.png"];
            hotSprite[i].position=ccp(-275,415);
            [self addChild:hotSprite[i] z:0];
        }
        CCSprite *teaPotSprite=[CCSprite spriteWithFile:@"cooker.png"];
        teaPotSprite.position=ccp(400,270);
        [self addChild:teaPotSprite z:9];
        
        
        honeyPotSprite=[CCSprite spriteWithFile:@"honey_pot.png"];
        honeyPotSprite.position=ccp(442,507);
        honeyPotSprite.scale=0.65;
        [self addChild:honeyPotSprite z:1];
        
        
        milkSprite=[CCSprite spriteWithFile:@"milk.png"];
        milkSprite.position=ccp(825,560);
        milkSprite.scale=0.65;
        milkSprite.anchorPoint=ccp(0.1f, 0.1f);
        [self addChild:milkSprite z:1];
        
        for(int i=0;i<20;i++){
            waterDropsSprite[i]=[CCSprite spriteWithFile:@"dotted.png"];
            waterDropsSprite[i].position=ccp(-275,415);
            waterDropsSprite[i].rotation=arc4random() % 360 + 1;
            waterDropsSprite[i].scale=0.2;
            [self addChild:waterDropsSprite[i] z:0];
        }
        
        for(int i=0;i<6;i++){
            visibleSprite[i]=[CCSprite spriteWithFile:@"window2.png"];
            if(i==0)
                visibleSprite[i].position=ccp(250,490);
            else if(i==1){
                visibleSprite[i].position=ccp(315,490);
                visibleSprite[i].flipX=1;
            }else if(i==2)
                visibleSprite[i].position=ccp(380,490);
            else if(i==3){
                visibleSprite[i].position=ccp(445,490);
                visibleSprite[i].flipX=1;
            }else if(i==4)
                visibleSprite[i].position=ccp(510,490);
            else if(i==5){
                visibleSprite[i].position=ccp(572,490);
                visibleSprite[i].flipX=1;
            }
            visibleSprite[i].scale=1.2;
            [self addChild:visibleSprite[i] z:10];
        }
        
        CCSprite *crackedSprite=[CCSprite spriteWithFile:@"cracked.png"];
        crackedSprite.position=ccp(219,432);
        [self addChild:crackedSprite z:2];
        
        for(int i=0;i<20;i++){
            heroPimpleSprite[i]=[CCSprite spriteWithFile:@"dotted.png"];
            heroPimpleSprite[i].position=ccp(-100,160);
            heroPimpleSprite[i].scale=0.3;
            [self addChild:heroPimpleSprite[i] z:10];
        }
        
        //===================================================================
        dotSprite=[CCSprite spriteWithFile:@"dotted.png"];
        dotSprite.position=ccp(455,290);
        dotSprite.scale=0.2;
        [self addChild:dotSprite z:10];
        [self addHudLayerToTheScene];
        [self starCheeseSpriteInitilized];
        
        [self scheduleUpdate];
        
        //720
        for(int i=0;i<0;i++){
            CGFloat xx=0;
            CGFloat yy=0;
            
            if(i<=30){
                xx=[trigo circlex:i a:359]+770;
                yy=[trigo circley:i a:359]+570;
            }else if(i>30 &&i<=60){
                xx=[trigo circlex:i a:180]+845;
                yy=[trigo circley:i a:180]+571;
            }else if(i>60&&i<=174){
                xx=[trigo circlex:50 a:i]+740;
                yy=[trigo circley:70 a:i]+493;
            }else if(i>174 && i<=222){
                xx=[trigo circlex:i a:359]+460;
                yy=[trigo circley:i a:359]+500;
            }else if(i>222 && i<=360 ){
                xx=[trigo circlex:75 a:360-i]+808;
                yy=[trigo circley:80 a:350-i]+422;
            }else if(i>360 && i<=430){
                xx=[trigo circlex:i a:359]+450;
                yy=[trigo circley:i a:359]+405;
            }else if(i>430 && i<=500){
                xx=[trigo circlex:i a:179]+1528;
                yy=[trigo circley:i a:179]+405;
            }else if(i>500&&i<=615){
                xx=[trigo circlex:130 a:i-80]+827;
                yy=[trigo circley:150 a:i-80]+240;
            }else {
                xx=[trigo circlex:(i-615) a:179]+663;
                yy=[trigo circley:i-615 a:179]+255;
            }
            
            CCSprite *sprite=[CCSprite spriteWithFile:@"dotted.png"];
            sprite.position=ccp(xx,yy);
            sprite.scale=0.1;
            [self addChild:sprite z:10];
        }
    }
    return self;
}

-(void) addHudLayerToTheScene{
    hudLayer = [[HudLayer alloc] init];
    hudLayer.tag = 8;
    [sLayer08 addChild: hudLayer z:2000];
    [hudLayer updateNoOfCheeseCollected:0 andMaxValue:[cheeseSetValue[motherLevel-1] intValue]];
}

-(void) addLevelCompleteLayerToTheScene{
    hudLayer.visible = NO;
    LevelCompleteScreen *lvlCompleteLayer = [[LevelCompleteScreen alloc] init];
    lvlCompleteLayer.tag = 8;
    [sLayer08 addChild: lvlCompleteLayer z:2000];
}

-(void)initValue{
    //Cheese Count Important
//    DB *db = [DB new];
    motherLevel= 8;//[[db getSettingsFor:@"CurrentLevel"] intValue];
//    [db release];
    
    cheeseCount=[cheeseSetValue[motherLevel-1] intValue];
    
    platformX=750;//[gameFunc getPlatformPosition:motherLevel].x;
    platformY=290;//[gameFunc getPlatformPosition:motherLevel].y;
    
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
    gameFunc.moveCount=75;
    gameFunc.moveCount2=75;
    gameFunc.flowerFallChe=YES;
    catX=780;
    catY=595;
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
    [self hotSmokingFunc];
    [self waterDropsFunc];
    gameFunc.runChe=runningChe;
    [gameFunc render];
    [self catFunc];
    
    [self level05];
    
    if(visibleCount>=1){
        visibleCount+=15;
        if(visibleCount>=249){
            visibleCount=249;
        }
        for(int i=0;i<6;i++)
            visibleSprite[i].opacity=250-visibleCount;
        
    }
}

-(void)catFunc{
    
    if(!catJumpChe && catObj == nil){
        catObj = [[StrongLevel8Cat alloc] init];
        [catObj runCurrentSequence];
        [self addChild:catObj];
    }
    
    if(catSpillTimeCount==0){
        if(!catBackChe){
            if(catMovementCount<=30){
                catX=[trigo circlex:catMovementCount a:359]+770;
                catY=[trigo circley:catMovementCount a:359]+570;
                if(catAnimationCount%2 == 0)
//                    [self catSpriteGenerate:catAnimationCount/2 animationType:@"run"];
                catMovementCount+=1;
                if(catMovementCount>=30)
                    turnAnimationCount=1;
                
            }else if(catMovementCount>30 &&catMovementCount<=60){
                if(turnAnimationCount==0){
                    catX=[trigo circlex:catMovementCount a:180]+845;
                    catY=[trigo circley:catMovementCount a:180]+571;
                    if(catAnimationCount%2 == 0)
//                        [self catSpriteGenerate:catAnimationCount/2 animationType:@"run"];
                    catMovementCount+=1;
                    if(catMovementCount>=60)
                        catJumpChe=YES;
                }
            }else if(catMovementCount>60&&catMovementCount<=174){
                if(catJumpingAnimationCount>=55){
                    catX=[trigo circlex:50 a:catMovementCount]+740;
                    catY=[trigo circley:70 a:catMovementCount]+493;
                    catMovementCount+=2;
                    
                    if(catJumpingAnimationCount>=55){
                        catJumpingAnimationCount+=1;
                        catJumpingAnimationCount=(catJumpingAnimationCount>=90?90:catJumpingAnimationCount);
//                        if(catJumpingAnimationCount%5==0)
//                            [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                    }
                }
            }else if(catMovementCount>174 && catMovementCount<=222){
                if(!catJumpChe&&turnAnimationCount==0){
                    catX=[trigo circlex:catMovementCount a:359]+460;
                    catY=[trigo circley:catMovementCount a:359]+500;
                    catMovementCount+=1;
//                    if(catAnimationCount%2 == 0)
//                        [self catSpriteGenerate:catAnimationCount/2 animationType:@"run"];
                    
                }else{
                    if(catJumpChe){
                        if(catJumpingAnimationCount<=105){
                            catJumpingAnimationCount+=1;
//                            if(catJumpingAnimationCount%5 == 0)
//                                [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
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
                    catX=[trigo circlex:75 a:360-catMovementCount]+808;
                    catY=[trigo circley:80 a:350-catMovementCount]+422;
                    catMovementCount+=2;
                    if(catJumpingAnimationCount>=55&&catJumpingAnimationCount<=90){
                        catJumpingAnimationCount+=1;
                        catJumpingAnimationCount=(catJumpingAnimationCount>=90?90:catJumpingAnimationCount);
//                        if(catJumpingAnimationCount%5==0)
//                            [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                    }
                }
            }else if(catMovementCount>360 && catMovementCount<=430){
                if(!catJumpChe){
                    catX=[trigo circlex:catMovementCount a:359]+450;
                    catY=[trigo circley:catMovementCount a:359]+405;
//                    if(catAnimationCount%2 == 0)
//                        [self catSpriteGenerate:catAnimationCount/2 animationType:@"run"];
                    catMovementCount+=1;
                    if(catMovementCount>=430)
                        turnAnimationCount=1;
                }else{
                    if(catJumpingAnimationCount<=105){
                        catJumpingAnimationCount+=1;
//                        if(catJumpingAnimationCount%5 == 0)
//                            [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                    }else{
                        catJumpingAnimationCount=0;
                        catJumpChe=NO;
                    }
                }
            }else if(catMovementCount>430 && catMovementCount<=500){
                if(turnAnimationCount==0){
                    catX=[trigo circlex:catMovementCount a:179]+1528;
                    catY=[trigo circley:catMovementCount a:179]+405;
//                    if(catAnimationCount%2 == 0)
//                        [self catSpriteGenerate:catAnimationCount/2 animationType:@"run"];
                    catMovementCount+=1;
                    if(catMovementCount>=500)
                        catJumpChe=YES;
                }
            }else if(catMovementCount>500&&catMovementCount<=615){
                if(catJumpingAnimationCount>=55){
                    catX=[trigo circlex:130 a:catMovementCount-80]+827;
                    catY=[trigo circley:150 a:catMovementCount-80]+240;
                    catMovementCount+=1.3;
                    if(catJumpingAnimationCount>=55){
                        catJumpingAnimationCount+=1;
                        catJumpingAnimationCount=(catJumpingAnimationCount>=90?90:catJumpingAnimationCount);
//                        if(catJumpingAnimationCount%5==0)
//                            [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                    }
                }
            }else if(catMovementCount<=805){
                if(!catJumpChe){
                    if(catMovementCount<705){
                        catX=[trigo circlex:(catMovementCount-615) a:179]+663;
                        catY=[trigo circley:catMovementCount-615 a:179]+255;
//                        if(catAnimationCount%2 == 0)
//                            [self catSpriteGenerate:catAnimationCount/2 animationType:@"run"];
                        catMovementCount+=1;
                        
                    }else{
                        catMovementCount+=1;
                        if(gameFunc.milkRotateCount>=90&&catMovementCount<=708){
                            catSpillTimeCount=1;
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
//                        if(catJumpingAnimationCount%5 == 0)
//                            [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                    }else{
                        catJumpingAnimationCount=0;
                        catJumpChe=NO;
                    }
                }
            }
        }else{
            
            if(catMovementCount>=615 && catMovementCount<=705){
                if(turnAnimationCount==0){
                    catX=[trigo circlex:(catMovementCount-615) a:179]+663;
                    catY=[trigo circley:catMovementCount-615 a:179]+255;
//                    if(catAnimationCount%2 == 0)
//                        [self catSpriteGenerate:catAnimationCount/2 animationType:@"run"];
                    catMovementCount-=1;
                    if(catMovementCount<=615)
                        catJumpChe=YES;
                }
            }else if(catMovementCount>=500 &&catMovementCount<615){
                if(catJumpingAnimationCount>=55){
                    catX=[trigo circlex:130 a:catMovementCount-80]+827;
                    catY=[trigo circley:150 a:catMovementCount-80]+240;
                    catMovementCount-=1.3;
                    if(catJumpingAnimationCount>=55&&catMovementCount<540){
                        catJumpingAnimationCount+=1;
                        catJumpingAnimationCount=(catJumpingAnimationCount>=90?90:catJumpingAnimationCount);
//                        if(catJumpingAnimationCount%5==0)
//                            [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                    }
                }
            }else if(catMovementCount>=430 && catMovementCount<500){
                if(!catJumpChe){
                    catX=[trigo circlex:catMovementCount a:179]+1528;
                    catY=[trigo circley:catMovementCount a:179]+405;
//                    if(catAnimationCount%2 == 0)
//                        [self catSpriteGenerate:catAnimationCount/2 animationType:@"run"];
                    catMovementCount-=1;
                    if(catMovementCount<=430)
                        turnAnimationCount=1;
                }else{
                    if(catJumpingAnimationCount<=105){
                        catJumpingAnimationCount+=1;
//                        if(catJumpingAnimationCount%5 == 0)
//                            [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                    }else{
                        catJumpingAnimationCount=0;
                        catJumpChe=NO;
                    }
                }
            }else if(catMovementCount>=360 && catMovementCount<430){
                if(turnAnimationCount==0){
                    catX=[trigo circlex:catMovementCount a:359]+450;
                    catY=[trigo circley:catMovementCount a:359]+405;
//                    if(catAnimationCount%2 == 0)
//                        [self catSpriteGenerate:catAnimationCount/2 animationType:@"run"];
                    catMovementCount-=1;
                    if(catMovementCount<=360)
                        catJumpChe=YES;
                }
            }else if(catMovementCount>=222 && catMovementCount<360 ){
                if(catJumpingAnimationCount>=55){
                    catX=[trigo circlex:75 a:360-catMovementCount]+808;
                    catY=[trigo circley:80 a:350-catMovementCount]+422;
                    catMovementCount-=1.9;
                    if(catJumpingAnimationCount>=55&&catMovementCount<270){
                        catJumpingAnimationCount+=1;
                        catJumpingAnimationCount=(catJumpingAnimationCount>=90?90:catJumpingAnimationCount);
//                        if(catJumpingAnimationCount%5==0)
//                            [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                    }
                }
            }else if(catMovementCount>=174 && catMovementCount<222){
                if(!catJumpChe){
                    catX=[trigo circlex:catMovementCount a:359]+460;
                    catY=[trigo circley:catMovementCount a:359]+500;
                    catMovementCount-=1;
//                    if(catAnimationCount%2 == 0)
//                        [self catSpriteGenerate:catAnimationCount/2 animationType:@"run"];
                    if(catMovementCount<=174){
                        turnAnimationCount=1;
                    }
                }else{
                    if(catJumpingAnimationCount<=105){
                        catJumpingAnimationCount+=1;
//                        if(catJumpingAnimationCount%5 == 0)
//                            [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                    }else{
                        catJumpingAnimationCount=0;
                        catJumpChe=NO;
                    }
                }
            }else if(catMovementCount>=60&&catMovementCount<174){
                if(turnAnimationCount==0)
                    catJumpChe=YES;
                if(turnAnimationCount==0&&catJumpingAnimationCount>=55){
                    catX=[trigo circlex:50 a:catMovementCount]+740;
                    catY=[trigo circley:70 a:catMovementCount]+493;
                    catMovementCount-=2;
                    if(catJumpingAnimationCount>=55&&catMovementCount<100){
                        catJumpingAnimationCount+=1;
                        catJumpingAnimationCount=(catJumpingAnimationCount>=90?90:catJumpingAnimationCount);
//                        if(catJumpingAnimationCount%5==0)
//                            [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                    }
                }
            }else if(catMovementCount>=30 &&catMovementCount<60){
                if(!catJumpChe){
                    catX=[trigo circlex:catMovementCount a:180]+845;
                    catY=[trigo circley:catMovementCount a:180]+571;
//                    if(catAnimationCount%2 == 0)
//                        [self catSpriteGenerate:catAnimationCount/2 animationType:@"run"];
                    catMovementCount-=1;
                    if(catMovementCount<=30)
                        turnAnimationCount=1;
                }else{
                    if(catJumpingAnimationCount<=105){
                        catJumpingAnimationCount+=1;
//                        if(catJumpingAnimationCount%5 == 0)
//                            [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                    }else{
                        catJumpingAnimationCount=0;
                        catJumpChe=NO;
                    }
                }
            }else if(catMovementCount<=30){
                if(turnAnimationCount==0){
                    catX=[trigo circlex:catMovementCount a:359]+770;
                    catY=[trigo circley:catMovementCount a:359]+570;
//                    if(catAnimationCount%2 == 0)
//                        [self catSpriteGenerate:catAnimationCount/2 animationType:@"run"];
                    catMovementCount-=1;
                    if(catMovementCount<=0){
                        catBackChe=NO;
                        catJumpChe=YES;
                        catMovementCount=61;
                    }
                }
                
            }
        }
    }
    
    if(turnAnimationCount>0){
        turnAnimationCount+=1;
//        if(turnAnimationCount%4==0)
//            [self catSpriteGenerate:turnAnimationCount/4 animationType:@"turn"];
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
//            if(catJumpingAnimationCount%5==0)
//                [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
        }
    }
    
    catAnimationCount+=2;
    catAnimationCount=(catAnimationCount>=43?0:catAnimationCount);
    
//    if(turnAnimationCount==0)
//        catSprite.position=ccp(catX,catY+17);
//    else
//        catSprite.position=ccp(catX,catY+14);
    
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
//    
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

-(CGFloat)catJumpingFunc:(int)cValue position:(int)pValue{
    
    CGFloat angle=30;
    
    b2Vec2 impulse = b2Vec2(cosf(angle*3.14/180), sinf(angle*3.14/180));
    impulse *= 5.6;
    
    heroBody->ApplyLinearImpulse(impulse, heroBody->GetWorldCenter());
    
    b2Vec2 velocity = heroBody->GetLinearVelocity();
    impulse *= -1;
    heroBody->ApplyLinearImpulse(impulse, heroBody->GetWorldCenter());
    velocity = b2Vec2(-velocity.x, velocity.y);
    
    b2Vec2 point = [self getTrajectoryPoint:heroBody->GetWorldCenter() andStartVelocity:velocity andSteps:cValue*15 andAngle:angle];
    point = b2Vec2(-point.x, point.y);
    
    int lValue=65;
    CGFloat xx=210+point.x+lValue-20;
    CGFloat yy=415+point.y+12;
    
    return (pValue==0?xx:yy);
}
-(void)waterDropsFunc{
    
    for(int i=0;i<20;i++){
        if(!milkStopChe){
            CGFloat xx=0;
            CGFloat yy=0;
            if(waterDropsCount[i]>=1){
                if(gameFunc.flowerFallChe){
                    if(waterDropsCount[i]<=80){
                        waterDropsCount[i]+=2;
                        xx=[trigo circlex:20 a:waterDropsCount[i]+80]+780;
                        yy=[trigo circley:20 a:waterDropsCount[i]+80]+545;
                    }else if(waterDropsCount[i]>80&&waterDropsCount[i]<320){
                        waterDropsCount[i]+=1.5;
                        xx=[trigo circlex:waterDropsCount[i] a:260]+773;
                        yy=[trigo circley:waterDropsCount[i] a:260]+655;
                        waterDropsSprite[i].scale=((waterDropsCount[i]-80)/580)+0.2;
                    }else if(waterDropsCount[i]>=320){
                        if(waterDropsCount[i]<=500){
                            waterDropsCount[i]+=0.5;
                            xx=[trigo circlex:waterDropsCount[i] a:180]+1112;
                            yy=[trigo circley:waterDropsCount[i] a:180]+260;
                        }
                    }
                }else{
                    waterDropsCount[i]+=1.5;
                    xx=[trigo circlex:waterDropsCount[i] a:359]+810;
                    yy=[trigo circley:waterDropsCount[i] a:359]+526;
                }
                if(waterDropsCount[i]>=500){
                    waterDropsCount[i]=500;
                    milkStopChe=YES;
                    break;
                }
                waterDropsSprite[i].position=ccp(xx,yy);
            }
        }else{
            
            
        }
    }
    
    if(gameFunc.milkRotateCount>=90){
        waterDropsReleaseCount+=1;
        if(waterDropsReleaseCount>2){
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


-(void)switchFunc{
    
    if(!screenMoveChe&&gameFunc.appleWoodCount<=-30&&screenMovementFindValue==0){
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
    }else if(!screenMoveChe&&gameFunc.honeyPotCount>=50&&screenMovementFindValue2==0&&gameFunc.honeyPotCount2==0){
        screenShowX=platformX;
        screenShowY=platformY;
        screenShowX2=platformX;
        screenShowY2=platformY;
        
        screenMoveChe=YES;
        heroStandChe=YES;
        runningChe=NO;
        heroRunSprite.visible=NO;
        heroSprite.visible=YES;
        heroPushSprite.visible=NO;
        gameFunc.pushChe=NO;
        screenMovementFindValue2=1;
    }else if(!screenMoveChe&&gameFunc.milkRotateCount>=10&&screenMovementFindValue3==0){
        screenShowX=platformX;
        screenShowY=platformY;
        screenShowX2=platformX;
        screenShowY2=platformY;
        
        screenMoveChe=YES;
        heroStandChe=YES;
        runningChe=NO;
        heroRunSprite.visible=NO;
        heroSprite.visible=YES;
        heroPushSprite.visible=NO;
        gameFunc.pushChe=NO;
        screenMovementFindValue3=1;
    }
    
    if(screenMoveChe){
        if(screenMovementFindValue==1){
            screenShowX+=8;
            if(screenShowX>600)
                screenMovementFindValue=2;
        }else if(screenMovementFindValue==2){
            screenShowY+=1;
            if(screenShowY>600)
                screenShowY=600;
            if(gameFunc.domeMoveCount>=130)
                screenMovementFindValue=3;
            
        }else if(screenMovementFindValue==3){
            screenShowY-=1;
            if(screenShowY<screenShowY2){
                screenShowY=screenShowY2;
                screenMovementFindValue=4;
            }
        }else if(screenMovementFindValue==4){
            screenShowX-=5;
            if(screenShowX<screenShowX2){
                screenShowX=screenShowX2;
                screenMovementFindValue=5;
                screenMoveChe=NO;
                screenHeroPosX=platformX;
                screenHeroPosY=platformY;
                screenShowX=platformX;
                screenShowY=platformY;
            }
        }
        
        if(screenMovementFindValue2==1){
            if(gameFunc.honeyPotCount2>=60){
                screenShowX+=8;
                if(screenShowX>800)
                    screenMovementFindValue2=2;
            }
        }else if(screenMovementFindValue2 == 2){
            if(vegetableOpenCount==0)
                vegetableOpenCount=1;
            
            screenShowY-=2;
            if(screenShowY<350)
                screenShowY=350;
            if(vegetableOpenCount>=100){
                screenMovementFindValue2=3;
            }
        }else if(screenMovementFindValue2 == 3){
            screenShowY+=4;
            if(screenShowY>screenShowY2){
                screenShowY=screenShowY2;
                screenMovementFindValue2=4;
            }
        }else if(screenMovementFindValue2==4){
            screenShowX-=8;
            if(screenShowX<screenShowX2){
                screenShowX=screenShowX2;
                screenMovementFindValue2=5;
                screenMoveChe=NO;
                screenHeroPosX=platformX;
                screenHeroPosY=platformY;
                screenShowX=platformX;
                screenShowY=platformY;
            }
        }
        
        if(screenMovementFindValue3==1){
            if(gameFunc.milkRotateCount>=90){
                screenShowY-=1;
                if(screenShowY<300)
                    screenMovementFindValue3=2;
            }
        }else if(screenMovementFindValue3 ==2){
            screenShowX-=1;
            if(screenShowX<500){
                screenMovementFindValue3=3;
                milkSprite.visible=NO;
            }
        }else if(screenMovementFindValue3 ==3){
            screenShowX+=3;
            if(screenShowX>screenShowX2){
                screenShowX=screenShowX2;
                screenMovementFindValue3=4;
            }
        }else if(screenMovementFindValue3 == 4){
            screenShowY+=3;
            if(screenShowY>screenShowY2){
                screenShowY=screenShowY2;
                screenMovementFindValue3=5;
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
    
    knifeSprite.position=ccp(832,306+gameFunc.moveCount2);
    honeyPotSprite.position=ccp(442+gameFunc.honeyPotCount,507-gameFunc.honeyPotCount2);
    
    if(vegetableOpenCount>=1){
        vegetableOpenCount+=0.5;
        vegetableOpenCount=(vegetableOpenCount>100?100:vegetableOpenCount);
        vegetableCloseSprite.rotation=vegetableOpenCount-15;
    }
    if(vegetableOpenCount>=100){
        gameFunc.moveCount+=0.5;
        gameFunc.moveCount=(gameFunc.moveCount>150?1:gameFunc.moveCount);
        gameFunc.moveCount2=(gameFunc.moveCount<75?gameFunc.moveCount:(75-(gameFunc.moveCount-75)));
    }
    if(gameFunc.milkRotateCount>=1){
        milkSprite.rotation=-gameFunc.milkRotateCount;
    }
    
    CGFloat hx=heroSprite.position.x;
    CGFloat hy=heroSprite.position.y;
    int iValue=(forwardChe?50:0);
    if(hx-iValue>knifeSprite.position.x-110 &&hx-iValue<knifeSprite.position.x+70 &&hy > knifeSprite.position.y-30 &&hy<knifeSprite.position.y+10 &&!gameFunc.trappedChe){
        gameFunc.trappedChe=YES;
        trappedTypeValue=1;
    }
    
    if(hx-iValue>[catObj getCatSprite].position.x-90 &&hx-iValue<[catObj getCatSprite].position.x+40 &&hy > [catObj getCatSprite].position.y-30 &&hy<[catObj getCatSprite].position.y+50 &&!gameFunc.
       trappedChe){
        
        
        gameFunc.trappedChe=YES;
        trappedTypeValue=3;
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
    if(heroSprite.position.x>=920+fValue && heroSprite.position.y>550 && heroSprite.position.y<=650&&!mouseWinChe&&!gameFunc.trappedChe){
        /*  if(runningChe||heroStandChe){
         mouseWinChe=YES;
         heroStandChe=YES;
         runningChe=NO;
         heroRunSprite.visible=NO;
         }*/
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
-(void)hotSmokingFunc{
    CGFloat sx=0;
    CGFloat sy=0;
    CGFloat hotScale=0;
    CGFloat divideLength=0;
    
    sx=417;
    sy=270;
    hotScale=0.8;
    divideLength=1.4;
    
    for(int i=0;i<10;i++){
        if(hotSmokingCount[i]>=1){
            hotSmokingCount[i]+=1.5;
            hotSprite[i].position=ccp(sx,sy+(hotSmokingCount[i]/divideLength));
            hotSprite[i].opacity=250-(hotSmokingCount[i]);
            hotSprite[i].scale=hotScale+(hotSmokingCount[i]/400.0);
            if(hotSmokingCount[i]>=250){
                hotSmokingCount[i]=0;
                hotSprite[i].position=ccp(-200,100);
            }
        }
    }
    
    if(hotSmokingRelease == 0){
        for(int i=0;i<10;i++){
            if(hotSmokingCount[i]==0){
                hotSmokingCount[i]=1;
                hotSmokingRelease=1;
                break;
            }
        }
    }
    
    if(hotSmokingRelease>=1){
        hotSmokingRelease+=1;
        if(hotSmokingRelease>=17){
            hotSmokingRelease=0;
        }
    }
    int iValue=(forwardChe?60:0);
    if(heroSprite.position.x-iValue>350 && heroSprite.position.x-iValue<= 430&& heroSprite.position.y>270&&heroSprite.position.y<=400&&!heroTrappedChe){
        gameFunc.trappedChe=YES;
        trappedTypeValue=2;
        
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
            
            if(trappedTypeValue==1||trappedTypeValue==2 || trappedTypeValue == 3)
                heroTrappedMove=1;
            
            mouseDragSprite.visible=NO;
            
            if (trappedTypeValue == 1) {
                [self showAnimationWithMiceIdAndIndex:FTM_STRONG_MICE_ID andAnimationIndex:STRONG_KNIFE_ANIM];
            }
            else if (trappedTypeValue == 2){
                heroTrappedSprite = [CCSprite spriteWithFile:@"sm_mist_0.png"];
                if(!forwardChe)
                    heroTrappedSprite.position = ccp(heroSprite.position.x+heroForwardX, heroSprite.position.y+5);
                else
                    heroTrappedSprite.position = ccp(heroSprite.position.x-heroForwardX, heroSprite.position.y+5);
                
                heroTrappedSprite.scale=0.5;
                [self addChild:heroTrappedSprite z:1000];
                int posY = 300;
                
                CCMoveTo *move = [CCMoveTo actionWithDuration:1 position:ccp(heroTrappedSprite.position.x, posY)];
                [heroTrappedSprite runAction:move];
            }
            else{
            heroTrappedSprite = [CCSprite spriteWithFile:@"sm_mist_0.png"];
            if(!forwardChe)
                heroTrappedSprite.position = ccp(platformX, platformY+5);
            else
                heroTrappedSprite.position = ccp(platformX+heroForwardX, platformY+5);
                heroTrappedSprite.scale = 0.5;
                [self addChild:heroTrappedSprite z:10000];
            }
            heroSprite.visible=NO;
        }
        if(heroTrappedMove!=0){
            int fValue = (forwardChe?heroForwardX:0);
            CGFloat xPos=0;
            if(trappedTypeValue==1)
                xPos=heroSprite.position.x-(forwardChe?80:-40);
            else if(trappedTypeValue==2)
                xPos=415;
            else if(trappedTypeValue==3){
                xPos=heroSprite.position.x-(forwardChe?40:-40);
            }
            
            if (trappedTypeValue == 3) {
                heroTrappedSprite.position = ccp(xPos,heroSprite.position.y-heroTrappedMove);
            }
            CGPoint copyHeroPosition = ccp(heroSprite.position.x-fValue, heroSprite.position.y-heroTrappedMove);
            [self setViewpointCenter:copyHeroPosition];
            if(trappedTypeValue == 1){
                heroTrappedMove+=1;
                if(heroSprite.position.y-heroTrappedMove<=300)
                    heroTrappedMove=0;
            }else if(trappedTypeValue == 2){
                heroTrappedMove+=1;
                if(heroSprite.position.y-heroTrappedMove<=300)
                    heroTrappedMove=0;
            }else if(trappedTypeValue == 3){
                if(xPos>800){
                    heroTrappedMove+=1;
                    if(heroSprite.position.y-heroTrappedMove<=300)
                        heroTrappedMove=0;
                }else{
                    heroTrappedMove+=1;
                    if(heroSprite.position.y-heroTrappedMove<=270)
                        heroTrappedMove=0;
                }
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
            for(int i = 0; i < 27; i++) {
                CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"strong_win%d.png",i+1]];
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
            
            if(gameFunc.visibleWindowChe&&visibleCount==0){
                visibleCount=1;
                printf("welc ");
            }
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
                    mouseDragSprite.position=ccp(platformX + DRAG_SPRITE_OFFSET_X/2+heroForwardX,platformY-DRAG_SPRITE_OFFSET_Y/2);
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
        [[CCDirector sharedDirector] replaceScene:[StrongMouseEngine08 scene]];
//        [self respwanTheMice];
    }else if(sender.tag ==2){
        [[CCDirector sharedDirector] replaceScene:[LevelScreen scene]];
    }
}

-(void ) respwanTheMice{
    gameFunc.trappedChe = NO;
    [FTMUtil sharedInstance].isRespawnMice = YES;
    menu2.visible=NO;
    heroTrappedSprite.visible = NO;
    mouseTrappedBackground.visible=NO;
    safetyJumpChe = YES;
    runningChe = NO;
    
    if (trappedTypeValue == 1) {
        if ([self getTrappingAnimatedSprite] != nil) {
            [[self getTrappingAnimatedSprite] removeFromParentAndCleanup:YES];
        }
        [self endJumping:platformX  yValue:platformY - 50];
        [self schedule:@selector(startRespawnTimer) interval:1];
    }else{
        [self endJumping:(platformX+gameFunc.xPosition)/2  yValue:gameFunc.yPosition];
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
