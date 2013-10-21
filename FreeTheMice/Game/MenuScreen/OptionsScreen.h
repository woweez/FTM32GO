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


@interface OptionsScreen : CCLayer {
	CCMenu *menu,*menu2,*menu3,*menu4,*menu5;
    sound *soundEffect;
    
    CCSprite *toggleSprite;
    CCSprite *toggleSprite2;
    CCSprite *resetSprite;
    CCSprite *alphaSprite;
    BOOL toggleChe,toggleChe2;
    int toggleCount,toggleCount2;
    BOOL moveChe,moveChe2;
    BOOL resetChe;
}

+(CCScene *) scene;
@end
