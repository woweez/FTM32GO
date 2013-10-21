//
//  HelloWorldLayer.mm
//  Tap
//
//  Created by karthik g on 27/09/12.
//  Copyright karthik g 2012. All rights reserved.
//

// Import the interfaces
#import "AboutScreen.h"
#import "OptionsScreen.h"
#import "MenuScreen.h"


// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "DB.h"
enum {
	kTagParentNode = 1,
};



@implementation AboutScreen

+(CCScene *) scene {
	
    CCScene *scene = [CCScene node];
	AboutScreen *layer = [AboutScreen node];
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
        float scaleX = winSize.width/480;
        float scaleY = winSize.height/320;
        
		CCSprite *background = [CCSprite spriteWithFile:@"About_background.png"];
        background.position = ccp(240 *scaleX, 160 *scaleY);
        background.scaleX = background.scaleX*scaleX;
        [self addChild: background z:0];
        
        
        
        CCMenuItem *buyMenuItem = [CCMenuItemImage itemWithNormalImage:@"about_screen_button_buy_1.png" selectedImage:@"about_screen_button_buy_2.png" block:^(id sender) {
            
		}];
        
        menu = [CCMenu menuWithItems: buyMenuItem, nil];
        [menu alignItemsHorizontallyWithPadding:30.0];
        menu.position=ccp(240,26);
        [self addChild: menu];
        
        CCMenuItem *backMenuItem = [CCMenuItemImage itemWithNormalImage:@"back_button_1.png" selectedImage:@"back_button_2.png" block:^(id sender) {
            DB *db = [DB new];
            if([[db getSettingsFor:@"About"] intValue] == 1)
                [[CCDirector sharedDirector] replaceScene:[MenuScreen scene]];
            else
                [[CCDirector sharedDirector] replaceScene:[OptionsScreen scene]];
            [db release];
            
            
		}];
        [backMenuItem setScale:0.5];
        menu2 = [CCMenu menuWithItems: backMenuItem,  nil];
        [menu2 alignItemsVerticallyWithPadding:30.0];
        menu2.position=ccp(75,253);
        [self addChild: menu2];
        
        
        background = [CCSprite spriteWithFile:@"text_lite.png"];
        background.position = ccp(240, 140);
        [self addChild: background z:0];
        
		[self scheduleUpdate];
	}
	return self;
}


-(void) dealloc {
	[super dealloc];
}

-(void) update: (ccTime) dt {
    
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
