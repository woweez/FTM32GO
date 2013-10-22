
//  Created by Muhammad Kamran on 19/09/13.
//  Copyright Muhammad Kamran 2013. All rights reserved.
//


#import "HudLayer.h"
#import "AppDelegate.h"
#import "LevelScreen.h"
#import "MenuScreen.h"
#import "GameEngine01.h"
#import "GameEngine02.h"
#import "GameEngine03.h"
#import "GameEngine04.h"
#import "GameEngine05.h"
#import "GameEngine06.h"
#import "GameEngine07.h"
#import "GameEngine08.h"
#import "GameEngine09.h"
#import "GameEngine10.h"
#import "GameEngine11.h"
#import "GameEngine12.h"
#import "GameEngine13.h"
#import "GameEngine14.h"
#import "StrongMouseEngine01.h"
#import "StrongMouseEngine02.h"
#import "StrongMouseEngine03.h"
#import "StrongMouseEngine04.h"
#import "StrongMouseEngine05.h"
#import "StrongMouseEngine06.h"
#import "StrongMouseEngine07.h"
#import "StrongMouseEngine08.h"
#import "StrongMouseEngine09.h"
#import "StrongMouseEngine10.h"
#import "StrongMouseEngine11.h"
#import "StrongMouseEngine12.h"
#import "StrongMouseEngine13.h"
#import "StrongMouseEngine14.h"
#import "GirlMouseEngine01.h"
#import "GirlMouseEngine02.h"
#import "GirlMouseEngine03.h"
#import "GirlMouseEngine04.h"
#import "GirlMouseEngine05.h"
#import "GirlMouseEngine06.h"
#import "GirlMouseEngine07.h"
#import "GirlMouseEngine08.h"
#import "GirlMouseEngine09.h"
#import "GirlMouseEngine10.h"
#import "GirlMouseEngine11.h"
#import "GirlMouseEngine12.h"
#import "GirlMouseEngine13.h"
#import "GirlMouseEngine14.h"
#import "FTMUtil.h"
#import "FTMConstants.h"
#import "DB.h"
#import "SimpleAudioEngine.h"

@implementation HudLayer


-(id) init
{
	if( (self=[super init])) {
		
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
        
        soundEffect=[[sound alloc] init];
        CGSize winSize = [CCDirector sharedDirector].winSize;
        scaleFactorX = winSize.width/480;
        scaleFactorY = winSize.height/320;
        
        if (RETINADISPLAY == 2) {
            xScale = 1 * scaleFactorX;
            yScale = 1 * scaleFactorY;
            cScale = 1;
        }else{
            xScale = 0.5 * scaleFactorX;
            yScale = 0.5 * scaleFactorY;
            cScale = 0.5;
        }
        
        
		timerBg = [CCSprite spriteWithFile:@"empty_meter.png"];
        timerBg.position = ccp(240 *scaleFactorX, 298*scaleFactorY);
        [timerBg setScale:cScale];
        [self addChild: timerBg z:0];
        
        timer = [CCSprite spriteWithFile:@"color_meter.png"];
        [timer setScale:cScale];
        if (RETINADISPLAY == 2) {
            timer.position = ccp(timerBg.position.x - timerBg.contentSize.width/4 - 47*scaleFactorX, 306*scaleFactorY);
        }else{
            timer.position = ccp(timerBg.position.x - timerBg.contentSize.width/4 + 7*scaleFactorX, 306*scaleFactorY);
        }
        [timer setAnchorPoint:ccp(0, 1)];
        [self addChild: timer z:0];
        
        cheezeCollectedBg = [CCSprite spriteWithFile:@"cheese_collected.png"];
        [cheezeCollectedBg setScale:cScale];
        cheezeCollectedBg.position = ccp(405 *scaleFactorX , 298 *scaleFactorY);
        [self addChild: cheezeCollectedBg z:0];
        
        noOfCollectedCheese = [[CCLabelAtlas labelWithString:@"0/5" charMapFile:@"numbers.png" itemWidth:15 itemHeight:20 startCharMap:'.'] retain];
        noOfCollectedCheese.position= ccp(cheezeCollectedBg.position.x - 9* scaleFactorX, cheezeCollectedBg.position.y - 6 *scaleFactorY);
        noOfCollectedCheese.scale=0.8;
        [self addChild:noOfCollectedCheese z:0];
        
        remainingTime = [[CCLabelAtlas labelWithString:@"1.60" charMapFile:@"numbers.png" itemWidth:15 itemHeight:20 startCharMap:'.'] retain];
        remainingTime.position= ccp(timerBg.position.x, timerBg.position.y - 6 *scaleFactorY);
        remainingTime.scale=0.8;
        [self addChild:remainingTime z:0];
               
        [self addPauseBtnMenu];
        [self addRetryBtnMenu];
        [self addInventoryBtnMenu];
        [self addMagnifyingBtnMenu];
        [self addMoveLeftBtnMenu];
        [self addMoveRightBtnMenu];
        [self addPauseScreen];
        
	}
	return self;
}

-(void) updateNoOfCheeseCollected:(int)currentValue andMaxValue:(int)maxValue{
    if (currentValue > 0) {
        totalCheeseCollected++;
    }
    switch (currentValue) {
        case 1:
            [soundEffect cheese_1];
            break;
        case 2:
            [soundEffect cheese_2];
            break;
        case 3:
            [soundEffect cheese_3];
            break;
        case 4:
            [soundEffect cheese_3];
            break;
        case 5:
            [soundEffect cheese_all];
            break;
        default:
            break;
    }
    [noOfCollectedCheese setString:[NSString stringWithFormat:@"%d/%d",currentValue,maxValue]];
}

-(int) getTotalNoOffCheeseCollected{
    return totalCheeseCollected;
}
-(void) updateTimeRemaining:(int)minuts andTimeInSec:(int)seconds{
    float time = minuts * 60 + seconds;
    float totalTime = 120;
    [timer setScaleX:(time/totalTime) * cScale];
    [remainingTime setString:[NSString stringWithFormat:@"0%d.%d",minuts,seconds]];
}

-(void) addPauseBtnMenu{
    
    CCMenuItem *pauseMenuItem = [CCMenuItemImage itemWithNormalImage:@"pause_btn.png" selectedImage:@"pause_btn_press.png" block:^(id sender) {
        [soundEffect button_1];
        if ([FTMUtil sharedInstance].isFirstTutorial || [FTMUtil sharedInstance].isSecondTutorial) {
            return;
        }
        [self showPausingAnimation];
        [[SimpleAudioEngine sharedEngine] setMute:YES];
        
    }];
    [pauseMenuItem setScale:cScale];
    pauseMenuItem.position = ccp(-220 *scaleFactorX, 138 *scaleFactorY);
    menu = [CCMenu menuWithItems: pauseMenuItem,  nil];
    menu.position = ccp(240 *scaleFactorX, 160 *scaleFactorY);
    [self addChild:menu];
}

-(void) addRetryBtnMenu{
    CCMenuItem *retryMenuItem = [CCMenuItemImage itemWithNormalImage:@"retry_btn.png" selectedImage:@"retry_btn_press.png" block:^(id sender) {
        [soundEffect button_1];
        if ([FTMUtil sharedInstance].isFirstTutorial || [FTMUtil sharedInstance].isSecondTutorial) {
            return;
        }
//        [FTMUtil sharedInstance].isBoostPowerUpEnabled = NO;
//        [FTMUtil sharedInstance].isFirstTutorial = YES;
        [self addLevelSceneAgainForRetry];
    }];
    [retryMenuItem setScale:cScale];
    retryMenuItem.position = ccp(-185 *scaleFactorX, 138 *scaleFactorY);
    [menu addChild:retryMenuItem];
}

-(void) addLevelSceneAgainForRetry{
    int selectedMouse = [FTMUtil sharedInstance].mouseClicked;
    switch (selectedMouse) {
        case FTM_MAMA_MICE_ID:
            [self addMotherMouseToSceneWithLvl:self.tag];
            break;
        case FTM_STRONG_MICE_ID:
            [self addStrongMouseToSceneWithLvl:self.tag];
            break;
        case FTM_GIRL_MICE_ID:
            [self addGirlMouseToSceneWithLvl:self.tag];
            break;
        default:
            break;
    }
}
-(void) addInventoryBtnMenu{
    CCMenuItem *inventoryMenuItem = [CCMenuItemImage itemWithNormalImage:@"inventory_btn.png" selectedImage:@"inventory_btn_press.png" block:^(id sender) {
        [soundEffect button_1];
        if ([FTMUtil sharedInstance].isFirstTutorial || [FTMUtil sharedInstance].isSecondTutorial) {
            return;
        }
//        [FTMUtil sharedInstance].isSlowDownTimer = YES;
//        [self hideFailureScreen];
    }];
    [inventoryMenuItem setScale:cScale];
    inventoryMenuItem.position = ccp(-150 *scaleFactorX, 138 *scaleFactorY);
    [menu addChild:inventoryMenuItem];

}
+(void) setParentReference : (CCLayer *) parent{
    self.parentReference = parent;
}


-(void) addMagnifyingBtnMenu{
    CCMenuItem *magnifyMenuItem = [CCMenuItemImage itemWithNormalImage:@"zoom_btn.png" selectedImage:@"zoom_btn_press.png" block:^(id sender) {
        [soundEffect button_1];
        if ([FTMUtil sharedInstance].isFirstTutorial || [FTMUtil sharedInstance].isSecondTutorial) {
            return;
        }
//        [FTMUtil sharedInstance].isBoostPowerUpEnabled = YES;
    }];
    [magnifyMenuItem setScale:cScale];
    magnifyMenuItem.position = ccp(220 *scaleFactorX, 138 *scaleFactorY);
    [menu addChild:magnifyMenuItem];
}

-(void) addMoveLeftBtnMenu{
    
    leftSprite = [CCSprite spriteWithFile:@"arrow_indicator_left.png"];
    [leftSprite setScale:cScale];
    leftSprite.position = ccp(37 *scaleFactorX , 34 *scaleFactorY);
    [self addChild: leftSprite z:0];
}

-(void) addMoveRightBtnMenu{
    
    rightSprite = [CCSprite spriteWithFile:@"arrow_indicator_right.png"];
    [rightSprite setScale:cScale];
    rightSprite.position = ccp(443 *scaleFactorX , 34 *scaleFactorY);
    [self addChild: rightSprite z:0];
    
//    CCMenuItem *moveRightMenuItem = [CCMenuItemImage itemWithNormalImage:@"arrow_indicator_right.png" selectedImage:@"arrow_indicator_right.png" block:^(id sender) {
//        
//        
//    }];
//    [moveRightMenuItem setScale:cScale];
//    moveRightMenuItem.position = ccp(203 *scaleFactorX, -126 *scaleFactorY);
//    [menu addChild:moveRightMenuItem];
}

-(void) addPauseScreen {
    
    pauseScreenBg = [CCSprite spriteWithFile:@"pause_screen_bg.png"];
    [pauseScreenBg setScaleX:0.0001];
    [pauseScreenBg setScaleY:cScale];
    [pauseScreenBg setAnchorPoint:ccp(0, 1)];
    pauseScreenBg.position = ccp(0 *scaleFactorX , 275 *scaleFactorY);
    pauseScreenBg.tag = 125;
    [self addChild: pauseScreenBg z:0];
    
    CCMenuItem *levelsMenuItem = [CCMenuItemImage itemWithNormalImage:@"level_select_btn.png" selectedImage:@"level_select_btn_press.png" block:^(id sender) {
        [soundEffect button_1];
        [[CCDirector sharedDirector] resume];
        [[SimpleAudioEngine sharedEngine] setMute:NO];
        [[CCDirector sharedDirector] replaceScene:[LevelScreen scene]];
    }];

    levelsMenuItem.position = ccp(0 *scaleFactorX, 10 *scaleFactorY);
    
    soundOn = [CCMenuItemImage itemWithNormalImage:@"sound_on.png" selectedImage:@"sound_off.png" block:^(id sender) {
        [soundEffect button_1];
        
        soundOn.visible = NO;
        soundOn.isEnabled = NO;
        [soundEffect stopPlayingMusic];
        [FTMUtil sharedInstance].isGameSoundOn = NO;
        soundOff.visible = YES;
        soundOff.isEnabled = YES;
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSNumber numberWithInt:1] forKey:@"soundTrigger"];
        [defaults synchronize];
        
    }];
    
    soundOff = [CCMenuItemImage itemWithNormalImage:@"sound_off.png" selectedImage:@"sound_off.png" block:^(id sender) {
        [soundEffect button_1];
        soundOff.visible = NO;
        soundOff.isEnabled = NO;
        [[SimpleAudioEngine sharedEngine] setMute:NO];
        [FTMUtil sharedInstance].isGameSoundOn = YES;
        [soundEffect playGamePlayMusic];
        soundOn.visible = YES;
        soundOn.isEnabled = YES;
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSNumber numberWithInt:0] forKey:@"soundTrigger"];
        [defaults synchronize];
        
    }];
    
    if ([FTMUtil sharedInstance].isGameSoundOn) {
        soundOff.visible = NO;
        soundOff.isEnabled = NO;
    }else{
        soundOn.visible = NO;
        soundOn.isEnabled = NO;
    }
    soundOn.position = ccp(0 *scaleFactorX, 10 *scaleFactorY);
    soundOff.position = ccp(0 *scaleFactorX, 10 *scaleFactorY);
    
    CCMenuItem *homeMenuItem = [CCMenuItemImage itemWithNormalImage:@"home_btn.png" selectedImage:@"home_btn_press.png" block:^(id sender) {
        [soundEffect button_1];
        [soundEffect stopPlayingMusic];
        [[CCDirector sharedDirector] resume];
        [[SimpleAudioEngine sharedEngine] setMute:NO];
        [[CCDirector sharedDirector] replaceScene:[MenuScreen scene]];
    }];

    homeMenuItem.position = ccp(0 *scaleFactorX, 10 *scaleFactorY);
    
    CCMenuItem *resumeMenuItem = [CCMenuItemImage itemWithNormalImage:@"play_btn.png" selectedImage:@"play_btn_press.png" block:^(id sender) {
        [soundEffect button_1];
        [self showPausingAnimation];
        [[SimpleAudioEngine sharedEngine] setMute:NO];
        
    }];
    
    resumeMenuItem.position = ccp(10 *scaleFactorX, 10 *scaleFactorY);
    
    CCMenu *resumeMenu = [CCMenu menuWithItems:resumeMenuItem, nil];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    if (RETINADISPLAY == 2) {
        resumeMenu.position = ccp(56 *scaleFactorX, 107 *scaleFactorY);
    }else{
        if(winSize.width >480 && winSize.height < 1100){
            resumeMenu.position = ccp(123 *scaleFactorX, 223*scaleFactorY);
        }else{
            resumeMenu.position = ccp(146 *scaleFactorX, 223*scaleFactorY);
        }
    }
    [pauseScreenBg addChild: resumeMenu];
    
    CCMenu *pauseMenu = [CCMenu menuWithItems:homeMenuItem,soundOn,levelsMenuItem, nil];
    [pauseMenu alignItemsVerticallyWithPadding:30 * scaleFactorY];
    if (RETINADISPLAY == 2) {
        pauseMenu.position = ccp(30 *scaleFactorX, 110 *scaleFactorY);
    }else{
        pauseMenu.position = ccp(60 *scaleFactorX, 220 *scaleFactorY);
    }
    [pauseScreenBg addChild:pauseMenu];
    
    CCMenu *soundOffMenu = [CCMenu menuWithItems:soundOff, nil];
    [soundOffMenu alignItemsVerticallyWithPadding:30 * scaleFactorY];
    if (RETINADISPLAY == 2) {
        soundOffMenu.position = ccp(30 *scaleFactorX, 110 *scaleFactorY);
    }
    else{
        soundOffMenu.position = ccp(60 *scaleFactorX, 220 *scaleFactorY);
    }
    [pauseScreenBg addChild:soundOffMenu];
    
}

-(void ) showRetryOptionMenu{
    
//    [self hideHudItems];
    CCSprite *optionsBg=[CCSprite spriteWithFile:@"mouse_trapped_background.png"];
    CGSize size = [CCDirector sharedDirector].winSize;
    float scalex = size.width/480;
    float scaley = size.height/320;
    optionsBg.position=ccp(240 *scalex,160*scaley);
    optionsBg.tag = 999;
    [self addChild:optionsBg z:10000];
    
    CCMenuItem *levelsScreen = [CCMenuItemImage itemWithNormalImage:@"main_menu_button_1.png" selectedImage:@"main_menu_button_2.png" target:self selector:@selector(retryOptionsCallback:)];
    levelsScreen.tag=2;
    
    
    CCMenuItem *retryLevel = [CCMenuItemImage itemWithNormalImage:@"try_again_button_1.png" selectedImage:@"try_again_button_2.png" target:self selector:@selector(retryOptionsCallback:)];
    retryLevel.tag=1;
    
    CCMenu *optionsMenu = [CCMenu menuWithItems: retryLevel,levelsScreen,  nil];
    [optionsMenu alignItemsHorizontallyWithPadding:4.0];
    optionsMenu.position=ccp(241 *scalex,136*scaley);
    optionsMenu.tag = 998;
    [self addChild: optionsMenu z:10000];
}

-(void) hideFailureScreen{
    [self getChildByTag:999].visible = NO;
    [self getChildByTag:998].visible = NO;
}
-(void) showPausingAnimation{
    
    if(pauseScreenBg.tag ==125){
        [self hideHudItems];
        CCScaleTo *scaleAction = [CCScaleTo actionWithDuration:0.03 scaleX:cScale scaleY:cScale];
        CCCallFunc *pauseCall = [CCCallFunc actionWithTarget:self selector:@selector (pauseCallback)];
        CCSequence *pauseSequence = [CCSequence actions:scaleAction,pauseCall, nil];
        
        [pauseScreenBg runAction:pauseSequence];
        [pauseScreenBg setTag:126];
        
    }else if (pauseScreenBg.tag == 126){
        [[CCDirector sharedDirector] resume];
        CCScaleTo *scaleAction = [CCScaleTo actionWithDuration:0.03 scaleX:0.0001 scaleY:cScale];
        [pauseScreenBg runAction:scaleAction];
        [self showHudItems];
        [pauseScreenBg setTag:125];
    }
}
-(void) pauseCallback{
    [[CCDirector sharedDirector] pause];
}

-(void) hideHudItems{
    menu.visible = NO;
    timer.visible = NO;
    timerBg.visible = NO;
    cheezeCollectedBg.visible = NO;
    leftSprite.visible = NO;
    rightSprite.visible = NO;
    remainingTime.visible = NO;
    noOfCollectedCheese.visible = NO;
}

-(void) showHudItems{
    menu.visible = YES;
    timer.visible = YES;
    timerBg.visible = YES;
    cheezeCollectedBg.visible = YES;
    leftSprite.visible = YES;
    rightSprite.visible = YES;
    remainingTime.visible = YES;
    noOfCollectedCheese.visible = YES;
}

-(void) update: (ccTime) dt {
    
}

-(void) addMotherMouseToSceneWithLvl: (int) lvl{
    
    switch (lvl) {
        case 1:
            [[CCDirector sharedDirector] replaceScene:[GameEngine01 scene]];
            break;
        case 2:
            [[CCDirector sharedDirector] replaceScene:[GameEngine02 scene]];
            break;
        case 3:
            [[CCDirector sharedDirector] replaceScene:[GameEngine03 scene]];
            break;
        case 4:
            [[CCDirector sharedDirector] replaceScene:[GameEngine04 scene]];
            break;
        case 5:
            [[CCDirector sharedDirector] replaceScene:[GameEngine05 scene]];
            break;
        case 6:
            [[CCDirector sharedDirector] replaceScene:[GameEngine06 scene]];
            break;
        case 7:
            [[CCDirector sharedDirector] replaceScene:[GameEngine07 scene]];
            break;
        case 8:
            [[CCDirector sharedDirector] replaceScene:[GameEngine08 scene]];
            break;
        case 9:
            [[CCDirector sharedDirector] replaceScene:[GameEngine09 scene]];
            break;
        case 10:
            [[CCDirector sharedDirector] replaceScene:[GameEngine10 scene]];
            break;
        case 11:
            [[CCDirector sharedDirector] replaceScene:[GameEngine11 scene]];
            break;
        case 12:
            [[CCDirector sharedDirector] replaceScene:[GameEngine12 scene]];
            break;
        case 13:
            [[CCDirector sharedDirector] replaceScene:[GameEngine13 scene]];
            break;
        case 14:
            [[CCDirector sharedDirector] replaceScene:[GameEngine14 scene]];
            break;
        case 15:
            
            break;
            
        default:
            break;
    }
}
-(void) addStrongMouseToSceneWithLvl: (int) lvl{
    
    switch (lvl) {
        case 1:
            [[CCDirector sharedDirector] replaceScene:[StrongMouseEngine01 scene]];
            break;
        case 2:
            [[CCDirector sharedDirector] replaceScene:[StrongMouseEngine02 scene]];
            break;
        case 3:
            [[CCDirector sharedDirector] replaceScene:[StrongMouseEngine03 scene]];
            break;
        case 4:
            [[CCDirector sharedDirector] replaceScene:[StrongMouseEngine04 scene]];
            break;
        case 5:
            [[CCDirector sharedDirector] replaceScene:[StrongMouseEngine05 scene]];
            break;
        case 6:
            [[CCDirector sharedDirector] replaceScene:[StrongMouseEngine06 scene]];
            break;
        case 7:
            [[CCDirector sharedDirector] replaceScene:[StrongMouseEngine07 scene]];
            break;
        case 8:
            [[CCDirector sharedDirector] replaceScene:[StrongMouseEngine08 scene]];
            break;
        case 9:
            [[CCDirector sharedDirector] replaceScene:[StrongMouseEngine09 scene]];
            break;
        case 10:
            [[CCDirector sharedDirector] replaceScene:[StrongMouseEngine10 scene]];
            break;
        case 11:
            [[CCDirector sharedDirector] replaceScene:[StrongMouseEngine11 scene]];
            break;
        case 12:
            [[CCDirector sharedDirector] replaceScene:[StrongMouseEngine12 scene]];
            break;
        case 13:
            [[CCDirector sharedDirector] replaceScene:[StrongMouseEngine13 scene]];
            break;
        case 14:
            [[CCDirector sharedDirector] replaceScene:[StrongMouseEngine14 scene]];
            break;
        case 15:
            
            break;
            
        default:
            break;
    }
}


-(void) addGirlMouseToSceneWithLvl: (int) lvl{
    
    switch (lvl) {
        case 1:
            [[CCDirector sharedDirector] replaceScene:[GirlMouseEngine01 scene]];
            break;
        case 2:
            [[CCDirector sharedDirector] replaceScene:[GirlMouseEngine02 scene]];
            break;
        case 3:
            [[CCDirector sharedDirector] replaceScene:[GirlMouseEngine03 scene]];
            break;
        case 4:
            [[CCDirector sharedDirector] replaceScene:[GirlMouseEngine04 scene]];
            break;
        case 5:
            [[CCDirector sharedDirector] replaceScene:[GirlMouseEngine05 scene]];
            break;
        case 6:
            [[CCDirector sharedDirector] replaceScene:[GirlMouseEngine06 scene]];
            break;
        case 7:
            [[CCDirector sharedDirector] replaceScene:[GirlMouseEngine07 scene]];
            break;
        case 8:
            [[CCDirector sharedDirector] replaceScene:[GirlMouseEngine08 scene]];
            break;
        case 9:
            [[CCDirector sharedDirector] replaceScene:[GirlMouseEngine09 scene]];
            break;
        case 10:
            [[CCDirector sharedDirector] replaceScene:[GirlMouseEngine10 scene]];
            break;
        case 11:
            [[CCDirector sharedDirector] replaceScene:[GirlMouseEngine11 scene]];
            break;
        case 12:
            [[CCDirector sharedDirector] replaceScene:[GirlMouseEngine12 scene]];
            break;
        case 13:
            [[CCDirector sharedDirector] replaceScene:[GirlMouseEngine13 scene]];
            break;
        case 14:
            [[CCDirector sharedDirector] replaceScene:[GirlMouseEngine14 scene]];
            break;
        case 15:
            
            break;
            
        default:
            break;
    }
}


-(void)clickMouse:(CCMenuItem *)sender {
    [soundEffect button_1];
    DB *db = [DB new];
    [db setSettingsFor:@"CurrentMouse" withValue:[NSString stringWithFormat:@"%d",sender.tag]];
    [db release];
}

-(CCSprite *) getAppropriateStarImageAgainstLevel: (int) level{
   // get the appropriate star image id here from the level: use db to get that. for now just 1;
    CCSprite *starImage = [CCSprite spriteWithFile:[NSString stringWithFormat:@"stars_%d.png",level]];
    starImage.position = ccp(45, 18);
    
    return starImage;
}
-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		location = [[CCDirector sharedDirector] convertToGL: location];
	}
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		location = [[CCDirector sharedDirector] convertToGL: location];
        
	}
    
}

-(void)retryOptionsCallback:(CCMenuItem *)sender {
    [soundEffect button_1];
    if(sender.tag == 1){
        [self addLevelSceneAgainForRetry];
    }else if(sender.tag ==2){
        [soundEffect stopPlayingMusic];
        [[CCDirector sharedDirector] replaceScene:[LevelScreen scene]];
    }
}

-(void) dealloc {
    [remainingTime release];
    [noOfCollectedCheese release];
	[super dealloc];
}
@end
