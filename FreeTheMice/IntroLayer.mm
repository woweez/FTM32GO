//
//  IntroLayer.m
//  FreeTheMice
//
//  Created by karthik gopal on 23/01/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "MenuScreen.h"
#import "GameEngine.h"
#import "LevelFinished.h"
#import "LevelScreen.h"
#import "FTMUtil.h"
#import "FTMConstants.h"

#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// 
-(void) onEnter
{
	[super onEnter];

	// ask director for the window size
	CGSize size = [[CCDirector sharedDirector] winSize];

	CCSprite *background;
	
	if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		background = [CCSprite spriteWithFile:@"Default.png"];
		background.rotation = 90;
	} else {
		background = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
	}
	background.position = ccp(size.width/2, size.height/2);
    [[GameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
	// add the label as a child to this Layer
	[self addChild: background];
	
//    NSString *modelName = [[FTMUtil sharedInstance] getModel];
//    if([modelName isEqual:@"iPhone4S"]){
//    isIphone5 1;
//}O
	// In one second transition to the new scene
	[self scheduleOnce:@selector(makeTransition:) delay:1];
}

-(void) makeTransition:(ccTime)dt
{
//	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0 scene:[LevelScreen scene] withColor:ccWHITE]];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0 scene:[MenuScreen scene] withColor:ccWHITE]];
    
}
@end
