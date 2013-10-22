//
//  HelloWorldLayer.mm
//  Tap
//
//  Created by karthik g on 27/09/12.
//  Copyright karthik g 2012. All rights reserved.
//

// Import the interfaces
#import "StrongMouseEngine14.h"
#import "LevelScreen.h"
#import "FTMUtil.h"
#import "FTMConstants.h"
// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "DB.h"
enum {
    kTagParentNode = 1,
};

StrongMouseEngineMenu14 *sLayer14;

@implementation StrongMouseEngineMenu14


-(id) init {
    if( (self=[super init])) {
    }
    return self;
}
@end

@implementation StrongMouseEngine14

@synthesize tileMap = _tileMap;
@synthesize background = _background;

+(CCScene *) scene {
    CCScene *scene = [CCScene node];
    sLayer14=[StrongMouseEngineMenu14 node];
    [scene addChild:sLayer14 z:1];
    
    StrongMouseEngine14 *layer = [StrongMouseEngine14 node];
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
        heroRunningStopArr=[[NSArray alloc] initWithObjects:@"80",@"80",@"80", @"40",@"140",@"80",@"80",@"80",@"20",@"80",@"80",@"80",@"40",@"120",nil];
        fireXPos=[[NSArray alloc] initWithObjects:@"434",@"696", @"877",nil];
        
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
    
        
        for(int i=0;i<6;i++){
            blockSprite[i]=[CCSprite spriteWithFile:@"block.png"];
            if(i==0)
                blockSprite[i].position=ccp(245,554);
            else if(i==1)
                blockSprite[i].position=ccp(395,554);
            else if(i == 2)
                blockSprite[i].position=ccp(500,474);
            else if(i == 3)
                blockSprite[i].position=ccp(745,554);
            else if(i == 4)
                blockSprite[i].position=ccp(875,554);
            else if(i == 5)
                blockSprite[i].position=ccp(860,373);
            
            [self addChild:blockSprite[i] z:0];
        }
        

//        catCache = [CCSpriteFrameCache sharedSpriteFrameCache];
//        [catCache addSpriteFramesWithFile:@"cat_default.plist"];
//        catSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"cat_default.png"];
//        [self addChild:catSpriteSheet z:0];
//        
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
        [sLayer14 addChild:menu z:10];
        
        mouseTrappedBackground=[CCSprite spriteWithFile:@"mouse_trapped_background.png"];
        mouseTrappedBackground.position=ccp(240,160);
        mouseTrappedBackground.visible=NO;
        [sLayer14 addChild:mouseTrappedBackground z:10];
        
        CCMenuItem *aboutMenuItem = [CCMenuItemImage itemWithNormalImage:@"main_menu_button_1.png" selectedImage:@"main_menu_button_2.png" target:self selector:@selector(clickLevel:)];
        aboutMenuItem.tag=2;
        
        CCMenuItem *optionMenuItem = [CCMenuItemImage itemWithNormalImage:@"try_again_button_1.png" selectedImage:@"try_again_button_2.png" target:self selector:@selector(clickLevel:)];
        optionMenuItem.tag=1;
        
        menu2 = [CCMenu menuWithItems: optionMenuItem,aboutMenuItem,  nil];
        [menu2 alignItemsHorizontallyWithPadding:4.0];
        menu2.position=ccp(241,136);
        menu2.visible=NO;
        [sLayer14 addChild: menu2 z:10];
        
        cheeseCollectedSprite=[CCSprite spriteWithFile:@"cheese_collected.png"];
        cheeseCollectedSprite.position=ccp(430,300);
        cheeseCollectedSprite.visible = NO;
        [sLayer14 addChild:cheeseCollectedSprite z:10];
        
        timeCheeseSprite=[CCSprite spriteWithFile:@"time_cheese.png"];
        timeCheeseSprite.position=ccp(121+240,301);
        timeCheeseSprite.visible = NO;
        [sLayer14 addChild:timeCheeseSprite z:10];
        
        lifeMinutesAtlas = [[CCLabelAtlas labelWithString:@"01.60" charMapFile:@"numbers.png" itemWidth:15 itemHeight:20 startCharMap:'.'] retain];
        lifeMinutesAtlas.position=ccp(250,292);
        lifeMinutesAtlas.visible = NO;
        [sLayer14 addChild:lifeMinutesAtlas z:10];
        
        cheeseCollectedAtlas = [[CCLabelAtlas labelWithString:@"0/3" charMapFile:@"numbers.png" itemWidth:15 itemHeight:20 startCharMap:'.'] retain];
        cheeseCollectedAtlas.position=ccp(422,292);
        cheeseCollectedAtlas.scale=0.8;
        cheeseCollectedAtlas.visible = NO;
        [sLayer14 addChild:cheeseCollectedAtlas z:10];
        [cheeseCollectedAtlas setString:[NSString stringWithFormat:@"%d/%d",0,[cheeseSetValue[motherLevel-1] intValue]]];
        
        for(int i=0;i<cheeseCount;i++){
            cheeseCollectedChe[i]=YES;
            cheeseSprite2[i]=[CCSprite spriteWithFile:@"cheeseGlow.png"];
            [self addChild:cheeseSprite2[i] z:9];
            cheeseSprite[i]=[CCSprite spriteWithFile:@"Cheese.png"];
            [self addChild:cheeseSprite[i] z:9];
            
            if(i==0||i==4){
                cheeseSprite[i].position=[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i];
                cheeseSprite2[i].position=[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i];
            }
        }
        
        iceBlastAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"ice_blast.png" itemWidth:100 itemHeight:50 startCharMap:'0'] retain];
        iceBlastAtlas.position=ccp(-270,200);
        [self addChild:iceBlastAtlas z:9];
        
        
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
        
        CCSprite *pSprite=[CCSprite spriteWithFile:@"move_platform3.png"];
        pSprite.position=ccp(865,339);
        [self addChild:pSprite z:9];
        
        pSprite=[CCSprite spriteWithFile:@"move_platform3.png"];
        pSprite.position=ccp(1058,339);
        [self addChild:pSprite z:9];
        
        
        pSprite=[CCSprite spriteWithFile:@"move_platform3.png"];
        pSprite.position=ccp(320,520);
        [self addChild:pSprite z:9];
        
        pSprite=[CCSprite spriteWithFile:@"move_platform3.png"];
        pSprite.position=ccp(810,520);
        pSprite.scaleX=0.9;
        [self addChild:pSprite z:9];
        
        pSprite=[CCSprite spriteWithFile:@"move_platform3.png"];
        pSprite.position=ccp(575,440);
        [self addChild:pSprite z:9];
        
        pSprite=[CCSprite spriteWithFile:@"move_platform2.png"];
        pSprite.position=ccp(990,460);
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
        sprite.position=ccp(580,235);
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
        sprite.position=ccp(580,182);
        [self addChild:sprite z:9];
        
        sprite=[CCSprite spriteWithFile:@"water_plate.png"];
        sprite.position=ccp(544,245);
        sprite.scale=0.7;
        [self addChild:sprite z:9];
        
        sprite=[CCSprite spriteWithFile:@"water_plate.png"];
        sprite.position=ccp(614,245);
        sprite.scale=0.7;
        [self addChild:sprite z:9];
        
        gateSprite=[CCSprite spriteWithFile:@"gate.png"];
        gateSprite.position=ccp(970,275);
        [self addChild:gateSprite z:9];
        
        CCSprite *holeSprite=[CCSprite spriteWithFile:@"hole.png"];
        holeSprite.position=ccp(970,280);
        [self addChild:holeSprite z:1];
        
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
            [self addChild:hotSprite[i] z:0];
        }
        
        for(int i=0;i<20;i++){
            heroPimpleSprite[i]=[CCSprite spriteWithFile:@"dotted.png"];
            heroPimpleSprite[i].position=ccp(-100,160);
            heroPimpleSprite[i].scale=0.3;
            [self addChild:heroPimpleSprite[i] z:10];
        }
        
        //===================================================================
        dotSprite=[CCSprite spriteWithFile:@"dotted.png"];
        dotSprite.position=ccp(115,490);
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
    hudLayer.tag = 14;
    [sLayer14 addChild: hudLayer z:2000];
    [hudLayer updateNoOfCheeseCollected:0 andMaxValue:[cheeseSetValue[motherLevel-1] intValue]];
}

-(void) addLevelCompleteLayerToTheScene{
    [self levelCompleted :14];
}


-(void)initValue{
    
    //Cheese Count Important
//    DB *db = [DB new];
    motherLevel = 14;//[[db getSettingsFor:@"CurrentLevel"] intValue];
//    [db release];
    
    cheeseCount=[cheeseSetValue[motherLevel-1] intValue];
    
    platformX=200;//[gameFunc getPlatformPosition:motherLevel].x;
    platformY=250;//[gameFunc getPlatformPosition:motherLevel].y;
    
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
    catRunningSection=1;
    
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
    gameFunc.runChe=runningChe;
    [gameFunc render];
    [self catFunc];
    [self collision];
    [self hotSmokingFunc];
    [self iceQubeAnimation];
    
    [self level05];
    
    
    
}

-(void)catFunc{
    
    if(!catJumpChe && catObj == nil){
        catObj = [[StrongLevel14Cat alloc] init];
        [catObj runCurrentSequence];
        [self addChild:catObj];
    }
    if(catRunningSection ==1){
        if(!catBackChe){
            if(catMovementCount<=135){
                if(turnAnimationCount==0){
                    catX=[trigo circlex:catMovementCount a:359]+235;
                    catY=[trigo circley:catMovementCount a:359]+543;
                    if(catAnimationCount%2 == 0)
                        [self catSpriteGenerate:catAnimationCount/2 animationType:@"run"];
                    catMovementCount+=1.0;
                    if(catMovementCount >= 135){
                        catRunningCount+=1;
                        if(catRunningCount>=3){
                            catRunningCount=0;
                            catRunningSection=2;
                            catMovementCount=136;
                            catJumpChe=YES;
                            catSideChe=NO;
                        }else{
                            turnAnimationCount=1;
                            catBackChe=YES;
                        }
                    }
                }
            }
        }else{
            if(catMovementCount<=135){
                if(turnAnimationCount==0&&!catJumpChe){
                    catX=[trigo circlex:catMovementCount a:359]+235;
                    catY=[trigo circley:catMovementCount a:359]+543;
                    if(catAnimationCount%2 == 0)
                        [self catSpriteGenerate:catAnimationCount/2 animationType:@"run"];
                    catMovementCount-=1.0;
                    
                    if(catMovementCount <=0){
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
                            catJumpChe=NO;
                        }
                    }
                }
            }
        }
    }
    
    if(catRunningSection ==2){
        if(!catBackChe){
            if(catMovementCount >135&&catMovementCount<=250){
                if(catJumpingAnimationCount>=55){
                    catX=[trigo circlex:45 a:260-catMovementCount]+436;
                    catY=[trigo circley:100 a:260-catMovementCount]+440;
                    catMovementCount+=2.0;
                    if(catJumpingAnimationCount>=55){
                        catJumpingAnimationCount+=1;
                        catJumpingAnimationCount=(catJumpingAnimationCount>=90?90:catJumpingAnimationCount);
                        if(catJumpingAnimationCount%5==0)
                            [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                    }
                }
            }else if(catMovementCount>250&&catMovementCount<=380){
                if(!catJumpChe&&turnAnimationCount==0){
                    catX=[trigo circlex:catMovementCount a:359]+180;
                    catY=[trigo circley:catMovementCount a:359]+463;
                    catMovementCount+=1.0;
                    if(catAnimationCount%2 == 0)
                        [self catSpriteGenerate:catAnimationCount/2 animationType:@"run"];
                    
                    if(catMovementCount>=380){
                        if(!catSideChe)
                            catRunningCount+=1;
                        if(catRunningCount>=3){
                            catRunningCount=0;
                            catRunningSection=3;
                            catMovementCount=381;
                            catJumpChe=YES;
                        }else{
                            turnAnimationCount=1;
                            catBackChe=YES;
                        }
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
            if(catMovementCount>250&&catMovementCount<=380){
                if(turnAnimationCount==0&&!catJumpChe){
                    catX=[trigo circlex:catMovementCount a:359]+180;
                    catY=[trigo circley:catMovementCount a:359]+463;
                    catMovementCount-=1.0;
                    if(catAnimationCount%2 == 0)
                        [self catSpriteGenerate:catAnimationCount/2 animationType:@"run"];
                    if(catMovementCount<=250){
                        if(catSideChe)
                            catRunningCount2+=1;
                        if(catRunningCount2>=3){
                            catRunningCount2=0;
                            catMovementCount=250;
                            catJumpChe=YES;
                        }else{
                            turnAnimationCount=1;
                            catMovementCount=251;
                            catBackChe=NO;
                        }
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
            }else if(catMovementCount >135&&catMovementCount<=250){
                if(catJumpingAnimationCount>=55){
                    catX=[trigo circlex:45 a:260-catMovementCount]+436;
                    catY=[trigo circley:100 a:260-catMovementCount]+440;
                    catMovementCount-=2.0;
                    if(catJumpingAnimationCount>=55&&catMovementCount<190){
                        catJumpingAnimationCount+=1;
                        catJumpingAnimationCount=(catJumpingAnimationCount>=90?90:catJumpingAnimationCount);
                        if(catJumpingAnimationCount%5==0)
                            [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                    }
                    if(catMovementCount <= 135){
                        catRunningSection=1;
                        catMovementCount=134;
                    }
                    
                }
            }
        }
    }
    
    if(catRunningSection == 3){
        if(!catBackChe){
            if(catMovementCount>380&&catMovementCount<=495){
                if(catJumpingAnimationCount>=55){
                    catX=[trigo circlex:45 a:190-catMovementCount]+709;
                    catY=[trigo circley:100 a:190-catMovementCount]+440;
                    catMovementCount+=2.0;
                    if(catJumpingAnimationCount>=55&&catMovementCount>450){
                        catJumpingAnimationCount+=1;
                        catJumpingAnimationCount=(catJumpingAnimationCount>=90?90:catJumpingAnimationCount);
                        if(catJumpingAnimationCount%5==0)
                            [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                    }
                }
            }else if(catMovementCount>495){
                if(!catJumpChe&&turnAnimationCount == 0){
                    catX=[trigo circlex:catMovementCount a:359]+122;
                    catY=[trigo circley:catMovementCount a:359]+543;
                    catMovementCount+=1.0;
                    if(catAnimationCount%2 == 0)
                        [self catSpriteGenerate:catAnimationCount/2 animationType:@"run"];
                    if(catMovementCount>=605){
                        turnAnimationCount=1;
                        catBackChe=YES;
                        catMovementCount=604;
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
            if(catMovementCount>495 &&catMovementCount<=605){
                if(!catJumpChe&&turnAnimationCount == 0){
                    catX=[trigo circlex:catMovementCount a:359]+122;
                    catY=[trigo circley:catMovementCount a:359]+543;
                    catMovementCount-=1.0;
                    if(catAnimationCount%2 == 0)
                        [self catSpriteGenerate:catAnimationCount/2 animationType:@"run"];
                    if(catMovementCount<=495){
                        catRunningCount+=1;
                        if(catRunningCount>=3){
                            catRunningCount=0;
                            catRunningSection=3;
                            catMovementCount=494;
                            catJumpChe=YES;
                            catSideChe=YES;
                        }else{
                            turnAnimationCount=1;
                            catBackChe=NO;
                            catMovementCount=496;
                        }
                    }
                }
            }else if(catMovementCount>380&&catMovementCount<=495){
                if(catJumpingAnimationCount>=55){
                    catX=[trigo circlex:45 a:190-catMovementCount]+709;
                    catY=[trigo circley:100 a:190-catMovementCount]+440;
                    catMovementCount-=2.0;
                    if(catJumpingAnimationCount>=55){
                        catJumpingAnimationCount+=1;
                        catJumpingAnimationCount=(catJumpingAnimationCount>=90?90:catJumpingAnimationCount);
                        if(catJumpingAnimationCount%5==0)
                            [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                    }
                    if(catMovementCount<=380){
                        catRunningSection=2;
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
//    
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
//    
    
}
-(void) playBlockSound: (int) tag{
    //chusss tareeen code karthik ;(
    BOOL playSound = NO;
    if (tag == 1 && !box1) {
        box1 = YES;
        playSound = YES;
    }
    else if (tag == 2 && !box2) {
        box2 = YES;
        playSound = YES;
    }
    else if (tag == 3 && !box3) {
        box3 = YES;
        playSound = YES;
    }
    else if (tag == 4 && !box4) {
        box4 = YES;
        playSound = YES;
    }
    else if (tag == 5 && !box5) {
        box5 = YES;
        playSound = YES;
    }
    else if (tag == 6 && !box6) {
        box6 = YES;
        playSound = YES;
    }
    
    if (playSound) {
        [soundEffect blocks_hitting_ground];
    }
}

-(void)collision{
    
    CGFloat hx=heroSprite.position.x;
    CGFloat hy=heroSprite.position.y;
    int iValue=(forwardChe?43:0);
    
    if(hx-iValue>[catObj getCatSprite].position.x-90 &&hx-iValue<[catObj getCatSprite].position.x+40 &&hy > [catObj getCatSprite].position.y-30 &&hy<[catObj getCatSprite].position.y+50 &&!gameFunc.
       trappedChe){
        gameFunc.trappedChe=YES;
        trappedTypeValue=3;
    }
    for(int i=0;i<6;i++){
        for(int j=0;j<6;j++){
            if(i!=j){
                if(blockSprite[i].position.x>blockSprite[j].position.x-40 && blockSprite[i].position.x<blockSprite[j].position.x+40&&blockSprite[i].position.y>blockSprite[j].position.y-40 && blockSprite[i].position.y<blockSprite[j].position.y+40){
                    [gameFunc setBlockChe:i];
                    [gameFunc setBlockChe:j];
                }
            }
        }
    }
    if(blockSuccessCount!=6)
        blockSuccessCount=0;
    
    checkCheese[0]=0;
    checkCheese2[0]=0;
    checkCheese3[0]=0;
    checkCheese[1]=0;
    checkCheese2[1]=0;
    checkCheese3[1]=0;
    
    
    for(int i=0;i<6;i++){
        //Block 1
        if(blockSprite[i].position.x>=420 && blockSprite[i].position.x<=440 && blockSprite[i].position.y <= 275){
            if(blockSuccessCount<=6)
                blockSuccessCount+=1;
            checkCheese3[0]=1;
            [self playBlockSound: 1];
        }
        if(blockSprite[i].position.x>=460 && blockSprite[i].position.x<=480 && blockSprite[i].position.y <= 275){
            if(blockSuccessCount<=6)
                blockSuccessCount+=1;
            checkCheese3[1]=1;
            [self playBlockSound: 2];
        }
        
        
        //Block 2
        if(blockSprite[i].position.x>=686 && blockSprite[i].position.x<=706 && blockSprite[i].position.y <= 275){
            if(blockSuccessCount<=6)
                blockSuccessCount+=1;
            checkCheese2[0]=1;
            [self playBlockSound: 3];
        }
        if(blockSprite[i].position.x>=725 && blockSprite[i].position.x<=745 && blockSprite[i].position.y <= 275){
            if(blockSuccessCount<=6)
                blockSuccessCount+=1;
            checkCheese2[1]=1;
            [self playBlockSound: 4];
        }
        
        //Block 3
        if(blockSprite[i].position.x >= 866 && blockSprite[i].position.x<=886 && blockSprite[i].position.y <= 275){
            if(blockSuccessCount<=6)
                blockSuccessCount+=1;
            checkCheese[0]=1;
            [self playBlockSound: 5];
        }
        if(blockSprite[i].position.x >= 905 && blockSprite[i].position.x<=925 && blockSprite[i].position.y <= 275){
            if(blockSuccessCount<=6)
                blockSuccessCount+=1;
            checkCheese[1]=1;
           [self playBlockSound: 6];
        }
        if(blockSuccessCount>=6)
            gameFunc.notCollideBlockChe=YES;
        
        
        if(checkCheese[0]==1&&checkCheese[1]==1){
            
            cheeseSprite[3].position=[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:3];
            cheeseSprite2[3].position=[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:3];
//            starSprite[3].position=ccp([gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:3].x-12,[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:3].y+8);
        }else{
            cheeseSprite[3].position=ccp(-300,100);
            cheeseSprite2[3].position=ccp(-300,100);
//            starSprite[3].position=ccp(-300,100);
        }
        
        if(checkCheese2[0]&&checkCheese2[1]){
            cheeseSprite[2].position=[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:2];
            cheeseSprite2[2].position=[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:2];
//            starSprite[2].position=ccp([gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:2].x-12,[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:2].y+8);
        }else{
            cheeseSprite[2].position=ccp(-300,100);
            cheeseSprite2[2].position=ccp(-300,100);
//            starSprite[2].position=ccp(-300,100);
        }
        if(checkCheese3[0]&&checkCheese3[1]){
            cheeseSprite[1].position=[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:1];
            cheeseSprite2[1].position=[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:1];
//            starSprite[1].position=ccp([gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:1].x-12,[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:1].y+8);
        }else{
            cheeseSprite[1].position=ccp(-300,100);
            cheeseSprite2[1].position=ccp(-300,100);
//            starSprite[1].position=ccp(-300,100);
        }
        
        
    }
    
    iValue = (forwardChe?60:0);
    for(int i=0;i<3;i++){
        if(hx-iValue>iceQubeSprite[i].position.x-60 &&hx-iValue<iceQubeSprite[i].position.x+20 &&hy > iceQubeSprite[i].position.y-30 &&hy<iceQubeSprite[i].position.y+50 &&!gameFunc.trappedChe && iceQubeSprite[i].visible){
            gameFunc.trappedChe=YES;
            trappedTypeValue=1;
        }
    }
    iValue = (forwardChe?43:0);
    if(gameFunc.releasePushChe){
        heroStandChe=YES;
        runningChe=NO;
        heroRunSprite.visible=NO;
        heroSprite.visible=YES;
        heroPushSprite.visible=NO;
        gameFunc.pushChe=NO;
        gameFunc.releasePushChe=NO;
    }
    
    if(hx-iValue>100 &&hx-iValue<200 && hy<300&&!cheeseSprite[0].visible&&screenMovementFindValue2==0){
        
        screenMovementFindValue2=1;
        gateCount=1;
        gameFunc.gateOpenChe=YES;
        screenMoveChe=YES;
        screenHeroPosX=platformX;
        screenHeroPosY=platformY;
        screenShowX=platformX;
        screenShowY=platformY;
        heroStandChe=YES;
        runningChe=NO;
        heroRunSprite.visible=NO;
        heroSprite.visible=YES;
    }
    if(!screenMoveChe&&screenMovementFindValue==0&&blockSuccessCount>=6){
        screenMoveChe=YES;
        screenMovementFindValue=1;
        screenShowX=platformX;
        screenShowY=platformY;
        screenShowX2=platformX;
        screenShowY2=platformY;
    }
    if(hx-iValue>[catObj getCatSprite].position.x-90 &&hx-iValue<[catObj getCatSprite].position.x+40 &&hy > [catObj getCatSprite].position.y-30 &&hy<[catObj getCatSprite].position.y+50 &&!gameFunc.
       trappedChe){
        gameFunc.trappedChe=YES;
        trappedTypeValue=3;
    }
}


-(void)iceQubeAnimation{
    if(!screenMoveChe && screenMovementFindValue2 == 6){
        for(int i=0;i<5;i++){
            if(iceQubeCount[i]!=0){
                if(iceQubeCount[i]!=0)
                    iceQubeCount[i]+=2.5;
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
                
            }
            
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
        }
        
        if(fireReleaseCount==0&&fireStartCount<=100&&gateCount>=1){
            for(int i=0;i<5;i++){
                if(iceQubeCount[i]==0){
                    iceQubeCount[i]=1;
                    break;
                }
            }
        }
        
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
        if(screenMovementFindValue==1){
            screenShowX-=5;
            if(screenShowX<0)
                screenMovementFindValue=2;
        }else if(screenMovementFindValue==2){
            screenShowX+=5;
            if(screenShowX>screenShowX2){
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
            screenShowX+=6;
            if(screenShowX>900)
                screenShowX=900;
            if(gateCount==35)
                screenMovementFindValue2=2;
        }else if(screenMovementFindValue2==2){
            screenShowX-=6;
            if(screenShowX<233){
                screenMoveChe=NO;
                screenShowX=233;
                screenMovementFindValue2=3;
                fireStartCount=1;
                gameFunc.switchCount=0;
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
    
    blockSprite[0].position=ccp(245+[gameFunc getBlockValue:0 pValue:0],554-[gameFunc getBlockValue:0 pValue:1]);
    blockSprite[1].position=ccp(395+[gameFunc getBlockValue:1 pValue:0],554-[gameFunc getBlockValue:1 pValue:1]);
    blockSprite[2].position=ccp(500+[gameFunc getBlockValue:2 pValue:0],474-[gameFunc getBlockValue:2 pValue:1]);
    blockSprite[3].position=ccp(745+[gameFunc getBlockValue:3 pValue:0],554-[gameFunc getBlockValue:3 pValue:1]);
    blockSprite[4].position=ccp(875+[gameFunc getBlockValue:4 pValue:0],554-[gameFunc getBlockValue:4 pValue:1]);
    blockSprite[5].position=ccp(850+[gameFunc getBlockValue:5 pValue:0],373-[gameFunc getBlockValue:5 pValue:1]);
    
    if(gateCount>=1) {
        gateCount+=0.1;
        gateCount=(gateCount>=35?35:gateCount);
    }
    
    gateSprite.position=ccp(970,275+gateCount);
    
    for(int i=0;i<6;i++){
        if(blockSprite[i].position.y<350){
            blockSprite[i].zOrder=9;
        }
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
        if(heroTrappedChe&&heroTrappedCount>=100&&heroTrappedMove==0){
            menu2.visible=YES;
            mouseTrappedBackground.visible=YES;
        }
    }
    
    if(gameFunc.honeyPotCount==0&&!cheeseSprite[0].visible)
        gameFunc.honeyPotCount=1;
    
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
    
    if(hotSmokingRelease == 0 && screenMovementFindValue<=0&&!firstRunningChe){
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
        if(hotSmokingRelease>=25){
            hotSmokingRelease=0;
        }
    }
    int iValue=(forwardChe?60:0);
    if(heroSprite.position.x-iValue<100 && heroSprite.position.y>250&&heroSprite.position.y<=435&&!heroTrappedChe&&blockSuccessCount<6&&screenMovementFindValue<=0&&!firstRunningChe){
        gameFunc.trappedChe=YES;
        trappedTypeValue=2;
    }
    
}
-(void)starCheeseSpriteInitilized{
//    for(int i=0;i<5;i++){
//        starSprite[i] = [CCSprite spriteWithSpriteFrameName:@"star2.png"];
//        starSprite[i].scale=0.4;
//        if(i==0 ||i==4)
//            starSprite[i].position=ccp([gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].x-12,[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].y+8);
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
            
            CGFloat cheeseX=cheeseSprite[i].position.x;
            CGFloat cheeseY=cheeseSprite[i].position.y;
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
                if(heroX>=cheeseX-70-mValue &&heroX<=cheeseX+10-mValue&&heroY>cheeseY-20+mValue2&&heroY<cheeseY+30+mValue2&&ch2&&!firstRunningChe){
                    [soundEffect cheeseCollectedSound];
                    cheeseCollectedChe[i]=NO;
                    cheeseSprite[i].visible=NO;
                    cheeseSprite2[i].visible=NO;
                    cheeseCollectedScore+=1;
//                    starSprite[i].visible=NO;
                    [cheeseCollectedAtlas setString:[NSString stringWithFormat:@"%d/%d",cheeseCollectedScore,[cheeseSetValue[motherLevel-1] intValue]]];
                    [self createExplosionX:cheeseX-mValue y:cheeseY+mValue2];
                    break;
                }
            }else{
                if(heroX>=cheeseX-10-mValue &&heroX<=cheeseX+70-mValue&&heroY>cheeseY-20+mValue2&&heroY<cheeseY+30+mValue2&&ch2&&!firstRunningChe){
                    [soundEffect cheeseCollectedSound];
                    cheeseCollectedChe[i]=NO;
                    cheeseSprite[i].visible=NO;
                    cheeseSprite2[i].visible=NO;
                    cheeseCollectedScore+=1;
//                    starSprite[i].visible=NO;
                    [cheeseCollectedAtlas setString:[NSString stringWithFormat:@"%d/%d",cheeseCollectedScore,[cheeseSetValue[motherLevel-1] intValue]]];
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
            heroTrappedSprite = [CCSprite spriteWithFile:@"sm_mist_0.png"];
            if(!forwardChe)
                heroTrappedSprite.position = ccp(platformX, platformY+5);
            else
                heroTrappedSprite.position = ccp(platformX+heroForwardX, platformY+5);
            heroTrappedSprite.scale = 0.5;
            [self addChild:heroTrappedSprite];
            
//            NSMutableArray *animFrames2 = [NSMutableArray array];
//            for(int i = 1; i < 4; i++) {
//                
//                CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"strong_trapped%d.png",i]];
//                [animFrames2 addObject:frame];
//                
//            }
//            CCAnimation *animation2 = [CCAnimation animationWithSpriteFrames:animFrames2 delay:0.1f];
//            [heroTrappedSprite runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation2]]];
            heroSprite.visible=NO;
        }
        if(heroTrappedMove!=0){
            int fValue = (forwardChe?heroForwardX:0);
            CGFloat xPos=0;
            if(trappedTypeValue<=3)
                xPos=heroSprite.position.x-(forwardChe?40:-40);
            
            
            heroTrappedSprite.position = ccp(xPos,heroSprite.position.y-heroTrappedMove);
            CGPoint copyHeroPosition = ccp(heroSprite.position.x-fValue, heroSprite.position.y-heroTrappedMove);
            [self setViewpointCenter:copyHeroPosition];
            if(trappedTypeValue <= 3){
                heroTrappedMove+=2;
                if(heroSprite.position.y-heroTrappedMove<=270)
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
            if(currentLvl < motherLevel){
                [db setSettingsFor:@"strongCurrLvl" withValue:[NSString stringWithFormat:@"%d", motherLevel]];
                int currentGirlLvl = [[db getSettingsFor:@"girlCurrLvl"] intValue];
                int currentMouse = [[db getSettingsFor:@"CurrentMouse"] intValue];
                if(currentGirlLvl == 0){
                    [db setSettingsFor:@"CurrentLevel" withValue:[NSString stringWithFormat:@"%d", 1]];
                    [db setSettingsFor:@"girlCurrLvl" withValue:[NSString stringWithFormat:@"%d", 1]];
                }
                if (currentMouse == 2) {
                    [db setSettingsFor:@"CurrentMouse" withValue:[NSString stringWithFormat:@"%d", 3]];
                }
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
        mouseDragSprite.position=ccp(platformX +DRAG_SPRITE_OFFSET_X/2 +heroForwardX,platformY-DRAG_SPRITE_OFFSET_Y/2);
    
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
                    mouseDragSprite.position=ccp(platformX + DRAG_SPRITE_OFFSET_X/2 +heroForwardX,platformY-DRAG_SPRITE_OFFSET_Y/2);
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
        [[CCDirector sharedDirector] replaceScene:[StrongMouseEngine14 scene]];
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
//    if ( trappedTypeValue == 2 ||  trappedTypeValue == 1) {
//        [self endJumping:platformX - 30 yValue:gameFunc.yPosition];
//        [self schedule:@selector(startRespawnTimer) interval:1];
//    }else{
        [self endJumping:(platformX + gameFunc.xPosition)/2 yValue:gameFunc.yPosition];
        [self schedule:@selector(startRespawnTimer) interval:1];
//    }
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
