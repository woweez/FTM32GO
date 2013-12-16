
//  Created by Muhammad Kamran on 15/09/13.
//  Copyright Muhammad Kamran 2013. All rights reserved.
//

// Import the interfaces
#import "MouseSelectionScreen.h"
#import "LevelScreen.h"
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

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "DB.h"
enum {
	kTagParentNode = 1,
};

int counter;

@implementation MouseSelectionScreen

+(CCScene *) scene {
	
    CCScene *scene = [CCScene node];
	MouseSelectionScreen *layer = [MouseSelectionScreen node];
	[scene addChild: layer];
	
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
		
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
        
        soundEffect=[[sound alloc] init];
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
        background.position = ccp(240*scaleFactorX, 160);
        [background setScaleX:xScale];
        [background setScaleY:yScale];
        [self addChild: background z:0];
        
        CCSprite *miceSelectionBg = [CCSprite spriteWithFile:@"mouse_selection_bg.png"];
        miceSelectionBg.position = ccp(240*scaleFactorX, 160 *scaleFactorY);
        [miceSelectionBg setScale:cScale];
        [self addChild: miceSelectionBg z:0];
        
        CCSprite *selectMouseTitle = [CCSprite spriteWithFile:@"level_select_title.png"];
        [selectMouseTitle setScale:cScale];
        
        selectMouseTitle.position = ccp(240*scaleFactorX, 290 *scaleFactorY);
        [self addChild: selectMouseTitle z:0];
        
        CCMenuItem *backMenuItem = [CCMenuItemImage itemWithNormalImage:@"back_button_1.png" selectedImage:@"back_button_2.png" block:^(id sender) {
            [soundEffect button_1];
            [[CCDirector sharedDirector] replaceScene:[MenuScreen scene]];
            
		}];
        [backMenuItem setScale:cScale];
        menu = [CCMenu menuWithItems: backMenuItem,  nil];
        [menu alignItemsVerticallyWithPadding:30.0];
        menu.position=ccp(240*scaleFactorX,35*scaleFactorY);
        [self addChild: menu];
        
        DB *db = [DB new];
        currentMouse = [[db getSettingsFor:@"CurrentMouse"] intValue];
//        int currentLvl = [[db getSettingsFor:@"CurrentLevel"] intValue];
        int mamaCurrentLvl = [[db getSettingsFor:@"mamaCurrLvl"] intValue];
        int strongCurrentLvl = [[db getSettingsFor:@"strongCurrLvl"] intValue];
        int girlCurrentLvl = [[db getSettingsFor:@"girlCurrLvl"] intValue];
        [db release];
        
        int width = 15;
        int height = 20;
        
        // need to add check for iPhone 4s/5.
        CCLabelAtlas *currentLevelLabel = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d/14", mamaCurrentLvl=mamaCurrentLvl>14?14:mamaCurrentLvl] charMapFile:@"numbers.png" itemWidth:width itemHeight:height startCharMap:'.'];
        currentLevelLabel.position=ccp(72*scaleFactorX,38*scaleFactorY);
        if ([FTMUtil sharedInstance].isRetinaDisplay) {
            currentLevelLabel.visible = YES;
            currentLevelLabel.scale = 0.5;
            currentLevelLabel.position=ccp(36*scaleFactorX,19*scaleFactorY);
        }
        CCMenuItem *motherMenuItem=[CCMenuItemImage itemWithNormalImage:@"mother_levels_unlocked.png" selectedImage:@"mother_levels_unlocked.png" target:self selector:@selector(clickMouse:)];
        [motherMenuItem setScale:cScale];
        [motherMenuItem addChild:currentLevelLabel z:10];
        motherMenuItem.tag=1;
        
        CCMenuItem *strongMenuItem = NULL;
        currentLevelLabel = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d/14", strongCurrentLvl=strongCurrentLvl>14?14:strongCurrentLvl] charMapFile:@"numbers.png" itemWidth:width itemHeight:height startCharMap:'.'];
        currentLevelLabel.position=ccp(78*scaleFactorX,44*scaleFactorY);
        if ([FTMUtil sharedInstance].isRetinaDisplay) {
            currentLevelLabel.visible = YES;
            currentLevelLabel.scale = 0.5;
            currentLevelLabel.position=ccp(39*scaleFactorX,22*scaleFactorY);
        }
        if(currentMouse == 2 || currentMouse == 3){
            strongMenuItem = [CCMenuItemImage itemWithNormalImage:@"strong_levels_unlocked.png" selectedImage:@"strong_levels_unlocked.png" target:self selector:@selector(clickMouse:)];
            [strongMenuItem addChild:currentLevelLabel z:10];
        }
        else{
            strongMenuItem = [CCMenuItemImage itemWithNormalImage:@"strong_levels_locked.png" selectedImage:@"strong_levels_locked.png" target:self selector:@selector(clickMouse:)];
            strongMenuItem.isEnabled = NO;
        }
        [strongMenuItem setScale:cScale];
        strongMenuItem.tag=2;
        
        CCMenuItem *girlMenuItem = NULL;
        currentLevelLabel = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d/14", girlCurrentLvl=girlCurrentLvl>14?14:girlCurrentLvl] charMapFile:@"numbers.png" itemWidth:width itemHeight:height startCharMap:'.'];
        currentLevelLabel.position=ccp(80*scaleFactorX,51*scaleFactorY);
        if ([FTMUtil sharedInstance].isRetinaDisplay) {
            currentLevelLabel.visible = YES;
            currentLevelLabel.scale = 0.5;
            currentLevelLabel.position=ccp(40*scaleFactorX,25*scaleFactorY);
        }
        if(currentMouse == 3){
            girlMenuItem=[CCMenuItemImage itemWithNormalImage:@"girl_levels_unlocked.png" selectedImage:@"girl_levels_unlocked.png" target:self selector:@selector(clickMouse:)];
            [girlMenuItem addChild:currentLevelLabel z:10];
        }
        else{
            girlMenuItem=[CCMenuItemImage itemWithNormalImage:@"girl_levels_locked.png" selectedImage:@"girl_levels_locked.png" target:self selector:@selector(clickMouse:)];
            girlMenuItem.isEnabled = NO;
        }
        [girlMenuItem setScale:cScale];
        girlMenuItem.tag=3;
        
        menu3 = [CCMenu menuWithItems: motherMenuItem,strongMenuItem,girlMenuItem,  nil];
        [menu3 alignItemsHorizontallyWithPadding:10.0];
        menu3.position=ccp(240*scaleFactorX,160*scaleFactorY);
        [self addChild: menu3];
        
        CCMenuItem *magnifyMenuItem = [CCMenuItemImage itemWithNormalImage:@"debugBtn_nor.png" selectedImage:@"debugBtn.png" block:^(id sender) {
            [soundEffect button_1];
            counter++;
            if(counter == 10){
                DB *db = [DB new];
                [db setSettingsFor:@"CurrentMouse" withValue:[NSString stringWithFormat:@"%d", 3]];
                [db setSettingsFor:@"CurrentLevel" withValue:[NSString stringWithFormat:@"%d", 15]];
                [db setSettingsFor:@"strongCurrLvl" withValue:[NSString stringWithFormat:@"%d", 15]];
                [db setSettingsFor:@"mamaCurrLvl" withValue:[NSString stringWithFormat:@"%d", 15]];
                [db setSettingsFor:@"girlCurrLvl" withValue:[NSString stringWithFormat:@"%d", 15]];
                [db release];
                [[CCDirector sharedDirector] replaceScene:[MouseSelectionScreen scene]];
            }
        }];
        [magnifyMenuItem setScale:.6];
        if ([FTMUtil sharedInstance].isRetinaDisplay) {
            [magnifyMenuItem setScale:1.2];
        }
        
        magnifyMenuItem.position = ccp(170 *scaleFactorX, 250 *scaleFactorY);
        [menu addChild:magnifyMenuItem];
	}
	return self;
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
    [FTMUtil sharedInstance].mouseClicked = sender.tag;
    [[CCDirector sharedDirector] replaceScene:[LevelScreen scene]];
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
