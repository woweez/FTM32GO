//
//  HelloWorldLayer.mm
//  Tap
//
//  Created by karthik g on 27/09/12.
//  Copyright karthik g 2012. All rights reserved.
//

// Import the interfaces
#import "OptionsScreen.h"
#import "MenuScreen.h"
#import "AboutScreen.h"


// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "DB.h"
enum {
	kTagParentNode = 1,
};



@implementation OptionsScreen

+(CCScene *) scene {
	
    CCScene *scene = [CCScene node];
	OptionsScreen *layer = [OptionsScreen node];
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
        
		CCSprite *background = [CCSprite spriteWithFile:@"Options_background.png"];
        background.position = ccp(240 *scaleX, 160*scaleY);
        background.scaleX = background.scaleX*scaleX;
        [self addChild: background z:0];
        
        
        CCMenuItem *aboutMenuItem = [CCMenuItemImage itemWithNormalImage:@"options_screen_button_about_1.png" selectedImage:@"options_screen_button_about_2.png" target:self selector:@selector(clickLevel:)];
        aboutMenuItem.tag=2;

        
        CCMenuItem *optionMenuItem = [CCMenuItemImage itemWithNormalImage:@"options_screen_button_reset_1.png" selectedImage:@"options_screen_button_reset_2.png" target:self selector:@selector(clickLevel:)];
        optionMenuItem.tag=1;
        
        menu = [CCMenu menuWithItems: optionMenuItem,aboutMenuItem,  nil];
        [menu alignItemsHorizontallyWithPadding:30.0];
        menu.position=ccp(240,26);
        [self addChild: menu];
        
        CCMenuItem *backMenuItem = [CCMenuItemImage itemWithNormalImage:@"back_button_1.png" selectedImage:@"back_button_2.png" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[MenuScreen scene]];
		}];
        [backMenuItem setScale:0.5f];
        menu2 = [CCMenu menuWithItems: backMenuItem,  nil];
        [menu2 alignItemsVerticallyWithPadding:30.0];
        menu2.position=ccp(75,253);
        [self addChild: menu2];
        
        CCSprite *sprite = [CCSprite spriteWithFile:@"switchBgd.png"];
        sprite.position = ccp(335, 175);
        [self addChild: sprite z:0];
        
        sprite = [CCSprite spriteWithFile:@"switchBgd.png"];
        sprite.position = ccp(335, 125);
        [self addChild: sprite z:0];
        
        sprite = [CCSprite spriteWithFile:@"on.png"];
        sprite.position = ccp(310, 176);
        [self addChild: sprite z:0];
        
        sprite = [CCSprite spriteWithFile:@"on.png"];
        sprite.position = ccp(310, 126);
        [self addChild: sprite z:0];
        
        sprite = [CCSprite spriteWithFile:@"off.png"];
        sprite.position = ccp(360, 176);
        [self addChild: sprite z:0];
        
        sprite = [CCSprite spriteWithFile:@"off.png"];
        sprite.position = ccp(360, 126);
        [self addChild: sprite z:0];
        
        CCMenuItem *toggle1MenuItem = [CCMenuItemImage itemWithNormalImage:@"toggle.png" selectedImage:@"toggle.png" block:^(id sender) {
            if(toggleChe)
                toggleChe=NO;
            else
                toggleChe=YES;
            
            moveChe=YES;
		}];
        menu3 = [CCMenu menuWithItems: toggle1MenuItem,  nil];
        menu3.position=ccp(313,175);
        [self addChild: menu3];
        
        CCMenuItem *toggle2MenuItem = [CCMenuItemImage itemWithNormalImage:@"toggle.png" selectedImage:@"toggle.png" block:^(id sender) {
            if(toggleChe2)
                toggleChe2=NO;
            else
                toggleChe2=YES;
            moveChe2=YES;
		}];
        menu4 = [CCMenu menuWithItems: toggle2MenuItem,  nil];
        menu4.position=ccp(356,125);
        [self addChild: menu4];
        
        alphaSprite = [CCSprite spriteWithFile:@"alpha.png"];
        alphaSprite.position = ccp(240, 160);
        alphaSprite.visible=NO;
        [self addChild: alphaSprite z:0];
        
        resetSprite = [CCSprite spriteWithFile:@"reset_pop-up_background.png"];
        resetSprite.position = ccp(240, 160);
        resetSprite.visible=NO;
        [self addChild: resetSprite z:0];
        
        CCMenuItem *yesMenuItem = [CCMenuItemImage itemWithNormalImage:@"yes_button_1.png" selectedImage:@"yes_button_2.png" block:^(id sender) {
            
		}];
        CCMenuItem *noMenuItem = [CCMenuItemImage itemWithNormalImage:@"no_button_1.png" selectedImage:@"no_button_2.png" block:^(id sender) {
            resetChe=NO;
            resetSprite.visible=NO;
            alphaSprite.visible=NO;
            menu5.visible=NO;
		}];
        
        menu5 = [CCMenu menuWithItems: yesMenuItem,noMenuItem,  nil];
        [menu5 alignItemsHorizontallyWithPadding:30.0];
        menu5.position=ccp(240,116);
        menu5.visible=NO;
        [self addChild: menu5 z:1];
        
        toggleChe=YES;
        toggleChe2=NO;
        moveChe=YES;
        moveChe2=YES;
        
        toggleCount=313;
        toggleCount2=356;
        
		[self scheduleUpdate];
	}
	return self;
}


-(void) dealloc {
	[super dealloc];
}
-(void)clickLevel:(CCMenuItem *)sender {
    if(sender.tag==1){
        if(!resetChe){
            resetChe=YES;
            menu5.visible=YES;
            alphaSprite.visible=YES;
            resetSprite.visible=YES;
        }
    }else if(sender.tag==2){
        DB *db = [DB new];
        [db setSettingsFor:@"About" withValue:[NSString stringWithFormat:@"%d",2]];
        [db release];
        [[CCDirector sharedDirector] replaceScene:[AboutScreen scene]];
    }
}
-(void) update: (ccTime) dt {
    if(moveChe){
        if(toggleChe){
            toggleCount-=3;
            if(toggleCount<313){
                toggleCount=313;
                moveChe=NO;
            }
            menu3.position=ccp(toggleCount,175);
        }else{
            toggleCount+=3;
            if(toggleCount>356 ){
                toggleCount=356;
                moveChe=NO;
            }
            menu3.position=ccp(toggleCount,175);
        }
    }
    if(moveChe2){
        if(toggleChe2){
            toggleCount2-=3;
            if(toggleCount2<313){
                toggleCount2=313;
                moveChe2=NO;
            }
            menu4.position=ccp(toggleCount2,125);
        }else{
            toggleCount2+=3;
            if(toggleCount2>356){
                toggleCount2=356;
                moveChe2=NO;
            }
            menu4.position=ccp(toggleCount2,125);
        }
    }
    
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
