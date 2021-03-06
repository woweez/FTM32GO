//
//  HelloWorldLayer.mm
//  Tap
//
//  Created by karthik g on 27/09/12.
//  Copyright karthik g 2012. All rights reserved.
//

#import "GameEngine05.h"

#import "AppDelegate.h"
#import "LevelScreen.h"
#import "LevelCompleteScreen.h"
#import "CommonEngine.h"
#import "FTMConstants.h"
#import "DB.h"
#import "FTMUtil.h"

enum {
    kTagParentNode = 1,
};


GameEngineMenu05 *layer05;

@implementation GameEngineMenu05


-(id) init {
    if( (self=[super init])) {
    }
    return self;
}
@end

@implementation GameEngine05 

@synthesize tileMap = _tileMap;
@synthesize background = _background;


+(CCScene *) scene {
    CCScene *scene = [CCScene node];
    layer05=[GameEngineMenu05 node];
    [scene addChild:layer05 z:1];
    GameEngine05 *layer = [GameEngine05 node];
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
        heroRunningStopArr=[[NSArray alloc] initWithObjects:@"80",@"80",@"80", @"40",@"140",@"80",@"80",@"80",@"80",nil];
        
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
        if ([FTMUtil sharedInstance].isRetinaDisplay) {
            self.background.scale = 2;
        }
        [self addChild:_tileMap z:-1 tag:1];
        
        cache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [cache addSpriteFramesWithFile:@"mother_mouse_default.plist"];
        spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"mother_mouse_default.png"];
        [self addChild:spriteSheet z:10];
        
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
        menu.visible = NO;
        menu.position=ccp(52,302);
        [layer05 addChild:menu z:10];
        
        
        progressBarBackSprite=[CCSprite spriteWithFile:@"grey_bar_57.png"];
        progressBarBackSprite.position=ccp(240,300);
        progressBarBackSprite.visible = NO;
        [layer05 addChild:progressBarBackSprite z:10];
        
        
        cheeseCollectedSprite=[CCSprite spriteWithFile:@"cheese_collected.png"];
        cheeseCollectedSprite.position=ccp(430,300);
        cheeseCollectedSprite.visible = NO;
        [layer05 addChild:cheeseCollectedSprite z:10];
        
        progressBarSprite[0]=[CCSprite spriteWithFile:@"red_end.png"];
        progressBarSprite[0].position=ccp(117,301);
        progressBarSprite[0].scaleX=2.2;
        progressBarSprite[0].visible = NO;
        [layer05 addChild:progressBarSprite[0] z:10];
        
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
            [layer05 addChild:progressBarSprite[i] z:10];
        }
        
        timeCheeseSprite=[CCSprite spriteWithFile:@"time_cheese.png"];
        timeCheeseSprite.position=ccp(121+240,301);
        timeCheeseSprite.visible = NO;
        [layer05 addChild:timeCheeseSprite z:10];
        
        
        lifeMinutesAtlas = [[CCLabelAtlas labelWithString:@"01.60" charMapFile:@"numbers.png" itemWidth:15 itemHeight:20 startCharMap:'.'] retain];
        lifeMinutesAtlas.position=ccp(250,292);
        lifeMinutesAtlas.visible = NO;
        [layer05 addChild:lifeMinutesAtlas z:10];
        
        
        cheeseCollectedAtlas = [[CCLabelAtlas labelWithString:@"0/3" charMapFile:@"numbers.png" itemWidth:15 itemHeight:20 startCharMap:'.'] retain];
        cheeseCollectedAtlas.position=ccp(422,292);
        cheeseCollectedAtlas.scale=0.8;
        cheeseCollectedAtlas.visible = NO;
        [layer05 addChild:cheeseCollectedAtlas z:10];
        [cheeseCollectedAtlas setString:[NSString stringWithFormat:@"%d/%d",0,[cheeseSetValue[motherLevel-1] intValue]]];
        
        for(int i=0;i<cheeseCount;i++){
            cheeseCollectedChe[i]=YES;
            cheeseSprite[i]=[CCSprite spriteWithFile:@"Cheese.png"];
            cheeseSprite[i].position=[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i];
            [self playStaticCheeseAnimation:cheeseSprite[i]];
            [self addChild:cheeseSprite[i] z:9];
            cheeseSprite[i].scale = CHEESE_SCALE;
        }
        int switchWidth = [FTMUtil sharedInstance].isRetinaDisplay ? 40: 80;
        int switchHeight = [FTMUtil sharedInstance].isRetinaDisplay ? 103: 206;
        switchAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"switch.png" itemWidth:switchWidth itemHeight:switchHeight startCharMap:'0'] retain];
        switchAtlas.position=ccp(552,539);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            switchAtlas.scale = 0.35;
        }else{
            switchAtlas.scale=0.7;
        }
        [self addChild:switchAtlas z:9];
        
        clockBackgroundSprite=[CCSprite spriteWithFile:@"clock_background.png"];
        clockBackgroundSprite.position=ccp(-100,258);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            clockBackgroundSprite.scale = NON_RETINA_SCALE/2;
        }else{
            clockBackgroundSprite.scale=0.5;
        }
        [layer05 addChild:clockBackgroundSprite z:0];
        
        clockArrowSprite=[CCSprite spriteWithFile:@"clock_arrow.png"];
        clockArrowSprite.position=ccp(-100,258);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            clockArrowSprite.scale = NON_RETINA_SCALE/2;
        }else{
            clockArrowSprite.scale = 0.5;
        }
        clockArrowSprite.anchorPoint=ccp(0.2f, 0.2f);
        clockArrowSprite.rotation=-40;
        [layer05 addChild:clockArrowSprite z:0];
        
        
        CCSprite *slapSprite=[CCSprite spriteWithFile:@"slap.png"];
        slapSprite.position=ccp(150,188);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            slapSprite.scale = NON_RETINA_SCALE - 0.2;
        }else{
            slapSprite.scale = 0.6;
        }
        [self addChild:slapSprite z:2];
        
        slapSprite=[CCSprite spriteWithFile:@"slap.png"];
        slapSprite.position=ccp(450,188);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            slapSprite.scale = NON_RETINA_SCALE - 0.2;
        }else{
            slapSprite.scale=0.6;
        }
        [self addChild:slapSprite z:1];
        
        slapSprite=[CCSprite spriteWithFile:@"slap.png"];
        slapSprite.position=ccp(750,188);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            slapSprite.scale = NON_RETINA_SCALE - 0.2;
        }else{
            slapSprite.scale=0.6;
        }
        [self addChild:slapSprite z:1];
        
        slapSprite=[CCSprite spriteWithFile:@"slap.png"];
        slapSprite.position=ccp(1050,188);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            slapSprite.scale = NON_RETINA_SCALE - 0.2;
        }else{
            slapSprite.scale=0.6;
        }
        [self addChild:slapSprite z:1];
        
        CCSprite *pSprite=[CCSprite spriteWithFile:@"move_platform3.png"];
        pSprite.position=ccp(205,345);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            pSprite.scale = NON_RETINA_SCALE;
        }
        [self addChild:pSprite z:9];
        
        pSprite=[CCSprite spriteWithFile:@"move_platform2.png"];
        pSprite.position=ccp(40,345);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            pSprite.scale = NON_RETINA_SCALE;
        }
        [self addChild:pSprite z:9];
        
        pSprite=[CCSprite spriteWithFile:@"move_platform3.png"];
        pSprite.position=ccp(910,348);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            pSprite.scale = NON_RETINA_SCALE;
        }
        [self addChild:pSprite z:9];
        
        pSprite=[CCSprite spriteWithFile:@"move_platform2.png"];
        pSprite.position=ccp(727,447);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            pSprite.scale = NON_RETINA_SCALE;
        }
        [self addChild:pSprite z:9];
        
        CCSprite *windowSprite=[CCSprite spriteWithFile:@"window1.png"];
        windowSprite.position=ccp(975,516);
        windowSprite.rotation=-21;
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            windowSprite.scaleY = NON_RETINA_SCALE;
            windowSprite.scaleX = 0.55;
        }else{
            windowSprite.scaleX=1.1;
        }
        [self addChild:windowSprite z:0];
        
        windowSprite=[CCSprite spriteWithFile:@"window1.png"];
        windowSprite.position=ccp(50,488);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            windowSprite.scaleX = NON_RETINA_SCALE;
            windowSprite.scaleY = 0.45;
        }else{
            windowSprite.scaleY=0.9;
        }
        [self addChild:windowSprite z:0];
        
        windowSprite=[CCSprite spriteWithFile:@"window2.png"];
        windowSprite.position=ccp(131,488);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            windowSprite.scaleX = NON_RETINA_SCALE;
            windowSprite.scaleY = 0.45;
        }else{
            windowSprite.scaleY=0.9;
        }
        [self addChild:windowSprite z:0];
        
        windowSprite=[CCSprite spriteWithFile:@"object8.png"];
        windowSprite.position=ccp(30,443);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            windowSprite.scale = NON_RETINA_SCALE;
        }
        [self addChild:windowSprite z:0];
        
        windowSprite=[CCSprite spriteWithFile:@"object7.png"];
        windowSprite.position=ccp(60,475);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            windowSprite.scale = NON_RETINA_SCALE;
        }
        [self addChild:windowSprite z:0];
        
        windowSprite=[CCSprite spriteWithFile:@"object3.png"];
        windowSprite.position=ccp(20,525);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            windowSprite.scale = 0.35;
        }else{
            windowSprite.scale=0.7;
        }
        [self addChild:windowSprite z:0];
        
        windowSprite=[CCSprite spriteWithFile:@"knives_tray.png"];
        windowSprite.position=ccp(548,280);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            windowSprite.scale = NON_RETINA_SCALE;
        }
//        windowSprite.scale=0.5;
        [self addChild:windowSprite z:0];
        
        
        for(int i=0;i<15;i++){
            hotSprite[i]=[CCSprite spriteWithFile:@"smoke.png"];
            hotSprite[i].position=ccp(-275,415);
            [self addChild:hotSprite[i] z:9];
        }
        
        teaPotSprite=[CCSprite spriteWithFile:@"tea_pot.png"];
        teaPotSprite.position=ccp(274,395);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            teaPotSprite.scale = NON_RETINA_SCALE;
        }
        [self addChild:teaPotSprite z:9];
        
        tileMove=[CCSprite spriteWithFile:@"move_platform1.png"];
        tileMove.position=ccp(350,479);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            tileMove.scaleY = NON_RETINA_SCALE;
            tileMove.scaleX = 0.3;
        }else{
            tileMove.scaleX=0.6;
        }
        [self addChild:tileMove z:9];
        
        //===================================================================
        for(int i=0;i<0;i++){
            testSprite[i]=[CCSprite spriteWithFile:@"dotted.png"];
            testSprite[i].position=ccp(275,415);
            if (![FTMUtil sharedInstance].isRetinaDisplay) {
                testSprite[i].scale = 0.05;
            }else{
                testSprite[i].scale=0.1;
            }
            [self addChild:testSprite[i] z:9];
        }
        
        mouseTrappedBackground=[CCSprite spriteWithFile:@"mouse_trapped_background.png"];
        mouseTrappedBackground.position=ccp(240,160);
        mouseTrappedBackground.visible=NO;
        [layer05 addChild:mouseTrappedBackground z:10];
        
        CCMenuItem *aboutMenuItem = [CCMenuItemImage itemWithNormalImage:@"main_menu_button_1.png" selectedImage:@"main_menu_button_2.png" target:self selector:@selector(clickLevel:)];
        aboutMenuItem.tag=2;
        
        CCMenuItem *optionMenuItem = [CCMenuItemImage itemWithNormalImage:@"try_again_button_1.png" selectedImage:@"try_again_button_2.png" target:self selector:@selector(clickLevel:)];
        optionMenuItem.tag=1;
        
        menu2 = [CCMenu menuWithItems: optionMenuItem,aboutMenuItem,  nil];
        [menu2 alignItemsHorizontallyWithPadding:4.0];
        menu2.position=ccp(241,136);
        menu2.visible=NO;
        [layer05 addChild: menu2 z:10];
        
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
        
        CCSprite *holeSprite=[CCSprite spriteWithFile:@"hole.png"];
        holeSprite.position=ccp(960,276);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            holeSprite.scale = NON_RETINA_SCALE;
        }
        [self addChild:holeSprite z:0];
        
        dotSprite=[CCSprite spriteWithFile:@"dotted.png"];
        dotSprite.position=ccp(462,240);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            dotSprite.scale = 0.15;
        }else{
            dotSprite.scale=0.3;
        }
        [self addChild:dotSprite z:10];
        [self addHudLayerToTheScene];
        [self starCheeseSpriteInitilized];
        
        [self scheduleUpdate];
    }
    return self;
}

-(void) addHudLayerToTheScene{
    hudLayer = [[HudLayer alloc] init];
    hudLayer.tag = 5;
    [layer05 addChild: hudLayer z:2000];
    [hudLayer updateNoOfCheeseCollected:0 andMaxValue:[cheeseSetValue[motherLevel-1] intValue]];
}

-(void) addLevelCompleteLayerToTheScene{
    [self levelCompleted: 5];
}

-(void)initValue{
    //Cheese Count Important
    DB *db = [DB new];
    motherLevel= 5;//[[db getSettingsFor:@"CurrentLevel"] intValue];
    [db release];
    
    cheeseCount=[cheeseSetValue[motherLevel-1] intValue];
    platformX=200;
    platformY=450;
    
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
        self.position = ccp(-126, -85);
        if (self.scaleX > (0.02+ winSize.width/1000)) {
            self.scaleX = self.scaleX - 0.01;
            
        }
        if (self.scaleY > winSize.height/700) {
            self.scaleY = self.scaleY - 0.01;
        }
    }
    
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
    
    //[self trigoJumpingFunc:platformX yPosition:platformY];
    
    gameFunc.runChe=runningChe;
    [gameFunc render];
    
    if(motherLevel==5 || motherLevel == 6 || motherLevel==7 || motherLevel ==8)
        [self level05];
    
    if(gameFunc.trigoVisibleChe){
        heroSprite.rotation=-gameFunc.trigoHeroAngle;
        heroRunSprite.rotation=-gameFunc.trigoHeroAngle;
    }
    
    
}
-(void)trigoJumpingFunc:(CGFloat)xPos yPosition:(CGFloat)yPos{
    /*  for(int i=15;i<165;i++){
     CGFloat xx=[trigo circlex:82 a:i]+650;
     CGFloat yy=[trigo circley:60 a:i]+350;
     
     testSprite[i].position=ccp(xx,yy+gameFunc.moveCount2);
     }*/
    
    
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
    if(motherLevel == 5){
        tileMove.position=ccp(350+gameFunc.moveCount2,449);
        cheeseSprite[2].position=ccp(350+gameFunc.moveCount2,471);
    }else if(motherLevel == 6){
        if(!gameFunc.moveSideChe){
            tileMove2.position=ccp(750,420+gameFunc.moveCount2);
            cheeseSprite[2].position=ccp(750,443+gameFunc.moveCount2);
        }else{
            tileMove2.position=ccp(750-gameFunc.moveCount3,420);
            cheeseSprite[2].position=ccp(750-gameFunc.moveCount3,443);
        }
        if(!gameFunc.switchStrChe)
            [switchAtlas setString:@"0"];
        else{
            if ([[switchAtlas string] isEqualToString:@"0"]){
                [soundEffect switchSound];
            }
            [switchAtlas setString:@"1"];
        }
    }else if(motherLevel == 7){
        tileMove.position=ccp(650,349+gameFunc.moveCount2);
        domeSprite.position=ccp(650,393+gameFunc.domeMoveCount);
        cheeseSprite[3].position=ccp(655,374+gameFunc.moveCount2);
        if(gameFunc.heightMoveChe&&gameFunc.domeMoveCount==130){
            domeRotateCount+=1;
            domeRotateCount=(domeRotateCount>200?0:domeRotateCount);
            int localDomeCount=(domeRotateCount<=100?domeRotateCount:100-(domeRotateCount-100));
            domeSprite.rotation=(localDomeCount/13.0);
        }
        if(gameFunc.domChe&&gameFunc.domeEnterChe){
            gameFunc.domeEnterChe=NO;
            //Running Visible
            heroStandChe=NO;
            runningChe=YES;
            heroSprite.visible=NO;
            heroRunSprite.visible=YES;
            
            platformX=gameFunc.xPosition;
            platformY=gameFunc.yPosition;
            
            
            if(!forwardChe)
                heroSprite.position=ccp(platformX,platformY);
            else
                heroSprite.position=ccp(platformX+heroForwardX,platformY);
            //heroSprite.rotation=-gameFunc.domeAngle;
            CGPoint copyHeroPosition = ccp(platformX, platformY);
            [self setViewpointCenter:copyHeroPosition];
            if(!gameFunc.domeSideChe&&gameFunc.domeAngle>180)
                gameFunc.autoJumpChe=YES;
            else if(gameFunc.domeSideChe&&gameFunc.domeAngle<0)
                gameFunc.autoJumpChe=YES;
        }
    }else if(motherLevel ==8){
        int localVegetableCount=(gameFunc.vegetableCount<=200?gameFunc.vegetableCount:200-(gameFunc.vegetableCount-200));
        vegetableCloseSprite.rotation=(localVegetableCount/3.0)-15;
        
        tileMove.position=ccp(960-gameFunc.moveCount2,299);
        if(gameFunc.vegetableCount!=0){
            if ([[switchAtlas2 string] isEqualToString:@"0"]){
                [soundEffect switchSound];
            }
            [switchAtlas2 setString:@"1"];
        }
        else if(gameFunc.moveCount2!=0){
            if ([[switchAtlas string] isEqualToString:@"0"]){
                [soundEffect switchSound];
            }
            if ([[switchAtlas string] isEqualToString:@"0"]){
                [soundEffect switchSound];
            }
            [switchAtlas setString:@"1"];
        }
        
        
        if(gameFunc.vegetableCount<50&&!gameFunc.trappedChe&&gameFunc.vegetableCount!=0 && ![FTMUtil sharedInstance].isInvincibilityOn){
            if(heroSprite.position.x>=625 &&heroSprite.position.x<715 && heroSprite.position.y>304 &&heroSprite.position.y<312&&!forwardChe){
                gameFunc.trappedChe=YES;
            }else if(heroSprite.position.x>=680 &&heroSprite.position.x<770 && heroSprite.position.y>304 &&heroSprite.position.y<312&&forwardChe){
                gameFunc.trappedChe=YES;
            }
        }
    }
    
}
-(void)hotSmokingFunc{
    if(motherLevel == 3 || motherLevel == 4 || motherLevel == 5 || motherLevel == 7){
        CGFloat sx=0;
        CGFloat sy=0;
        CGFloat hotScale=0;
        CGFloat divideLength=2.3;
        if(motherLevel == 3){
            sx=642;
            sy= 355;
            hotScale=0.6;
            divideLength=2.3;
        }else if(motherLevel == 4){
            sx=653;
            sy= 262;
            hotScale=0.65;
            divideLength=2.3;
        }else if(motherLevel == 5){
            sx=275;
            sy=400;
            if (![FTMUtil sharedInstance].isRetinaDisplay) {
                hotScale = NON_RETINA_SCALE;
            }else{
                hotScale = 1;
            }
            divideLength=1.5;
        }else if(motherLevel == 7){
            sx=795;
            sy=280;
            hotScale=1.0;
            divideLength=1.2;
        }
        for(int i=0;i<15;i++){
            if(hotSmokingCount[i]>=1){
                hotSmokingCount[i]+=1.0;
                if(hotSmokingCount[i]>=250){
                    hotSmokingCount[i]=0;
                }
                hotSprite[i].position=ccp(sx,sy+(hotSmokingCount[i]/divideLength));
                hotSprite[i].opacity=250-(hotSmokingCount[i]);
                hotSprite[i].scale=hotScale+(hotSmokingCount[i]/400.0);
            }
        }
        
        if(motherLevel==3){
            hotIntervel+=1;
            hotIntervel=(hotIntervel>800?0:hotIntervel);
        }
        
        if(hotSmokingRelease == 0){
            for(int i=0;i<15;i++){
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
            if(hotSmokingRelease>=35){
                hotSmokingRelease=0;
            }
        }
        
        if(motherLevel==5 && ![FTMUtil sharedInstance].isInvincibilityOn){
            if(!forwardChe && heroSprite.position.x>220 && heroSprite.position.x<= 300&& heroSprite.position.y>400&&heroSprite.position.y<=600&&!heroTrappedChe&&gameFunc.switchCount==0){
                gameFunc.trappedChe=YES;
              //  NSLog(@"Object width and height==== %d %d %d", gameFunc.objectWidth,gameFunc.objectHeight,gameFunc.sideValueForObject);
                
            }else if(forwardChe && heroSprite.position.x>240 && heroSprite.position.x<= 300&& heroSprite.position.y>400&&heroSprite.position.y<=600&&!heroTrappedChe &&gameFunc.switchCount==0){
                gameFunc.trappedChe=YES;
               // NSLog(@"Object width and height==== %d %d %d", gameFunc.objectWidth,gameFunc.objectHeight,gameFunc.sideValueForObject);
            }
        }
    }
    
}
-(void)switchFunc{
    if(motherLevel==4||motherLevel==5 || motherLevel == 7){
        if(gameFunc.switchCount==1){
            gameFunc.switchCount=2;
            [self startClockTimer];
//            clockArrowSprite.position=ccp(450,258);
//            clockBackgroundSprite.position=ccp(450,258);
            if ([[switchAtlas string] isEqualToString:@"0"]){
                [soundEffect switchSound];
            }
            [switchAtlas setString:@"1"];
        }else if(gameFunc.switchCount>=1){
            gameFunc.switchCount+=1;
            if(gameFunc.switchCount%60==0)
                clockArrowSprite.rotation=((gameFunc.switchCount/60)*12)-40;
            if(gameFunc.switchCount/60>30){
                clockBackgroundSprite.position=ccp(-100,258);
                clockArrowSprite.position=ccp(-100,258);
                gameFunc.switchCount=0;
//                if (newClockSprite != nil) {
//                    [newClockSprite removeFromParentAndCleanup:YES];
//                    newClockSprite = nil;
//                }
                [switchAtlas setString:@"0"];
            }
        }
        
        if(gameFunc.domeSwitchChe){
            if ([[switchAtlas2 string] isEqualToString:@"0"]){
                [soundEffect switchSound];
            }
            [switchAtlas2 setString:@"1"];
        }
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
    if(motherLevel == 5 || motherLevel == 6 ){
        int fValue=(!forwardChe?0:30);
        if(heroSprite.position.x>=920+fValue&&heroSprite.position.y<=295&&!mouseWinChe){
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
        }else if(gameFunc.trappedChe && !heroTrappedChe){
            heroTrappedChe=YES;
//             NSLog(@"Object width and height==== %d %d %d", gameFunc.objectWidth,gameFunc.objectHeight,gameFunc.sideValueForObject);
            heroSprite.visible=NO;
            heroStandChe=NO;
            heroRunSprite.visible=NO;
        }
    }
    if(gameFunc.trappedChe ){//&& ![FTMUtil sharedInstance].isRespawnMice
        if(heroTrappedChe&&heroTrappedCount ==100){
            [self showLevelFailedUI:motherLevel];
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
            if(motherLevel==5&&i==2){
                mValue=gameFunc.moveCount2;
            }            
            cheeseAnimationCount+=2;
            cheeseAnimationCount=(cheeseAnimationCount>=500?0:cheeseAnimationCount);
            CGFloat localCheeseAnimationCount=0;
            localCheeseAnimationCount=(cheeseAnimationCount<=250?cheeseAnimationCount:250-(cheeseAnimationCount-250));
            
            CGFloat cheeseX=[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].x;
            CGFloat cheeseY=[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].y;
            
            
            if(!forwardChe){
                if(heroX>=cheeseX-70+mValue &&heroX<=cheeseX+10+mValue&&heroY>cheeseY-20+mValue2&&heroY<cheeseY+30){
                    [soundEffect cheeseCollectedSound];
                    cheeseCollectedChe[i]=NO;
                    cheeseSprite[i].visible=NO;
                    cheeseCollectedScore+=1;
                    [self playCheeseCollectedAnimation:cheeseSprite[i]];
                    break;
                }
            }else{
                if(heroX>=cheeseX-10+mValue &&heroX<=cheeseX+70+mValue&&heroY>cheeseY-20&&heroY<cheeseY+30){
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

-(int ) getAnimationTypeForTrapping{
    
    if (gameFunc.objectWidth == 75 && gameFunc.objectHeight == 40) {
        return MAMA_KNIFE_ANIM;
    }
    else{
        return 0;
    }
}
-(void)heroTrappedFunc{
    
    if(heroTrappedChe){
        heroTrappedCount+=1;
        if(heroTrappedCount==10){
            if ([self getAnimationTypeForTrapping] == MAMA_KNIFE_ANIM) {
                [self showAnimationWithMiceIdAndIndex:FTM_MAMA_MICE_ID andAnimationIndex:MAMA_KNIFE_ANIM];
            }
            else{
                
                heroTrappedSprite = [CCSprite spriteWithFile:@"mm_mist_0.png"];
                heroTrappedSprite.scale=0.5;
                if(!forwardChe)
                    heroTrappedSprite.position = ccp(heroSprite.position.x , heroSprite.position.y+15);
                else
                    heroTrappedSprite.position = ccp(heroSprite.position.x , heroSprite.position.y+15);
                
                heroTrappedSprite.scale=0.5;
                [self addChild:heroTrappedSprite z:1000];
                int posY;
                if(heroSprite.position.x<350){
                    posY = 455;
                }else{
                    posY = 335;
                }
                
                CCMoveTo *move = [CCMoveTo actionWithDuration:1 position:ccp(heroTrappedSprite.position.x, posY)];
                [heroTrappedSprite runAction:move];
                
                heroSprite.visible=NO;
            }
        }
    }
}

-(void) playKittenKnockedAnimation{
    
    [cache addSpriteFramesWithFile:@"mama_knives_animation.plist"];
    CCSpriteBatchNode *catKnockedSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"mama_knives_animation.png"];
    [self addChild:catKnockedSpriteSheet z:10];
    
    NSMutableArray *knockedOutAnimationFramesArr = [NSMutableArray array];
    for(int i = 0; i <= 23; i++) {
        CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"mm_knives_hit_%d.png",i]];
        [knockedOutAnimationFramesArr addObject:frame];
    }
    CCAnimation *knockedOutAnimation = [CCAnimation animationWithSpriteFrames:knockedOutAnimationFramesArr delay:0.03f];
    
    CCSprite *knockedOutSprite = [CCSprite spriteWithSpriteFrameName:@"mm_knives_hit_0.png"];
    if(!forwardChe){
        knockedOutSprite.position = ccp(heroRunSprite.position.x+heroRunSprite.contentSize.width/4, heroRunSprite.position.y -heroRunSprite.contentSize.height/3);
    }else{
         knockedOutSprite.position = ccp(heroRunSprite.position.x-heroRunSprite.contentSize.width/4, heroRunSprite.position.y -heroRunSprite.contentSize.height/3);
    }
    knockedOutSprite.scale=0.5;
    [catKnockedSpriteSheet addChild:knockedOutSprite];
    
    CCAnimate *actionOne = [CCAnimate actionWithAnimation:knockedOutAnimation];
//    CCCallFuncN *callbackFunc = [CCCallFuncN actionWithTarget:self selector:@selector(animationDoneForKitten1:)];
//    CCSequence *sequence = [CCSequence actions:actionOne, nil];
    [knockedOutSprite runAction:[CCRepeatForever actionWithAction:actionOne ]];
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
            heroWinSprite.scale=MAMA_SCALE;
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
                }
            }else{
                if(motherLevel == 5){
                    gameFunc.movePlatformX-=(gameFunc.moveCount<=150?3.4:2.8);
                    platformX=gameFunc.movePlatformX-gameFunc.landMoveCount+gameFunc.moveCount2;
                    [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
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
            }else if(gameFunc.landingChe ){//&& ![FTMUtil sharedInstance].isRespawnMice
                
                yy=gameFunc.yPosition;
                gameFunc.landingChe=NO;
                if(safetyJumpChe){
                    safetyJumpChe=NO;
                    gameFunc.topHittingCollisionChe=NO;
                }
                if(gameFunc.trigoVisibleChe)
                    dragTrigoCheckChe=forwardChe;
                if (!gameFunc.trappedChe) {
                    [self endJumping:gameFunc.xPosition yValue:gameFunc.yPosition];
                }
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
    self.position = viewPoint;
    
}
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    CGPoint prevLocation = [myTouch previousLocationInView: [myTouch view]];
    prevLocation = [[CCDirector sharedDirector] convertToGL: prevLocation];
    
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
                [soundEffect mama_jump];
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
        [[CCDirector sharedDirector] replaceScene:[GameEngine05 scene]];
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
    heroTrappedSprite.visible = NO;
    mouseTrappedBackground.visible=NO;
    [[self getTrappingAnimatedSprite] removeFromParentAndCleanup:YES];
    [self endJumping:(platformX + gameFunc.xPosition)/2  yValue:gameFunc.yPosition];
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
