//
//  HelloWorldLayer.mm
//  Tap
//
//  Created by karthik g on 27/09/12.
//  Copyright karthik g 2012. All rights reserved.
//

// Import the interfaces
#import "MenuScreen.h"
#import "MouseSelectionScreen.h"
#import "OptionsScreen.h"
#import "AboutScreen.h"
#import "LevelScreen.h"
#import "ToolShedScreen.h"
#import "AppDelegate.h"
#import "DB.h"
#import "InAppUtils.h"
#import "FTMUtil.h"
#import "FTMConstants.h"
#import "LevelFailedScreen.h"
#import "LevelCompleteScreen.h"

enum {
	kTagParentNode = 1,
};



@implementation MenuScreen

+(CCScene *) scene {
	
    CCScene *scene = [CCScene node];
	MenuScreen *layer = [MenuScreen node];
	[scene addChild: layer];
	
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
		
        
        DB *db = [DB new];
        int currentMouse=[[db getSettingsFor:@"CurrentMouse"] intValue];
        if(currentMouse == 0){
            [db setSettingsFor:@"CurrentMouse" withValue:[NSString stringWithFormat:@"%d",1]];
            [db setSettingsFor:@"CurrentLevel" withValue:[NSString stringWithFormat:@"%d",1]];
        }
            [db release];
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
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
        
        soundEffect=[[sound alloc] init];
       
        if (![soundEffect isMusicPlaying]) {
            [self schedule:@selector(startMenuMusic) interval:0.1];
        }
		CCSprite *background = [CCSprite spriteWithFile:@"main_menu_bg.png"];
        [background setScaleX:xScale];
        [background setScaleY:yScale];
        background.position = ccp(240 *scaleFactorX, 160 *scaleFactorY);
        [self addChild: background z:0];
        
        CCFadeTo *fadeInAction = [CCFadeTo actionWithDuration:1 opacity:255.0];
        CCFadeTo *fadeoutAction = [CCFadeTo actionWithDuration:1 opacity:180.0];
        CCSequence *fadingSequence = [CCSequence actions:fadeInAction,fadeoutAction, nil];
        [background runAction:[CCRepeatForever actionWithAction:fadingSequence]];
        
        CCMenuItem *playMenuItem = [CCMenuItemImage itemWithNormalImage:@"play.png" selectedImage:@"play_press.png" block:^(id sender) {
            [soundEffect button_1];
            [[CCDirector sharedDirector] replaceScene:[MouseSelectionScreen scene]];
		}];
        [playMenuItem setScale:cScale];
        
        CCMenu *playBtnMenu = [CCMenu menuWithItems:playMenuItem, nil];
        playBtnMenu.position = ccp(240*scaleFactorX, 26 *scaleFactorY);
        [self addChild:playBtnMenu];
        
        CCMenuItem *optionMenuItem = [CCMenuItemImage itemWithNormalImage:@"setting.png" selectedImage:@"setting_press.png" block:^(id sender) {
//            [[CCDirector sharedDirector] replaceScene:[OptionsScreen scene]];
            [soundEffect button_1];
            [self addSettingsSlidingAnimation];
		}];
        [optionMenuItem setScale:cScale];
        
        CCMenu *optionBtnMenu = [CCMenu menuWithItems:optionMenuItem, nil];
        optionBtnMenu.position = ccp(25 *scaleFactorX, 26*scaleFactorY);
        [self addChild:optionBtnMenu z:10];
        
        CCMenuItem *aboutMenuItem = [CCMenuItemImage itemWithNormalImage:@"arrow.png" selectedImage:@"arrow_press.png" block:^(id sender) {
            [soundEffect button_1];
            [self addAboutSlidingAnimation];
            // DB *db = [DB new];
//            [db setSettingsFor:@"About" withValue:[NSString stringWithFormat:@"%d",1]];
//            [db release];
//            [[CCDirector sharedDirector] replaceScene:[AboutScreen scene]];
		}];
        [aboutMenuItem setScale:cScale];
                
        CCMenu *aboutBtnMenu = [CCMenu menuWithItems:aboutMenuItem, nil];
        aboutBtnMenu.position = ccp(455*scaleFactorX, 26*scaleFactorY);
        [self addChild:aboutBtnMenu z:10];
        
        if ([FTMUtil sharedInstance].isRetinaDisplay || scaleFactorX > 1) {
            [aboutMenuItem setScale:cScale *scaleFactorX];
            [optionMenuItem setScale:cScale *scaleFactorX];
            aboutBtnMenu.position = ccp(455*scaleFactorX, 28*scaleFactorY);
            optionBtnMenu.position = ccp(25 *scaleFactorX, 28*scaleFactorY);
        }

        
        CCMenuItem *storeMenuItem = [CCMenuItemImage itemWithNormalImage:@"store.png" selectedImage:@"store_press.png" block:^(id sender) {
            [soundEffect button_1];
            //add functionality here.
            if ([[InAppUtils sharedInstance]._products count] == 0) {
                [[InAppUtils sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
                    if (success) {
                        [InAppUtils sharedInstance]._products = products;
                        
                        NSLog(@"No of products retrived successfully: %d", [InAppUtils sharedInstance]._products.count);
                    }
                }];
            }
            [[CCDirector sharedDirector] replaceScene:[ToolShedScreen scene]];
            
		}];
        [storeMenuItem setScale:cScale];
        if ([FTMUtil sharedInstance].isRetinaDisplay || scaleFactorX > 1) {
            [storeMenuItem setScale:cScale *scaleFactorX];
        }
        CCMenu *storeBtnMenu = [CCMenu menuWithItems:storeMenuItem, nil];
        storeBtnMenu.position = ccp(25 *scaleFactorX, 300 *scaleFactorY);
        [self addChild:storeBtnMenu z:10];
        
        CCMenuItem *gameCenterMenuItem = [CCMenuItemImage itemWithNormalImage:@"game_center.png" selectedImage:@"game_center_press.png" block:^(id sender) {
            //add functionality here.
            [soundEffect button_1];
            [[InAppUtils sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
                if (success) {
                    [InAppUtils sharedInstance]._products = products;
                    
                    NSLog(@"No of products retrived successfully: %d", [InAppUtils sharedInstance]._products.count);
                }
            }];
		}];
        [gameCenterMenuItem setScale:cScale];
        if ([FTMUtil sharedInstance].isRetinaDisplay || scaleFactorX > 1) {
            [gameCenterMenuItem setScale:cScale *scaleFactorX];
        }
        CCMenu *gameCenterBtnMenu = [CCMenu menuWithItems:gameCenterMenuItem, nil];
        gameCenterBtnMenu.position = ccp(455*scaleFactorX, 300*scaleFactorY);
        [self addChild:gameCenterBtnMenu z:10];
        
        [self addCatRunningAnimation];
        [self addFireFlamesAnimation];
        [self addWaterAnimation];
        [self addPimppleMouseEyesAnimation];
        [self addStrongMouseEyesAnimation];
        [self addMammaMouseEyesAnimation];
        [self addGilMouseEyesAnimation];
        [self addAboutSelectionMenu];
        [self addSettingsSelectionMenu];
//
//        LevelCompleteScreen *lvlCompleteLayer = [[LevelCompleteScreen alloc] init];
//        [lvlCompleteLayer playStarImageAnimationAgainstLevel:12];
//        lvlCompleteLayer.tag = 12;
//        [self addChild: lvlCompleteLayer z:2000];
	}
	return self;
}

-(void) addCatRunningAnimation{
    CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [cache addSpriteFramesWithFile:@"cat_shadow_animation.plist"];
    CCSpriteBatchNode *catRunningSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"cat_shadow_animation.png"];
    [self addChild:catRunningSpriteSheet z:0];
    
    CCSprite *catRunSprite = [CCSprite spriteWithSpriteFrameName:@"bosscat_shadow_0.png"];
    catRunSprite.position = ccp(380, 130);
    catRunSprite.scale=cScale;
    catRunSprite.flipX = 1;
    [catRunningSpriteSheet addChild:catRunSprite z:0];
    
    NSMutableArray *animFrames = [NSMutableArray array];
    for(int i = 0; i <= 30; i++) {
        CCSpriteFrame *frame4 = [cache spriteFrameByName:[NSString stringWithFormat:@"bosscat_shadow_%d.png",i]];
        [animFrames addObject:frame4];
    }
    
    CCCallFuncN *leftMovementCallback = [CCCallFuncN actionWithTarget:self selector:@selector(leftMovementCompleteCallback:)];
    CCCallFuncN *rightMovementCallback = [CCCallFuncN actionWithTarget:self selector:@selector(rightMovementCompleteCallback:)];
    
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.03f];
    CCMoveTo *moveLeft = [CCMoveTo actionWithDuration:7 position:ccp(100, 130)];
    CCMoveTo *moveRight = [CCMoveTo actionWithDuration:7 position:ccp(380, 130)];

    CCSequence *sequence = [CCSequence actions:moveLeft,leftMovementCallback, moveRight,rightMovementCallback, nil];
    [catRunSprite runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];
    [catRunSprite runAction:[CCRepeatForever actionWithAction:sequence]];

}

-(void) leftMovementCompleteCallback:(id)sender{
    CCSprite *mySprite = (CCSprite *)sender;
    mySprite.flipX = 0;
}

-(void) rightMovementCompleteCallback:(id)sender{
    CCSprite *mySprite = (CCSprite *)sender;
    mySprite.flipX = 1;
}

-(void) addGilMouseEyesAnimation{
    CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [cache addSpriteFramesWithFile:@"bubbleEyesAnimation.plist"];
    CCSpriteBatchNode *strongSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"bubbleEyesAnimation.png"];
    [self addChild:strongSpriteSheet z:0];
    
    CCSprite *strongSprite = [CCSprite spriteWithSpriteFrameName:@"bubbles_eyes_0.png"];
    strongSprite.position = ccp(200 *scaleFactorX,270*scaleFactorY);
    strongSprite.scaleX = xScale;
    strongSprite.scaleY = yScale;
    [strongSpriteSheet addChild:strongSprite z:0];
    
    NSMutableArray *animFrames = [NSMutableArray array];
    for(int i = 0; i <= 44; i++) {
        CCSpriteFrame *frame4 = [cache spriteFrameByName:[NSString stringWithFormat:@"bubbles_eyes_%d.png",i]];
        [animFrames addObject:frame4];
    }
    
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.04f];
    
    [strongSprite runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];
}

-(void) addStrongMouseEyesAnimation{
    
    CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [cache addSpriteFramesWithFile:@"strongEyesAnimation.plist"];
    CCSpriteBatchNode *strongSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"strongEyesAnimation.png"];
    [self addChild:strongSpriteSheet z:0];
    
    CCSprite *strongSprite = [CCSprite spriteWithSpriteFrameName:@"strong_eyes_0.png"];
    strongSprite.position = ccp(44 *scaleFactorX,148 *scaleFactorY);
    strongSprite.scaleX = xScale;
    strongSprite.scaleY = yScale;
    [strongSpriteSheet addChild:strongSprite z:0];
    
    NSMutableArray *animFrames = [NSMutableArray array];
    for(int i = 0; i <= 37; i++) {
        CCSpriteFrame *frame4 = [cache spriteFrameByName:[NSString stringWithFormat:@"strong_eyes_%d.png",i]];
        [animFrames addObject:frame4];
    }
    
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.04f];
    
    [strongSprite runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];
}

-(void) addMammaMouseEyesAnimation{
    CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [cache addSpriteFramesWithFile:@"momiEyesAnimation.plist"];
    CCSpriteBatchNode *strongSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"momiEyesAnimation.png"];
    [self addChild:strongSpriteSheet z:0];
    
    CCSprite *strongSprite = [CCSprite spriteWithSpriteFrameName:@"mamma_eyes_0.png"];
    strongSprite.position = ccp(395 *scaleFactorX,270 *scaleFactorY);
    strongSprite.scaleX = xScale;
    strongSprite.scaleY = yScale;
    [strongSpriteSheet addChild:strongSprite z:0];
    
    NSMutableArray *animFrames = [NSMutableArray array];
    for(int i = 0; i <= 37; i++) {
        CCSpriteFrame *frame4 = [cache spriteFrameByName:[NSString stringWithFormat:@"mamma_eyes_%d.png",i]];
        [animFrames addObject:frame4];
    }
    
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.04f];
    
    [strongSprite runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];
}

-(void) addPimppleMouseEyesAnimation{
    
    CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [cache addSpriteFramesWithFile:@"pimppleEyesAnim.plist"];
    CCSpriteBatchNode *pimppleSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"pimppleEyesAnim.png"];
    [self addChild:pimppleSpriteSheet z:0];
    
    CCSprite *pimppleSprite = [CCSprite spriteWithSpriteFrameName:@"pimpple_eye_0.png"];
    pimppleSprite.position = ccp(385*scaleFactorX,163*scaleFactorY);
    pimppleSprite.scaleX=xScale;
    pimppleSprite.scaleY=yScale;
    [pimppleSpriteSheet addChild:pimppleSprite z:0];
    
    NSMutableArray *animFrames = [NSMutableArray array];
    for(int i = 0; i <= 37; i++) {
        CCSpriteFrame *frame4 = [cache spriteFrameByName:[NSString stringWithFormat:@"pimpple_eye_%d.png",i]];
        [animFrames addObject:frame4];
    }
    
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.04f];
    
    [pimppleSprite runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];
}
-(void) addWaterAnimation{

    CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [cache addSpriteFramesWithFile:@"waterFlowingAnimation.plist"];
    CCSpriteBatchNode *waterSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"waterFlowingAnimation.png"];
    [self addChild:waterSpriteSheet z:0];
    
    CCSprite *waterSprite = [CCSprite spriteWithSpriteFrameName:@"water_0.png"];
    waterSprite.position = ccp(461 *scaleFactorX,182*scaleFactorY);
    waterSprite.scaleX = xScale;
    waterSprite.scaleY = yScale;
    [waterSpriteSheet addChild:waterSprite z:0];
    
    NSMutableArray *animFrames = [NSMutableArray array];
    for(int i = 0; i <= 28; i++) {
        CCSpriteFrame *frame4 = [cache spriteFrameByName:[NSString stringWithFormat:@"water_%d.png",i]];
        [animFrames addObject:frame4];
    }
    
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.03f];
    
    [waterSprite runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];
}

-(void) addFireFlamesAnimation{
    
    CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [cache addSpriteFramesWithFile:@"flamesAnimation.plist"];
    CCSpriteBatchNode *flamesSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"flamesAnimation.png"];
    [self addChild:flamesSpriteSheet z:0];
    
    CCSprite *flamesSprite = [CCSprite spriteWithSpriteFrameName:@"flames_0.png"];
    flamesSprite.position = ccp(42 *scaleFactorX, 200 *scaleFactorY);
    flamesSprite.scaleX = xScale;
    flamesSprite.scaleY = yScale;
    [flamesSpriteSheet addChild:flamesSprite z:0];
    
    NSMutableArray *animFrames = [NSMutableArray array];
    for(int i = 0; i <= 32; i++) {
        CCSpriteFrame *frame4 = [cache spriteFrameByName:[NSString stringWithFormat:@"flames_%d.png",i]];
        [animFrames addObject:frame4];
    }
 
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.03f];
   
    [flamesSprite runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];

}
-(void) addAboutSelectionMenu{
    
    slidingBgForAbout = [CCSprite spriteWithFile:@"button_base.png"];
    [slidingBgForAbout setScaleX:0.0001f];
    [slidingBgForAbout setScaleY:xScale];
    [slidingBgForAbout setAnchorPoint:ccp(1, 0)];
    slidingBgForAbout.position = ccp(467*scaleFactorX, 4*scaleFactorY);
    [slidingBgForAbout setTag:121];
    [self addChild: slidingBgForAbout z:0];
    
    CCMenuItem *twitterMenuItem = [CCMenuItemImage itemWithNormalImage:@"twitter.png" selectedImage:@"twitter.png" block:^(id sender) {
        [soundEffect button_1];
       // do nothing...
        
    }];

    CCMenu *twitterBtnMenu = [CCMenu menuWithItems:twitterMenuItem, nil];
    if ([FTMUtil sharedInstance].isRetinaDisplay) {
        twitterBtnMenu.position = ccp(80*scaleFactorX, 20 *scaleFactorY);
    }else{
        twitterBtnMenu.position = ccp(165*scaleFactorX, 40 *scaleFactorY);
    }
    [slidingBgForAbout addChild:twitterBtnMenu z:10];
    
    CCMenuItem *facebookMenuItem = [CCMenuItemImage itemWithNormalImage:@"facebook_like.png" selectedImage:@"facebook_like.png" block:^(id sender) {
        [soundEffect button_1];
        // do nothing...
    }];

    CCMenu *facebookBtnMenu = [CCMenu menuWithItems:facebookMenuItem, nil];
    if ([FTMUtil sharedInstance].isRetinaDisplay) {
        facebookBtnMenu.position = ccp(35 *scaleFactorX, 22 *scaleFactorY);
    }else{
        facebookBtnMenu.position = ccp(70 *scaleFactorX, 43 *scaleFactorY);
    }
    [slidingBgForAbout addChild:facebookBtnMenu z:10];
}

-(void) addSettingsSelectionMenu{
    slidingBgForSettings = [CCSprite spriteWithFile:@"button_base.png"];
    [slidingBgForSettings setScaleX:0.0001f];
    [slidingBgForSettings setScaleY:xScale];
    [slidingBgForSettings setAnchorPoint:ccp(0, 1)];
    if ([FTMUtil sharedInstance].isRetinaDisplay) {
        slidingBgForSettings.position = ccp(14 *scaleFactorX, 53*scaleFactorY);
    }else{
        slidingBgForSettings.position = ccp(14 *scaleFactorX, 49*scaleFactorY);
    }
    
    [slidingBgForSettings setTag:123];
    [self addChild: slidingBgForSettings z:0];
    
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
        
        [FTMUtil sharedInstance].isGameSoundOn = YES;
        [soundEffect playMenuMusic];
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
    
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CCMenu *soundBtnMenu = [CCMenu menuWithItems:soundOn, soundOff, nil];
    if ([FTMUtil sharedInstance].isRetinaDisplay) {
        soundBtnMenu.position = ccp(60*scaleFactorX, 21*scaleFactorY);
    }else{
        if (winSize.width > 480 && winSize.height < 1100) {
            soundBtnMenu.position = ccp(125*scaleFactorX, 42*scaleFactorY);
        }else{
            soundBtnMenu.position = ccp(150*scaleFactorX, 42*scaleFactorY);
        }
    }
    [slidingBgForSettings addChild:soundBtnMenu z:10];
    
    CCMenuItem *infoMenuItem = [CCMenuItemImage itemWithNormalImage:@"info.png" selectedImage:@"info_press.png" block:^(id sender) {
        [soundEffect button_1];
        // do nothing...
        [[CCDirector sharedDirector] replaceScene:[OptionsScreen scene]];
    }];
    
    CCMenu *infoBtnMenu = [CCMenu menuWithItems:infoMenuItem, nil];
    
    if ([FTMUtil sharedInstance].isRetinaDisplay) {
        infoBtnMenu.position = ccp(110 * scaleFactorX, 21 *scaleFactorY);
    }else{
        if(winSize.width > 480 && winSize.height < 1100)
        {
            infoBtnMenu.position = ccp(220 * scaleFactorX, 42 *scaleFactorY);
        }
        else{
            infoBtnMenu.position = ccp(250 * scaleFactorX, 42 *scaleFactorY);
        }
    }
    
    [slidingBgForSettings addChild:infoBtnMenu z:10];
}
-(void) addAboutSlidingAnimation{
    if(slidingBgForAbout.tag == 121){
        CCScaleTo *scaleAction = [CCScaleTo actionWithDuration:0.03 scaleX:xScale scaleY:xScale];
        [slidingBgForAbout runAction:scaleAction];
        [slidingBgForAbout setTag:122];
    }else if (slidingBgForAbout.tag == 122){
        CCScaleTo *scaleAction = [CCScaleTo actionWithDuration:0.03 scaleX:0.0001 scaleY:xScale];
        [slidingBgForAbout runAction:scaleAction];
        [slidingBgForAbout setTag:121];

    }
   
    
}


-(void) addSettingsSlidingAnimation{
    if(slidingBgForSettings.tag ==123){
        CCScaleTo *scaleAction = [CCScaleTo actionWithDuration:0.03 scaleX:xScale scaleY:xScale];
        [slidingBgForSettings runAction:scaleAction];
        [slidingBgForSettings setTag:124];
    }else if (slidingBgForSettings.tag == 124){
        CCScaleTo *scaleAction = [CCScaleTo actionWithDuration:0.03 scaleX:0.0001 scaleY:xScale];
        [slidingBgForSettings runAction:scaleAction];
        [slidingBgForSettings setTag:123];
    }
}

-(void) dealloc {
	[super dealloc];
}

-(void) startMenuMusic{
    [self unschedule:@selector(startMenuMusic)];
    [soundEffect playMenuMusic];
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


-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController {
	
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController {
	
}

@end
