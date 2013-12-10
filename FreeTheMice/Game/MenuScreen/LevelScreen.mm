//
//  HelloWorldLayer.mm
//  Tap
//
//  Created by karthik g on 27/09/12.
//  Copyright karthik g 2012. All rights reserved.
//

// Import the interfaces
#import "LevelScreen.h"
#import "MouseSelectionScreen.h"
#import "GameEngine.h"
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
#import "LoadingLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "DB.h"
enum {
	kTagParentNode = 1,
};



@implementation LevelScreen

+(CCScene *) scene {
	
    CCScene *scene = [CCScene node];
	LevelScreen *layer = [LevelScreen node];
	[scene addChild: layer];
	
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
		
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
        
        soundEffect=[[sound alloc] init];
        
        if (![soundEffect isMusicPlaying]) {
            [self schedule:@selector(startMenuMusic) interval:0.1];
        }
        CGSize winSize = [CCDirector sharedDirector].winSize;
        float scaleFactorX = winSize.width/480;
        float scaleFactorY = winSize.height/320;

        if ([FTMUtil sharedInstance].isRetinaDisplay) {
            xScale = 1 * scaleFactorX;
            yScale = 1 * scaleFactorY;
            cScale = 1;
        }else{
            xScale = 0.5 * scaleFactorX;
            yScale = 0.5 * scaleFactorY;
            cScale = 0.5;
        }
        
		CCSprite *background = [CCSprite spriteWithFile:@"Select_Level_background.png"];
        background.position = ccp(240 *scaleFactorX, 160*scaleFactorY);
        [background setScaleX:xScale];
        [background setScaleY:yScale];
        [self addChild: background z:0];
        
        CCSprite *kitchenTitle = [CCSprite spriteWithFile:@"kitchen_title.png"];
        [kitchenTitle setScale:cScale];
//        CGSize kitchenContentSize = [kitchenTitle contentSize];
        
        kitchenTitle.position = ccp(240 *scaleFactorX, 290*scaleFactorY);
        [self addChild: kitchenTitle z:0];
        
        CCMenuItem *backMenuItem = [CCMenuItemImage itemWithNormalImage:@"back_button_1.png" selectedImage:@"back_button_2.png" block:^(id sender) {
            [soundEffect button_1];
            [[CCDirector sharedDirector] replaceScene:[MouseSelectionScreen scene]];
            
		}];
        [backMenuItem setScale:cScale];
        menu = [CCMenu menuWithItems: backMenuItem,  nil];
        [menu alignItemsVerticallyWithPadding:30.0];
        menu.position=ccp(240 *scaleFactorX, 35 *scaleFactorY);
        [self addChild: menu];
        
        int currentLvl = 0;
        DB *db = [DB new];
        currentMouse = [FTMUtil sharedInstance].mouseClicked;//[[db getSettingsFor:@"CurrentMouse"] intValue];
        int currentMouseInDB = [[db getSettingsFor:@"CurrentMouse"] intValue];
        switch (currentMouse) {
            case 1://mother mouse
                currentLvl = [[db getSettingsFor:@"mamaCurrLvl"] intValue];
                break;
            case 2://strong mouse
                currentLvl = [[db getSettingsFor:@"strongCurrLvl"] intValue];
                break;
            case 3://girl mouse
                currentLvl = [[db getSettingsFor:@"girlCurrLvl"] intValue];
                break;
                
            default:
                break;
        }
        [db release];
        
        CCSprite *mouseCurrentLevelAndImageViewer = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%d.png", currentMouse]];
        mouseCurrentLevelAndImageViewer.position = ccp(70 *scaleFactorX, 160 *scaleFactorY);
        [mouseCurrentLevelAndImageViewer setScale:cScale];
        [self addChild: mouseCurrentLevelAndImageViewer z:0];
        int lvl = currentLvl>14 ? 14:currentLvl;
        
        CCLabelAtlas *currentLevelLabel = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d/14", lvl] charMapFile:@"numbers.png" itemWidth:15 itemHeight:20 startCharMap:'.'];
        currentLevelLabel.position=ccp(21 *scaleFactorX, 33 *scaleFactorY);
        if ([FTMUtil sharedInstance].isRetinaDisplay) {
            currentLevelLabel.scale = 0.5;
            currentLevelLabel.position=ccp(10 *scaleFactorX, 16 *scaleFactorY);
        }
        [mouseCurrentLevelAndImageViewer addChild: currentLevelLabel z:10];
        
        for(int i=0;i<15;i++){
            CCMenuItem *levelMenu = NULL;
            if(i<= 13 && i+1 > currentLvl){
            levelMenu=[CCMenuItemImage itemWithNormalImage:[NSString stringWithFormat:@"locked.png"] selectedImage:[NSString stringWithFormat:@"locked.png"] target:self selector:@selector(clickLevel:)];
                levelMenu.isEnabled = FALSE;
                [levelMenu addChild:[self getAppropriateStarImageAgainstLevel:0]];
            }else if(i>13){
                
                NSString *lvlStr;
                if (currentMouseInDB == 1) {
                    lvlStr = @"level15_lock_3.png";
                }else if(currentMouseInDB == 2){
                    lvlStr = @"level15_lock_2.png";
                }else if (currentMouseInDB == 3 && currentLvl <= 14){
                    lvlStr = @"level15_lock_1.png";
                }else{
                    lvlStr = @"15_1.png";
                }
                
                levelMenu=[CCMenuItemImage itemWithNormalImage:lvlStr selectedImage:lvlStr target:self selector:@selector(clickLevel:)];
                if ((currentLvl != 15 && currentLvl != 16 && currentLvl != 17) || currentMouse == FTM_MAMA_MICE_ID || currentMouse == FTM_STRONG_MICE_ID) {
                    levelMenu.isEnabled = FALSE;
                }
                
                [levelMenu addChild:[self getAppropriateStarImageAgainstLevel:0]];

            }else{
                levelMenu=[CCMenuItemImage itemWithNormalImage:[NSString stringWithFormat:@"%d_%d.png",i+1,1] selectedImage:[NSString stringWithFormat:@"%d_%d.png",i+1,2] target:self selector:@selector(clickLevel:)];
                [levelMenu addChild:[self getAppropriateStarImageAgainstLevel:2]];
            }
            if ([FTMUtil sharedInstance].isRetinaDisplay) {
                [levelMenu setScale:cScale];
            }else{
                [levelMenu setScale: 0.65];
            }
            
            
            
            CCMenu *menu2 = [CCMenu menuWithItems: levelMenu,  nil];
            if (i==14 && currentLvl > 15) {
                levelMenu.tag=currentLvl;
            }else{
                levelMenu.tag=i+1;
            }
            if ([FTMUtil sharedInstance].isRetinaDisplay) {
                if(i<=4)
                    menu2.position=ccp(140 *scaleFactorX+(i*55 *scaleFactorX),220 *scaleFactorY);
                else if(i>4 &&i<=9)
                    menu2.position=ccp(-135 *scaleFactorX+(i*55 *scaleFactorX),155 *scaleFactorY);
                else if(i>9)
                    menu2.position=ccp(-410 *scaleFactorX+(i*55 *scaleFactorX),90 *scaleFactorY);
                
                menu2.scale=cScale; //0.8
            }else{
                if(i<=4)
                    menu2.position=ccp(90 *scaleFactorX+(i*55 *scaleFactorX),190 *scaleFactorY);
                else if(i>4 &&i<=9)
                    menu2.position=ccp(-185 *scaleFactorX+(i*55 *scaleFactorX),125 *scaleFactorY);
                else if(i>9)
                    menu2.position=ccp(-460 *scaleFactorX+(i*55 *scaleFactorX),60 *scaleFactorY);
                
                menu2.scale= 0.8; //0.8
            }
            
            
            [self addChild:menu2];
        }
        
		[self scheduleUpdate];
	}
	return self;
}

-(void) startMenuMusic{
    [self unschedule:@selector(startMenuMusic)];
    [soundEffect playMenuMusic];
}

-(void) dealloc {
	[super dealloc];
}

-(void) update: (ccTime) dt {
    
}

-(void)clickMouse:(CCMenuItem *)sender {
    [soundEffect button_1];
//    DB *db = [DB new];
//    [db setSettingsFor:@"CurrentMouse" withValue:[NSString stringWithFormat:@"%d",sender.tag]];
//    [db release];
}
-(void)clickLevel:(CCMenuItem *)sender {
    [soundEffect button_1];
    [[CCDirector sharedDirector] replaceScene:[LoadingLayer scene:sender.tag currentMice:currentMouse]];
    
    }

-(CCSprite *) getAppropriateStarImageAgainstLevel: (int) level{
   // get the appropriate star image id here from the level: use db to get that. for now just 1;
    CCSprite *starImage = [CCSprite spriteWithFile:[NSString stringWithFormat:@"stars_%d.png",level]];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    float scaleFactorX = winSize.width/480;
    float scaleFactorY = winSize.height/320;
    
    if ([FTMUtil sharedInstance].isRetinaDisplay) {
        starImage.position = ccp(22 *scaleFactorX, 9 *scaleFactorY);
    }else{
        starImage.position = ccp(45 *scaleFactorX, 18 *scaleFactorY);
    }
    
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


-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController {
	
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController {
	
}

@end
