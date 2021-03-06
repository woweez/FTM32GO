//
//  HelloWorldLayer.mm
//  Tap
//
//  Created by karthik g on 27/09/12.
//  Copyright karthik g 2012. All rights reserved.
//

#import "GameEngine11.h"

#import "AppDelegate.h"
#import "LevelScreen.h"
#import "LevelCompleteScreen.h"
#import "FTMUtil.h"
#import "DB.h"
#import "FTMConstants.h"

enum {
    kTagParentNode = 1,
};


GameEngine11Menu *layer11;

@implementation GameEngine11Menu


-(id) init {
    if( (self=[super init])) {
    }
    return self;
}
@end

@implementation GameEngine11

@synthesize tileMap = _tileMap;
@synthesize background = _background;


+(CCScene *) scene {
    CCScene *scene = [CCScene node];
    layer11=[GameEngine11Menu node];
    [scene addChild:layer11 z:1];
    GameEngine11 *layer = [GameEngine11 node];
    [scene addChild: layer z:0];
    return scene;
}


-(id) init
{
    if( (self=[super init])) {
        
        heroJumpIntervalValue = [[NSArray alloc] initWithObjects:@"0",@"2",@"4",@"6",@"8",@"10",@"0",@"11",@"13",@"15",nil];
        cheeseArrX=[[NSArray alloc] initWithObjects:@"0",@"20",@"0",@"20",@"10",nil];
        cheeseArrY=[[NSArray alloc] initWithObjects:@"0",@"0", @"-15", @"-15",@"-8",nil];
        heroRunningStopArr=[[NSArray alloc] initWithObjects:@"80",@"80",@"80", @"40",@"140",@"80",@"80",@"80",@"80",@"80",@"50",@"80",@"80",@"80",nil];
        freezeReleaseArr=[[NSArray alloc] initWithObjects:@"4",@"3",@"2",@"1",@"4",@"2",@"3",@"1",@"1",@"2",@"3",@"4",nil];
        
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
        menu.position=ccp(52,302);
        menu.visible = NO;
        [layer11 addChild:menu z:10];
        
        
        progressBarBackSprite=[CCSprite spriteWithFile:@"grey_bar_57.png"];
        progressBarBackSprite.position=ccp(240,300);
        [layer11 addChild:progressBarBackSprite z:10];
        progressBarBackSprite.visible = NO;
        
        cheeseCollectedSprite=[CCSprite spriteWithFile:@"cheese_collected.png"];
        cheeseCollectedSprite.position=ccp(430,300);
        cheeseCollectedSprite.visible = NO;
        [layer11 addChild:cheeseCollectedSprite z:10];
        
        progressBarSprite[0]=[CCSprite spriteWithFile:@"red_end.png"];
        progressBarSprite[0].position=ccp(117,301);
        progressBarSprite[0].scaleX=2.2;
        progressBarSprite[0].visible = NO;
        [layer11 addChild:progressBarSprite[0] z:10];
        
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
            [layer11 addChild:progressBarSprite[i] z:10];
        }
        
        timeCheeseSprite=[CCSprite spriteWithFile:@"time_cheese.png"];
        timeCheeseSprite.position=ccp(121+240,301);
        timeCheeseSprite.visible = NO;
        [layer11 addChild:timeCheeseSprite z:10];
        
        
        lifeMinutesAtlas = [[CCLabelAtlas labelWithString:@"01.60" charMapFile:@"numbers.png" itemWidth:15 itemHeight:20 startCharMap:'.'] retain];
        lifeMinutesAtlas.visible = NO;
        lifeMinutesAtlas.position=ccp(250,292);
        [layer11 addChild:lifeMinutesAtlas z:10];
        
        cheeseCollectedAtlas = [[CCLabelAtlas labelWithString:@"0/3" charMapFile:@"numbers.png" itemWidth:15 itemHeight:20 startCharMap:'.'] retain];
        cheeseCollectedAtlas.visible = NO;
        cheeseCollectedAtlas.position=ccp(422,292);
        cheeseCollectedAtlas.scale=0.8;
        [layer11 addChild:cheeseCollectedAtlas z:10];
        [cheeseCollectedAtlas setString:[NSString stringWithFormat:@"%d/%d",0,5]];
        
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
        switchAtlas.position=ccp(50,335);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            switchAtlas.scale = 0.35;
        }else{
            switchAtlas.scale = 0.7;
        }
        [self addChild:switchAtlas z:9];
        
        int iceBlastWidth = [FTMUtil sharedInstance].isRetinaDisplay ? 100: 200;
        int iceBlastHeight = [FTMUtil sharedInstance].isRetinaDisplay ? 50: 100;
        iceBlastAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"ice_blast.png" itemWidth:iceBlastWidth itemHeight:iceBlastHeight startCharMap:'0'] retain];
        iceBlastAtlas.position=ccp(-270,200);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            iceBlastAtlas.scale = NON_RETINA_SCALE;
        }
        [self addChild:iceBlastAtlas z:9];
        
        iceBlastAtlas2 = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"ice_blast.png" itemWidth:iceBlastWidth itemHeight:iceBlastHeight startCharMap:'0'] retain];
        iceBlastAtlas2.position=ccp(-270,200);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            iceBlastAtlas2.scale = NON_RETINA_SCALE;
        }
        [self addChild:iceBlastAtlas2 z:9];
        
        
        int bridgeWidth = [FTMUtil sharedInstance].isRetinaDisplay ? 395: 790;
        int bridgetHeight = [FTMUtil sharedInstance].isRetinaDisplay ? 49: 98;
        CCLabelAtlas *bridgeAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"fridge_platform.png" itemWidth:bridgeWidth itemHeight:bridgetHeight startCharMap:'0'] retain];
        bridgeAtlas.position=ccp(-25,52);
        [self addChild:bridgeAtlas z:0];
        bridgeAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"fridge_platform.png" itemWidth:bridgeWidth itemHeight:bridgetHeight startCharMap:'0'] retain];
        bridgeAtlas.position=ccp(349,52);
        [self addChild:bridgeAtlas z:0];
        bridgeAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"fridge_platform.png" itemWidth:bridgeWidth itemHeight:bridgetHeight startCharMap:'0'] retain];
        bridgeAtlas.position=ccp(724,52);
        [self addChild:bridgeAtlas z:0];
        
        bridgeAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"fridge_platform.png" itemWidth:bridgeWidth itemHeight:bridgetHeight startCharMap:'0'] retain];
        bridgeAtlas.position=ccp(-25,154);
        [self addChild:bridgeAtlas z:0];
        bridgeAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"fridge_platform.png" itemWidth:bridgeWidth itemHeight:bridgetHeight startCharMap:'0'] retain];
        bridgeAtlas.position=ccp(349,154);
        [self addChild:bridgeAtlas z:0];
        bridgeAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"fridge_platform.png" itemWidth:bridgeWidth itemHeight:bridgetHeight startCharMap:'0'] retain];
        bridgeAtlas.position=ccp(724,154);
        [self addChild:bridgeAtlas z:0];
        
        CCSprite *bridgeSprite=[CCSprite spriteWithFile:@"fridge_platform4.png"];
        bridgeSprite.position=ccp(97,513);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            bridgeSprite.scale = NON_RETINA_SCALE;
        }
        [self addChild:bridgeSprite z:0];
        
        bridgeSprite=[CCSprite spriteWithFile:@"fridge_platform.png"];
        bridgeSprite.position=ccp(240,609);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            bridgeSprite.scale = NON_RETINA_SCALE;
        }
        [self addChild:bridgeSprite z:0];
        
        bridgeSprite=[CCSprite spriteWithFile:@"fridge_platform3.png"];
        bridgeSprite.position=ccp(-15,609);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            bridgeSprite.scale = NON_RETINA_SCALE;
        }
        [self addChild:bridgeSprite z:0];
        
        bridgeSprite=[CCSprite spriteWithFile:@"fridge_platform.png"];
        bridgeSprite.position=ccp(950,596);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            bridgeSprite.scale = NON_RETINA_SCALE;
        }
        [self addChild:bridgeSprite z:0];
        
        bridgeSprite=[CCSprite spriteWithFile:@"fridge_platform4.png"];
        bridgeSprite.position=ccp(820,433);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            bridgeSprite.scale = NON_RETINA_SCALE;
        }
        [self addChild:bridgeSprite z:0];

        CCSprite *iceBoxSprite=[CCSprite spriteWithFile:@"bridge_ice_box2.png"];
        iceBoxSprite.position=ccp(200,265);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            iceBoxSprite.scale = NON_RETINA_SCALE;
        }
        [self addChild:iceBoxSprite z:0];
        
        iceBoxSprite=[CCSprite spriteWithFile:@"bridge_ice_box.png"];
        iceBoxSprite.position=ccp(623,233);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            iceBoxSprite.scale = NON_RETINA_SCALE;
        }
        [self addChild:iceBoxSprite z:0];
        
        int boxWidth = [FTMUtil sharedInstance].isRetinaDisplay ? 232: 464;
        int boxWidth2 = [FTMUtil sharedInstance].isRetinaDisplay ? 279: 558;
        int boxHeight = [FTMUtil sharedInstance].isRetinaDisplay ? 90: 180;
        
        CCLabelAtlas *iceBoxAtlas = [[CCLabelAtlas labelWithString:@"1" charMapFile:@"bridge_ice_box2.png" itemWidth:boxWidth itemHeight:boxHeight startCharMap:'0'] retain];
        iceBoxAtlas.position=ccp(126,150);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            iceBoxAtlas.scale = NON_RETINA_SCALE;
        }
        iceBoxAtlas.opacity=100;
        [self addChild:iceBoxAtlas z:10];
        
        iceBoxAtlas = [[CCLabelAtlas labelWithString:@"1" charMapFile:@"bridge_ice_box.png" itemWidth:boxWidth2 itemHeight:boxHeight startCharMap:'0'] retain];
        iceBoxAtlas.position=ccp(483,140);
        iceBoxAtlas.opacity=100;
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            iceBoxAtlas.scale = NON_RETINA_SCALE;
        }
        [self addChild:iceBoxAtlas z:10];
        
        CCSprite *objectSprite=[CCSprite spriteWithFile:@"bridge_object8.png"];
        objectSprite.position=ccp(100,548);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            objectSprite.scale = 0.35;
        }else{
            objectSprite.scale = 0.7;
        }
        [self addChild:objectSprite z:0];
        
        objectSprite=[CCSprite spriteWithFile:@"object4.png"];
        objectSprite.position=ccp(40,648);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            objectSprite.scale = 0.35;
        }else{
            objectSprite.scale = 0.7;
        }
        [self addChild:objectSprite z:0];
        
        objectSprite=[CCSprite spriteWithFile:@"object1.png"];
        objectSprite.position=ccp(150,388);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            objectSprite.scale = 0.35;
        }else{
            objectSprite.scale = 0.7;
        }
        objectSprite.opacity=170;
        [self addChild:objectSprite z:0];
        
        objectSprite=[CCSprite spriteWithFile:@"bridge_object1.png"];
        objectSprite.position=ccp(825,478);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            objectSprite.scale = 0.3;
        }else{
            objectSprite.scale = 0.6;
        }
        [self addChild:objectSprite z:0];
        
        objectSprite=[CCSprite spriteWithFile:@"bridge_object5.png"];
        objectSprite.position=ccp(835,628);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            objectSprite.scale = 0.3;
        }else{
            objectSprite.scale = 0.6;
        }
        [self addChild:objectSprite z:0];
        
        objectSprite=[CCSprite spriteWithFile:@"bridge_object3.png"];
        objectSprite.position=ccp(925,208);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            objectSprite.scale = 0.3;
        }else{
            objectSprite.scale = 0.6;
        }
        [self addChild:objectSprite z:0];
        
        objectSprite=[CCSprite spriteWithFile:@"bridge_object6.png"];
        objectSprite.position=ccp(625,108);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            objectSprite.scale = NON_RETINA_SCALE;
        }
        [self addChild:objectSprite z:0];
        
        objectSprite=[CCSprite spriteWithFile:@"bridge_object4.png"];
        objectSprite.position=ccp(225,108);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            objectSprite.scale = NON_RETINA_SCALE;
        }
        [self addChild:objectSprite z:0];
        
        CCSprite *freezeWindowSprite=[CCSprite spriteWithFile:@"freeze_window.png"];
        freezeWindowSprite.position=ccp(105,642);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            freezeWindowSprite.scaleX = 0.4;
            freezeWindowSprite.scaleY = 0.5;
        }else{
            freezeWindowSprite.scaleX = 0.8;
        }
        [self addChild:freezeWindowSprite z:0];
        
        freezeWindowSprite=[CCSprite spriteWithFile:@"freeze_window.png"];
        freezeWindowSprite.position=ccp(170,642);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            freezeWindowSprite.scaleX = 0.4;
            freezeWindowSprite.scaleY = 0.5;
        }else{
            freezeWindowSprite.scaleX = 0.8;
        }
        [self addChild:freezeWindowSprite z:0];
        
        freezeWindowSprite=[CCSprite spriteWithFile:@"freeze_window.png"];
        freezeWindowSprite.position=ccp(235,642);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            freezeWindowSprite.scaleX = 0.4;
            freezeWindowSprite.scaleY = 0.5;
        }else{
            freezeWindowSprite.scaleX = 0.8;
        }
        [self addChild:freezeWindowSprite z:0];
        
        freezeWindowSprite=[CCSprite spriteWithFile:@"freeze_window.png"];
        freezeWindowSprite.position=ccp(305,642);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            freezeWindowSprite.scaleX = 0.4;
            freezeWindowSprite.scaleY = 0.5;
        }else{
            freezeWindowSprite.scaleX = 0.8;
        }
        [self addChild:freezeWindowSprite z:0];
        
        
        
        for(int i=0;i<3;i++){
            iceSmokingSprite[i]=[CCSprite spriteWithFile:@"ice_smoke.png"];
            iceSmokingSprite[i].position=ccp(-100,258);
            if (![FTMUtil sharedInstance].isRetinaDisplay) {
                iceSmokingSprite[i].scale = NON_RETINA_SCALE;
            }
            [self addChild:iceSmokingSprite[i] z:0];
        }
        
        for(int i=0;i<20;i++){
            heroPimpleSprite[i]=[CCSprite spriteWithFile:@"dotted.png"];
            heroPimpleSprite[i].position=ccp(-100,160);
            if (![FTMUtil sharedInstance].isRetinaDisplay) {
                heroPimpleSprite[i].scale = 0.15;
            }else{
                heroPimpleSprite[i].scale = 0.3;
            }
            [self addChild:heroPimpleSprite[i] z:10];
        }
        
        mouseTrappedBackground=[CCSprite spriteWithFile:@"mouse_trapped_background.png"];
        mouseTrappedBackground.position=ccp(240,160);
        mouseTrappedBackground.visible=NO;
        [layer11 addChild:mouseTrappedBackground z:10];
        
        CCMenuItem *aboutMenuItem = [CCMenuItemImage itemWithNormalImage:@"main_menu_button_1.png" selectedImage:@"main_menu_button_2.png" target:self selector:@selector(clickLevel:)];
        aboutMenuItem.tag=2;
        
        CCMenuItem *optionMenuItem = [CCMenuItemImage itemWithNormalImage:@"try_again_button_1.png" selectedImage:@"try_again_button_2.png" target:self selector:@selector(clickLevel:)];
        optionMenuItem.tag=1;
        
        for(int i=0;i<4;i++){
            iceQubeSprite[i]=[CCSprite spriteWithFile:@"ice_qube.png"];
            iceQubeSprite[i].position=ccp(-107,525);
            iceQubeSprite[i].rotation=arc4random() % 360 + 1;
            if (![FTMUtil sharedInstance].isRetinaDisplay) {
                iceQubeSprite[i].scale = NON_RETINA_SCALE;
            }
            [self addChild:iceQubeSprite[i] z:9];
            
            iceQubeSprite2[i]=[CCSprite spriteWithFile:@"ice_qube.png"];
            iceQubeSprite2[i].position=ccp(-107,525);
            iceQubeSprite2[i].rotation=arc4random() % 360 + 1;
            if (![FTMUtil sharedInstance].isRetinaDisplay) {
                iceQubeSprite2[i].scale = NON_RETINA_SCALE;
            }
            [self addChild:iceQubeSprite2[i] z:9];
        }
         
        movePlatformSprite=[CCSprite spriteWithFile:@"ice_platform.png"];
        movePlatformSprite.position=ccp(120,512);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            movePlatformSprite.scale = NON_RETINA_SCALE;
        }
        [self addChild:movePlatformSprite z:9];
        
        
        menu2 = [CCMenu menuWithItems: optionMenuItem,aboutMenuItem,  nil];
        [menu2 alignItemsHorizontallyWithPadding:4.0];
        menu2.position=ccp(241,136);
        menu2.visible=NO;
        [layer11 addChild: menu2 z:10];
        
        CCSprite *holeSprite=[CCSprite spriteWithFile:@"bridge_hole.png"];
        holeSprite.position=ccp(973,654);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            holeSprite.scale = NON_RETINA_SCALE;
        }
        [self addChild:holeSprite z:0];
        
        dotSprite=[CCSprite spriteWithFile:@"dotted.png"];
        dotSprite.position=ccp(187,425);
        if (![FTMUtil sharedInstance].isRetinaDisplay) {
            dotSprite.scale = 0.15;
        }else{
            dotSprite.scale = 0.3;
        }
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
    hudLayer.tag = 11;
    [layer11 addChild: hudLayer z:2000];
    [hudLayer updateNoOfCheeseCollected:0 andMaxValue: 5];
}

-(void) addLevelCompleteLayerToTheScene{
    [self levelCompleted :11];
}
-(void)initValue{
    //Cheese Count Important
    DB *db = [DB new];
    motherLevel= 11;//[[db getSettingsFor:@"CurrentLevel"] intValue];
    [db release];
    
    cheeseCount=5;
    
    platformX=200;
    platformY=200;
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
    for(int i=0;i<4;i++){
        iceQubePos[i][0]=10;
        iceQubePos[i][1]=410;
        iceQubeCount[i]=0;
        iceQubePos2[i][0]=10;
        iceQubePos2[i][1]=410;
        iceQubeCount2[i]=0;
        
    }
    iceQubeCount[0]=1;
    iceQubeCount2[0]=1;
    iceSmokingCount=1;
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
    for(int i=0;i<4;i++){
        if(![FTMUtil sharedInstance].isInvincibilityOn && hx-iValue>iceQubePos[i][0]-80 &&hx-iValue<iceQubePos[i][0]-30 &&hy > iceQubePos[i][1]-30 &&hy<iceQubePos[i][1]+20 &&!gameFunc.trappedChe){
            gameFunc.trappedChe=YES;
            mouseTrappedPosValue=iceQubeCount[i];
        }else if(![FTMUtil sharedInstance].isInvincibilityOn && hx-iValue>iceQubePos2[i][0]-70 &&hx-iValue<iceQubePos2[i][0]-20 &&hy > iceQubePos2[i][1]-10 &&hy<iceQubePos2[i][1]+20 &&!gameFunc.trappedChe){
            gameFunc.trappedChe=YES;
            mouseTrappedPosValue=iceQubeCount2[i];
        }
    }
    for(int i=0;i<3;i++){
        if(iceSmokingCount<100){
            int xx=[trigo circlex:1 a:-(iceSmokingCount-310)]+28+(i*8)+([freezeReleaseArr[freezeReleaseArrCount] intValue]*66);
            int yy=[trigo circley:130 a:-(iceSmokingCount-310)]+768;
            
            if(![FTMUtil sharedInstance].isInvincibilityOn && hx-iValue>xx-50 &&hx-iValue<xx+10 &&hy > yy-30 &&hy<yy+20 &&!gameFunc.trappedChe){
                gameFunc.trappedChe=YES;
            }
        }
    }
    
}

-(void)iceQubeAnimation{
    
    //Left Ice Cube
    for(int i=0;i<4;i++){
        if(iceQubeCount[i]!=0){
            
            if(iceQubeCount[i]<244){
                if (iceQubeCount[i] == 21) {
                    [soundEffect ice_cubes_appear];
                }
                iceQubeCount[i]+=2.0;
                iceQubePos[i][0]=[trigo circlex:iceQubeCount[i] a:270]+440;
                iceQubePos[i][1]=[trigo circley:iceQubeCount[i] a:270]+483;
            }else{
                if (iceQubeCount[i] == 35) {
                    [soundEffect ice_cubes_appear];
                }
                iceQubeCount[i]+=1.0;
                iceQubePos[i][0]=[trigo circlex:iceQubeCount[i] a:359]+144;
                iceQubePos[i][1]=[trigo circley:iceQubeCount[i] a:359]+178;
            }
        }
        if(iceQubeCount[1]==0&&iceQubeCount[0]>=50){
//            if (i ==0) {
//                [soundEffect ice_cubes_appear];
//            }
            iceQubeCount[1]=1;
        }else if(iceQubeCount[2]==0&&iceQubeCount[1]>=50){
            iceQubeCount[2]=1;
        }else if(iceQubeCount[3]==0&&iceQubeCount[2]>=50){
            iceQubeCount[3]=1;
        }
        if(iceQubeCount[i]>=244&&iceQubeCount[i]<246){
            [soundEffect ice_cubes_fall];
            iceBlastAnimationCount=1;
            iceBlastAtlas.position=ccp(iceQubePos[i][0]-90,iceQubePos[i][1]-14);
        }
        if(iceQubeCount[i]>=400&&iceQubeCount[i]<=403){
//            if (i == 2) {
//                [soundEffect ice_cubes_fall];
//            }
            
            iceBlastAnimationCount=1;
            iceBlastAtlas.position=ccp(iceQubePos[i][0]-95,iceQubePos[i][1]-10);
            iceQubeSprite[i].rotation=arc4random() % 360 + 1;
            iceQubeCount[i]=405;
        }else if(iceQubeCount[i]>=405){
            iceQubeCount[i]+=1;
            iceQubePos[i][0]=-200;
            iceQubePos[i][1]=100;
            if(iceQubeCount[i]>=800)
                iceQubeCount[i]=1;
        }
        
        iceQubeSprite[i].position=ccp(iceQubePos[i][0]-35,iceQubePos[i][1]);
    }
    
    
    //Right Ice Cube
    for(int i=0;i<4;i++){
        if(iceQubeCount2[i]!=0){
            
            if(iceQubeCount2[i]<160){
                if (iceQubeCount[i] > 2 && iceQubeCount[i] < 5) {
                    [soundEffect ice_cubes_appear];
                }

                iceQubeCount2[i]+=2.0;
                iceQubePos2[i][0]=[trigo circlex:iceQubeCount2[i] a:270]+980;
                iceQubePos2[i][1]=[trigo circley:iceQubeCount2[i] a:270]+383;
            }else{
                iceQubeCount2[i]+=1.0;
                iceQubePos2[i][0]=[trigo circlex:iceQubeCount2[i] a:180]+1180;
                iceQubePos2[i][1]=[trigo circley:iceQubeCount2[i] a:180]+188;
            }
        }
        if(iceQubeCount2[1]==0&&iceQubeCount2[0]>=50){
//            if (i == 3) {
//                [soundEffect ice_cubes_appear];
//            }
            iceQubeCount2[1]=1;
        }else if(iceQubeCount2[2]==0&&iceQubeCount2[1]>=50){
            iceQubeCount2[2]=1;
        }else if(iceQubeCount2[3]==0&&iceQubeCount2[2]>=50){
            iceQubeCount2[3]=1;
        }
        if(iceQubeCount2[i]>=160&&iceQubeCount2[i]<162){
            [soundEffect ice_cubes_fall];
            iceBlastAnimationCount2=1;
            iceBlastAtlas2.position=ccp(iceQubePos2[i][0]-90,iceQubePos2[i][1]-8);
        }
        if(iceQubeCount2[i]>=410&&iceQubeCount2[i]<415){
            iceBlastAnimationCount2=1;
            iceBlastAtlas2.position=ccp(iceQubePos2[i][0]-75,iceQubePos2[i][1]-10);
            iceQubeCount2[i]=415;
            iceQubeSprite2[i].rotation=arc4random() % 360 + 1;
        }else if(iceQubeCount2[i]>=415){
            iceQubeCount2[i]+=1;
            iceQubePos2[i][0]=-200;
            iceQubePos2[i][1]=100;
            if(iceQubeCount2[i]>=800)
                iceQubeCount2[i]=1;
        }
        iceQubeSprite2[i].position=ccp(iceQubePos2[i][0]-35,iceQubePos2[i][1]);
    }
    
    if(iceBlastAnimationCount>=1){
        iceBlastAnimationCount+=3;
        if(iceBlastAnimationCount>=90){
            iceBlastAnimationCount=90;
            iceBlastAtlas.position=ccp(-200,100);
        }
        [iceBlastAtlas setString:[NSString stringWithFormat:@"%d",iceBlastAnimationCount/10]];
    }
    if(iceBlastAnimationCount2>=1){
        iceBlastAnimationCount2+=3;
        if(iceBlastAnimationCount2>=90){
            iceBlastAnimationCount2=90;
            iceBlastAtlas2.position=ccp(-200,100);
        }
        [iceBlastAtlas2 setString:[NSString stringWithFormat:@"%d",iceBlastAnimationCount2/10]];
    }
    
    //Smoking
    for(int i=0;i<3;i++){
        if(iceSmokingCount!=0){
            int xx=0;
            int yy=0;
            
            //printf("%f \n",-(iceSmokingCount[i][j]-230));
            if(iceSmokingCount<100){
                xx=[trigo circlex:1 a:-(iceSmokingCount-310)]+28+(i*8)+([freezeReleaseArr[freezeReleaseArrCount] intValue]*66);
                yy=[trigo circley:130 a:-(iceSmokingCount-310)]+768;
                
                iceSmokingSprite[i].position=ccp(xx,yy);
                iceSmokingSprite[i].scale=(iceSmokingCount/40.0)+0.1;
                iceSmokingSprite[i].opacity=(250-(iceSmokingCount*2.5));
            }
        }
    }
    iceSmokingCount+=2.0;
    if(iceSmokingCount>=100&&iceSmokingCount<=104){
        freezeReleaseArrCount+=1;
        if(freezeReleaseArrCount>=12)
            freezeReleaseArrCount=0;
        iceSmokingCount=105;
    }else if(iceSmokingCount>=((freezeReleaseArrCount+1)%4 ==1?270:140)){
        iceSmokingCount=0;
    }
}

-(void)switchFunc{
    if(screenMoveChe&&gameFunc.switchCount==1)
        gameFunc.switchCount=0;
    if(gameFunc.moveCount2!=0||gameFunc.switchHitValue!=0){
        if ([[switchAtlas string] isEqualToString:@"0"]){
            [soundEffect switchSound];
        }
        [switchAtlas setString:@"1"];
    }
    
    if(gameFunc.switchHitValue>=2){
        gameFunc.switchHitValue+=1;
        if(gameFunc.switchHitValue>=70)
            gameFunc.switchHitValue=70;
    }
    
    if(screenMoveChe){
        if(screenMovementFindValue==0){
            screenShowY+=4;
            if(screenShowY>500)
                screenMovementFindValue=1;
        }else if(screenMovementFindValue==1){
            screenShowX+=1.8;
            if(gameFunc.moveCount2>=218)
                screenMovementFindValue=2;
        }else if(screenMovementFindValue == 2){
            screenShowX-=10;
            if(screenShowX<screenShowX2){
                screenShowX = screenShowX2;
                screenMovementFindValue=4;
            }
        }else if(screenMovementFindValue==4){
            screenShowY-=5;
            if(screenShowY<screenShowY2){
                screenShowY=screenShowY2;
                screenMoveChe=NO;
                gameFunc.switchCount=1;
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
    
    movePlatformSprite.position=ccp(320+gameFunc.moveCount2,512);
    
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
    
    int fValue=(!forwardChe?0:30);
    if(heroSprite.position.x>=920+fValue&&heroSprite.position.y>=500 && heroSprite.position.y<600 &&!mouseWinChe){
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
                
            }else if(motherLevel == 6 && i ==2){
                if(!gameFunc.moveSideChe){
                    mValue2=gameFunc.moveCount2;
                }else{
                    mValue=gameFunc.moveCount3;
                    mValue=-mValue;
                }
            }else if(motherLevel == 7 && i ==3){
                mValue2=gameFunc.moveCount2;
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

-(void)heroTrappedFunc{
    if(heroTrappedChe){
        heroTrappedCount+=1;
        if(heroTrappedCount==10){
            mouseDragSprite.visible=NO;
            for (int i = 0; i < 20; i=i+1)
                heroPimpleSprite[i].position=ccp(-100,100);
            heroTrappedSprite = [CCSprite spriteWithFile:@"mm_mist_0.png"];
            
            int fValue=(forwardChe?heroForwardX:0);
            if(heroSprite.position.y<570){
                if(heroSprite.position.x<650){
                    if(mouseTrappedPosValue<240)
                        heroTrappedMove=1;
                    else{
                        heroTrappedSprite.position = ccp(heroSprite.position.x-fValue+30, 200);
                    }
                }else{
                    if(mouseTrappedPosValue<160)
                        heroTrappedMove=1;
                    else
                        heroTrappedSprite.position = ccp(heroSprite.position.x-fValue+30, 200);
                    
                }
            }else{
                heroTrappedSprite.position = ccp(heroSprite.position.x-fValue+30, 620);
            }
            
            int posY = heroSprite.position.y;
            if (posY < 215) {
                posY = 215;
            }
            heroTrappedSprite.position = ccp(heroSprite.position.x-fValue, posY);
            heroTrappedSprite.scale=0.5;
            [self addChild:heroTrappedSprite z:1000];
            CCMoveTo *move = [CCMoveTo actionWithDuration:1 position:ccp(heroSprite.position.x-fValue, 215)];
            [heroTrappedSprite runAction:move];
            heroSprite.visible=NO;
        }
        if(heroTrappedMove!=0){
            heroTrappedMove+=5;
            int fValue=(forwardChe?heroForwardX:0);
            CGPoint copyHeroPosition = ccp(heroSprite.position.x-fValue, heroSprite.position.y-heroTrappedMove);
            [self setViewpointCenter:copyHeroPosition];
            if(heroSprite.position.y-heroTrappedMove<=215)
                heroTrappedMove=0;
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
                gameFunc.movePlatformX+=(gameFunc.moveCount<=220?2.8:3.4);
                platformX=gameFunc.movePlatformX-gameFunc.landMoveCount+gameFunc.moveCount2;
                [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
                platformX=gameFunc.xPosition;
            }else{
                gameFunc.movePlatformX-=(gameFunc.moveCount<=220?3.4:2.8);
                platformX=gameFunc.movePlatformX-gameFunc.landMoveCount+gameFunc.moveCount2;
                [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
                platformX=gameFunc.xPosition;
            }
        }else{
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
                jumpPower = (gameFunc.autoJumpSpeedValue!=1?5:5);
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
            if(!screenMoveChe&&!safetyJumpChe&&screenMovementFindValue==0&&gameFunc.switchHitValue==1){
                gameFunc.switchHitValue=2;
                screenMoveChe=YES;
                screenShowX=233;
                screenShowY=platformY;
                screenShowX2=233;
                screenShowY2=platformY;
                gameFunc.moveCount2=1;
            }
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
            heroSprite.position=ccp(platformX+2,platformY+3+tValue);
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
}
-(void)clickMenuButton{
    [[CCDirector sharedDirector] replaceScene:[LevelScreen scene]];
}
-(void)clickLevel:(CCMenuItem *)sender {
    if(sender.tag == 1){
        [[CCDirector sharedDirector] replaceScene:[GameEngine11 scene]];
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
