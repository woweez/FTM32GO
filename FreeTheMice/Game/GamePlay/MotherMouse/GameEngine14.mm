//
//  HelloWorldLayer.mm
//  Tap
//
//  Created by karthik g on 27/09/12.
//  Copyright karthik g 2012. All rights reserved.
//

#import "GameEngine14.h"
#import "FTMUtil.h"
#import "AppDelegate.h"
#import "LevelScreen.h"
#import "LevelCompleteScreen.h"
#import "FTMConstants.h"
#import "DB.h"

enum {
    kTagParentNode = 1,
};


GameEngine14Menu *layer14;


@implementation GameEngine14Menu


-(id) init {
    if( (self=[super init])) {
    }
    return self;
}
@end

@implementation GameEngine14

@synthesize tileMap = _tileMap;
@synthesize background = _background;


+(CCScene *) scene {
    CCScene *scene = [CCScene node];
    layer14=[GameEngine14Menu node];
    [scene addChild:layer14 z:1];
    GameEngine14 *layer = [GameEngine14 node];
    [scene addChild: layer z:0];
    return scene;
}


-(id) init
{
    if( (self=[super init])) {
        
        heroJumpIntervalValue = [[NSArray alloc] initWithObjects:@"0",@"2",@"4",@"6",@"8",@"10",@"0",@"11",@"13",@"15",nil];
        cheeseSetValue= [[NSArray alloc] initWithObjects:@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",nil];
        cheeseArrX=[[NSArray alloc] initWithObjects:@"0",@"20",@"0",@"20",@"10",nil];
        cheeseArrY=[[NSArray alloc] initWithObjects:@"0",@"0", @"-15", @"-15",@"-8",nil];
        heroRunningStopArr=[[NSArray alloc] initWithObjects:@"80",@"80",@"80", @"40",@"140",@"80",@"80",@"80",@"80",@"80",@"80",@"80",@"40",@"80",nil];
        fireXPos=[[NSArray alloc] initWithObjects:@"434",@"696", @"877",nil];
        
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
        
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"background.tmx"];
        self.background = [_tileMap layerNamed:@"background"];
        [self addChild:_tileMap z:-1 tag:1];
        
        cache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [cache addSpriteFramesWithFile:@"mother_mouse_default.plist"];
        [cache addSpriteFramesWithFile:@"sink_waterAnim.plist"];
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
        [layer14 addChild:menu z:10];
        
        cheeseCollectedSprite=[CCSprite spriteWithFile:@"cheese_collected.png"];
        cheeseCollectedSprite.position=ccp(430,300);
        [layer14 addChild:cheeseCollectedSprite z:10];
        cheeseCollectedSprite.visible = NO;
        
        timeCheeseSprite=[CCSprite spriteWithFile:@"time_cheese.png"];
        timeCheeseSprite.position=ccp(121+240,301);
        [layer14 addChild:timeCheeseSprite z:10];
        timeCheeseSprite.visible = NO;
        
        lifeMinutesAtlas = [[CCLabelAtlas labelWithString:@"01.60" charMapFile:@"numbers.png" itemWidth:15 itemHeight:20 startCharMap:'.'] retain];
        lifeMinutesAtlas.position=ccp(250,292);
        lifeMinutesAtlas.visible = NO;
        [layer14 addChild:lifeMinutesAtlas z:10];
        
        cheeseCollectedAtlas = [[CCLabelAtlas labelWithString:@"0/3" charMapFile:@"numbers.png" itemWidth:15 itemHeight:20 startCharMap:'.'] retain];
        cheeseCollectedAtlas.visible = NO;
        cheeseCollectedAtlas.position=ccp(422,292);
        cheeseCollectedAtlas.scale=0.8;
        [layer14 addChild:cheeseCollectedAtlas z:10];
        [cheeseCollectedAtlas setString:[NSString stringWithFormat:@"%d/%d",0,[cheeseSetValue[motherLevel-1] intValue]]];
        
        movePlatformSprite=[CCSprite spriteWithFile:@"move_platform2.png"];
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
        
        for(int i=0;i<2;i++){
            switchAtlas[i] = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"switch.png" itemWidth:40 itemHeight:103 startCharMap:'0'] retain];
            if(i==0)
                switchAtlas[i].position=ccp(750,560);
            else if(i==1)
                switchAtlas[i].position=ccp(360,560);
            
            switchAtlas[i].scale=0.7;
            [self addChild:switchAtlas[i] z:9];
        }
        
        
        eleAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"ele.png" itemWidth:130 itemHeight:110 startCharMap:'0'] retain];
        //eleAtlas.position=ccp(820,605);
        eleAtlas.position=ccp(430,605);
        eleAtlas.rotation=-122;
        eleAtlas.scale=0.7;
        [self addChild:eleAtlas z:9];
        
        clockBackgroundSprite=[CCSprite spriteWithFile:@"clock_background.png"];
        clockBackgroundSprite.position=ccp(-100,258);
        clockBackgroundSprite.scale=0.5;
        [layer14 addChild:clockBackgroundSprite z:0];
        
        clockArrowSprite=[CCSprite spriteWithFile:@"clock_arrow.png"];
        clockArrowSprite.position=ccp(-100,258);
        clockArrowSprite.scale=0.5;
        clockArrowSprite.anchorPoint=ccp(0.2f, 0.2f);
        clockArrowSprite.rotation=-40;
        [layer14 addChild:clockArrowSprite z:0];
        ;
            iceQubeSprite[0]=[self addFireFlamesAnimation:ccp(0, 0)];
            iceQubeSprite[0].position = ccp(450,282);
            iceQubeSprite[0].scale=0.7;
            iceQubeSprite[0].visible = NO;
            [self addChild:iceQubeSprite[0] z:10];

            iceQubeSprite[1]=[self addFireFlamesAnimation:ccp(0, 0)];
            iceQubeSprite[1].position=ccp(715,282);
            iceQubeSprite[1].scale=0.7;
            iceQubeSprite[1].visible = NO;
            [self addChild:iceQubeSprite[1] z:10];
        
            iceQubeSprite[2]=[self addFireFlamesAnimation:ccp(0, 0)];
            iceQubeSprite[2].position=ccp(895,282);
            iceQubeSprite[2].scale=0.7;
            iceQubeSprite[2].visible = NO;
            [self addChild:iceQubeSprite[2] z:10];
        
        for(int i=0;i<10;i++){
            NSString *fNameStr=@"";
            if(i%2 ==0)
                fNameStr=@"smoke.png";
            else
                fNameStr=@"smoke2.png";
            
            hotSprite[i]=[CCSprite spriteWithFile:fNameStr];
            hotSprite[i].position=ccp(-275,415);
            hotSprite[i].scale=2.3;
            hotSprite[i].rotation=arc4random() % 360 + 1;
            [self addChild:hotSprite[i] z:9];
        }
        
        
        pulbSprite=[CCSprite spriteWithFile:@"pulb.png"];
        pulbSprite.position=ccp(570,713);
        pulbSprite.anchorPoint=ccp(0.5f, 0.98f);
        [self addChild:pulbSprite z:10];
        
        mouseTrappedBackground=[CCSprite spriteWithFile:@"mouse_trapped_background.png"];
        mouseTrappedBackground.position=ccp(240,160);
        mouseTrappedBackground.visible=NO;
        [layer14 addChild:mouseTrappedBackground z:10];
        
        CCMenuItem *aboutMenuItem = [CCMenuItemImage itemWithNormalImage:@"main_menu_button_1.png" selectedImage:@"main_menu_button_2.png" target:self selector:@selector(clickLevel:)];
        aboutMenuItem.tag=2;
        
        CCMenuItem *optionMenuItem = [CCMenuItemImage itemWithNormalImage:@"try_again_button_1.png" selectedImage:@"try_again_button_2.png" target:self selector:@selector(clickLevel:)];
        optionMenuItem.tag=1;
        
        menu2 = [CCMenu menuWithItems: optionMenuItem,aboutMenuItem,  nil];
        [menu2 alignItemsHorizontallyWithPadding:4.0];
        menu2.position=ccp(241,136);
        menu2.visible=NO;
        [layer14 addChild: menu2 z:10];
        
        CCSprite *slapSprite=[CCSprite spriteWithFile:@"slap.png"];
        slapSprite.position=ccp(140,192);
        slapSprite.scale=0.55;
        [self addChild:slapSprite z:1];
        
        slapSprite=[CCSprite spriteWithFile:@"slap.png"];
        slapSprite.position=ccp(410,192);
        slapSprite.scale=0.55;
        [self addChild:slapSprite z:1];
        
        slapSprite=[CCSprite spriteWithFile:@"slap.png"];
        slapSprite.position=ccp(680,192);
        slapSprite.scale=0.55;
        [self addChild:slapSprite z:1];
        
        slapSprite=[CCSprite spriteWithFile:@"slap.png"];
        slapSprite.position=ccp(900,192);
        slapSprite.scale=0.55;
        [self addChild:slapSprite z:1];
        
        CCSprite *pSprite=[CCSprite spriteWithFile:@"move_platform3.png"];
        pSprite.position=ccp(935,339);
        [self addChild:pSprite z:9];
        
        pSprite=[CCSprite spriteWithFile:@"move_platform2.png"];
        pSprite.position=ccp(987,428);
        [self addChild:pSprite z:9];
        
        pSprite=[CCSprite spriteWithFile:@"move_platform3.png"];
        pSprite.position=ccp(794,518);
        [self addChild:pSprite z:9];
        
        pSprite=[CCSprite spriteWithFile:@"move_platform3.png"];
        pSprite.position=ccp(344,518);
        [self addChild:pSprite z:9];
        
        CCSprite *sprite=[CCSprite spriteWithFile:@"kitchen_pipe.png"];
        sprite.position=ccp(73,600);
        [self addChild:sprite z:10];
        
        sprite=[CCSprite spriteWithFile:@"gas_stove.png"];
        sprite.position=ccp(58,190);
        [self addChild:sprite z:9];
        
        sprite=[CCSprite spriteWithFile:@"gas_stove.png"];
        sprite.position=ccp(448,190);
        [self addChild:sprite z:8];
        
        sprite=[CCSprite spriteWithFile:@"gas_stove_stick.png"];
        sprite.position=ccp(451,245);
        [self addChild:sprite z:8];
        
        sprite=[CCSprite spriteWithFile:@"gas_stove.png"];
        sprite.position=ccp(713,190);
        [self addChild:sprite z:8];
        
        sprite=[CCSprite spriteWithFile:@"gas_stove_stick.png"];
        sprite.position=ccp(716,245);
        [self addChild:sprite z:8];
        
        sprite=[CCSprite spriteWithFile:@"gas_stove.png"];
        sprite.position=ccp(893,190);
        [self addChild:sprite z:9];
        
        sprite=[CCSprite spriteWithFile:@"gas_stove_stick.png"];
        sprite.position=ccp(895,245);
        [self addChild:sprite z:9];
        
        sprite=[CCSprite spriteWithFile:@"water_sink_1.png"];
        sprite.position=ccp(580,245);
        [self addChild:sprite z:8];
        
        sprite=[CCSprite spriteWithSpriteFrameName:@"sink_water_0.png"];
        sprite.position=ccp(580,236);
        NSMutableArray *frameArr3 = [NSMutableArray array];
        for(int i = 0; i <= 29; i++) {
            CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"sink_water_%d.png",i]];
            [frameArr3 addObject:frame];
        }
        CCAnimation *animation4 = [CCAnimation animationWithSpriteFrames:frameArr3 delay:0.03f];
        CCAnimate *anim3 = [CCAnimate actionWithAnimation:animation4];
        [sprite runAction:[CCRepeatForever actionWithAction: anim3]];
        [self addChild:sprite z:100];

        sprite=[CCSprite spriteWithFile:@"water_sink_2.png"];
        sprite.position=ccp(580,182);
        [self addChild:sprite z:10];
        
        gateSprite=[CCSprite spriteWithFile:@"gate.png"];
        gateSprite.position=ccp(970,275);
        [self addChild:gateSprite z:9];
        
        waterLineSprite=[CCSprite spriteWithFile:@"water_line.png"];
        waterLineSprite.position=ccp(580,242);
        waterLineSprite.visible = NO;
        [self addChild:waterLineSprite z:10];
        
        CCSprite *holeSprite=[CCSprite spriteWithFile:@"hole.png"];
        holeSprite.position=ccp(970,280);
        [self addChild:holeSprite z:1];
        
        for(int i=0;i<20;i++){
            heroPimpleSprite[i]=[CCSprite spriteWithFile:@"dotted.png"];
            heroPimpleSprite[i].position=ccp(-100,160);
            heroPimpleSprite[i].scale=0.3;
            [self addChild:heroPimpleSprite[i] z:10];
        }
        
        dotSprite=[CCSprite spriteWithFile:@"dotted.png"];
        dotSprite.position=ccp(946,300);
        dotSprite.scale=0.3;
        [self addChild:dotSprite z:10 ];
        [self addHudLayerToTheScene];
        [self starCheeseSpriteInitilized];
        [self scheduleUpdate];
        
        for(int i=0;i<0;i++){
            CGFloat xx=0;
            CGFloat yy=0;
            if(i<=100){
                xx=[trigo circlex:i a:90]+108;
                yy=[trigo circley:i a:90]+580;
            }else{
                xx=[trigo circlex:i a:124]+238;
                yy=[trigo circley:i a:124]+390;
            }
            
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
    hudLayer.tag = 14;
    [layer14 addChild: hudLayer z:2000];
    [hudLayer updateNoOfCheeseCollected:0 andMaxValue: 5];
}

-(void) addLevelCompleteLayerToTheScene{
    [self levelCompleted :14];
}

-(void)initValue{
    
    DB *db = [DB new];
    motherLevel= 14;//[[db getSettingsFor:@"CurrentLevel"] intValue];
    [db release];
    
    cheeseCount=[cheeseSetValue[motherLevel-1] intValue];
    platformX=400;
    platformY=550;
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
    gameFunc.switchStatusChe=NO;
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
    
}

-(void)iceCubeCollision{
    
    CGFloat hx=heroSprite.position.x;
    CGFloat hy=heroSprite.position.y;
    int iValue=(forwardChe?60:0);
    
   for(int i=0;i<3;i++){
        if(hx-iValue>iceQubeSprite[i].position.x-60 &&hx-iValue<iceQubeSprite[i].position.x+20 &&hy > iceQubeSprite[i].position.y-30 &&hy<iceQubeSprite[i].position.y+50 &&!gameFunc.trappedChe && iceQubeSprite[i].visible){
                gameFunc.trappedChe=YES;
                trappedTypeValue=1;
        }
    }
    
    pulbCount+=1.7;
    pulbCount=(pulbCount>=250?0:pulbCount);
    int lCount=(pulbCount<=125?pulbCount-63:(125-(pulbCount-125)-63));
    if(pulbCount<=125){
        pulbSprite.rotation=(pulbCount-63);
        eleAtlas.position=ccp(820,605);
    }else{
        pulbSprite.rotation=(125-(pulbCount-125)-63);
        eleAtlas.position=ccp(430,605);
    }
    
    CGFloat xx=[trigo circlex:150 a:360-((lCount+73)*1.2)]+568;
    CGFloat yy=[trigo circley:100 a:360-((lCount+73)*1.2)]+630;
    
    if(hx>xx-30 && hx< xx+20 &&hy > yy-30  &&!gameFunc.trappedChe&&!forwardChe){
//        gameFunc.trappedChe=YES;
        trappedTypeValue=3;
    }else if(hx-iValue > xx-60 &&hx-iValue<xx-20 &&hy > yy-30  &&!gameFunc.trappedChe&&forwardChe){
//        gameFunc.trappedChe=YES;
        trappedTypeValue=3;
    }
    
    
    //Switch 1
    if(hx-iValue>720 &&hx-iValue<800 &&hy > 570 && hy<600 &&gameFunc.moveCount2==0){
        if(eleAtlas.position.x==820){
            trappedTypeValue=5;
//            gameFunc.trappedChe=YES;
        }else{
            gameFunc.moveCount=1;
            [switchAtlas[0]  setString:@"1"];
            if(!screenMoveChe)
                screenMovementFindValue2=1;
        }
    }else if(hx-iValue>330 &&hx-iValue<410 && hy>570 && hy<600 &&!gameFunc.trappedChe){
        if(eleAtlas.position.x==430){
            trappedTypeValue=5;
//            gameFunc.trappedChe=YES;
        }else{
            [switchAtlas[1]  setString:@"1"];
            gameFunc.switchCount=1;
            if(!screenMoveChe)
                screenMovementFindValue=1;
        }
    }
    
    if(gateCount==0&&gameFunc.moveCount>=1){
        gameFunc.moveCount+=0.4;
        gameFunc.moveCount=(gameFunc.moveCount>65?65:gameFunc.moveCount);
        gameFunc.moveCount2=gameFunc.moveCount;
    }else if(gateCount!=0&&gameFunc.moveCount>=1){
        gameFunc.moveCount+=0.4;
        gameFunc.moveCount=(gameFunc.moveCount>=130?1:gameFunc.moveCount);
        gameFunc.moveCount2=(gameFunc.moveCount<=65?gameFunc.moveCount:(65-(gameFunc.moveCount-65)));
    }
    
    
    if(hx-iValue>100 &&hx-iValue<200 && hy<300&&!cheeseSprite[0].visible&&screenMovementFindValue3==0){
        screenMovementFindValue3=1;
        screenShowX=233;
        screenShowY=platformY;
        gateCount=1;
        gameFunc.gateOpenChe=YES;
    }
    
    if(hx-iValue>465 &&hx-iValue<630 && hy==266&&!gameFunc.trappedChe){
        trappedTypeValue=4;
//        gameFunc.trappedChe=YES;
    }
    
    eleCount+=1;
    eleCount=(eleCount>10?0:eleCount);
    [eleAtlas setString:[NSString stringWithFormat:@"%d",eleCount/2]];
    
    waterLineCount+=0.01;
    waterLineCount=(waterLineCount>1.0?0:waterLineCount);
    CGFloat wCount=(waterLineCount<0.5?waterLineCount:(0.5-(waterLineCount-0.5)));
    waterLineSprite.scaleY=0.5+wCount;
}

-(void)iceQubeAnimation{
    if(!screenMoveChe && screenMovementFindValue2 == 6){
//        for(int i=0;i<5;i++){
//            if(iceQubeCount[i]!=0){
//                if(iceQubeCount[i]!=0)
//                    iceQubeCount[i]+=2.5;
//                
//                iceQubeSprite[i].position=ccp([fireXPos[0] intValue],250+iceQubeCount[i]-(iceQubeCount[i]/4));
//                iceQubeSprite[i].scale=(iceQubeCount[i]/250.0);
//                iceQubeSprite2[i].position=ccp([fireXPos[1] intValue],250+iceQubeCount[i]-(iceQubeCount[i]/4));
//                iceQubeSprite2[i].scale=(iceQubeCount[i]/250.0);
//                iceQubeSprite3[i].position=ccp([fireXPos[2] intValue],250+iceQubeCount[i]-(iceQubeCount[i]/4));
//                iceQubeSprite3[i].scale=(iceQubeCount[i]/250.0);
//                
//                iceQubeSprite4[i].position=ccp([fireXPos[0] intValue]+36,250+iceQubeCount[i]-(iceQubeCount[i]/4));
//                iceQubeSprite4[i].scale=(iceQubeCount[i]/250.0);
//                iceQubeSprite5[i].position=ccp([fireXPos[1] intValue]+36,250+iceQubeCount[i]-(iceQubeCount[i]/4));
//                iceQubeSprite5[i].scale=(iceQubeCount[i]/250.0);
//                iceQubeSprite6[i].position=ccp([fireXPos[2] intValue]+36,250+iceQubeCount[i]-(iceQubeCount[i]/4));
//                iceQubeSprite6[i].scale=(iceQubeCount[i]/250.0);
//                
//            }
//            
//            if(iceQubeCount[i]>=100){
//                iceQubeSprite[i].rotation=arc4random() % 360 + 1;
//                iceQubeSprite[i].position=ccp(-283,250);
//                iceQubeSprite2[i].rotation=arc4random() % 360 + 1;
//                iceQubeSprite2[i].position=ccp(-283,250);
//                iceQubeSprite3[i].rotation=arc4random() % 360 + 1;
//                iceQubeSprite3[i].position=ccp(-283,250);
//                iceQubeSprite4[i].rotation=arc4random() % 360 + 1;
//                iceQubeSprite4[i].position=ccp(-283,250);
//                iceQubeSprite5[i].rotation=arc4random() % 360 + 1;
//                iceQubeSprite5[i].position=ccp(-283,250);
//                iceQubeSprite6[i].rotation=arc4random() % 360 + 1;
//                iceQubeSprite6[i].position=ccp(-283,250);
//                iceQubeCount[i]=0;
//            }
//        }
//        
//        if(fireReleaseCount==0&&fireStartCount<=100&&gateCount!=0){
//            for(int i=0;i<5;i++){
//                if(iceQubeCount[i]==0){
//                    iceQubeCount[i]=1;
//                    break;
//                }
//            }
//        }
        
        fireReleaseCount+=1;
        if(fireReleaseCount>=150){
            iceQubeSprite[2].visible = NO;
            iceQubeSprite[1].visible = NO;
            iceQubeSprite[0].visible = NO;
            fireReleaseCount=0;
        }
        
        fireStartCount+=1;
        if(fireStartCount>=300){
            iceQubeSprite[2].visible = YES;
            iceQubeSprite[1].visible = YES;
            iceQubeSprite[0].visible = YES;
            fireStartCount=0;
            if(!fireSideChe)
                fireSideChe=YES;
            else
                fireSideChe=NO;
        }
        
    }
}
-(void)switchFunc{
    
    if(screenMoveChe){
        //Smoking View
        if(switchSideValue==0){
            if(screenMovementFindValue==2){
                screenShowY-=5;
                if(screenShowY<300){
                    screenMovementFindValue=3;
                }
            }else if(screenMovementFindValue==3){
                screenShowX-=3;
                if(screenShowX<200)
                    screenMovementFindValue=4;
            }else if(screenMovementFindValue==4){
                screenShowX+=3;
                if(screenShowX>screenShowX2){
                    screenShowX=screenShowX2;
                    screenMovementFindValue=5;
                }
            }else if(screenMovementFindValue==5){
                screenShowY+=5;
                if(screenShowY>screenShowY2){
                    screenShowY=screenShowY2;
                    screenMovementFindValue=6;
                    screenMoveChe=NO;
                    screenHeroPosX=platformX;
                    screenHeroPosY=platformY;
                    screenShowX=platformX;
                    screenShowY=platformY;
                }
            }
        }else{
            screenMoveChe=NO;
        }
        
        //Platform View
        if(switchSideValue==0){
            if(screenMovementFindValue2==2){
                screenShowY-=6;
                if(screenShowY<400){
                    screenMovementFindValue2=3;
                }
            }else if(screenMovementFindValue2==3){
                screenShowX-=3;
                if(screenShowX<550)
                    screenMovementFindValue2=4;
            }else if(screenMovementFindValue2==4){
                screenShowX+=3;
                if(screenShowX>screenShowX2){
                    screenShowX=screenShowX2;
                    screenMovementFindValue2=5;
                }
            }else if(screenMovementFindValue2==5){
                screenShowY+=6;
                if(screenShowY>screenShowY2){
                    screenShowY=screenShowY2;
                    screenMoveChe=NO;
                    screenMovementFindValue2=6;
                    screenHeroPosX=platformX;
                    screenHeroPosY=platformY;
                    screenShowX=platformX;
                    screenShowY=platformY;
                }
                
            }
        }else{
            screenMoveChe=NO;
        }
        
        CGPoint copyHeroPosition = ccp(screenShowX, screenShowY);
        [self setViewpointCenter:copyHeroPosition];
    }
    
    
    if(screenMovementFindValue3>=1&&screenMovementFindValue3<=2){
        if(screenMovementFindValue3==1){
            screenShowX+=6;
            if(screenShowX>900)
                screenShowX=900;
            if(gateCount==35)
                screenMovementFindValue3=2;
        }else if(screenMovementFindValue3==2){
            screenShowX-=6;
            if(screenShowX<233){
                screenShowX=233;
                screenMovementFindValue3=3;
                fireStartCount=1;
                gameFunc.switchCount=0;
                screenHeroPosX=233;
                screenHeroPosY=platformY;
                screenShowX=233;
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
    movePlatformSprite.position=ccp(580,340+gameFunc.moveCount2);
    if(gateCount>=1) {
        gateCount+=0.1;
        gateCount=(gateCount>=35?35:gateCount);
    }
    
    
    gateSprite.position=ccp(970,275+gateCount);
    cheeseSprite2[1].position=ccp([gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:1].x,[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:1].y+gameFunc.moveCount2);
    cheeseSprite[1].position=ccp([gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:1].x,[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:1].y+gameFunc.moveCount2);
    
}
-(void)hotSmokingFunc{
    
    CGFloat sx=59;
    CGFloat sy=195;
    
    for(int i=0;i<10;i++){
        if(hotSmokingCount[i]>=1){
            hotSmokingCount[i]+=1.5;
            hotSmokingScaleCount[i]+=0.02;
            if(hotSmokingCount[i]>=250){
                hotSmokingCount[i]=0;
                hotSmokingScaleCount[i]=0;
                hotSprite[i].rotation=arc4random() % 360 + 1;
            }
            hotSprite[i].position=ccp(sx,sy+(hotSmokingCount[i]));
            hotSprite[i].opacity=250-(hotSmokingCount[i]/1.5);
        }
    }
    
    if(hotSmokingRelease == 0){
        for(int i=0;i<10;i++){
            if(hotSmokingCount[i]==0){
                if(hotIntervel<450&&gameFunc.switchCount==0){
                    hotSmokingCount[i]=1;
                    hotSmokingRelease=1;
                    break;
                }
            }
        }
    }
    if(hotSmokingRelease>=1){
        hotSmokingRelease+=1;
        if(hotSmokingRelease>=25){
            hotSmokingRelease=0;
        }
    }
    int iValue=(forwardChe?60:0);

    if(heroSprite.position.x-iValue<100 && heroSprite.position.y>250&&heroSprite.position.y<=435&&!heroTrappedChe&&gameFunc.switchCount==0){
        gameFunc.trappedChe=YES;
        trappedTypeValue=2;
    }
    
    
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
    if(heroSprite.position.x>=920+fValue&&heroSprite.position.y>=250 && heroSprite.position.y<300&&gateCount==35&&!mouseWinChe){
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
        if(heroTrappedChe&&heroTrappedCount>=150&&heroTrappedMove==0){
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
            if(i==1){
                mValue2=gameFunc.moveCount2;
                starSprite[i].position=ccp([gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].x-12+cheeseX2,[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].y+8+cheeseY2+mValue2);
            }
            
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
//                    [cheeseCollectedAtlas setString:[NSString stringWithFormat:@"%d/%d",cheeseCollectedScore,[cheeseSetValue[motherLevel-1] intValue]]];
                    [self createExplosionX:cheeseX-mValue y:cheeseY];
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
            
            if(trappedTypeValue>=1&&trappedTypeValue<=5)
                heroTrappedMove=1;
            if (trappedTypeValue == 2) {
                heroTrappedSprite = [CCSprite spriteWithSpriteFrameName:@"mother_trapped1.png"];
                heroTrappedSprite.scale=0.8;
                [spriteSheet addChild:heroTrappedSprite z:1];
                
                NSMutableArray *animFrames2 = [NSMutableArray array];
                for(int i = 3; i < 20; i++) {
                    if(i!= 3){
                        CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"mother_trapped%d.png",i]];
                        [animFrames2 addObject:frame];
                    }
                }
                CCAnimation *animation2 = [CCAnimation animationWithSpriteFrames:animFrames2 delay:0.1f];
                [heroTrappedSprite runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation2]]];   
            }
            else if (trappedTypeValue == 4){
                [self showAnimationWithMiceIdAndIndex:FTM_MAMA_MICE_ID andAnimationIndex:MAMA_WATER_ANIM];
                [self getTrappingAnimatedSprite].position = ccp([self getTrappingAnimatedSprite].position.x, [self getTrappingAnimatedSprite].position.y+15);
            }
            else if (trappedTypeValue == 3){
                [self showAnimationWithMiceIdAndIndex:FTM_MAMA_MICE_ID andAnimationIndex:MAMA_SHOCK_ANIM];
                if ([self getTrappingAnimatedSprite].position.y < 270) {
                    [self getTrappingAnimatedSprite].position = ccp([self getTrappingAnimatedSprite].position.x, 270);
                }
                CCMoveTo *move = [CCMoveTo actionWithDuration:1 position:ccp([self getTrappingAnimatedSprite].position.x, 270)];
                [[self getTrappingAnimatedSprite] runAction:move];
            }
            else{
                [self showAnimationWithMiceIdAndIndex:FTM_MAMA_MICE_ID andAnimationIndex:MAMA_FLAME_ANIM];
                CCMoveTo *move = [CCMoveTo actionWithDuration:1 position:ccp([self getTrappingAnimatedSprite].position.x, 280)];
                [[self getTrappingAnimatedSprite] runAction:move];
            }
            
            heroSprite.visible=NO;
        }
        if(heroTrappedMove!=0){
            int fValue = (forwardChe?heroForwardX:0);
            CGFloat xPos=0;
            if(trappedTypeValue==1){
                
                xPos=heroSprite.position.x-(forwardChe?80:-40);
            }else if(trappedTypeValue==2){
                xPos=60;
            }else if(trappedTypeValue==3)
                xPos=heroSprite.position.x-fValue;
            else if(trappedTypeValue==4){
                if(!forwardChe)
                    xPos=heroSprite.position.x+53;
                else
                    xPos=heroSprite.position.x-50;
            }else if(trappedTypeValue==5){
                xPos=heroSprite.position.x-fValue;
            }
            if (trappedTypeValue == 2) {
                heroTrappedSprite.position = ccp(xPos,heroSprite.position.y-heroTrappedMove);
            }
            CGPoint copyHeroPosition = ccp(heroSprite.position.x-fValue, heroSprite.position.y-heroTrappedMove);
            [self setViewpointCenter:copyHeroPosition];
            if(trappedTypeValue == 1){
                heroTrappedMove+=3;
                if(heroSprite.position.y-heroTrappedMove<=270)
                    heroTrappedMove=0;
            }else if(trappedTypeValue==2){
                heroTrappedMove+=3;
                if(heroSprite.position.y-heroTrappedMove<=270)
                    heroTrappedMove=0;
            }else if(trappedTypeValue==3){
                heroTrappedMove+=3;
                if(heroSprite.position.y-heroTrappedMove<=270)
                    heroTrappedMove=0;
            }else if(trappedTypeValue==4){
                heroTrappedMove+=1;
                if(heroSprite.position.y-heroTrappedMove<=212)
                    heroTrappedMove=0;
            }else if(trappedTypeValue==5){
                heroTrappedMove+=3;
                if(heroSprite.position.y-heroTrappedMove<=252)
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
        DB *db = [DB new];
        int currentLvl = [[db getSettingsFor:@"mamaCurrLvl"] intValue];
        if(currentLvl < motherLevel){
            [db setSettingsFor:@"mamaCurrLvl" withValue:[NSString stringWithFormat:@"%d", motherLevel]];
            int currentStrongLvl = [[db getSettingsFor:@"strongCurrLvl"] intValue];
            int currentMouse = [[db getSettingsFor:@"CurrentMouse"] intValue];
            if(currentStrongLvl == 0){
                [db setSettingsFor:@"CurrentLevel" withValue:[NSString stringWithFormat:@"%d", 1]];
                [db setSettingsFor:@"strongCurrLvl" withValue:[NSString stringWithFormat:@"%d", 1]];
            }
            if (currentMouse == 1) {
                [db setSettingsFor:@"CurrentMouse" withValue:[NSString stringWithFormat:@"%d", 2]];
            }
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
            if(gameFunc.movePlatformChe)
                platformY=gameFunc.movePlatformY-gameFunc.landMoveCount+gameFunc.moveCount2;
            [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
            platformX=gameFunc.xPosition;
            platformY=gameFunc.yPosition;
            heroSprite.rotation=0;
            heroRunSprite.rotation=0;
        }else{
            platformX-=3.2;
            if(gameFunc.movePlatformChe)
                platformY=gameFunc.movePlatformY-gameFunc.landMoveCount+gameFunc.moveCount2;
            [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
            platformX=gameFunc.xPosition;
            platformY=gameFunc.yPosition;
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
                jumpPower = (gameFunc.speedReverseJump!=1?4:7);
                if(gameFunc.speedReverseJump==1)
                    jumpAngle=70;
                
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
                jumpPower = (gameFunc.autoJumpSpeedValue!=1?5:12);
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
            if(!screenMoveChe&&!safetyJumpChe&&screenMovementFindValue==1){
                screenMoveChe=YES;
                screenMovementFindValue=2;
                screenShowX=platformX;
                screenShowY=platformY;
                screenShowX2=platformX;
                screenShowY2=platformY;
                
                if(platformY>300)
                    switchSideValue=0;
                else
                    switchSideValue=1;
            }
            if(!screenMoveChe&&!safetyJumpChe&&screenMovementFindValue2==1){
                screenMoveChe=YES;
                screenMovementFindValue2=2;
                screenShowX=platformX;
                screenShowY=platformY;
                screenShowX2=platformX;
                screenShowY2=platformY;
                
                if(platformY>450)
                    switchSideValue=0;
                else
                    switchSideValue=1;
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
    
    if(!mouseWinChe&&!heroTrappedChe&&!firstRunningChe&&!screenMoveChe&&(screenMovementFindValue3==0||screenMovementFindValue3==3)){
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
    
    if(!jumpingChe&&!runningChe&&heroJumpLocationChe&&!mouseWinChe&&motherLevel!=1&&!heroTrappedChe&&!firstRunningChe&&!screenMoveChe&&(screenMovementFindValue3==0||screenMovementFindValue3==3)){
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
        if(!jumpingChe&&!runningChe&&heroJumpLocationChe&&(screenMovementFindValue3== 0||screenMovementFindValue3== 3)){
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
        [[CCDirector sharedDirector] replaceScene:[GameEngine14 scene]];
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
    mouseTrappedBackground.visible = NO;
   
    heroTrappedSprite.visible = NO;
    if ((trappedTypeValue == 1 || trappedTypeValue == 5) && (runningChe || heroStandChe)) {
        if ([self getTrappingAnimatedSprite] != NULL) {
            [[self getTrappingAnimatedSprite] removeFromParentAndCleanup:YES];
        }
        [FTMUtil sharedInstance].isRespawnMice = NO;
        heroTrappedChe = NO;
        heroSprite.visible = YES;
        heroStandChe = YES;

        heroTrappedCount = 0;
        runningChe = NO;
        if (!forwardChe) {
            platformX -= 60;
        }else{
            platformX += 60;
        }
        CGPoint copyHeroPosition = ccp(platformX, gameFunc.yPosition);
        heroRunSprite.position=ccp(platformX,platformY+2);
        
        // may be hero sprite position also should be settled.
        [self setViewpointCenter:copyHeroPosition];
        [self heroUpdateForwardPosFunc];
    }else{
        if (trappedTypeValue == 1 || trappedTypeValue == 5) {
            if ([self getTrappingAnimatedSprite] != NULL) {
                [[self getTrappingAnimatedSprite] removeFromParentAndCleanup:YES];
            }
        }
        runningChe = NO;
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
