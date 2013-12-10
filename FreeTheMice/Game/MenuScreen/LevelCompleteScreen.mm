
//  Created by Muhammad Kamran on 21/09/13.
//  Copyright Muhammad Kamran 2013. All rights reserved.
//

// Import the interfaces
#import "LevelCompleteScreen.h"



// Needed to obtain the Navigation Controller
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
#import "FTMUtil.h"
#import "FTMConstants.h"

#import "DB.h"
enum {
	kTagParentNode = 1,
};



@implementation LevelCompleteScreen


-(id) init
{
	if( (self=[super init])) {
		
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
        
        ccColor4B color = {0,0,0,128};
        CCLayerColor *colorLayer = [CCLayerColor layerWithColor:color];
        [self addChild:colorLayer z:-1];
        
        soundEffect=[[sound alloc] init];
        [soundEffect stopAllSoundEffects];
        [soundEffect PlayWinMusic];
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
        
		levelCompleteBg = [CCSprite spriteWithFile:@"level_complete_bg.png"];
        levelCompleteBg.position = ccp(240 *scaleFactorX, 160*scaleFactorY);
        [levelCompleteBg setScale:cScale];
        [self addChild: levelCompleteBg z:0];
        
        
        score = [[CCLabelAtlas labelWithString:@"2000" charMapFile:@"numbers.png" itemWidth:15 itemHeight:20 startCharMap:'.'] retain];
        
        if(winSize.width >480 && winSize.height < 1100){
            score.position= ccp((levelCompleteBg.position.x -45) * scaleFactorX , levelCompleteBg.position.y - 17 *scaleFactorY);
        }else{
            score.position= ccp((levelCompleteBg.position.x + 8) * scaleFactorX , levelCompleteBg.position.y - 17 *scaleFactorY);
        }
        score.scale=0.8;
        [self addChild:score z:0];

               
        [self addLevelsBtnMenu];
        [self addRetryBtnMenu];
        [self addNextLevelBtnMenu];
       
        
	}
	return self;
}

-(void) addLevelsBtnMenu{
    
    
    CCMenuItem *levelsMenuItem = [CCMenuItemImage itemWithNormalImage:@"level_select_btn.png" selectedImage:@"level_select_btn_press.png" block:^(id sender) {
        [soundEffect button_1];
        [[CCDirector sharedDirector] replaceScene:[LevelScreen scene]];
    }];
    
    [levelsMenuItem setScale:cScale];
    
    if([FTMUtil sharedInstance].isRetinaDisplay){
        [levelsMenuItem setScale:cScale/2];
        if ([FTMUtil sharedInstance].isIphone5) {
            levelsMenuItem.position = ccp(-5 *scaleFactorX, 11 *scaleFactorY);
        }else{
            levelsMenuItem.position = ccp(-15 *scaleFactorX, 11 *scaleFactorY);
        }
        
    }else{
        levelsMenuItem.position = ccp(-14 *scaleFactorX, 11 *scaleFactorY);
    }
    
    menu = [CCMenu menuWithItems: levelsMenuItem,  nil];
    menu.position = ccp(190 *scaleFactorX, 71 *scaleFactorY);
    [self addChild:menu];
    
}

-(void) addRetryBtnMenu{
    CCMenuItem *retryMenuItem = [CCMenuItemImage itemWithNormalImage:@"retry_btn.png" selectedImage:@"retry_btn_press.png" block:^(id sender) {
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
    CCMenuItem *nextLevelMenuItem = [CCMenuItemImage itemWithNormalImage:@"next_level_btn.png" selectedImage:@"next_level_btn_press.png" block:^(id sender) {
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
        nextLevelMenuItem.position = ccp(103 *scaleFactorX, 11 *scaleFactorY);
    }else{
        nextLevelMenuItem.position = ccp(113 *scaleFactorX, 11 *scaleFactorY);
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
    [score release];
	[super dealloc];
}

-(void) update: (ccTime) dt {
    
}

-(void) playStarImageAnimationAgainstLevel: (int) level{
    // get the appropriate star image id here from the level: use db to get that. for now just 1;
    level = [self getAppropriateStarLevel:level];
    
    CCSprite *starSprite = [CCSprite spriteWithFile:@"no_starBg.png"];
    starSprite.scale = NON_RETINA_SCALE;
    
    starSprite.position = ccp(240 *scaleFactorX, 220 *scaleFactorY);
    [self addChild:starSprite];
    CCSpriteFrameCache *cache = [CCSpriteFrameCache
                                 sharedSpriteFrameCache];
    [cache addSpriteFramesWithFile:@"starAnimation.plist"];
    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"starAnimation.png"];
    [self addChild:spriteSheet z:10];
    for (int i = 0 ; i< level; i++) {
        
        CCSprite *starSprite = [CCSprite spriteWithSpriteFrameName:@"ss_1.png"];
        starSprite.scale = NON_RETINA_SCALE;
        if (i == 0) {
            int x = [FTMUtil sharedInstance].isIphone5 ? 193: 185;
            starSprite.position = ccp(x *scaleFactorX, 218 *scaleFactorY);
        }
        else if (i == 1) {
            int x = [FTMUtil sharedInstance].isIphone5 ? 243: 245;
            starSprite.position = ccp(x *scaleFactorX, 218 *scaleFactorY);
        }
        else{
            int x = [FTMUtil sharedInstance].isIphone5 ? 295: 305;
            starSprite.position = ccp(x *scaleFactorX, 218 *scaleFactorY);
        }
        [spriteSheet addChild:starSprite];
        
        int length = 24;
        
        NSMutableArray *animFrames = [NSMutableArray array];
        for(int i = 1; i <= length; i++) {
            CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"ss_%d.png",i]];
            [animFrames addObject:frame];
        }
        CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.06f];
        [starSprite runAction:[CCSequence actions:[CCDelayTime actionWithDuration:i*0.5],[CCAnimate actionWithAnimation:animation],nil]];
        
    }
}

-(int) getAppropriateStarLevel:(int) count{
    
    switch (count) {
        case 1:
        case 2:
        case 3:
            return 1;
        case 4:
            return 2;
        case 5:
            return 3;
        default:
            return 1;
    }
}
@end
