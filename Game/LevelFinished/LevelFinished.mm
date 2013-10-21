//
//  HelloWorldLayer.mm
//  Tap
//
//  Created by karthik g on 27/09/12.
//  Copyright karthik g 2012. All rights reserved.
//

// Import the interfaces
#import "LevelFinished.h"


// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "DB.h"
enum {
	kTagParentNode = 1,
};



@implementation LevelFinished

+(CCScene *) scene {
	
    CCScene *scene = [CCScene node];
	LevelFinished *layer = [LevelFinished node];
	[scene addChild: layer];
	
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
		
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
        
        soundEffect=[[sound alloc] init];
        
        CCSprite *background = [CCSprite spriteWithFile:@"level_completed_screen_background.png"];
        background.position = ccp(240, 160);
        [self addChild: background z:0];
        
        CCSprite *sprite;
        
        for(int i=0;i<3;i++){
            sprite = [CCSprite spriteWithFile:@"level_completed_screen_cheese_grey.png"];
            sprite.position = ccp(240+(i*50), 243);
            [self addChild: sprite z:0];
            
        }
        for(int i=0;i<3;i++){
            sprite = [CCSprite spriteWithFile:@"level_completed_screen_cheese.png"];
            sprite.position = ccp(240+(i*50), 243);
            [self addChild: sprite z:0];
        }
        
        sprite=[CCSprite spriteWithFile:@"grey_bar_57.png"];
        sprite.position=ccp(264,193);
        sprite.scale=1.3;
        [self addChild:sprite z:10];
        
        
        sprite=[CCSprite spriteWithFile:@"red_end.png"];
        sprite.position=ccp(107,196);
        sprite.scaleX=3.0;
        sprite.scaleY=1.1;
        [self addChild:sprite z:10];
        
        for(int i=1;i<120;i++){
            NSString *fStr=@"";
            if(i<=59)
                fStr=@"red_middle.png";
            else if(i>59&&i<119)
                fStr=@"blue_middle.png";
            else
                fStr=@"blue_end.png";
            
            sprite=[CCSprite spriteWithFile:fStr];
            if(i<119)
                sprite.position=ccp(113+(i*2.5),196);
            else
                sprite.position=ccp(118+(i*2.5),196);
            sprite.scaleX=2.8;
            sprite.scaleY=1.1;
            [self addChild:sprite z:10];
        }
        
        sprite=[CCSprite spriteWithFile:@"time_cheese.png"];
        sprite.position=ccp(113+(119*2.5),195);
        [self addChild:sprite z:10];
        
        
        CCLabelAtlas * lifeMinutesAtlas = [[CCLabelAtlas labelWithString:@"01.60" charMapFile:@"numbers.png" itemWidth:15 itemHeight:20 startCharMap:'.'] retain];
        lifeMinutesAtlas.position=ccp(280,187);
        [self  addChild:lifeMinutesAtlas z:10];
        
        
        
        CCMenuItem *worldMenuItem = [CCMenuItemImage itemWithNormalImage:@"level_completed_screen_button_world_menu_1.png" selectedImage:@"level_completed_screen_button_world_menu_2.png" block:^(id sender) {
            
		}];
        
        
        CCMenuItem *replyMenuItem = [CCMenuItemImage itemWithNormalImage:@"level_completed_screen_button_replay_level_1.png" selectedImage:@"level_completed_screen_button_replay_level_2.png" block:^(id sender) {
            
            
		}];
        CCMenuItem *nextMenuItem = [CCMenuItemImage itemWithNormalImage:@"level_completed_screen_button_next_1.png" selectedImage:@"level_completed_screen_button_next_2.png" block:^(id sender) {
            
            
		}];
        
        
        menu = [CCMenu menuWithItems: worldMenuItem,replyMenuItem,nextMenuItem,  nil];
        [menu alignItemsHorizontallyWithPadding:20.0];
        menu.position=ccp(240,25);
        [self addChild: menu];
        
        CCLabelAtlas * scoreAtlas = [[CCLabelAtlas labelWithString:@"01.60" charMapFile:@"numbers.png" itemWidth:15 itemHeight:20 startCharMap:'.'] retain];
        scoreAtlas.position=ccp(150,137);
        [self  addChild:scoreAtlas z:10];
        [scoreAtlas setString:@"250"];
        
        for(int i=0;i<3;i++){
            if(i==1){
                NSString *fStr=@"";
                if(i==0)
                    fStr=@"level_completed_screen_good.png";
                else if(i==1)
                    fStr=@"level_completed_screen_excellent.png";
                else if(i==2)
                    fStr=@"level_completed_screen_perfect.png";
                else if(i==3)
                    fStr=@"level_completed_screen_new_record.png";
                
                sprite = [CCSprite spriteWithFile:fStr];
                sprite.position = ccp(150, 86);
                [self addChild: sprite z:10];
            }
        }
        
        
        
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
