

//  Created by Muhammad Kamran on 19/09/13.
//  Copyright Muhammad Kamran 2013. All rights reserved.
//

#import <GameKit/GameKit.h>


#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "sound.h"
#import "AppDelegate.h"

#define PTM_RATIO 32


@interface HudLayer : CCLayer {
	CCMenu *menu;
    sound *soundEffect;
    CCMenuItemImage *soundOn;
    CCMenuItemImage *soundOff;
    float scaleFactorX;
    float scaleFactorY;
    CCSprite * timer;
    CCSprite *pauseScreenBg;
    CCSprite *pauseText;
    CCSprite *timerBg;
    CCSprite *cheezeCollectedBg;
    CCSprite *leftSprite;
    CCSprite *rightSprite;
    CCLayer *parentReference;
    
    CCLabelAtlas * remainingTime;
    CCLabelAtlas * noOfCollectedCheese;
    
    float xScale;
    float yScale;
    float cScale;
    int totalCheeseCollected;
}

-(void) showRetryOptionMenu;
-(void) addLevelSceneAgainForRetry;
-(void) updateNoOfCheeseCollected:(int) currentValue andMaxValue: (int) maxValue;
-(void) updateTimeRemaining:(int) minuts andTimeInSec: (int) seconds;
-(int) getTotalNoOffCheeseCollected;
@end
