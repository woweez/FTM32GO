//
//  LevelFailedScreen.m
//  FreeTheMice
//
//  Created by Muhammad Kamran on 26/10/2013.
//
//

#import "LevelFailedScreen.h"
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
#import "BossCatLevel15A.h"
#import "BossCatLevel15B.h"
#import "BossCatLevel15C.h"
#import "DB.h"
#import "FTMConstants.h"
#import "sound.h"
#import "LevelScreen.h"
#import "FTMUtil.h"


@implementation LevelFailedScreen

- (id)init
{
    self = [super init];
    if (self) {
        self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
        ccColor4B color = {0,0,0,128};
        CCLayerColor *colorLayer = [CCLayerColor layerWithColor:color];
        [self addChild:colorLayer z:-1];
        
        soundEffect=[[sound alloc] init];
        [soundEffect stopAllSoundEffects];
        [soundEffect playLoseMusic];
        CGSize winSize = [CCDirector sharedDirector].winSize;
        scaleFactorX = winSize.width/480;
        scaleFactorY = winSize.height/320;
        
        if ([FTMUtil sharedInstance].isRetinaDisplay) {
            xScale = 1 * scaleFactorX;
            yScale = 1 * scaleFactorY;
            cScale = 1;
        }else{
            xScale = 0.5 * scaleFactorX;
            yScale = 0.5 * scaleFactorY;
            cScale = 0.5;
        }
        
        
		CCSprite *levelFailedBg = [CCSprite spriteWithFile:@"level_fail_bg.png"];
        levelFailedBg.position = ccp(240 *scaleFactorX, 160*scaleFactorY);
        [levelFailedBg setScale:cScale];
        [self addChild: levelFailedBg z:0];
        
        [self addLevelsBtnMenu];
        [self addRetryBtnMenu];
        [self addNextLevelBtnMenu];
        
    }
    return self;
}

-(void) setIfNextBtnDisable:(int) tag{
    DB *db = [DB new];
    int currentLvl = [[db getSettingsFor:@"mamaCurrLvl"] intValue];
    if(currentLvl <= tag){
        [nextLevelMenuItem setIsEnabled:NO];
    }
    [db release];
}

-(void) addLevelsBtnMenu{
    
    
    CCMenuItem *levelsMenuItem = [CCMenuItemImage itemWithNormalImage:@"level_select_btn.png" selectedImage:@"level_select_btn_press.png" block:^(id sender) {
        [soundEffect button_1];
        [[CCDirector sharedDirector] replaceScene:[LevelScreen scene]];
    }];
    [levelsMenuItem setScale:cScale];

    if([FTMUtil sharedInstance].isRetinaDisplay && [FTMUtil sharedInstance].isIphone5){
        levelsMenuItem.position = ccp(-4 *scaleFactorX, 12 *scaleFactorY);
    }else{
        levelsMenuItem.position = ccp(-14 *scaleFactorX, 11 *scaleFactorY);
    }
    
    menu = [CCMenu menuWithItems: levelsMenuItem,  nil];
    menu.position = ccp(190 *scaleFactorX, 71 *scaleFactorY);
    [self addChild:menu];
    
}

-(void) addRetryBtnMenu{
    CCMenuItem *retryMenuItem = [CCMenuItemImage itemWithNormalImage:@"retrybtn.png" selectedImage:@"retry_btnpress.png" block:^(id sender) {
        [soundEffect button_1];
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
    }];
    [retryMenuItem setScale:cScale];
    retryMenuItem.position = ccp(53 *scaleFactorX, 11 *scaleFactorY);
    [menu addChild:retryMenuItem];
}


-(void) addNextLevelBtnMenu{
    nextLevelMenuItem = [CCMenuItemImage itemWithNormalImage:@"skip_level_btn.png" selectedImage:@"skip_level_btnpress.png" disabledImage:@"skip_level_btn_disable.png" block:^(id sender) {
        [soundEffect button_1];
        int nextLevelTag = self.tag +1;
        int selectedMouse = [FTMUtil sharedInstance].mouseClicked;
        switch (selectedMouse) {
            case FTM_MAMA_MICE_ID:
                [self addMotherMouseToSceneWithLvl:nextLevelTag];
                break;
            case FTM_STRONG_MICE_ID:
                [self addStrongMouseToSceneWithLvl:nextLevelTag];
                break;
            case FTM_GIRL_MICE_ID:
                [self addGirlMouseToSceneWithLvl:nextLevelTag];
                break;
            default:
                break;
        }
    }];
    [nextLevelMenuItem setScale:cScale];

    if([FTMUtil sharedInstance].isRetinaDisplay && [FTMUtil sharedInstance].isIphone5){
        nextLevelMenuItem.position = ccp(105 *scaleFactorX, 10 *scaleFactorY);
    }else{
        nextLevelMenuItem.position = ccp(117 *scaleFactorX, 10 *scaleFactorY);
    }
    [menu addChild:nextLevelMenuItem];
    
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
            [[CCDirector sharedDirector] replaceScene:[BossCatLevel15C scene]];
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
            [[CCDirector sharedDirector] replaceScene:[BossCatLevel15B scene]];
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
            [[CCDirector sharedDirector] replaceScene:[BossCatLevel15A scene]];
            break;
            
        default:
            break;
    }
}


-(void) dealloc {
    [soundEffect stopPlayingMusic];
	[super dealloc];
}


@end
