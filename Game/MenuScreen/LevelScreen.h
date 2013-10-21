//
//  HelloWorldLayer.h
//  Tap
//
//  Created by karthik g on 27/09/12.
//  Copyright karthik g 2012. All rights reserved.
//


#import <GameKit/GameKit.h>


#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "sound.h"
#import "AppDelegate.h"

#define PTM_RATIO 32


@interface LevelScreen : CCLayer {
	CCMenu *menu;
    CCMenu *menu3;
    sound *soundEffect;
    int currentMouse;
    float xScale;
    float yScale;
    float cScale;
}

+(CCScene *) scene;
- (CCSprite *) getAppropriateStarImageAgainstLevel: (int) level;
@end
